<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="id_find" name="current"/>
    </jsp:include>
    <div class="container">
        <p class="title">아이디 찾기</p>
        
        <form action="${pageContext.request.contextPath}/users/id_find" method="post">
        	<div class="mb-4">
                <label for="name" class="control-label mb-2">이름</label>
                <input type="text" class="form-control" name="name" id="name"/>
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