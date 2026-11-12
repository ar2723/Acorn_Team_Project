<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가입 승인</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<script>
		Swal.fire({
      		title: `모임의 정원이 가득 찼습니다!`,
      		text: "",
      		icon: 'warning',
      		confirmButtonColor: 'rgb(13, 110, 253)',
      		cancelButtonColor: 'rgb(248, 162, 146)',
      		confirmButtonText: '확인',
      		cancelButtonText: '취소',
   		}).then((result) => {
	      	if (result.isConfirmed) {
	      		location.href="${pageContext.request.contextPath}/group_managing/applicantList?group_num=${group_num}";
	      	}
	    })
	</script>
</body>
</html>