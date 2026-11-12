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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_admin_member_card.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
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
			<div class="title">Member</div>
			<div class="group_name">${dto.name}</div>
		</div>
		<div id="menus">
			<div><a class="active" href="${pageContext.request.contextPath}/group_managing/memberList?group_num=${group_num}">참여 중</a></div>
			<div><a href="${pageContext.request.contextPath}/group_managing/kickedMemberList?group_num=${group_num}">강퇴</a></div>
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
							<div id="card-date">소모임 가입일: ${tmp.join_dt}</div>
							<div id="card-link"><a href="${pageContext.request.contextPath}/group_managing/memberInfo?num=${tmp.num}&group_num=${group_num}">활동 내역 보기</a></div>
							<div id="card-buttons" class="card-alert-button${tmp.num}"><div><a href="javascript:">추방</a></div></div>
						</div>
						<script>
							$(".card-alert-button${tmp.num}").css("cursor", "auto").click(()=>{
								Swal.fire({
						      		title: `${tmp.user_id}님을 소모임에서 
						      				추방하시겠습니까?`,
						      		text: "해당 회원을 한번 추방하면 다시 되돌릴 수 없습니다",
						      		icon: 'warning',
						      		showCancelButton: true,
						      		confirmButtonColor: 'rgb(13, 110, 253)',
						      		cancelButtonColor: 'rgb(248, 162, 146)',
						      		confirmButtonText: '확인',
						      		cancelButtonText: '취소',
					    		}).then((result) => {
							      	if (result.isConfirmed) {
								        postTo("${pageContext.request.contextPath}/group_managing/kick?num=${tmp.num}&group_num=${group_num}");}
							    })
							})
						</script>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
	</section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>