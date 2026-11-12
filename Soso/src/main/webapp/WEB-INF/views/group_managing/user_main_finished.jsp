<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 북메이트</title>
	<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<link rel="shortcut icon" type="image/x-icon" href="https://genfavicon.com/tmp/icon_7cacead7cd8483ca41a810db418dc8ab.ico">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_user_main.css" />
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
    <script src="${path }/resources/js/jquery.easing.1.3.js"></script>
    <script src="${path }/resources/js/common.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	
    <main id="main-banner" class="main-banner-02">
        <div class="inner-wrap">
            <div class="title">
                <h2>나의 북메이트</h2>
                <p>
			                    가입한 북메이트를<br>
		                             확인해보세요
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
            data-aos-offset="300"
            data-aos-easing="ease-in-sine">나의 북메이트</h3>
    	</div>
    	<div class="inner-wrap">
            <div class="user_content_theme">
                <ul>
                	<li><a href="${pageContext.request.contextPath}/group_managing/user_main_all">전체</a></li>
                    <li><a href="${pageContext.request.contextPath}/group_managing/user_main">진행중</a></li>
                    <li><a class="theme_active" href="${pageContext.request.contextPath}/group_managing/user_main_finished">종료</a></li>
                </ul>
            </div>
        </div>
    	<div class="inner-wrapper">
    		<c:forEach var="tmp" items="${list }">
                <div class="user_content_list">
                    <div class="user_contents">
                    	<div id="likedNumber">
							<div>❤ ${tmp.like_num }</div>
						</div>
                        <a href="${pageContext.request.contextPath}/group_managing/group_userdetail?num=${tmp.num}">
                            <div class="user_content_img">
                                <img src="${pageContext.request.contextPath }${tmp.img_path}"/>
                            </div>
                       		<div class="user_content_text">
                       			<ul class="">
		                            	<li class="title">${tmp.name}</li>
		                            	<li><span class="info-label">활동 종료 날짜 :</span> ${tmp.ended_dt}</li>
			                            <li><span class="info-label">모임장 :</span> ${tmp.manager_id}</li>
			                            <li><span class="info-label">모임 시간 :</span> ${tmp.meeting_time}</li>
			                            <li><span class="info-label">모임 장소 :</span> ${tmp.meeting_loc}</li>
			                            <li><span class="info-label">가입 인원 :</span> ${tmp.now_people}</li>
		                        </ul>
		                        <div class="user_content_btn">
		                        	<div class="user_content_community"><a href="${pageContext.request.contextPath}/group_managing/group_userdetail?num=${tmp.num}">커뮤니티</a></div>
									<div class="user_content_end"><a href="#">모임 종료</a></div>
		                        </div>
                       		</div>   
                        </a>
                    </div>
                </div>
	        </c:forEach>
    	</div>
    </section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script>
		AOS.init();
	</script>
</body>
</html>

