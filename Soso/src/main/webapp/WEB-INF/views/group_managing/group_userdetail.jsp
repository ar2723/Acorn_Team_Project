<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${dto.name}</title>
	<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_user_detail.css" />
	<script src="${path }/resources/js/common.js"></script>
	<script src="${path }/resources/js/jquery.lightbox-0.5.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
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
				<c:forEach items="${mateList}" var="user">
					<c:if test="${user.isJoin == 0}"> <!-- 가입된 유저만 출력 -->
						<div class="user_mate">
							<div class="user_mate_img">
								<img src="${pageContext.request.contextPath}${user.profile}" alt="" />
							</div>
							<div class="user_mate_name">
								<p class="text">${user.user_id }</p>
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
		</div>

		<!-- <a href="javascript:deleteConfirm()">모임 탈퇴</a> -->
		<div class="group_content_bg">
			<div class="inner-wrap">
				<div class="group_content">
					<div class="group_meet_img">
						<img src="${pageContext.request.contextPath}${dto.img_path}">
					</div>

					<div class="modal">
						<span class="close">&times;</span>
						<img class="modal_content" src="${pageContext.request.contextPath}${dto.img_path}">
					</div>

					<div class="group_meet_detail_contents">
						<h3 class="title black">모임규칙</h3>
						<ul>
							<li>1. <span> 책은 모임 전에 읽기</span></li>
							<li>2. <span> 모임에 지각 하지 않기</span></li>
							<li>3. <span> 사람들과 소통 많이 하기</span></li>
							<li>4. <span> 독서 경험이 없는 사람</span></li>
							<li>5. <span> 20~30대와 어울리기</span></li>
						</ul>
					</div> 

					<div class="group_meet_contents">
						<h3 class="title black">모임정보</h3>
						<ul>
							<li><span>모임장 : ${dto.manager_id}</span></li>
							<li><span>모임 시간 : ${dto.meeting_time}</span></li>
							<li><span>모임 장소 : ${dto.meeting_loc}</span></li>
							<li><span>가입 인원 : ${dto.now_people} 명</span></li>
						</ul>
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

		<div class="inner-wrap">
			<h2 class="title_black">공지사항</h2>
			<ul>
				<li style="line-height: 2.5;"><span style="font-size: 18px;"> 1. 한번 가입했다가 탈퇴 하신 회원님은 다시 가입 불가능 합니다.</span></li>
				<li style="line-height: 2.5;"><span style="font-size: 18px;"> 2. 저희 모임에 불순한 의도를 갖고 저희 페이지를 이용하시면 법적 대응 들어갑니다.</span></li>
				<li style="line-height: 2.5;"><span style="font-size: 18px;"> 3. 항상 모임 2일 전에 문자로 안내 드립니다.</span></li>
			</ul>	 	
		</div>
	</section>

	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>

	<script>
		function deleteConfirm() {
			const isDelete = confirm("${id} 님 탈퇴 하시겠습니까?");
			if (isDelete) {
				postTo("${pageContext.request.contextPath}/group_managing/group_userdropOut?group_num=${dto.num}");
			}
		}

		const modal = document.querySelector(".modal");
		const img = document.querySelector(".group_meet_img img");
		const modal_img = document.querySelector(".modal_content");
		const span = document.querySelector(".close");

		img.addEventListener('click', ()=>{
			modalDisplay("block");
			modal_img.src = img.src;
		});

		span.addEventListener('click', ()=>{
			modalDisplay("none");
		});

		modal.addEventListener('click', ()=>{
			modalDisplay("none");
		});
		
		function modalDisplay(text){
			modal.style.display = text;
		}
	</script>
</body>
</html>