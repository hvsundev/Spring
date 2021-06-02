package com.moddk.swagger.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.moddk.swagger.service.TodoService;
import com.moddk.swagger.vo.TodoVO;

import io.swagger.annotations.ApiOperation;

@RestController
public class TodoController {
	
	private Gson gson = new Gson();
	
	@Autowired
	private TodoService service;
	
	@RequestMapping(value = "/")
	private String goHome() {
		return "todoList";
	}
	
	@ApiOperation(value = "투두리스트 가져오기")
	@RequestMapping(value = "/select/todoList", method = RequestMethod.GET)
	@ResponseBody
	private String getTodoList() {
		
		System.out.println("in getTodoList()");

		List<TodoVO> todoList = service.getTodoList();
		System.out.println("todoList >>> " +  todoList);
		
		return gson.toJson(todoList);
	}
}
