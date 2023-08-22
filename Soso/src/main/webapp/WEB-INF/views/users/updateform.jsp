<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/views/users/updateform.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="update" name="current"/>
	</jsp:include>
	<div class="container">
		<p class="title">가입 정보 수정</p>
		<a id="profileLink" href="javascript:">
			<c:choose>
				<c:when test="${ empty dto.profile }">
					<i class="bi bi-person-circle" style="font-size:100px" id="profileImage"></i>
				</c:when>
				<c:otherwise>
					<img id="profileImage" src="${pageContext.request.contextPath}${dto.profile}">
				</c:otherwise>
			</c:choose>
		</a>
		<form action="${pageContext.request.contextPath}/users/update" method="post">		
			<input type="hidden" name="profile" 
				value="${ empty dto.profile ? 'empty' : dto.profile }"/>		
			<div>
				<label class="form-label" for="id">아이디</label>
				<input class="form-control" type="text" id="id" value="${dto.id }" disabled/>
			</div>
			<div>
				<label class="form-label" for="email">이메일</label>
				<input class="form-control" type="text" id="email" name="email" value="${dto.email }"/>
			</div>
			<div class="mt-2">
				<button class="btn btn-join" type="submit">수정확인</button>
				<button class="btn btn-cancle" type="reset">취소</button>
			</div>
		</form>	
		
		<form id="imageForm" action="${pageContext.request.contextPath}/users/profile_upload" method="post" enctype="multipart/form-data">
			프로필 사진
			<input type="file" id="image" name="image" accept=".jpg, .png, .gif"/>
			<button type="submit">업로드</button>
		</form>
					
	</div>
	
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<!-- gura_util.js 로딩 -->
	<script src="${pageContext.request.contextPath }/resources/js/gura_util.js"></script>
	<script>

		//프로필 이미지 링크를 클릭하면 
		document.querySelector("#profileLink").addEventListener("click", function(){
			// input type="file" 을 강제 클릭 시킨다. 
			document.querySelector("#image").click();
		});	
		
		//프로필 이미지를 선택하면(바뀌면) 실행할 함수 등록
		document.querySelector("#image").addEventListener("change", function(){
			//ajax 전송할 폼의 참조값 얻어오기
			const form=document.querySelector("#imageForm");
			//gura_util.js 에 있는 함수를 이용해서 ajax 전송하기 
			ajaxFormPromise(form)
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				console.log(data);
				// input name="profile" 요소의 value 값으로 이미지 경로 넣어주기
				document.querySelector("input[name=profile]").value=data.imagePath;
				
				// img 요소를 문자열로 작성한 다음 
				let img=`<img id="profileImage" 
					src="${pageContext.request.contextPath }\${data.imagePath}">`;
				//id 가 profileLink 인 요소의 내부(자식요소)에 덮어쓰기 하면서 html 형식으로 해석해 주세요 라는 의미 
				document.querySelector("#profileLink").innerHTML=img;
			});
		});		
	</script>
</body>
</html>
