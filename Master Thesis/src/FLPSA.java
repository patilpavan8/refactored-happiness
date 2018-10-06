//Implementation of a real-world application for a Facility Location Problem using Simulated Annealing Algorithm.



import java.util.Random;
import javax.swing.*;
import java.awt.*;


public class FLPSA extends JFrame {
  Random generator = new Random(1);
  int num = generator.nextInt(30) + 20;

  int[] optimalState;
  double[] xcr = new double[num];
  double[] ycr = new double[num];

  {
    for (int x = 0; x < num; x++) {
      xcr[x] = generator.nextDouble();
      ycr[x] = generator.nextDouble();	
    }
  }

  public void SimulatedAnnealing() {
    int[] presentState = new int[num];
    for (int j = 0; j < num; j++)
    	presentState[j] = j;
    double presentEnergy = evaluate(presentState);
    optimalState = presentState.clone();
    double optimalEnergy = presentEnergy;
    for (double Temperature = 0.07, coolFactor = 0.99; Temperature > 1e-4; Temperature = Temperature*coolFactor) {
      int x = generator.nextInt(num);
      int y = (x + 1 + generator.nextInt(num - 2)) % num;
      int x1 = (x - 1 + num) % num;
      int y1 = (y + 1) % num;
      double ObjFun = distance(xcr[presentState[x1]], ycr[presentState[x1]], xcr[presentState[y]], ycr[presentState[y]])
          + distance(xcr[presentState[x]], ycr[presentState[x]], xcr[presentState[y1]], ycr[presentState[y1]])
          - distance(xcr[presentState[x1]], ycr[presentState[x1]], xcr[presentState[x]], ycr[presentState[x]])
          - distance(xcr[presentState[y]], ycr[presentState[y]], xcr[presentState[y1]], ycr[presentState[y1]]);
      if (ObjFun < 0 || Math.exp(-ObjFun / Temperature) > generator.nextDouble()) {
    	  localsearch(presentState, x, y);
        presentEnergy =presentEnergy+ ObjFun;

        if (optimalEnergy > presentEnergy) {
        	optimalEnergy = presentEnergy;
          System.arraycopy(presentState, 0, optimalState, 0, num);
          repaint();
        }
      }
    }
  }	

  //  Local Search
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
    for (int m = 0, n = position.length - 1; m < position.length; n = m++)
      r += distance(xcr[position[m]], ycr[position[m]], xcr[position[n]], ycr[position[n]]);
    return r;
  }

  static double distance(double i1, double j1, double i2, double j2) {
    double distx = i1 - i2;
    double disty = j1 - j2;
    return Math.sqrt(distx * distx + disty * disty);
  }

  // Swing Frame display code
  public FLPSA() {
    setContentPane(new JPanel() {
      protected void paintComponent(Graphics plane) {
        super.paintComponent(plane);
       // ((Graphics2D) plane).setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        //((Graphics2D) plane).setStroke(new BasicStroke(3));
        plane.setColor(Color.BLUE);
        int width = getWidth() - 10;
        int height = getHeight() - 30;
        for (int m = 0, n = num - 1; m < num; n = m++)
        	plane.drawLine((int) (xcr[optimalState[m]] * width), (int) ((1 - ycr[optimalState[m]]) * height),
              (int) (xcr[optimalState[n]] * width), (int) ((1 - ycr[optimalState[n]]) * height));
        plane.setColor(Color.RED);
        for (int j = 0; j < num; j++)
        	plane.drawOval((int) (xcr[j] * width) - 1, (int) ((1 - ycr[j]) * height) - 1, 6, 6);
        plane.setColor(Color.BLACK);
        plane.drawString(String.format("length: %.4f", evaluate(optimalState)), 5, height + 30);
      }
    });
    setSize(new Dimension(500, 500));
    setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    setVisible(true);
    new Thread(this::SimulatedAnnealing).start();
  }

  public static void main(String[] args) {
    new FLPSA();
  }
}