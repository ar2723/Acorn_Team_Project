<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="id_find" name="current"/>
    </jsp:include>
    <div class="container">
        <p class="title">아이디 찾기</p>
        
        <form action="${pageContext.request.contextPath}/users/id_find" method="post">
        	<div class="mb-2">
                <label for="userName" class="control-label">이름</label>
                <input type="text" class="form-control" name="userName" id="userName"/>
            </div>
            <div class="mb-2">
                <label for="email" class="control-label">이메일</label>
                <input type="text" class="form-control" name="email" id="email"/>
            </div>
            
            <button class="btn btn-join" type="submit">찾기</button>
        </form>
    </div>
    
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    
</body>
</html>