// first commit

class Fibonacci {
  public static void main(String[] args) {
    System.out.println("Hello world");
  }
}

// second commit

class Fibonacci {
  public static void main(String[] args) {
    System.out.println("0");
    System.out.println("1");
    System.out.println("1");
    System.out.println("2");
    System.out.println("3");
    System.out.println("5");
    System.out.println("8");
    System.out.println("13");
    System.out.println("21");
    System.out.println("34");
    System.out.println("55");
  }
}

// merge

class Fibonacci {
  public static void main(String[] args) {
    int i = 0;
    while (i <= 10) {
        System.out.println(Fibonacci.fibbonaci(i) + "\n");
        i++;
    }
  }

  public static int fibbonaci(int number) {
    if (number <= 1) {
        return number;
    }

    return Fibonacci.fibbonaci(number - 1) + Fibonacci.fibbonaci(number - 2);
  }
}

// second merge

class Fibonacci {
  public static void main(String[] args) throws Exception {
    int i = 0;
    while (i <= 10) {
        System.out.println(Fibonacci.fibbonaci(i) + "\n");
        i++;
    }
  }

  public static int fibbonaci(int number) throws Exception {
    // PR
    if (number < 0) {
        throw new Exception("Votseke");
    }

    if (number <= 1) {
        return number;
    }

    // conflict created by
    // persan a Removing Fibbonaci prefix and reordering addition
    // person b chanigng the method fibbonaci to fibonacciFor
    return Fibonacci.fibbonaci(number - 1) + Fibonacci.fibbonaci(number - 2);
  }
}
