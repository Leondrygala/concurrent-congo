package com.example;

import static org.junit.jupiter.api.Assertions.assertEquals;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

class CalculatorTests {

    public class MockPrinter implements CanPrint {

        private String output;

        public MockPrinter(){
            this.output = "";
        }

        public void print(String s){
            output = s;
        }

        public String getLastPrint(){
            return output;
        }
    }

    @Test
    @DisplayName("Says Hi!")
    void saysHi() {
        MockPrinter mock = new MockPrinter();
        Printer p = new Printer(mock);
        p.sayHi();
        assertEquals("Hi!", mock.getLastPrint(), "Printer should say Hi!");
    }

    @ParameterizedTest(name = "{0} + {1} = {2}")
    @ValueSource(strings = {"This", "That"})
    void add(String param) {
        MockPrinter mock = new MockPrinter();
        Printer p = new Printer(mock);
        p.sayWhat(param);
        assertEquals(param, mock.getLastPrint(), "Printer should sayWhat: " + param);
    }
}