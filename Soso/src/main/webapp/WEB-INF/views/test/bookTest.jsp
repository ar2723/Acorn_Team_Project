<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
<script src="${path }/resources/js/jquery.easing.1.3.js"></script>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
	<head>
		<meta charset="UTF-8">
		<title>book::list</title>
		<link rel="stylesheet" href="${path }/resources/css/common.css" type="text/css">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
	<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
	</head>
	<body>
		<div class="container">
		<h3>네이버 오픈 API를 활용한 도서 목록</h3>		
		<table class="table table-hover">
			<c:forEach var="tmp" items="${books }">
				<tr>
					<td scope="col">${tmp.isbn }</td>
					<td scope="col"><img src="${tmp.image }" alt="${tmp.title }" width="100" /></td>
					<td scope="col"><a href="${tmp.link }">${tmp.title }</a></td>
					<td scope="col">
	                     <form class="addForm" action="${pageContext.request.contextPath}/test/addList">
			                <input type="text" name="title" value="${tmp.title}" hidden />
			                <input type="text" name="link" value="${tmp.link}" hidden />
			                <input type="text" name="image" value="${tmp.image}" hidden />
			                <input type="text" name="isbn" value="${tmp.isbn}" hidden />
			                <input type="text" name="description" value="${tmp.description}" hidden />
			                <button class="addBtn btn btn-outline-success">추가</button>
			            </form>
	                </td>
				</tr>
			</c:forEach>
		</table>
		</div>
	</body>
	<script>
	    
		const urlParams = new URLSearchParams(window.location.search);
		const num = urlParams.get('num');
	
	    $(document).ready(function() {
	        $(".addBtn").on("click", function(e) {
	        	//폼 전송을 막는다
	            e.preventDefault();
				
	        	//해당 줄의 정보를 얻어낸다.
	        	//$(this)는 클릭한 버튼의 정보를 의미한다.
	        	//.closest는 상위 요소의 tr을 알아낸다.
	        	//.find는 input요소가 name=XXX를 알아내는 것
	            const row = $(this).closest("tr");
	            const group_num = row.find("input[name='group_num']").val();
	            const title = row.find("input[name='title']").val();
	            const link = row.find("input[name='link']").val();
	            const image = row.find("input[name='image']").val();
	            const isbn = row.find("input[name='isbn']").val();
	            const description = row.find("input[name='description']").val();
				//해당 데이터를 json 형식으로 담고
	            const bookInfo = {
	                group_num: num,
	                title: title,
	                link: link,
	                image: image,
	                isbn: isbn,
	                description: description
	            };
	            // 원래 페이지로 데이터를 전송
	            window.opener.postMessage(bookInfo, "*");

	        });
	    });
	    
	   /*  //저장 버튼을 눌렀을 때 ajax로 저장되는 구조(정식으로 넣을 때는 이 코드는 삭제될 예정.)
	    $("#saveList").on("click", function(){
	        $.ajax({
	            url: "${pageContext.request.contextPath}/test/saveBook",
	            type: "POST",
	            data: JSON.stringify(booklist), // 데이터를 JSON 형태로 변환
	            contentType: "application/json", // 컨텐츠 유형을 JSON으로 설정
	            error: function(data){
	                console.log("오류입니다.");
	            },
	            success: function(data){
	                console.log("저장 성공!");
	            }
	        });
	    }); */
	</script>

</html>