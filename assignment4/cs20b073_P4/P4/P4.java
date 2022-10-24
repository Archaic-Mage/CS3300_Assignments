import syntaxtree.*;
import visitor.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         //System.out.println("Program parsed successfully");
         GJDepthFirst df = new GJDepthFirst();
         Object value = root.accept(df, null); // Your assignment part is invoked here.
         value = root.accept(df, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 



