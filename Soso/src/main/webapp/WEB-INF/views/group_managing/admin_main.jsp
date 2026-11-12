<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>북메이트 관리</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
	<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
	<link rel="shortcut icon" type="image/x-icon" href="https://genfavicon.com/tmp/icon_7cacead7cd8483ca41a810db418dc8ab.ico">
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_user_main.css" />
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
    <script src="${path }/resources/js/jquery.easing.1.3.js"></script>
    <script src="${path }/resources/js/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/navbar.jsp">
        <jsp:param value="login" name="current"/>
    </jsp:include>
    <main id="main-banner" class="main-banner-03">
        <div class="inner-wrap">
            <div class="title">
                <h2>북메이트 관리</h2>
                <p>
			                    나의 북메이트를 <br>
		                             관리해보세요
                </p>
            </div>
            <div class="indicator">
                <div class="home circle">
                    <a href="/main" title="메인페이지가기"><img src="${path }/resources/images/sub/icon_home.svg" alt="홈버튼이미지"></a>
                </div>
                <div class="main-menu circle">BOOKMATE</div>

            </div>
        </div>
    </main>
    
    <section class="sub-contents user_content">
    	<div class="inner-wrap">
    		<h3 class="title black" data-aos="fade-up"
            data-aos-offset="100"
            data-aos-easing="ease-in-sine">나의 북메이트 관리</h3>
            <div class="content_insert">
            <a href="${pageContext.request.contextPath}/group_managing/group_insertForm">개설하기</a></div>
    	</div>
    	<div class="inner-wrap">
            <div class="user_content_theme">
                <ul>
                	<li><a href="${pageContext.request.contextPath}/group_managing/admin_main_all">전체</a></li>
                    <li><a class="theme_active" href="${pageContext.request.contextPath}/group_managing/admin_main">진행중</a></li>
                    <li><a href="${pageContext.request.contextPath}/group_managing/admin_main_finished">종료</a></li>
                </ul>
            </div>
        </div>
            <div class="inner-wrapper">
    		<c:forEach var="tmp" items="${list }">
                <div class="user_content_list">
                    <div class="user_contents">
                    	<div id="likedNumber">
							<div>❤ ${tmp.like_num }</div>
							<div>
								<div tabindex="0" data-bs-toggle="popover" data-bs-trigger="hover focus" data-bs-content="여길 누르면 소모임 멤버관리를 할 수 있어요!!~" data-bs-placement="top">
									 <a href="${pageContext.request.contextPath}/group_managing/memberList?group_num=${tmp.num}">${tmp.now_people} / ${tmp.max_people}</a>
								</div>
							</div>
						</div>

                        		<c:choose>
									<c:when test="${fn:length(tmp.img_path) < 32}">
										<div class="user_content_img"><img src="${pageContext.request.contextPath}/resources/images/main/001.jpg"/></div>
									</c:when>
									<c:otherwise>
										<div class="user_content_img"><img src="${pageContext.request.contextPath}${tmp.img_path}"/></div>
									</c:otherwise>
								</c:choose>
                       		<div class="user_content_text">
                       			<ul class="">
		                            	<li class="title">${tmp.name}</li>
			                            <li><span class="info-label">모임 종료일 :</span> ${tmp.ended_dt}</li>
			                            <li><span class="info-label">모임 평점 :</span> ${tmp.avrg_rate }</li>
			                            <li><span class="info-label">가입 인원 :</span> ${tmp.now_people}</li>
		                        </ul>
		                        <div class="user_content_btn">
		                        	<div class="user_content_info"><a href="${pageContext.request.contextPath}/group_managing/group_updateForm?num=${tmp.num}">정보 수정</a></div>
									<div class="user_content_join"><a href="${pageContext.request.contextPath}/group_managing/applicantList?group_num=${tmp.num}">가입 관리</a></div>
		                        </div>	
                       		</div>   
                    </div>
                </div>
	        </c:forEach>
    	</div>
    	
    </section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script>
		AOS.init();
	</script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
	<script>
		const memberlinks = document.querySelectorAll('[data-bs-toggle=popover]');
        [...memberlinks].map(item => new bootstrap.Popover(item));
	</script>
</body>
</html>