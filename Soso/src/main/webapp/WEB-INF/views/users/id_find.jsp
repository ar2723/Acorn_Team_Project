<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="id_find" name="current"/>
    </jsp:include>
		<div class="container">
			<div class="title">아이디 찾기</div>
			<c:choose>
				<c:when test="${isSuccess }">
					<div class="d-flex justify-content-center mb-4">
						<div class="mb-4 h4"><span style="font-weight:700">${name}</span>님의 아이디는 <span style="font-weight:700">'${id}'</span>입니다.</div>
					</div>
					<div class="d-flex justify-content-center">
						<div class="btn btn-join" style="margin-right:30px">
							<a href="${pageContext.request.contextPath}/users/loginform">로그인 하기</a>
						</div>
						<div class="btn btn-cancle">
							<a href="${pageContext.request.contextPath}/users/pwd_findform">비밀번호 찾기</a>
						</div>
					</div>
				</c:when>

				<c:when test="${isSocial}">
					<div class="d-flex justify-content-center mb-3">
						<div class="mb-2 h4">소셜 회원 입니다.</div>
					</div>
					<div class="d-flex justify-content-center mb-4">
						<div class="mb-2 h5">로그인 페이지 하단의 네이버 아이디로 로그인 버튼으로 로그인 가능합니다.</div>
					</div>
					<div class="d-flex justify-content-center">
						<div class="btn btn-join">
							<a href="${pageContext.request.contextPath}/users/loginform">로그인 하러 가기</a>
						</div>
					</div>
				</c:when>
				
				<c:otherwise>
					<div class="d-flex justify-content-center mb-4">
						<div class="mb-2 h4">아이디 또는 이메일 정보가 일치하지 않습니다.</div>
					</div>
					<div class="d-flex justify-content-center">
						<a class=" btn btn-cancle" href="${pageContext.request.contextPath}/users/id_findform">다시 시도하기</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>