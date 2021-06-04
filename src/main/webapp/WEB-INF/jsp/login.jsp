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
				<p class="color_grey">������ �� �Ͽ� ���� ���� ȯ���մϴ�.</p>
			</div>
			<div class="login">
				<div>
					<input id="user_id" value="dabinch" type="text" placeholder="���̵� �Է��� �ּ���.">
					<input id="user_pw" type="password" placeholder="��й�ȣ�� �Է��� �ּ���.">
				</div>
				<div>
					<input type="checkbox" class="rmbId"><label>���̵� ����ҷ���.</label>
				</div>
			</div>
			<div>
				<button onClick="checkLogin()">�α���</button>
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