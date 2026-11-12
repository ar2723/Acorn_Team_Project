<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta property="og:title" content="북메이트" /> 
	<meta property="og:image" content="${path }/resources/images/main/bookmate_or_image.jpg" /> 
	<meta property="og:description" content="함께하는 독서모임 , 북메이트" /> 
	<meta name="viewport" content="width=device-width, maximum-scale=1.0, minimum-scale=1, user-scalable=yes,initial-scale=1.0" />
 	<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
    <link rel="stylesheet" href="${path }/resources/css/swiper-bundle.min.css" type="text/css">
    <link rel="stylesheet" href="${path }/resources/css/main.css" type="text/css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css" >
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${path }/resources/js/main.js"></script>
    <title>북메이트</title>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
    <main>
        <div class="swiper">
            <div class="swiper-wrapper">
                    <div class="swiper-slide main01 main-img"></div> 
                    <div class="swiper-slide main02 main-img"></div> 
                    <div class="swiper-slide main03 main-img"></div>
                    <div class="swiper-slide main04 main-img"></div>
                    <div class="swiper-slide main05 main-img"></div>
            </div>
            <div id="box">
                <span class="text"></span><span class="blink">|</span>
            </div>
<!-- 			<div class="slide-btn">
               <div class="swiper-button-prev"></div>
               <div class="swiper-button-next"></div>
            </div> -->
        </div>
    </main>
    <section class="popular">
        <div class="inner-wrap">
            <h3 class="title black" data-aos="fade-up"
            data-aos-offset="300"
            data-aos-once="false"
            data-aos-easing="ease-in-sine">인기 독서 모임</h3>
            <!-- <div class="slide_btn">
                <div class="swiper-button-prev prev"></div>
                <div class="swiper-button-next next"></div>
            </div> -->
            <div class="mate_content">
              <div class="inner-wrap">
	        	<c:forEach var="tmp" items="${viewList}" end="2">
	       		<div class="mate_content_list" >
	               <div class="mate_contents">
	                   <a href="${pageContext.request.contextPath}/group/group_page?num=${tmp.num }">
	                       <div class="mate_content_img">
	                           <img src="${pageContext.request.contextPath}${tmp.img_path}">
	                       </div>
	                       <div class="mate_content_text">
	                           <p class="mate_content_title">${tmp.name}</p>
	                           <p>모임장 ${tmp.manager_id}</p>
	                           <p>조회수 ${tmp.viewCount}</p>
	                           <p class="mate_content_date">${tmp.meeting_time}ㆍ금요일ㆍ${tmp.meeting_loc }</p>
	                       </div>
	                   </a>
	               </div>
	           </div>
	        	</c:forEach>
	        </div>
	        <div class="inner-wrapper">
	        <div data-aos="fade-up"
           		data-aos-offset="100"
            	data-aos-easing="ease-in-sine" class="button">
                <a href="${pageContext.request.contextPath}/group/list?genre=-1" class="about-button">북메이트 더보기</a>
            </div>
	        </div>
         </div>
     
        </div>
    </section>
    <section class="about-us">
        <div class="inner-wrap">
            <h3 class="title black" data-aos="fade-up"
            data-aos-offset="100"
            data-aos-easing="ease-in-sine">ABOUT US</h3>
            <div class="about-content">
                <p data-aos="fade-up"
                data-aos-offset="300"
                data-aos-easing="ease-in-sine" class="serif">
			                    공동체 독서모임 연결 함께하는 독서 모임, <br>
			                    배우고 성장하는 북메이트
                </p>
                <ul data-aos="fade-up"
                data-aos-offset="100"
                data-aos-easing="ease-in-sine" class="circle">
                    <li>독서</li>
                    <li>모임</li>
                    <li>토론</li>
                </ul>
                <p data-aos="fade-up"
                data-aos-offset="100"
                data-aos-easing="ease-in-sine" class="serif">
                공동체 독서모임 연결 함께하는 독서 모임, <br>
                배우고 성장하는 북메이트
                </p>
            </div>
            <div data-aos="fade-up"
            data-aos-offset="100"
            data-aos-easing="ease-in-sine" class="button">
                <a href="${pageContext.request.contextPath}/group_managing/user_main" class="about-button">개설하기</a>
            </div>
        </div>
    </section>
    
    <section class="fixed01"></section>

    <section class="our-business">
        <h3 class="title black">OUR MATE</h3>
        <div class="inner-wrap">
            <div data-aos="zoom-in-up" class="swiper pcol06 tcol06 mcol12">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <figure>
                            <img src="${path }/resources/images/main/authentic-book-club-scene.png" alt="">
                            <figcaption></figcaption>
                        </figure>
                    </div> 
                    <div class="swiper-slide">
                        <figure>
                            <img src="${path }/resources/images/main/high-angle-people-reading-together.png" alt="">
                            <figcaption></figcaption>
                        </figure>
                    </div> 
                    <div class="swiper-slide">
                        <figure>
                            <img src="${path }/resources/images/main/authentic-book-club-scene.png" alt="">
                            <figcaption></figcaption>
                        </figure>
                    </div> 
                    <div class="swiper-slide">
                        <figure>
                            <img src="${path }/resources/images/main/high-angle-people-reading-together.png" alt="">
                            <figcaption></figcaption>
                        </figure>
                    </div> 
                </div>
                <div class="slide-btn">
                    <div class="swiper-button-prev"></div>
                    <div class="swiper-button-next"></div>
                </div>
            </div>
            <div class="business-content pcol06 tcol06 mcol12">
	            <ul>
	            	<li data-aos="flip-right" data-aos-offset="100"
			                data-aos-once="true"
			                data-aos-easing="ease-in-sine">
			              <span></span>
			              <p><b style="font-size:1.7rem;">CONTACT</b></p>
			              <span></span>
	                  </li>
	                  <li data-aos="flip-right" data-aos-offset="100"
			                data-aos-once="true"
			                data-aos-easing="ease-in-sine">
			              <p>정세영</p>
			              <span><a href="https://github.com/ar2723"><i class="bi bi-github"></i></a></span>
	                      <p>고현준</p>
	                      <span><a href="https://github.com/HyeonJunKOH"><i class="bi bi-github"></i></a></span>
	                  </li>
	                  <li data-aos="flip-right" data-aos-offset="100"
			                data-aos-once="true"
			                data-aos-easing="ease-in-sine">
			              <p>김형규</p>
			              <span><a href="https://github.com/kariyarn"><i class="bi bi-github"></i></a></span>
	                      <p>박종현</p>
	                      <span><a href="https://github.com/PakrJongHyeon"><i class="bi bi-github"></i></a></span>
	                  </li>
	                  <li data-aos="flip-right" data-aos-offset="100"
			                data-aos-once="true"
			                data-aos-easing="ease-in-sine">
			              <p>송한나</p>
			              <span><a href="https://github.com/songhannaa"><i class="bi bi-github"></i></a></span>
	                      <p>이영주</p>
	                      <span><a href="https://github.com/2youngjoo"><i class="bi bi-github"></i></a></span>
	                  </li>
	                  <li data-aos="flip-right" data-aos-offset="100"
			                data-aos-once="true"
			                data-aos-easing="ease-in-sine">
			              <p>이진영</p>
			              <span><a href="https://github.com/Lee-Jin-Young"><i class="bi bi-github" ></i></a></span>
	                      <p>임효열</p>
	                      <span><a href="https://github.com/Wideds"><i class="bi bi-github"></i></a></span>
	                  </li>
                  
                </ul>
            </div>
        </div>
    </section>

    <section class="fixed02"></section>
<%-- 
    <section class="process">
        <div class="inner-wrap">
            <h3 class="title white">독서 소모임</h3>
            <ul>
                <li>
                    <div>
                        <img src="${path }/resources/images/main/4_icon_advice.svg" alt="">
                    </div>
                    <div class="txt">
                        <h6 class="serif">01. </h6>
                        <p>abc</p>
                    </div>
                </li>
                <li>
                    <div>
                        <img src="${path }/resources/images/main/4_icon_survey.svg" alt="">
                    </div>
                    <div class="txt">
                        <h6 class="serif">02.</h6>
                        <p>abc</p>
                    </div>
                
                </li>
                <li>
                    <div>
                        <img src="${path }/resources/images/main/4_icon_document.svg" alt="">
                    </div>
                    <div class="txt">
                        <h6 class="serif">03.</h6>
                        <p>abc</p>
                    </div>
                </li>
                <li>
                    <div>
                        <img src="${path }/resources/images/main/4_icon_construction.svg" alt="">
                    </div>
                    <div class="txt">
                        <h6 class="serif">04. </h6>
                        <p>abc</p>
                    </div>
                </li>
                <li>
                    <div>
                        <img src="${path }/resources/images/main/4_icon_manage.svg" alt="">
                    </div>
                    <div class="txt">
                        <h6 class="serif">05. </h6>
                        <p>abc</p>
                    </div>
                </li>
            </ul>
        </div>
    </section>
    
    <section class="fixed03"></section> --%>

    <section class="map">
        <h3 class="title black">북메이트 오시는 길</h3>
        <div class="inner-wrap">
            <div class="map-one pcol12 tcol12 mcol12" data-aos="fade-up"
            data-aos-offset="300"
            data-aos-once="true"
            data-aos-easing="ease-in-sine">
                <div class="first_map">
                <div id="daumRoughmapContainer1692434262801" class="root_daum_roughmap root_daum_roughmap_landing" style="width: 100%;"></div>
                </div>
            </div>
<%--             <div class="map-content pcol06 mcol12">
                <ul>
                    <div data-aos="flip-right" data-aos-offset="400"
                    data-aos-once="true"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                            <p>북메이트</p>
                        </li>
                    </div>
                    <div data-aos="flip-left" data-aos-offset="400"
                    data-aos-once="true"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                            <p>주소 서울 강남구 테헤란로 124 삼원타워 5층 501호</p>
                        </li>
                    </div>
                    <div data-aos="flip-left" data-aos-offset="400"
                    data-aos-once="true"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                            <p>대표전화 012-345-6789</p>
                        </li>
                    </div>
                </ul>
            </div> --%>
        </div>
    </section>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
    <!--카카오맵 지도-->
	<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>
	<script charset="UTF-8">
		new daum.roughmap.Lander({
			"timestamp" : "1692434262801",
			"key" : "2fw26",
			"mapWidth" : "100%",
			"mapHeight" : "400"
		}).render();
	</script>
    <script>
        AOS.init();

        $(function(){
        var list = $(".popular_content_list");
        var showNum = 4;
        var num = 0;
        var total = $(">li", list).size();
        var liWidth = $("li:first", list).width();
        var copyObj = $(">li:lt("+showNum+")", list).clone();
        list.append(copyObj);
        
        $(".next").on("click", function(){
            if(num == total){ 
                num = 0; 
                list.css("margin-left",num);
            }
            num++;
            
            list.stop().animate({marginLeft:-liWidth*num+"px"},500);
            return false;
        });

        $(".prev").on("click", function(){
            if(num == 0){    
                num = total; 
                list.css("margin-left", -num*liWidth+"px");
            }
            
            num--;
            list.stop().animate({marginLeft:-liWidth*num+"px"},400);
            return false;
        });
    });
    </script>
      
</body>
</html>