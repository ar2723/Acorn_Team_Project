<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>에러 페이지</title>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<div class="container">
		<h1>404</h1>
		<h2>존재하지 않는 모임 입니다!</h2>
		<p>방문하신 페이지의 주소가 잘못 되었습니다!</p>
		<p class="class">
			<a href="">북메이트 찾기</a>
		</p>
	</div>
</body>
</html>

