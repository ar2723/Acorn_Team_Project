<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소모임 커뮤니티 글쓰기</title>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<script>
		alert("새글이 추가 되었습니다.");
		location.href="${pageContext.request.contextPath}/group_managing/group_userdetail?num=${group_num}";
	</script>
</body>
</html>