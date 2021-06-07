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
		<!-- <span class="count">${fn:length(todoList)}개</span>  -->
		<div class="time_wrap">
			<div>
				<input type="date" id="currentDate">
			</div>
			<div class="time_wrap_box">
				<div id="box_hour1"></div>
				<div id="box_hour2"></div>
				<span></span>
				<div id="box_minite1"></div>
				<div id="box_minite2"></div>
			</div>
		</div>
		<div class="btn_box">
			<div class="subTab">
				<li class="active" value="0" onclick="changeType(0)">ALL</li>
				<li value="1" onclick="changeType(1)">ACTIVE</li>
				<li value="2" onclick="changeType(2)">COMPLETED</li>
				<div class="btnAdd" onclick="clickAddBtn()">
					Add
				</div>
			</div>
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
							<button class="delBtn" onclick="deleteTodo(${ item.idx })" style="display: none;">삭제</button>
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
		
		var listEl = $(".subTab > li");
		listEl.click(function() {
			var subIdx = $(this).val();
			listEl.removeClass("active");
			$(this).addClass("active");
		})
		
		showDeleteBtn();
		setTime();
		setInterval(setTime, 1000);
		
	})
	
	function showDeleteBtn() {
		$(".list > li").each(function(index, item) {
			$(item).mouseover(function() {
				$(item).children("button").css("display", "inline");
			});
			$(item).mouseout(function() {
				$(item).children("button").css("display", "none");
			});
		});
	}
	
	function deleteTodo(todoIdx) {
		console.log("todoIdx >>> ", todoIdx);
	}
	
	function setTime() {
		
		// 방법 1
		const time = new Date();
		var hour = time.getHours().toString();
		var minutes = time.getMinutes().toString();

		hour = hour.length == 1 ? "0" + hour : hour;
		minutes = minutes.length == 1 ? "0" + minutes : minutes;
	    
		document.getElementById("currentDate").value = new Date().toISOString().substring(0, 10);
		document.getElementById('box_hour1').innerHTML = hour.substring(0, 1);
		document.getElementById('box_hour2').innerHTML = hour.substring(1, 2);
		document.getElementById('box_minite1').innerHTML = minutes.substring(0, 1);
		document.getElementById('box_minite2').innerHTML = minutes.substring(1, 2);
		
	    // 방법 2
	    /*
		document.getElementById("currentDate").value = new Date().toISOString().substring(0, 10);
		document.getElementById('box_hour1').innerHTML = new Date().toISOString().slice(11, 12);
		document.getElementById('box_hour2').innerHTML = new Date().toISOString().slice(12, 13);
		document.getElementById('box_minite1').innerHTML = new Date().toISOString().slice(14, 15);
		document.getElementById('box_minite2').innerHTML = new Date().toISOString().slice(15, 16);
		*/
	}
	
	
	// 체크박스 초기화
	// ajax 후 다시 크려진 엘리먼트에는 클릭이벤트가 적용되지 않는 현상으로
	// $(document).on('click', className, function() {})으로 시도해보았으나
	// 이렇게되면 문제가 생겨서 function으로 따로 빼고 ajax 후 해당 function 호출함
	function initCheckBoxClickEvent() {
		$("input[type='checkbox']").on('click', function() {
			// 체크여부
			var flag = $(this).prop("checked");
			
			var todoIndex = $(this).val();
			var subType = document.getElementsByClassName("active")[0].value;
			
			$.ajax({
				url: '/update/todoList',
				method: 'GET',
				async: true,
				data: {
					"idx" : todoIndex,
					"searchType" : subType
				},
				success: function(data) {
					if(flag) {
						$(".list" + todoIndex).addClass('checked');
					} else {
						$(".list" + todoIndex).removeClass('checked');
					}
					
					refreshList(data);
					initCheckBoxClickEvent();
				}
			})
		});
	}
	
	function changeType(type) {
		console.log("현재 타입 >>> ", type);
		$.ajax({
			url: '/select/todoList',
			method: 'POST',
			data: {
				"searchType": type
			},
			success: function(data) {
				refreshList(data);
				initCheckBoxClickEvent();
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
	
	function addTodo() {
		var contents = $(".newTodoContents").val();
		var subType = document.getElementsByClassName('active')[0].value;
		
		if(contents.length == 0) {
			alert("값을 입력해주세요.");
			// 텍스트박스 깜짝이게 하기
		} else {
			$.ajax({
				url: "/insert/todoList",
				method: 'GET',
				async: true,
				data: {
					"contents" : contents,
					"searchType" : subType 
				},
				success : function(data) {
					if(data.isSuccess > 0) {
						alert("등록완료되었습니다.");
						var todoList = data.todoList;
						refreshList(data);
						initCheckBoxClickEvent();
					}
				}
			})
		}
	}
	
	function refreshList(data) {
		var todoList = data.todoList;
		$(".list").empty();
		for(var i=0; i<todoList.length; i++) {
			var checked = data.todoList[i].complete_yn == 'Y' ? 'checked' : '';
			$(".list").append('<li class="list' + todoList[i].idx + ' ' + checked + '"></li>');
			$(".list" + todoList[i].idx).append('<input type="checkbox" value="' + todoList[i].idx + '" id="middle' + todoList[i].idx + '" ' + checked + '>');
			$(".list" + todoList[i].idx).append('<label for="middle' + todoList[i].idx + '">' + todoList[i].contents + '</label>');
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
	
	function addNewTodo() {
		
		if($(".list").children().length > 0) {
			$(".list > li:first-child").before("<li class='newTodoFrame'></li>");
			$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
			$(".newTodoFrame").append("<button onclick='addTodo()'>추가</button><button onclick='cancleAdd()'>취소</button>");
		
		} else {
			$(".list").append("<li class='newTodoFrame'></li>");
			$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
			$(".newTodoFrame").append("<button onclick='addTodo()'>추가</button><button onclick='cancleAdd()'>취소</button>");
			
		}	
	}
	
</script>

</html>