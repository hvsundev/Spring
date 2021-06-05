package com.moddk.swagger.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.moddk.swagger.vo.TodoVO;

@Mapper
public interface TodoMapper {
	public List<TodoVO> getAllTodoList(String user_id);
	public List<TodoVO> getActiveTodoList(String user_id);
	public List<TodoVO> getCompletedTodoList(String user_id);
	public int addTodoList(String contents, String user_id);
	public int updateComYnOfTodoList(int idx);
}

