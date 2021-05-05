package com.example;

public class ProjectRunner {
    public static void main(String args[]) {
        Printer printer = new Printer(s -> System.out.println(s));
        printer.sayHi();
        Point p = new Point(1,2);
        printer.sayWhat("Created point record: " + p.toString());
    }
}