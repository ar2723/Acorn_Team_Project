<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${dto.name } 가입 신청 페이지</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group/group_join_form.css">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	<section>
		<div class="container">
			<div id="join_title">소모임 가입 신청</div>
			<div id="group_title">
				<div><img src="${pageContext.request.contextPath}${dto.img_path }"/></div>
				<div id="group_name">${dto.name }</div>
			</div>
			<form action="${pageContext.request.contextPath}/group/join?num=${num}" method="post">
				<label class="form_label" style="text-align:center">소모임 규칙 & 소개</label>
				<textarea id="join_caption" readonly>${dto.caption }</textarea>
				<label class="form_label" for="intro">가입 인사말</label>			
				<textarea id="join_intro" name="intro" placeholder="소모임 가입 신청 시 본인에 대한 소개와 소모임에 대한 지원 동기를 자세하게 적어주시기 바랍니다." 
					onfocus="this.placeholder = ''" onblur="this.placeholder = '소모임 가입 신청 시 본인에 대한 소개와 소모임에 대한 지원 동기를 자세하게 적어주시기 바랍니다.'"></textarea>
				<div id="join_button">
					<button type="submit">가입 신청</button>
				</div>
			</form>
		</div>
	</section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>