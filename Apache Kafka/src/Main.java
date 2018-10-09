package com.spnotes.kafka;

import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

//import com.spnotes.test.SimpleConsumer;
//import com.spnotes.test.SimpleProducer;

import java.util.Arrays;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.ConsumerRecord;

 public class Main {
	  int args;
	  public static void main(String[] args)
	  {
		  //String topicName = args[0].toString();
		  ExecutorService service = Executors.newFixedThreadPool(2);
		  
		  SimpleProducer myproducer = new SimpleProducer(args);
		  SimpleConsumer myconsumer = new SimpleConsumer(args);
	    System.out.println("Hello World");
	    service.submit(myconsumer);
	    service.submit(myproducer);
	    
		   
	  }
	}
	 class SimpleProducer extends Thread{ 
		private String[] args;
		 public SimpleProducer(String[] args){
			 this.args = args;
		 }
		 
		@Override
		public void run()
		{ 
			String topicName;
			
			if(args.length == 0){
	       System.out.println("Topic name");
	       topicName = "todaydata";
	    } else {
	    	topicName= args[0].toString();
	    }
	    	     
	    Properties props = new Properties();
	    	    
	    props.put("bootstrap.servers", "localhost:9092");
	    
	         
	    props.put("acks", "all");
	    
	   
	    props.put("retries", 0);
	    
	   
	    props.put("batch.size", 16384);
	    
	      
	    props.put("linger.ms", 1);
	    
	    props.put("buffer.memory", 33554432);
	    
	    props.put("key.serializer", 
	       "org.apache.kafka.common.serialization.StringSerializer");
	       
	    props.put("value.serializer", 
	       "org.apache.kafka.common.serialization.StringSerializer");
	    
	    Producer<String, String> producer = new KafkaProducer
	       <String, String>(props);
	    System.out.println("before for");
	    for(int i = 0; i < 10; i++){
	    	System.out.println("before after");
	    	producer.send(new ProducerRecord<String, String>(topicName, 
	          Integer.toString(i), Integer.toString(i)));
	             System.out.println("Message sent !!" + i);
	    }
	           //  producer.close();
	 }
	}
	
	 class SimpleConsumer extends Thread {
		 private String[] args;
		 public SimpleConsumer(String[] args){
			 this.args = args;
		 }
		 
		 @Override
			 public void run()
		    {
				 String topicName;
				 if(args.length == 0){
		         System.out.println("Topic name");
		         topicName = "todaydata";
		      }else {
		    	  topicName = args[0].toString();
		      }
		       Properties props = new Properties();
		      
		       props.put("auto.offset.reset", "earliest");
		       
		       props.put("bootstrap.servers", "localhost:9092");
		       props.put("group.id", "todaydata");
		       props.put("enable.auto.commit", "true");
		       props.put("auto.commit.interval.ms", "1000");
		       props.put("session.timeout.ms", "30000");
		       props.put("key.deserializer", 
		          "org.apache.kafka.common.serialization.StringDeserializer");
		       props.put("value.deserializer", 
		          "org.apache.kafka.common.serialization.StringDeserializer");
		      
		      System.out.println("unti here");
		      KafkaConsumer<String, String> consumer = new KafkaConsumer
		         <String, String>(props);
		      System.out.println("not here");
		      consumer.subscribe(Arrays.asList(topicName));
		      
		      System.out.println("Subscribed to topic" + topicName);
		      int i = 0;
		      
		      while (true) {
		    	  System.out.println("rec");
		        ConsumerRecords<String, String> records = consumer.poll(100);
		     for (ConsumerRecord<String, String> record : records){
		         
		         System.out.printf("offset = %d, key = %s, value = %s\n", 
		            record.offset(), record.key(), record.value());
		        	// System.out.println("recieved");
		        }
		      }
		   }
		}