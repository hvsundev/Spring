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
	public List<TodoVO> getTodoList() {
		return mapper.getTodoList();
	}
	
}
