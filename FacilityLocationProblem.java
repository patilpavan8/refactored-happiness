
//Implementation of a Facility Location Problem using Integer Programming and Gurobi Optimizer.



import gurobi.*;
import java.util.*;
import java.lang.Math;

public class FacilityLocationProblem {

  public static void main(String[] args) {
    try {

    	// Capacity of facility (Manufacturing Plants) in thousands number of units
        double MPCapacity[] = new double[] { 22, 24, 20, 14, 17 };
    	
        
       // Fixed setup cost for each facility (Manufacturing Plant)
        double FixedCost_mp[] =
            new double[] { 12000, 14000, 16000, 13000, 19000 };
    		
      // Demand placed by a client (warehouse)in thousands number of units
      double ClientRequest[] = new double[] { 12, 18, 15, 25};
 
      // connection cost per thousand number of units from manufacturing plant to warehouse
      double Trans_cost[][] =
          new double[][] { { 3000, 2200, 3100, 2600, 4300 },
              { 2200, 2700, 3400, 3300, 3900 },
              { 1400, 1900, 2700, 4000, 3200 },
              { 2100, 2700, 3200, 3900, 3100 }};
             

      // Number of client (warehouses) and facility (Manufacturing Plants)  
      int numPlants = MPCapacity.length;
      int numWarehouses = ClientRequest.length;

      // Setting up the Gurobi Optimizer Model and environment
      GRBEnv environment = new GRBEnv();
      GRBModel grbmodel = new GRBModel(environment);
      grbmodel.set(GRB.StringAttr.ModelName, "facilitylocationproblem");

      // Decision variables for facility (Manufacturing Plant) open : Open_mp[plant] == 1 if facility (Manufacturing Plant) plant is open.
      GRBVar[] Open_mp = new GRBVar[numPlants];
      for (int plant = 0; plant < numPlants; ++plant) {
    	  Open_mp[plant] = grbmodel.addVar(0, 1, FixedCost_mp[plant], GRB.BINARY, "Open" + plant);
      }

      // Decision variables for Transport Quantity: how much to transport from a Manufacturing Plant plant to a warehouse warehouse
      GRBVar[][] TransportQuantity = new GRBVar[numWarehouses][numPlants];
      for (int warehouse = 0; warehouse < numWarehouses; ++warehouse) {
        for (int plant = 0; plant < numPlants; ++plant) {
        	TransportQuantity[warehouse][plant] =
        			grbmodel.addVar(0, GRB.INFINITY, Trans_cost[warehouse][plant], GRB.CONTINUOUS,"Transport" + plant + "." + warehouse);
        }
      }

      // optimize the sum of  fixed setup cost and connection costs
      grbmodel.set(GRB.IntAttr.ModelSense, GRB.MINIMIZE);

 

       // Assume we are at the starting point: close Manufacturing Plants 
      // having the highest fixed setup cost; Initially, open all Manufacturing Plants
     
      for (int plant = 0; plant < numPlants; ++plant) {
    	  Open_mp[plant].set(GRB.DoubleAttr.Start, 1.0);
      }

      // Close the facility (Manufacturing Plant) having the highest fixed setup cost
      System.out.println("Initial assumption:");
      double MaxFixedcost_mp = -GRB.INFINITY;
      for (int plant = 0; plant < numPlants; ++plant) {
        if (FixedCost_mp[plant] > MaxFixedcost_mp) {
        	MaxFixedcost_mp = FixedCost_mp[plant];
        }
      }
      for (int plant = 0; plant < numPlants; ++plant) {
        if (FixedCost_mp[plant] == MaxFixedcost_mp) {
        	Open_mp[plant].set(GRB.DoubleAttr.Start, 0.0);
          System.out.println("Closing a facility (Manufacturing Plant) " + plant + "\n");
          break;
        }
      }

    

      // Optimizing the model
      grbmodel.optimize();

      // Printing the optimal solution 
      
      System.out.println("TOTAL NUMBER OF MANUFACTURING PLANTS: " + numPlants);
      System.out.println("TOTAL NUMBER OF WAREHOUSES :"+ numWarehouses);
      
      System.out.println("TOTAL COST of OPTIMAL SOLUTION: " + grbmodel.get(GRB.DoubleAttr.ObjVal));
      System.out.println("OPTIMAL SOLUTION WITH OPTIMIZED TRANSPORTATION COST :");
      for (int plant = 0; plant < numPlants; ++plant) {
        if (Open_mp[plant].get(GRB.DoubleAttr.X) > 0.99) {
          System.out.println("Manufacturing Plant " + plant + " open:");
          for (int wh = 0; wh < numWarehouses; ++wh) {
            if (TransportQuantity[wh][plant].get(GRB.DoubleAttr.X) > 0.0001) {
              System.out.println("  Transport " +
            		  TransportQuantity[wh][plant].get(GRB.DoubleAttr.X) +
                  "number of units to warehouse " + wh);
            }
          }
        } else {
          System.out.println("Manufacturing Plant " + plant + " closed!");
        }
      }

      // Disposing the Gurobi model and Gurobi environment
      grbmodel.dispose();
      environment.dispose();

    } catch (GRBException exception) {
      System.out.println("Error Message: " + exception.getErrorCode() + ". " +
    		  exception.getMessage());
    }
  }
}