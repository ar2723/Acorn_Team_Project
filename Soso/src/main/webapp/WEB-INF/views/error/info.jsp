<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>경고</title>
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<%-- NotDeleteException, 권한 없음(403) 등 공통 경고 화면 --%>
	<script>
		Swal.fire({
			title: '주의!',
			text: "${fn:escapeXml(exception.message)}",
			icon: 'error',
			confirmButtonColor: 'rgb(248, 162, 146)',
			confirmButtonText: '확인',
		}).then(() => {
			if (document.referrer) {
				history.back();
			} else {
				location.href = "${pageContext.request.contextPath}/";
			}
		});
	</script>
</body>
</html>
