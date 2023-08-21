<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/group/user_main.jsp</title>
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_user_main.css" />
	<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
    <script src="${path }/resources/js/jquery.easing.1.3.js"></script>
    <script src="${path }/resources/js/common.js"></script>
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
                    <a href="#" title="메인페이지가기"><img src="${path }/resources/images/sub/icon_home.svg" alt="홈버튼이미지"></a>
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
                    <li><a href="#">진행중</a></li>
                    <li><a href="#">종료</a></li>
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
			                            <li><span class="info-label">모임장 :</span> ${tmp.manager_id}</li>
			                            <li><span class="info-label">모임 시간 :</span> ${tmp.meeting_time}</li>
			                            <li><span class="info-label">모임 장소 :</span> ${tmp.meeting_loc}</li>
			                            <li><span class="info-label">가입 인원 :</span> ${tmp.now_people}</li>
		                        </ul>
		                        <div class="user_content_btn">
		                        	<div class="user_content_community"><a href="${pageContext.request.contextPath}/group_managing/group_userdetail?num=${tmp.num}">커뮤니티</a></div>
									<div class="user_content_delete"><a href="javascript:deleteConfirm()">탈퇴</a></div>
		                        </div>
		                        <script>
								    function deleteConfirm() {
								        const isDelete = confirm("${id} 님 탈퇴 하시겠습니까?");
								        if(isDelete) {
								            location.href = "${pageContext.request.contextPath}/group_managing/group_userdropOut?group_num=${tmp.num}";
								        }
								    }
								</script>
                       		</div>   
                        </a>
                    </div>
                </div>
	        </c:forEach>
    	</div>
    	<div class="inner-wrap">
    	<!-- 페이지 이동을 위한  --> 
	    <nav>
	       <ul class="">
	          <c:choose>
	             <c:when test="${dto.prevNum ne 0 }">
	                <li class="">
	                     <a class="" href="${pageContext.request.contextPath}">&larr; Prev</a>
	                </li>
	             </c:when>
	         </c:choose>
	         <c:choose>
	            <c:when test="${dto.nextNum ne 0 }">
	               <li class="">
	                   <a class="" href="${pageContext.request.contextPath}">Next &rarr;</a>
	               </li>
	            </c:when>
	         </c:choose>         
	       </ul>
	    </nav>
    	</div>
    </section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script>
		AOS.init();
	</script>
</body>
</html>

