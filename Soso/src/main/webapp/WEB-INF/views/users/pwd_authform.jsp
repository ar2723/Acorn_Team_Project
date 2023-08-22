<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pageContext.request.contextPath}</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="pwd_update" name="current"/>
    </jsp:include>
    <div class="container">
    	<p class="title">비밀번호 확인</p>
        <form action="${pageContext.request.contextPath}/users/pwd_auth" method="post">
            <c:choose>
                <%-- 홈 화면에서 로그인 할 경우 파라미터 값으로 url이 주어지지 않음 --%>
                <c:when test="${ empty param.url }">
                    <input type="hidden" name="url" value="${pageContext.request.contextPath}/" />
                </c:when>
                <%-- 그외는 Interceptor를 거치기 때문에 url이 주어짐 --%>
                <c:otherwise>
                    <input type="hidden" name="url" value="${param.url }" />
                </c:otherwise>
            </c:choose>
            
            <div class="input-group">
                <div class="form-floating">
                   <input type="password" name="pwd" id="pwd" class="form-control" placeholder="비밀번호" required>
                   <label for="pwd">비밀번호</label>
                </div>
                <button class="btn btn-outline-secondary bi-eye-slash" type="button" id="openpwd"></button>
            </div>
            <button class="btn btn-join" type="submit">확인</button>
            <button class="btn btn-cancle" type="reset">리셋</button>
        </form>
    </div>
    
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    <script src="${pageContext.request.contextPath}/resources/js/open_pwd.js"></script>
</body>
</html>


