
$(document).ready(function() {
	initCheckBoxClickEvent(); // 체크박스 초기화
	initSubTab();
	showDeleteBtn();
	setTime();
	setInterval(setTime, 1000); // 1초마다 실행
})

function initSubTab() {
	let listEl = $(".subTab > li");
	listEl.click(function() {
		listEl.removeClass("active");
		$(this).addClass("active");
	})
}

// list에 마우스 오버 시 삭제버튼 노출
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

// 삭제버튼 클릭 시 TODO 삭제
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

// 상단 시계에 시간 설정
function setTime() {
	
	// 방법 1
	const time = new Date();
	let hour = time.getHours().toString();
	let minutes = time.getMinutes().toString();

	hour = hour.length == 1 ? "0" + hour : hour;
	minutes = minutes.length == 1 ? "0" + minutes : minutes;
	
	document.getElementById('currentDate').value = new Date().toISOString().substring(0, 10);
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
	console.log("1");
	$("input[type='checkbox']").on('click', function() {
		// 체크여부
		let flag = $(this).prop("checked");
		
		let todoIndex = $(this).val();
		let subType = document.getElementsByClassName("active")[0].value;
		
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

// [전체/활성화/완료] 서브 영역 클릭 시 타입에 따라 리스트 refresh
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
		}
	})
}

// add 버튼 클릭 시 프레임 추가 function을 실행하고
// TODO가 작성된 input[type="text"]를 검사한다.
function clickAddBtn() {
	// 이미 추가용 프레임이 존재하는 경우
	if($(".newTodoFrame").length) {
		// 텍스트 박스에 값이 존재할 때
		if($(".newTodoContents").val().length > 0) {
			let flag = confirm("이미 할 일이 존재합니다. 새로 작성하시겠습니까?");
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

// add 버튼 클릭 시 TODO 추가
function addTodo() {
	let contents = $(".newTodoContents").val();
	let subType = document.getElementsByClassName('active')[0].value;
	
	if(contents.length == 0) {
		alert("값을 입력해주세요.");
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
					refreshList(data);
					initCheckBoxClickEvent();
				}
			}
		})
	}
}

// 각 function에서 ajax 호출 후 TODO 목록 다시 그리기
function refreshList(data) {
	console.log("2");
	let todoList = data.todoList;
	$(".list").empty();
	for(let i=0; i<todoList.length; i++) {
		let checked = data.todoList[i].complete_yn == 'Y' ? 'checked' : '';
		$(".list").append('<li class="list' + todoList[i].idx + ' ' + checked + '"></li>');
		$(".list" + todoList[i].idx).append('<input type="checkbox" value="' + todoList[i].idx + '" id="middle' + todoList[i].idx + '" ' + checked + '>');
		$(".list" + todoList[i].idx).append('<label for="middle' + todoList[i].idx + '">' + todoList[i].contents + '</label>');
		$(".list" + todoList[i].idx).append('<button class="delBtn" onclick="deleteTodo(' + todoList[i].idx + ')" style="display: none;">삭제</button>');
	}
	
	initCheckBoxClickEvent();
	showDeleteBtn();
}

function cancleAdd() {
	if($(".newTodoContents").val().length > 0) {
		let flag = confirm("이미 작성된 할 일이 존재합니다. 취소하시겠습니까?");
		if(flag) {
			$(".newTodoFrame").remove();
		}
	} else {
		$(".newTodoFrame").remove();
	}
}

// add 버튼 클릭 후 새로 추가할 TODO를 작성할 프레임을 추가하는 기능
function addNewTodo() {
	if($(".list").children().length > 0) {
		$(".list > li:first-child").before("<li class='newTodoFrame'></li>");
		$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
		$(".newTodoFrame").append("<div class='btn_wrap'><button onclick='addTodo()'>추가</button><button onclick='cancleAdd()'>취소</button></div>");
	} else {
		$(".list").append("<li class='newTodoFrame'></li>");
		$(".newTodoFrame").append("<input type='text' class='newTodoContents'>");
		$(".newTodoFrame").append("<div class='btn_wrap'><button onclick='addTodo()'>추가</button><button onclick='cancleAdd()'>취소</button></div>");
	}
}