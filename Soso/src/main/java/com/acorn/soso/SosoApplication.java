package com.acorn.soso;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
public class SosoApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(SosoApplication.class, args);
	}

}
