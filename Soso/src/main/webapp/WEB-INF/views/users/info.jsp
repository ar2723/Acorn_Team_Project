<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/views/users/info.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="info" name="current" />
	</jsp:include>
	<div class="container">
		<p class="title">가입 정보</p>
		<div class="row border mb-5">
			<div class="col-2">
				<c:choose>
					<c:when test="${empty dto.profile }">
						<i class="bi bi-person-circle" style="font-size:100px" id="profileImage"></i>
					</c:when>
					<c:otherwise>
						<img id="profileImage" src="${pageContext.request.contextPath}${dto.profile}" />
					</c:otherwise>
				</c:choose>
			</div>
			<div class="col-5">
				<table class="table table-borderless">
					<tr>
						<th>이름</th>
						<td>${dto.name }</td>
					</tr>
					<tr>
						<th>아이디</th>
						<td>${id }</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>${dto.email }</td>
					</tr>
					<tr>
						<th>가입일</th>
						<td>${dto.regdate }</td>
					</tr>
				</table>
			</div>
			<div class="col-5">
				<table class="table table-borderless">
					<tr>
						<th>비밀번호</th>
						<td><a class="btn btn-gray btn-sm" href="${pageContext.request.contextPath}/users/pwd_updateform">수정하기</a></td>
					</tr>
					<tr>
						<th>생일</th>
						<td>${dto.birth }</td>
					</tr>
					<tr>
						<th>성별</th>
						<td>${dto.gender }</td>
					</tr>
				</table>
				<a class="btn btn-join" href="${pageContext.request.contextPath}/users/updateform">개인정보 수정</a>
				<a class="btn btn-cancle" href="javascript:deleteConfirm()">탈퇴</a>
			</div>
		</div>
		
		<div class="mb-5">
			<p class="title">활동 내역</p>
			<ul class="nav justify-content-end nav-tabs">
				<li class="nav-item">
					<a class="nav-link" id="writingList" href="#">작성글</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" id="commentList" href="#">작성댓글</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" id="supportList" href="#">문의사항</a>
				</li>
			</ul>
			
			<div id="Parse_Area"gt;lt;></div>
		</div>
	</div>
	
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
	<script>
		//작성글 클릭 시 writing_list 페이지 로딩
		$("#writingList").click(function() {
			$.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/users/info/writing_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
	            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	                console.log("통신 데이터 값 : " + Parse_data);
	            }
	            
        	});
			
			$(this).attr("class","nav-link active")
			$("#commentList").attr("class","nav-link");
			$("#supportList").attr("class","nav-link");
		});
		
		//작성 댓글 클릭 시 comment_list 페이지 로딩
		$("#commentList").click(function() {
	        $.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/users/info/comment_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
	            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	            }
	            
        	});
	        
	        $(this).attr("class","nav-link active");
	        $("#writingList").attr("class","nav-link");
	        $("#supportList").attr("class","nav-link");
		})
		
		//문의사항 클릭 시 support_list 페이지 로딩 
		$("#supportList").click(function() {
	        $.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/users/info/support_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
	            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	            }
	            
        	});
	        
	        $(this).attr("class","nav-link active");
	        $("#writingList").attr("class","nav-link");
	        $("#commentList").attr("class","nav-link");
	        
		})
		
		//화면 로딩 시 writing_list 페이지 로딩
		$(document).ready(function() {
			$.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/users/info/writing_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
	            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	            }
	            
        	});
			
			$("#writingList").attr("class","nav-link active");
		});
    
		function deleteConfirm() {
			const isDelete = confirm("${id} 님 탈퇴 하시겠습니까?");
			if (isDelete) {
				location.href = "${pageContext.request.contextPath}/users/delete";
			}
		}
	</script>
</body>
</html>