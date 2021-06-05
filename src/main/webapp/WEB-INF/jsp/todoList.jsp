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
					<li class="active" value="0" onclick="changeType(0)">ALL</li>
					<li value="1" onclick="changeType(1)">ACTIVE</li>
					<li value="2" onclick="changeType(2)">COMPLETED</li>
					<div class="btnAdd" onclick="clickAddBtn()">
						Add
					</div>
				</div>
			<!-- <span class="count">${fn:length(todoList)}��</span>  -->
		</div>
		
		<div class="list">
			<c:forEach var="item" items="${ todoList }">
				<c:choose>
					<c:when test="${fn:length(todoList) == 0}">
						<span>��ϵ� �� ���� �����ϴ�.</span>
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
		- Ŀ���� alert �����
	*/
	
	$(document).ready(function() {
		initCheckBoxClickEvent();
		
		var listEl = $(".subTab > li");
		listEl.click(function() {
			var subIdx = $(this).val();
			listEl.removeClass("active");
			$(this).addClass("active");
		})
	})
	
	// üũ�ڽ� �ʱ�ȭ
	// ajax �� �ٽ� ũ���� ������Ʈ���� Ŭ���̺�Ʈ�� ������� �ʴ� ��������
	// $(document).on('click', className, function() {})���� �õ��غ�������
	// �̷��ԵǸ� ������ ���ܼ� function���� ���� ���� ajax �� �ش� function ȣ����
	function initCheckBoxClickEvent() {
		$("input[type='checkbox']").on('click', function() {
			// üũ����
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
		console.log("���� Ÿ�� >>> ", type);
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
	
	// add ��ư Ŭ�� ��
	function clickAddBtn() {
		// �̹� �߰��� �������� �����ϴ� ���
		if($(".newTodoFrame").length) {
			// �ؽ�Ʈ �ڽ��� ���� ������ ��
			if($(".newTodoContents").val().length > 0) {
				var flag = confirm("�̹� �� ���� �����մϴ�. ���� �ۼ��Ͻðڽ��ϱ�?");
				if(flag) {
					cancleAdd();
					addNewTodo();
				}
			// �ؽ�Ʈ�� ���� �������� ���� ��
			} else {
				cancleAdd();
				addNewTodo();
			}
		
		// �������� ���� ���
		} else {
			addNewTodo();
		}
	}
	
	function addTodo() {
		var contents = $(".newTodoContents").val();
		var subType = document.getElementsByClassName('active')[0].value;
		
		if(contents.length == 0) {
			alert("���� �Է����ּ���.");
			// �ؽ�Ʈ�ڽ� ��¦�̰� �ϱ�
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
						alert("��ϿϷ�Ǿ����ϴ�.");
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
			var flag = confirm("�̹� �� ���� �����մϴ�. ����Ͻðڽ��ϱ�?");
			if(flag) {
				$(".newTodoFrame").remove();
			}
		} else {
			$(".newTodoFrame").remove();
		}
	}
	
	function addNewTodo() {
		$(".list").append("<li class='newTodoFrame'></li>");
		$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
		$(".newTodoFrame").append("<button onclick='addTodo()'>�߰�</button><button onclick='cancleAdd()'>���</button>");
	}

</script>

</html>