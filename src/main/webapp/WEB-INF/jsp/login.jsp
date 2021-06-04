<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">

<!-- CSS -->
<link href="../css/css.css" rel="stylesheet" type="text/css">

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

</head>
<body>
	<div class="list_box">
		<div class="loginWrap">
			<div class="intro">
				<p class="color_green">Welcome!</p>
				<p class="color_grey">오늘의 할 일에 오신 것을 환영합니다.</p>
			</div>
			<div class="login">
				<div>
					<input id="user_id" value="dabinch" type="text" placeholder="아이디를 입력해 주세요.">
					<input id="user_pw" type="password" placeholder="비밀번호를 입력해 주세요.">
				</div>
				<div>
					<input type="checkbox" class="rmbId"><label>아이디를 기억할래요.</label>
				</div>
			</div>
			<div>
				<button onClick="checkLogin()">로그인</button>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
		
	function checkLogin() {
		
		var user_id = $("#user_id").val();
		$.ajax({
			url: '/accessLogin',
			method: 'POST',
			async: true,
			data: {
				"user_id" : user_id
			},
			success: function() {
			}
		})
	}
		
</script>

</html>