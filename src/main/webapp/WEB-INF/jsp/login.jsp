<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- CSS -->
<link href="static/css/css.css" rel="stylesheet" type="text/css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

</head>
<body>
	<div class="list_box">
		<div class="loginWrap">
			<div class="intro">
				<p class="color_green">Welcome!</p>
				<p class="color_grey">오늘의 할일</p>
			</div>
			<div class="login">
				<div>
					<input id="user_id" value="dabinch" type="text" placeholder="아이디를 입력해 주세요.">
					<input id="user_pw" value="1234" type="password" placeholder="비밀번호를 입력해 주세요.">
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

	// 아이디 기억 로직 (구현 중)
	$(".rmbId").on('click', function() {
		// 체크여부
		var flag = $(this).prop("checked");
	});
		
	// 로그인 로직 (구현 중)
	function checkLogin() {
		
		var user_id = $("#user_id").val();
		var user_pw = $("#user_pw").val();
		
		console.log(user_id);
		console.log(user_pw);
		
		if(user_id.length == 0 || user_pw.length == 0) {
			alert("정보를 모두 입력해주세요.");
		} else {
			$.ajax({
				url: '/accessLogin',
				method: 'POST',
				async: true,
				data: {
					"user_id" : user_id,
					"user_pw" : user_pw,
				},
				success: function(data) {
					console.log(data);
					if(data == 1) {
						location.href = "/home";
					} else {
						alert("아이디 또는 비밀번호가 틀렸습니다.");
					}
				}
			})
		}
	}
		
</script>

</html>