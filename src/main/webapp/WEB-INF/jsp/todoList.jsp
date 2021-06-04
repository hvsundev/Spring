<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">

<!-- CSS -->
<link href="../css/css.css" rel="stylesheet" type="text/css">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

</head>
<body>
	<div class="list_box">
		<div class="title">
			<h3>TodoList</h3>
		</div>
			<div class="btn_box">
				<div class="subTab">
					<li onclick="changeType(0)">ALL</li>
					<li onclick="changeType(1)">ACTIVE</li>
					<li onclick="changeType(2)">COMPLETED</li>
					<div class="btnAdd" onclick="clickAddBtn()">
						Add
					</div>
				</div>
			<!-- <span class="count">${fn:length(todoList)}개</span>  -->
		</div>
		
		<div class="list">
			<c:forEach var="item" items="${ todoList }">
				<c:choose>
					<c:when test="${fn:length(todoList) == 0}">
						<span>등록된 할 일이 없습니다.</span>
					</c:when>
					<c:otherwise>
						<li class="list${ item.idx } ${ item.complete_yn == 'Y' ? 'checked' : '' }">
							<input type="checkbox" value="${ item.idx }" id="middle${ item.idx }" ${ item.complete_yn == 'Y' ? 'checked' : '' }>
							<label for="middle${ item.idx }">${ item.contents }</label>
						</li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
	</div>
</body>

<script type="text/javascript">

	/*
		- 커스텀 alert 만들기
	*/
	
	$(document).ready(function() {
		initCheckBoxClickEvent();
	})
	
	function initCheckBoxClickEvent() {
		$("input[type='checkbox']").on('click', function() {
			
			var todoIndex = $(this).val();
			var flag = $(this).prop("checked");
			
			$.ajax({
				url: '/update/todoList',
				method: 'GET',
				async: true,
				data: {
					"idx" : todoIndex
				},
				success: function() {
					if(flag) {
						$(".list" + todoIndex).addClass('checked');
					} else {
						$(".list" + todoIndex).removeClass('checked');
					}
				}
			})
		});
	}
	
	function changeType(type) {
		$.ajax({
			url: '/select/todoList',
			method: 'POST',
			data: {
				"searchType": type
			},
			success: function(data) {
				var todoList = data.todoList;
				$(".list").empty();
				for(var i=0; i<todoList.length; i++) {
					var checked = data.todoList[i].complete_yn == 'Y' ? 'checked' : '';
					$(".list").append('<li class="list' + todoList[i].idx + ' ' + checked + '"></li>');
					$(".list" + todoList[i].idx).append('<input type="checkbox" value="' + todoList[i].idx + '" id="middle' + todoList[i].idx + '" ' + checked + '>');
					$(".list" + todoList[i].idx).append('<label for="middle' + todoList[i].idx + '">' + todoList[i].contents + '</label>');
					initCheckBoxClickEvent();
				}
			}
		})
	}
	
	// add 버튼 클릭 시
	function clickAddBtn() {

		// 이미 추가용 프레임이 존재하는 경우
		if($(".newTodoFrame").length) {
			// 텍스트 박스에 값이 존재할 때
			if($(".newTodoContents").val().length > 0) {
				var flag = confirm("이미 할 일이 존재합니다. 새로 작성하시겠습니까?");
				if(flag) {
					cancleAdd();
					addNewTodo();
				}
			// 텍스트에 값이 존재하지 않을 때
			} else {
				cancleAdd();
				addNewTodo();
			}
		
		// 프레임이 없는 경우
		} else {
			addNewTodo();
		}
	}
	
	function addNewTodo() {
		$(".list").append("<li class='newTodoFrame'></li>");
		$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
		$(".newTodoFrame").append("<button onclick='addTodo()'>추가</button><button onclick='cancleAdd()'>취소</button>");
	}
	
	function addTodo() {
		var contents = $(".newTodoContents").val();
		
		if(contents.length == 0) {
			alert("값을 입력해주세요.");
			// 텍스트박스 깜짝이게 하기
		} else {
			$.ajax({
				url: "/insert/todoList",
				method: 'GET',
				async: true,
				data: {
					"contents" : contents
				},
				success : function(data) {
					if(data.isSuccess > 0) {
						alert("등록완료되었습니다.");
						
						var todoList = data.todoList;
						$(".list").empty();
						for(var i=0; i<todoList.length; i++) {
							var checked = data.todoList[i].complete_yn == 'Y' ? 'checked' : '';
							$(".list").append('<li class="list' + todoList[i].idx + ' ' + checked + '"></li>');
							$(".list" + todoList[i].idx).append('<input type="checkbox" value="' + todoList[i].idx + '" id="middle' + todoList[i].idx + '" ' + checked + '>');
							$("#middle" + todoList[i].idx).append('<label for="middle' + todoList[i].idx + '">' + todoList[i].contents + '</label>');
							initCheckBoxClickEvent();
						}
					}
				}
			})
		}
	}
	
	function cancleAdd() {
		if($(".newTodoContents").val().length > 0) {
			var flag = confirm("이미 할 일이 존재합니다. 취소하시겠습니까?");
			if(flag) {
				$(".newTodoFrame").remove();
			}
		} else {
			$(".newTodoFrame").remove();
		}
	}

</script>

</html>