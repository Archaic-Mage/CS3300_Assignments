class Test {
    public static void main(String[] a) {
        System.out.println(new B().printAndAdd(5));
    }
}

class B {
    int x;
    public int printAndAdd(int a) {
        x = a;
        return x;  
    }
}