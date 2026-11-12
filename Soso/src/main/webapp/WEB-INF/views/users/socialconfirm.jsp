<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소셜 로그인 확인</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/reset.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="login" name="current"/>
    </jsp:include>
    <section>
    	<div style="padding-bottom:30%">
			<script>
				Swal.fire({
		      		title: "${id } 회원님 통합 로그인 하시겠습니까?",
		      		text: "",
		      		icon: 'success',
		      		confirmButtonColor: 'rgb(13, 110, 253)',
		      		cancelButtonColor: 'rgb(248, 162, 146)',
		      		confirmButtonText: '확인',
		      		cancelButtonText: '취소',
					showCancelButton: true
		   		}).then((result) => {
			      	if (result.isConfirmed) {
			      		location.href="${pageContext.request.contextPath}/users/socialaccess?id=${id}";
			      	}else{
			      		location.href="${pageContext.request.contextPath}/users/login_form";
			      	}
			    })
			</script>
		</div>
    </section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>