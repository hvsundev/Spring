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

import com.moddk.swagger.service.TodoService;
import com.moddk.swagger.vo.TodoVO;

import io.swagger.annotations.ApiOperation;

@Controller
public class TodoController {
	
	@Autowired
	private TodoService service;
	
	@ApiOperation(value="초기 화면 진입", hidden = true)
	@RequestMapping(value = "/")
	private String goLogin(HttpServletRequest req) {
		
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id");
		
		// 기존에 로그인되어 있으면 home으로 redirect
		if(user_id == null) {
			return "login";
			
		} else {
			return "redirect:/home";
		}
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		
		// 로그아웃이면 session 만료
		session.invalidate();
		
		return "login";
	}
	
	@ApiOperation(value="로그인 시도", hidden = true)
	@RequestMapping(value = "/accessLogin", method = RequestMethod.POST)
	@ResponseBody
	private int accessLogin(HttpServletRequest req, @RequestParam String user_id, @RequestParam String user_pw) {
		
		// 비밀번호 검사 후 맞으면 1, 아니면 0 return
		int isPassed = service.loginCheck(user_id, user_pw);
		
		if(isPassed == 1) {
			HttpSession session = req.getSession();
			session.setAttribute("user_id", user_id);
			
			goHome(req); // 홈으로 이동
		}
		
		return isPassed;
	}
	
	@ApiOperation(value="Todo 화면 진입", hidden = true)
	@RequestMapping("/home")
	private String goHome(HttpServletRequest req) {
	
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id");
		
		List<TodoVO> todoList = service.getTodoList(0, user_id);
		req.setAttribute("todoList", todoList);
		
		return "todoList";
	}
	
	@ApiOperation(value = "TodoList 가져오기")
	@RequestMapping(value = "/select/todoList", method = RequestMethod.POST)
	@ResponseBody
	private HashMap<String, Object> getTodoList(HttpServletRequest req, @RequestParam int searchType) {
		
		System.out.println("searchType " + searchType);
		
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id");
		
		List<TodoVO> todoList = service.getTodoList(searchType, user_id);
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("todoList", todoList);
		
		return data;
	}
	
	@ApiOperation(value = "Todo 추가하기")
	@RequestMapping(value = "/insert/todoList", method = RequestMethod.GET)
	@ResponseBody
	private HashMap<String, Object> addTodoList(HttpServletRequest req, @RequestParam String contents, @RequestParam int searchType) {
		
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id");
		
		int isSuccess = service.addTodoList(contents, user_id);
		System.out.println(isSuccess > 0 ? "성공" : "실패");
		
		HashMap<String, Object> data = new HashMap<>();
		data.put("isSuccess", isSuccess);
		data.put("todoList", service.getTodoList(searchType, user_id));
	
		return data;
	}
	
	@ApiOperation(value="Todo 체크 시 완료여부 반영")
	@RequestMapping(value = "/update/todoList", method = RequestMethod.GET)
	@ResponseBody
	private HashMap<String, Object> updateComYnOfTodoList(HttpServletRequest req, @RequestParam int searchType, @RequestParam int idx) {
		
		int result = service.updateComYnOfTodoList(idx);
		System.out.println(result);
		
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id");
		
		HashMap<String, Object> data = new HashMap<>();
		data.put("todoList", service.getTodoList(searchType, user_id));
		 
		return data;
	}
	
	@ApiOperation(value = "Todo 삭제하기")
	@RequestMapping(value = "/delete/todoList", method = RequestMethod.POST)
	@ResponseBody
	private HashMap<String, Object> deleteTodo(HttpServletRequest req, @RequestParam int idx, @RequestParam int searchType) {
		
		
		HttpSession session = req.getSession();
		String user_id = (String)session.getAttribute("user_id");
		
		service.deleteTodo(idx, user_id);

		List<TodoVO> todoList = service.getTodoList(searchType, user_id);
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		data.put("todoList", todoList);
		
		return data;
	}
}
