class Test {
    public static void main(String[] a) {
        System.out.println(new B().printAndAdd(5));
    }
}

class B {
    public int printAndAdd(int a) {
        boolean z;
        z = false;

        if(!z) {
            System.out.println(a);
        }

        return 0;
    }
}
