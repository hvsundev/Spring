package com.moddk.swagger.service;

import java.util.List;

import com.moddk.swagger.vo.TodoVO;

public interface TodoService {

	// TodoList 가져오기
	public List<TodoVO> getTodoList(int searchType, String user_id);
	
	// TodoList 추가하기
	public int addTodoList(String contents, String user_id);
	
	// TodoList 값 변경하기
	public int updateComYnOfTodoList(int idx);
	
	// Todo 삭제하기
	public int deleteTodo(int idx, String user_id);		
}
