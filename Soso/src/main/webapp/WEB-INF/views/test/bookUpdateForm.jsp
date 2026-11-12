<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>책 업데이트 & 삭제</title>
<link rel="stylesheet" href="${path }/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="${path }/resources/css/common.css" type="text/css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<style>
	.bookList button{
		background-color:#fff;
		color:red;
		border:none;
	}
	.bookList button:hover{
		text-decoration:underline;
	}
</style>
<body>
	<div class="container">
		<h3>책 목록 수정하기 </h3>
		<table class="table">
				<c:forEach var="tmp" items="${booklist }">
					<tr>
						<td scope="col"></td>
						<td scope="col"><img src="${tmp.image }" alt="${tmp.title }" width="100" /></td>
						<td scope="col"><a href="${tmp.link }">${tmp.title }</a></td>
						<td scope="col"><button class="deleteBookBtn btn btn-outline-danger" data-isbn="${tmp.isbn}" data-group-num="${tmp.group_num}">삭제</button></td>
					</tr>
				</c:forEach>
		</table>
	</div>
<!-- 책 검색 공간(임시) -->
<!-- 책 정보 추가 -->
<div class="container">
	<div class="bookList container" style="display:flex; overflow:auto;"></div>
</div>
<div class="container" style="margin:3%;">
	<button type="button" id="addBook" name="addBook" class="btn btn-outline-success">책 추가하기</button>
	<button type="submit" id="updateBook" name="updateBook" class="btn btn-outline-primary">수정 목록 제출</button>
</div>
	
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

//jQuery를 사용하여 URL에서 group_num 값을 가져오기
const urlParams = new URLSearchParams(window.location.search);
const groupNum = urlParams.get('group_num');

const booklist = []; // 책 목록 배열 초기화


$("#updateBook").click(function(){
	
	$.ajax({
	    type: "POST",
	    url: "${pageContext.request.contextPath}/test/bookUpdate",
	    data: JSON.stringify(booklist), // JSON 데이터로 변환
	    contentType: "application/json; charset=UTF-8", // Content-Type 설정
	    success: function(data) {
	        alert("저장되었습니다.");
	    },
	    error: function() {
	        alert("저장 중 오류가 발생했습니다.");
	    }
	});
})

$(document).ready(function() {
    // "삭제" 버튼 클릭 이벤트 핸들러
    $(".deleteBookBtn").click(function() {
        var isbn = $(this).data("isbn");
        var groupNum = $(this).data("group-num");
        
        //해당 row의 위치를 알아낸다.
        var buttonToRemove = $(this);
        
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/test/bookDelete",
            data: {
                isbn: isbn,
                group_num: groupNum
            },
            dataType: "text",
            success: function(data) {
                //부모 tr을 삭제한다
                buttonToRemove.closest('tr').remove();
                alert("삭제되었습니다.");
            },
            error: function() {
                alert("삭제 중 오류가 발생했습니다.");
            }
        });
    });
});

//원래 페이지가 로드될 때, 책 목록 표시
function displayBookList() {
    const bookListElement = $(".bookList");
    bookListElement.empty(); // 목록을 초기화

    booklist.forEach(function (book, index) {
        const bookContainer = $("<div>").addClass("bookContainer");
        const titleElement = $("<pre>").text(book.title);

        // 이미지 추가
        if (book.image) {
            const imageElement = $("<img>").attr("src", book.image).css({
            	width : "150px",
            	height : "250px",
            	border : "1px solid black",
            	margin : "1rem"
            });
            bookContainer.append(imageElement);
        }

        // 삭제 버튼 추가
        const deleteButton = $("<button>").text("삭제 X");
        deleteButton.click(function () {
            deleteBook(index);
        });

        bookContainer.append(titleElement, deleteButton);
        bookListElement.append(bookContainer);
    });
}

// 배열에서 책 삭제
function deleteBook(index) {
    if (index >= 0 && index < booklist.length) {
        booklist.splice(index, 1);
        displayBookList(); // 변경된 목록 다시 표시
        //booklist에 json 데이터를 집어넣음
    }
}

$(document).ready(function () {
    $("#addBook").click(function () {
        // 새 창을 열기 위한 URL
        var newWindowUrl = "${pageContext.request.contextPath}/test/booksearch";

        // 새 창 열기
        window.open(newWindowUrl, "booksearch", "width=600,height=400");
    });

    // 새 창으로부터 메시지 수신
    window.addEventListener("message", function (event) {
        if (event.data) {
            // 새로운 도서 정보를 받아서 booklist에 추가
            var newBook = event.data;
            // group_num을 추가
            newBook.group_num = groupNum;
            // 추가된 도서 정보를 booklist에 추가
            booklist.push(newBook);
            // 책 목록 업데이트 및 표시
            displayBookList();
        }
    });

    // 원래 페이지가 로드될 때, 책 목록 표시
    displayBookList();
});
</script>
</body>
</html>