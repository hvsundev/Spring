package com.moddk.swagger.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.moddk.swagger.vo.TodoVO;

@Mapper
public interface TodoMapper {
	public List<TodoVO> getTodoList();
}
