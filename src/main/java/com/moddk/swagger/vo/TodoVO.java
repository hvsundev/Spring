package com.moddk.swagger.vo;

public class TodoVO {
	private int idx;
	private String contents;
	private String complete_yn;
	private String user_id;
	
	public TodoVO() {}

	public TodoVO(int idx, String contents, String complete_yn, String user_id) {
		this.idx = idx;
		this.contents = contents;
		this.complete_yn = complete_yn;
		this.user_id = user_id;
	}
	
	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getComplete_yn() {
		return complete_yn;
	}

	public void setComplete_yn(String complete_yn) {
		this.complete_yn = complete_yn;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	@Override
	public String toString() {
		return "TodoVO [idx=" + idx + ", contents=" + contents + ", complete_yn=" + complete_yn + ", user_id=" + user_id
				+ "]";
	}
}
