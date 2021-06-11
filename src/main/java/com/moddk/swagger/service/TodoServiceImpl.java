package com.moddk.swagger.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.moddk.swagger.mapper.TodoMapper;
import com.moddk.swagger.vo.TodoVO;

@Service
public class TodoServiceImpl implements TodoService {
	
	@Autowired
	private TodoMapper mapper;

	@Override
	public List<TodoVO> getTodoList(int searchType, String user_id) {
		if(searchType == 0) {
			return mapper.getAllTodoList(user_id);
		} else if(searchType == 1) {
			return mapper.getActiveTodoList(user_id);
		} else {
			return mapper.getCompletedTodoList(user_id);
		}
	}

	@Override
	public int addTodoList(String contents, String user_id) {
		return mapper.addTodoList(contents, user_id);
	}

	@Override
	public int updateComYnOfTodoList(int idx) {
		return mapper.updateComYnOfTodoList(idx);
	}

	@Override
	public int deleteTodo(int idx, String user_id) {
 		return mapper.deleteTodo(idx, user_id);
	}

	@Override
	public int loginCheck(String user_id, String compare_user_pw) {
		
		String user_pw = mapper.getUserPw(user_id);
		int isPassed = user_pw.equals(compare_user_pw) ? 1 : 0;
		
		return isPassed;
	}
	
}
