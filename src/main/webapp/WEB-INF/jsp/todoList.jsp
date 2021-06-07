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
		<!-- <span class="count">${fn:length(todoList)}��</span>  -->
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
			<c:choose>
				<c:when test="${fn:length(todoList) == 0}">
					<span class="empty_notice">��ϵ� �� ���� �����ϴ�.</span>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${ todoList }">
						<li class="list${ item.idx } ${ item.complete_yn == 'Y' ? 'checked' : '' }">
							<input type="checkbox" value="${ item.idx }" id="middle${ item.idx }" ${ item.complete_yn == 'Y' ? 'checked' : ''}><label for="middle${ item.idx }">${ item.contents }</label>
							<button class="delBtn" onclick="deleteTodo(${ item.idx })" style="display: none;">����</button>
						</li>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	
	<!-- 
	<div class="modal">
		<div>�˾�â</div>
		<div>�̹� �� ���� �����մϴ�. ���� �ۼ��Ͻðڽ��ϱ�?</div>
		<button>Ȯ��</button>
		<button>���</button>
	</div>
	 -->
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
	
	function deleteTodo(todoIndex) {
		
		var subType = document.getElementsByClassName("active")[0].value;
		
		$.ajax({
			url: '/delete/todoList',
			method: 'POST',
			async: true,
			data: {
				"idx" : todoIndex,
				"searchType" : subType
			},
			success: function(data) {
				refreshList(data);
			}
		})
	}
	
	function setTime() {
		
		// ��� 1
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
		
	    // ��� 2
	    /*
		document.getElementById("currentDate").value = new Date().toISOString().substring(0, 10);
		document.getElementById('box_hour1').innerHTML = new Date().toISOString().slice(11, 12);
		document.getElementById('box_hour2').innerHTML = new Date().toISOString().slice(12, 13);
		document.getElementById('box_minite1').innerHTML = new Date().toISOString().slice(14, 15);
		document.getElementById('box_minite2').innerHTML = new Date().toISOString().slice(15, 16);
		*/
	}
	
	
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
			$(".list" + todoList[i].idx).append('<button class="delBtn" onclick="deleteTodo(' + todoList[i].idx + ')" style="display: none;">����</button>');
		}
		
		initCheckBoxClickEvent();
		showDeleteBtn();
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
		
		$.alert("�ȴ�", {em: 'Billible', title: '�λ�'});
		
		if($(".list").children().length > 0) {
			$(".list > li:first-child").before("<li class='newTodoFrame'></li>");
			$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
			$(".newTodoFrame").append("<div class='btn_wrap'><button onclick='addTodo()'>�߰�</button><button onclick='cancleAdd()'>���</button></div>");
		} else {
			$(".list").append("<li class='newTodoFrame'></li>");
			$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
			$(".newTodoFrame").append("<div class='btn_wrap'><button onclick='addTodo()'>�߰�</button><button onclick='cancleAdd()'>���</button></div>");
		}	
	}
	
</script>

</html>