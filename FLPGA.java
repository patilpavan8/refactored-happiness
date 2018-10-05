//Implementation of a real-world application for a Facility Location Problem using Genetic Algorithm.



import java.util.*;
import java.util.List;
import java.awt.*;
import javax.swing.*;

public class FLPGA extends JFrame {
  Random generator = new Random(1);
  int num = generator.nextInt(40) + 30;

  int group;
  double[] xcr = new double[num];
  double[] ycr = new double[num];
  
 
  int[] fit;

  {
    for (int x = 0; x < num; x++) {
    	xcr[x] = generator.nextDouble();
    	ycr[x] = generator.nextDouble();
    }
  }

  public void GA() {
	  fit = new int[num];
    for (int p = 0; p < num; p++)
    	fit[p] = p;
    
    //initialize the population
    
    final int popSize = 200;
    final Population pop = new Population(popSize);
    final int q = xcr.length;
    for (int x = 0; x < popSize; x++)
    	pop.chromosomeofga.add(new ChromosomeofGA(OptimizeDistance(getRandomCombination(q))));

    final double mutationSpeed = 0.3;
    final int NumOfGenerations = 100;

    for (group = 0; group < NumOfGenerations; group++) {
    	
    
    	
      while (pop.chromosomeofga.size() < pop.populationCapacity) {
        int p1 = generator.nextInt(pop.chromosomeofga.size());
        int p2 = (p1 + 1 + generator.nextInt(pop.chromosomeofga.size() - 1)) % pop.chromosomeofga.size();

        ChromosomeofGA par_1 = pop.chromosomeofga.get(p1);
        ChromosomeofGA par_2 = pop.chromosomeofga.get(p2);

        int[][] pairForCrossover = CrossOverOperator(par_1.edge, par_2.edge);

        if (generator.nextDouble() < mutationSpeed) {
        	mutation(pairForCrossover[0]);
        	mutation(pairForCrossover[1]);
        }

        pop.chromosomeofga.add(new ChromosomeofGA(OptimizeDistance(pairForCrossover[0])));
        pop.chromosomeofga.add(new ChromosomeofGA(OptimizeDistance(pairForCrossover[1])));
      }
      pop.nextGenerationOffspring();
      fit = pop.chromosomeofga.get(0).edge;
      repaint();
    }
  }

  int[][] CrossOverOperator(int[] par1, int[] par2) {	
    int p = par1.length;
    int m1 = generator.nextInt(p);
    int m2 = (m1 + 1 + generator.nextInt(p - 1)) % p;

    int[] l1 = par1.clone();
    int[] l2 = par2.clone();

    boolean[] UsedPosition1 = new boolean[p];
    boolean[] UsedPosition2 = new boolean[p];

    for (int x = m1; ;x = (x + 1) % p) {
      l1[x] = par2[x];
      UsedPosition1[l1[x]] = true;
      l2[x] = par1[x];
      UsedPosition2[l2[x]] = true;
      if (x == m2) {
        break;
      }
    }

    for (int j = (m2 + 1) % p; j != m1; j = (j + 1) % p) {
      if (UsedPosition1[l1[j]]) {
        l1[j] = -1;
      } else {
    	  UsedPosition1[l1[j]] = true;
      }
      if (UsedPosition2[l2[j]]) {
        l2[j] = -1;
      } else {
    	  UsedPosition2[l2[j]] = true;
      }
    }

    int position1 = 0;	
    int position2 = 0;
    for (int j = 0; j < p; j++) {
      if (l1[j] == -1) {
        while (UsedPosition1[position1])
          ++position1;	
        l1[j] = position1++;
      }
      if (l2[j] == -1) {
        while (UsedPosition2[position2])
          ++position2;
        l2[j] = position2++;
      }
    }
    return new int[][]{l1, l2};
  }

  void mutation(int[] var) {
    int m = var.length;
    int x = generator.nextInt(m);
    int y = (x + 1 + generator.nextInt(m - 1)) % m;
    localsearch(var, x, y);
  }

 
  static void localsearch(int[] q, int x, int y) {
    int m = q.length;
   
    while (x != y) {
      int temp = q[y];
      q[y] = q[x];
      q[x] = temp;
      x = (x + 1) % m;
      if (x == y) break;
      y = (y - 1 + m) % m;
    }
  }

  double evaluate(int[] position) {
    double r = 0;
    for (int x = 0, y = position.length - 1; x < position.length; y = x++)
      r += distance(xcr[position[x]], ycr[position[x]], xcr[position[y]], ycr[position[y]]);
    return r;
  }

  static double distance(double i1, double j1, double i2, double j2) {
    double distx = i1 - i2;
    double disty = j1 - j2;
    return Math.sqrt(distx * distx + disty * disty);
  }

  int[] getRandomCombination(int x) {
    int[] r = new int[x];
    for (int p = 0; p < x;p++) {
      int m = generator.nextInt(p + 1);
      r[p] = r[m];
      r[m] = p;
    }
    return r;
  }

  // Local Search
  int[] OptimizeDistance(int[] n) {
    int[] move = n.clone();
    for (boolean better = true; better; ) {
    	better = false;
      for (int x = 0; x < num; x++) {
        for (int y = 0; y < num; y++) {
          if (x == y || (y + 1) % num == x) continue;
          int x1 = (x - 1 + num) % num;
          int y1 = (y + 1) % num;
          double ObjFun = distance(xcr[move[x1]], ycr[move[x1]], xcr[move[y]], ycr[move[y]])
              + distance(xcr[move[x]], ycr[move[x]], xcr[move[y1]], ycr[move[y1]])
              - distance(xcr[move[x1]], ycr[move[x1]], xcr[move[x]], ycr[move[x]])
              - distance(xcr[move[y]], ycr[move[y]], xcr[move[y1]], ycr[move[y1]]);
          if (ObjFun < -1e-9) {
        	  localsearch(move, x, y);
        	  better = true;
          }
        }
      }
    }
    return move;
  }

  class ChromosomeofGA implements Comparable<ChromosomeofGA> {
    final int[] edge;
    //private double cost = Double.NaN;

    private double costofEdge ;	

    public ChromosomeofGA(int[] route) {
      this.edge = route;
    }

    public double getTotalCost() {
      return Double.isNaN(costofEdge) ? costofEdge = evaluate(edge) : costofEdge;
    }

    @Override
    public int compareTo(ChromosomeofGA obj) {
      return Double.compare(getTotalCost(), obj.getTotalCost());
    }
  }

  static class Population {
    List<ChromosomeofGA> chromosomeofga = new ArrayList<>();
    final int populationCapacity;

    public Population(int populationCapacity) {
      this.populationCapacity = populationCapacity;
    }

    public void nextGenerationOffspring() {
      Collections.sort(chromosomeofga);
      chromosomeofga = new ArrayList<>(chromosomeofga.subList(0, (chromosomeofga.size() + 1) / 2));
    }
  }

//Swing Frame display code
  public FLPGA() {
      setContentPane(new JPanel() {
      protected void paintComponent(Graphics plane) {
        super.paintComponent(plane);
       // ((Graphics2D) plane).setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
       //((Graphics2D) plane).setStroke(new BasicStroke(3));
        plane.setColor(Color.BLUE);
        int width = getWidth() - 10;
        int height = getHeight() - 50;
        for (int x = 0, y = num - 1; x < num; y = x++)
        	plane.drawLine((int) (xcr[fit[x]] * width), (int) ((1 - ycr[fit[x]]) * height),
              (int) (xcr[fit[y]] * width), (int) ((1 - ycr[fit[y]]) * height));
        plane.setColor(Color.RED);
        for (int m = 0; m < num; m++)
        	plane.drawOval((int) (xcr[m] * width) - 1, (int) ((1 - ycr[m]) * height) - 1, 6, 6);
        plane.setColor(Color.BLACK);
        
        plane.drawString(String.format("length: %.4f", evaluate(fit)), 5, height + 30);
        plane.drawString(String.format("group: %d", group), 130, height + 20);
      }
    });
    setSize(new Dimension(500, 500));
    setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    setVisible(true);
    new Thread(this::GA).start();
  }

  public static void main(String[] args) {
    new FLPGA();
  }
}