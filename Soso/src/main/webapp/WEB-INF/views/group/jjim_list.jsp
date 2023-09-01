<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en-us">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>북마크</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/jjimlist.css" />
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
  </head>
<body>
   	<c:forEach var="tmp" items="${list }">
   	    <div class="container">
    		<div class="item image"><img src="#" alt="" />여기에 이미지 띄우기</div>
	        <div class="item name">${tmp.manager_id} / ${tmp.name}</div>
	        <div class="item jjim">
     			<div class="p-2 heart">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
					  <path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
					</svg>
				</div>
				<input type="hidden" name="groupNum" value="${tmp.num}" />
	        </div>
	        <div class="item caption">${tmp.caption}</div>
        </div>
   	</c:forEach>
     	<!-- jQuery 라이브러리를 로드 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	    $(".container").on("click", ".heart", function(e) {
	        var $heart = $(this);
	
	        if ($heart.hasClass("clicked")) {
	            $heart.removeClass("clicked"); // 클래스 제거
	            //하트 비우기
	            $heart.html(`
	   				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
	   				    <path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
	   				</svg>
	   			`);
	           
	        } else {
	            $heart.addClass("clicked"); // 클래스 추가
	            //하트 채우기
	            $heart.html(`
    				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart" viewBox="0 0 16 16">
    				    <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
    				</svg>
    			`);
	        }	
	        var num = $heart.siblings('input[name="groupNum"]').val();
	        $.ajax({
	            url: "${pageContext.request.contextPath}/group/jjim",
	            method: "get",
	            data: { "num": num },
	            success: function(data){
	                if (data.isSuccess == true) {
	                    alert("찜 추가되었습니다.");
	                } else {
	                    alert("찜 취소하셨습니다.");
	                }            
	            }
	        });
	    });
	</script>
</body>
</html>
