<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="pwd_find" name="current"/>
    </jsp:include>
    <div class="container">
        <div class="text-center">
	       <div class="title">비밀번호 찾기</div>
        </div>
        
	    <form action="${pageContext.request.contextPath}/users/pwd_find" method="post">
	        <div class="mb-4">
	            <label for="id" class="control-label mb-2">아이디</label>
	            <input type="text" class="form-control" name="id" id="id"
	                placeholder="예) hello123"/>
	            <small class="form-text text-muted">아이디는 5~10글자 사이의 영문자 소문자입니다.</small>
	        </div>
	        <div class="mb-4">
	            <label for="email" class="control-label mb-2">이메일</label>
	            <input type="text" class="form-control" name="email" id="email"/>
	        </div>
	        <div class="d-flex justify-content-center">
	        	<button class="btn btn-join" type="submit" style="background-color: rgb(65, 75, 178)">찾기</button>
	        </div>
	    </form>
    </div>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    
</body>
</html>