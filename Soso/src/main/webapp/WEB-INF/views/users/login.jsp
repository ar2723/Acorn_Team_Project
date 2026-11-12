<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="login" name="current"/>
    </jsp:include>
    <section>
    	<div style="padding-bottom:30%">
			<c:choose>
				<c:when test="${not empty sessionScope.id }">
					<script>
						Swal.fire({
				      		title: `${sessionScope.id}님 로그인되었습니다.`,
				      		text: "",
				      		icon: 'success',
				      		confirmButtonColor: 'rgb(13, 110, 253)',
				      		cancelButtonColor: 'rgb(248, 162, 146)',
				      		confirmButtonText: '확인',
				      		cancelButtonText: '취소',
				   		}).then((result) => {
					      	if (result.isConfirmed) {
					      		location.href="${requestScope.url }";
					      	}
					    })
					</script>
				</c:when>
				<c:otherwise>
					<script>
						Swal.fire({
				      		title: `아이디 혹은 비밀 번호가 일치하지 않습니다!`,
				      		text: "",
				      		icon: 'error',
				      		confirmButtonColor: 'rgb(13, 110, 253)',
				      		cancelButtonColor: 'rgb(248, 162, 146)',
				      		confirmButtonText: '다시 시도하기',
				      		cancelButtonText: '취소',
				   		}).then((result) => {
					      	if (result.isConfirmed) {
					      		location.href="loginform?url=${requestScope.encodedUrl }";
					      	}
					    })
					</script>
				</c:otherwise>
			</c:choose>
		</div>
    </section>
	
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>