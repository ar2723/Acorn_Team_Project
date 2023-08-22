<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pageContext.request.contextPath}</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="pwd_find" name="current"/>
    </jsp:include>
    <div class="container">
        <div class="py-5 text-center">
	       <p class="title">비밀번호 찾기</p>
        </div>
        
	    <form action="${pageContext.request.contextPath}/users/pwd_find" method="post">
	        <div class="mb-2">
	            <label for="id" class="control-label">아이디</label>
	            <input type="text" class="form-control" name="id" id="id"
	                placeholder="예) hello123"/>
	            <small class="form-text text-muted">아이디는 5~10글자 사이의 영문자 소문자입니다.</small>
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