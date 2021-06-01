package com.moddk.swagger.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;

@RestController
public class ApiSwaggerController {
	
	private Gson gson = new Gson();
	
	// json 타입으로 리턴
	@RequestMapping("/select")
	private String getTodoList() {
		
		return gson.toJson("");
	}
}
