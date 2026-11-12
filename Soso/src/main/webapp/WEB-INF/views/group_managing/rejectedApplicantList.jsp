<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>북메이트 관리</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_admin_header.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_admin_applicant_card.css" />
<style>
</style>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="login" name="current"/>
    </jsp:include>
	<section>
		<div class="admin_container">
		<div id="admin_header">
			<div class="title">Rejected Applicant</div>
			<div class="group_name">${dto.name}</div>
		</div>
		<div id="menus">
			<div><a href="${pageContext.request.contextPath}/group_managing/applicantList?group_num=${group_num}">신청 중</a></div>
			<div><a class="active" href="${pageContext.request.contextPath}/group_managing/rejectedApplicantList?group_num=${group_num}">거절</a></div>
		</div>
		<div class="wrapper">
			<c:forEach var="tmp" items="${list}">
			<div id="card">
				<div class="card-box">
					<div class="card-left">
						<div><img class="card-image" src="${pageContext.request.contextPath}${tmp.profile}"/></div>
					</div>
					<div class="card-right">
						<div id="card-title">${tmp.user_id}</div>
						<div id="card-date">${tmp.request_dt}</div>
						<div id="card-link"><a href="${pageContext.request.contextPath}/cafe/list">회원 정보 보기</a></div>
						<div id="card-buttons" style="margin-left:130px">
							<div><a data-post href="${pageContext.request.contextPath}/group_managing/joinApprove?num=${tmp.num}&group_num=${group_num}">가입 승인</a></div>
						</div>
					</div>
				</div>
			</div>
			</c:forEach>
		</div>
	</div>
	</section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>