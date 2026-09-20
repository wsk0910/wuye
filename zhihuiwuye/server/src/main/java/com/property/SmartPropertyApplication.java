package com.property;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.property.mapper")
public class SmartPropertyApplication {
    public static void main(String[] args) {
        SpringApplication.run(SmartPropertyApplication.class, args);
    }
}
