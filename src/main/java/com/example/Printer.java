package com.example;

import org.joda.time.LocalTime;

public class Printer {

    private CanPrint printer;

    public Printer(CanPrint printer) {
        this.printer = printer;
    }

    public void sayHi() {
        this.printer.print("Hi!");
    }

    public void sayWhat(String what) {
        this.printer.print(what);
    }

    public void printTime() {
      LocalTime currentTime = new LocalTime();
      this.printer.print("The current local time is: " + currentTime);
    }
}

interface CanPrint {
    public void print(String output);
}