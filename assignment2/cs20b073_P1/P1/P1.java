import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P1 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         GJDepthFirst df = new GJDepthFirst();
         //Invoking for the first time to make symbol table and parse check
         Object value = root.accept(df, null); // Your assignment part is invoked here.
         value = root.accept(df, null); //invoking second time for the type checking
         System.out.println("Program type checked successfully");
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
