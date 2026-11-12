<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소모임 커뮤니티 글 수정하기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<script>
		alert("${id} 님 글을 수정 했습니다.");
		location.href="${pageContext.request.contextPath}/cafe/detail?comu_num=${comu_num}&condition=${condition}&keyword=${keyword}&group_num=${group_num}";
	</script>
</body>
</html>