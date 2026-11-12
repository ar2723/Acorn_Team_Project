<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>경고</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<script>
		Swal.fire({
      		title: `주의!`,
      		text: "${exception.getMessage()}",
      		icon: 'error',
      		confirmButtonColor: 'rgb(248, 162, 146)',
      		cancelButtonColor: 'rgb(248, 162, 146)',
      		confirmButtonText: '확인',
      		cancelButtonText: '취소',
   		}).then((result) => {
	      	if (result.isConfirmed) {
	      		location.href="${pageContext.request.contextPath}/group_managing/admin_main";
	      	}
	    })
	</script>
</body>
</html>