package com.creditos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class CreditosWebApplication {
    public static void main(String[] args) {
        SpringApplication.run(CreditosWebApplication.class, args);
    }
}
