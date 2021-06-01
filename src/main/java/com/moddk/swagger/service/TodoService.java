package com.moddk.swagger.service;

import java.util.List;

import com.moddk.swagger.vo.TodoVO;

public interface TodoService  {

	// TodoList 가져오기
	public List<TodoVO> getTodoList();
		
}
