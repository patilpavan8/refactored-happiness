####################################
# Public IP for Public Load Balancer
####################################

resource "azurerm_public_ip" "lb_pip" {
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
  name = "lb-public-ip"
}

######################
# Public Load Balancer
######################

resource "azurerm_lb" "lb_public" {
  name = "publicloadbalancer"

  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = var.sku
  frontend_ip_configuration {
    name                 = "shared-public"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

}

########################
# Public LB Backend Pool
########################

resource "azurerm_lb_backend_address_pool" "lb_public" {
  loadbalancer_id = azurerm_lb.lb_public.id
  name = "publiclbbackendpool"
}

########################
# public LB Health Probe
########################

resource "azurerm_lb_probe" "lb_public" {
  loadbalancer_id = azurerm_lb.lb_public.id
  name = "publiclbhealthprobe"
  protocol = "Tcp"
  port     = 3000
}

################
# Public LB Rule
################

resource "azurerm_lb_rule" "lb_public" {
  loadbalancer_id = azurerm_lb.lb_public.id
  name = "publiclbrule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_lb.lb_public.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_public.id]
  probe_id                       = azurerm_lb_probe.lb_public.id
  disable_outbound_snat          = true
  load_distribution              = "SourceIPProtocol"
  idle_timeout_in_minutes        = 35
}

resource "azurerm_lb_outbound_rule" "lb_public" {
  loadbalancer_id = azurerm_lb.lb_public.id
  name = "publiclboutboundrule"
  protocol = "Tcp"

  frontend_ip_configuration {
    name = azurerm_lb.lb_public.frontend_ip_configuration[0].name
  }

  backend_address_pool_id  = azurerm_lb_backend_address_pool.lb_public.id
  allocated_outbound_ports = 5120
}

########################
# Internal Load Balancer
########################

resource "azurerm_lb" "lbinternal" {
  name                = "internal-loadbalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = var.sku
  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = azurerm_subnet.router-subnet["routersubnet"].id
    private_ip_address_allocation = "Dynamic"
  }
}

##########################
# Internal LB Backend Pool
##########################

resource "azurerm_lb_backend_address_pool" "lb_internal" {
  loadbalancer_id = azurerm_lb.lbinternal.id
  name = "internallbbackendpool"
}

##########################
# Internal LB Health Probe
##########################

resource "azurerm_lb_probe" "lb_internal" {
  loadbalancer_id = azurerm_lb.lbinternal.id
  name = "internallbhealthprobe"
  protocol = "Tcp"
  port     = 2000
  interval_in_seconds = 5
  number_of_probes    = 2
}

##################
# Internal LB Rule
##################

resource "azurerm_lb_rule" "lb_internal" {
  loadbalancer_id = azurerm_lb.lbinternal.id
  name = "internalloadbalancer"
  # protocol                       = "Tcp"
  # frontend_port                  = 443
  # backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.lbinternal.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_internal.id]
  probe_id                       = azurerm_lb_probe.lb_internal.id
  disable_outbound_snat          = true
  floating_ip_enabled            = true
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 15
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
}

##############
# Router VMSS 
##############

resource "azurerm_linux_virtual_machine_scale_set" "gateway_vmss" {

  name = "router-vmss"

  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  sku                 = var.vmss_size
  instances           = var.instance_count
  admin_username      = var.username
  admin_password      = var.admin_password
  disable_password_authentication = false
  upgrade_mode        = "Manual"
  tags                       = var.tags
  encryption_at_host_enabled = true
  secure_boot_enabled        = false

  source_image_reference {
    publisher = "Debian"
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  ##############################################
  # NIC 1 — public routing interface (public LB)
  ##############################################
  network_interface {
    name = "public-nic"
    primary = true
    enable_ip_forwarding = true

    ip_configuration {
      name                                   = "ip-public"
      subnet_id                              = azurerm_subnet.router-subnet["routersubnet"].id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_public.id]
      primary                                = true
    }

  }

  ######################################
  # NIC 2 — private internal routing NIC
  ######################################
  network_interface {
    name = "internal-nic"
    primary = false
    enable_ip_forwarding = true

    ip_configuration {
      name      = "internal-nic"
      subnet_id = azurerm_subnet.router-subnet["routersubnet"].id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_internal.id]
      primary   = true
    }

  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size
  }

  # cloud-init, executed at VM instance creation time
  custom_data = base64encode(file("${path.module}/init.sh"))

}

# #########################################
# OPTIONAL: AUTOSCALE — Uncomment to enable
# #########################################
/*
resource "azurerm_monitor_autoscale_setting" "gateway_autoscale" {
  provider = azurerm.connectivity

  name = provider::lua::azure_name({
    resource_type = "autoscale",
    client        = var.name_fields.client,
    environment   = var.name_fields.environment,
    region        = var.name_fields.region,
    info          = "gateway-vmss"
  })

  resource_group_name = azurerm_resource_group.vmss_resource_group.name
  location            = azurerm_resource_group.vmss_resource_group.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.gateway_vmss.id
  tags                = var.tags

  profile {
    name = "default"

    capacity {
      minimum = "2"
      maximum = "10"
      default = "2"
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.gateway_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        type      = "ChangeCount"
        value     = "1"
        direction = "Increase"
        cooldown  = "PT3M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.gateway_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        type      = "ChangeCount"
        value     = "1"
        direction = "Decrease"
        cooldown  = "PT3M"
      }
    }
  }
}
*/
