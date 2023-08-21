<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/views/group_managing/group_userdetail.jsp</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_user_detail.css" />
<script src="${path }/resources/js/common.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	<section>
		<div class="inner-wrap">
			<h2 class="title black">함께하는 북메이트 멤버들</h2>
		</div>
		<div class="inner-wrapper">
			<div class="user_mate_list">
				<div class="user_mate">
					<div class="user_mate_img">
					<img src="${pageContext.request.contextPath}${dto.img_path}" alt="" />
					</div>
					<div class="user_mate_name">
						<p>가나다라</p>
					</div>
				</div>
				<div class="user_mate">
					<div class="user_mate_img">
					<img src="${pageContext.request.contextPath}${dto.img_path}" alt="" />
					</div>
					<div class="user_mate_name">
						<p>가나다</p>
					</div>
				</div>
				<div class="user_mate">
					<div class="user_mate_img">
					<img src="${pageContext.request.contextPath}${dto.img_path}" alt="" />
					</div>
					<div class="user_mate_name">
						<p>가나다</p>
					</div>
				</div>
			</div>
		</div>
	 	 <!-- <a href="javascript:deleteConfirm()">모임 탈퇴</a> -->
	 	<div class="group_content_bg">
		 	<div class="inner-wrap">
				<div class="group_content">
					<div class="group_meet_img">
						<img src="${pageContext.request.contextPath}${dto.img_path}">
					</div>
					<div class="group_meet_contents">
						<p class="text">${dto.manager_id}</p>
						<p class="text"> ${dto.meeting_time}</p>
						<p class="text"> ${dto.meeting_loc}</p>
						<p class="text"> ${dto.now_people}</p>
					</div> 
				</div>
			</div>
	 	</div>
	 	<div class="inner-wrap">
			<h2 class="title black">북메이트 커뮤니티</h2>
		</div>
	 	<div class="inner-wrap">
	 		<jsp:include page="/WEB-INF/views/cafe/list.jsp"></jsp:include>
	 	</div>
	</section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>	
	<script>
    function deleteConfirm() {
        const isDelete = confirm("${id} 님 탈퇴 하시겠습니까?");
        if (isDelete) {
            location.href = "${pageContext.request.contextPath}/group_managing/group_userdropOut?group_num=${dto.num}";
        }
    }
	</script>
</body>
</html>

