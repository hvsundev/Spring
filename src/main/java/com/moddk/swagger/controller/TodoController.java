package com.moddk.swagger.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.	Gson;
import com.moddk.swagger.service.TodoService;
import com.moddk.swagger.vo.TodoVO;

import io.swagger.annotations.ApiOperation;

@Controller
public class TodoController {
	
	private Gson gson = new Gson();
	
	@Autowired
	private TodoService service;
	
	@RequestMapping("/")
	private String goLogin() {
		return "login";
	}
	
	@RequestMapping(value = "/accessLogin", method = RequestMethod.POST)
	private String accessLogin(HttpServletRequest req, @RequestParam String user_id) {
		
		System.out.println("user_id >>> " + user_id);
		
		HttpSession session = req.getSession();
		session.setAttribute("user_id", user_id); // 임시코드
		
		//TODO: 로그인 처리 로직
		//TODO: home에서 로그인되지않은 회원일 경우 로그인화면으로 이동
		
		return "redirect:/home";
	}
	
	@RequestMapping("/home")
	private String goHome(HttpServletRequest req) {
		
		try {
			System.out.println("[goHome] 여기?");
			
			HttpSession session = req.getSession();
			String user_id = (String)session.getAttribute("user_id"); // 구현 후 주석풀기
			
			System.out.println("[goHome] user_id >>> " + user_id);
			
			List<TodoVO> todoList = service.getTodoList(0, user_id);
			req.setAttribute("todoList", todoList);
			
		} catch (Exception e) {
			System.out.println(e);
		}
		
		return "todoList";
	}
	
	@ApiOperation(value = "투두리스트 가져오기")
	@RequestMapping(value = "/select/todoList", method = RequestMethod.POST)
	@ResponseBody
	private HashMap<String, Object> getTodoList(HttpServletRequest req, @RequestParam int searchType) {
		
		System.out.println("searchType " + searchType);
		
//		HttpSession session = req.getSession();
//		String user_id = (String)session.getAttribute("user_id"); // 구현 후 주석풀기
		String user_id = "dabinch";
		
		List<TodoVO> todoList = service.getTodoList(searchType, user_id);
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("todoList", todoList);
		
		return data;
	}
	
	@ApiOperation(value = "투두리스트 추가하기")
	@RequestMapping(value = "/insert/todoList", method = RequestMethod.GET)
	@ResponseBody
	private HashMap<String, Object> addTodoList(HttpServletRequest req, @RequestParam String contents, @RequestParam int searchType) {
		
		int isSuccess = service.addTodoList(contents);
		System.out.println(isSuccess > 0 ? "성공" : "실패");
		
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id"); // 구현 후 주석풀기
		
		HashMap<String, Object> data = new HashMap<>();
		data.put("isSuccess", isSuccess);
		data.put("todoList", service.getTodoList(searchType, user_id));
	
		return data;
	}
	
	@ApiOperation(value="체크 시 완료여부 반영")
	@RequestMapping(value = "/update/todoList", method = RequestMethod.GET)
	@ResponseBody
	private String updateComYnOfTodoList(@RequestParam int idx) {
		
		int result = service.updateComYnOfTodoList(idx);
		System.out.println(result);
		 
		return gson.toJson(result);
	}
}
