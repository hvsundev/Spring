package com.moddk.swagger.vo;

import lombok.Data;

@Data
public class TodoVO {
	private int idx;
	private String contents;
	private String complete_yn;
	private String user_id;
}
