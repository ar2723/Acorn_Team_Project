<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<title>/views/home.jsp</title>
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="${path }/resources/css/swiper-bundle.min.css" type="text/css">
    <link rel="stylesheet" href="${path }/resources/css/main.css" type="text/css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
    <script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
    <script src="${path }/resources/js/jquery.easing.1.3.js"></script>
    <script src="${path }/resources/js/swiper-bundle.min.js"></script>
    <script src="${path }/resources/js/common.js"></script>
    <script src="${path }/resources/js/main.js"></script>
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
            </div>
            <div id="box">
                <span class="text"></span><span class="blink">|</span>
            </div>
              <!-- 08-02 수정중 -->
            <!-- <div class="slide-btn">
                <div class="swiper-button-prev"></div>
                <div class="swiper-button-next"></div>
                <div class="swiper-play-stop-btn">
                    <img class="play-btn" src="./images/play-btn.svg" alt="play-slide">
                </div>
            </div> -->
        </div>
    </main>
    

    <section class="popular">
        <div class="inner-wrap">
            <h3 class="title black" data-aos="fade-up"
            data-aos-offset="300"
            data-aos-easing="ease-in-sine">인기 독서 모임</h3>
            <div class="slide_btn">
                <div class="swiper-button-prev prev"></div>
                <div class="swiper-button-next next"></div>
            </div>
            <ul class="popular_content_list">
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <a href="#">
                                    <!-- 찜누르기전 -->
                                    <svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" fill="none" class="bi bi-bookmark-heart" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 4.41c1.387-1.425 4.854 1.07 0 4.277C3.146 5.48 6.613 2.986 8 4.412z"></path>
                                    <path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5V2zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1H4z"></path>
                                    </svg>
                                    <!-- 찜누른후 -->
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" class="bi bi-bookmark-heart-fill" viewBox="0 0 16 16">
                                        <path d="M2 15.5a.5.5 0 0 0 .74.439L8 13.069l5.26 2.87A.5.5 0 0 0 14 15.5V2a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v13.5zM8 4.41c1.387-1.425 4.854 1.07 0 4.277C3.146 5.48 6.613 2.986 8 4.412z"/>
                                    </svg>
                                </a>
                                <img src="${path }/resources/images/main/001.jpg" alt="테스트이미지">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li>
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/002.jpg" alt="테스트이미지2">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li>
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/003.jpg" alt="테스트이미지3">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li>
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/004.jpg" alt="테스트이미지4">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li> 
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/005.jpg" alt="테스트이미지5">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li> 
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/006.jpg" alt="테스트이미지">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li> 
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/007.jpg" alt="테스트이미지7">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li>
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/008.jpg" alt="테스트이미지8">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li> 
                <li>
                    <div class="popular_content">
                        <a href="#">
                            <div class="popular_content_img">
                                <img src="${path }/resources/images/main/009.jpg" alt="테스트이미지9">
                            </div>
                        </a>
                        <a href="#">
                            <div class="popular_content_text">
                                <p class="popular_content_title">마음 살롱 - 심리학자와 함께하는 독서 모임</p>
                                <p>모임장 농담곰</p>
                                <p class="popular_content_date">8월 11일ㆍ금요일ㆍ강남</p>
                            </div>
                        </a>
                    </div>
                </li>
            </ul>
        </div>
    </section>


    <section class="about-us">
        <div class="inner-wrap">
            <h3 class="title black" data-aos="fade-up"
            data-aos-offset="300"
            data-aos-easing="ease-in-sine">ABOUT US</h3>
            <div class="about-content">
                <p data-aos="fade-up"
                data-aos-offset="300"
                data-aos-easing="ease-in-sine" class="serif">
			                    공동체 독서모임 연결 함께하는 독서 모임, <br>
			                    배우고 성장하는 북클럽
                </p>
                <ul data-aos="fade-up"
                data-aos-offset="400"
                data-aos-easing="ease-in-sine" class="circle">
                    <li>독서</li>
                    <li>모임</li>
                    <li>토론</li>
                </ul>
                <p data-aos="fade-up"
                data-aos-offset="500"
                data-aos-easing="ease-in-sine" class="serif">
                공동체 독서모임 연결 함께하는 독서 모임, <br>
                배우고 성장하는 북클럽
                </p>
            </div>
            <div data-aos="fade-up"
            data-aos-offset="400"
            data-aos-easing="ease-in-sine" class="button">
                <a href="#" class="about-button">신청하기</a>
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
                    <div data-aos="flip-right" data-aos-offset="300"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <p>soso1</p>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                        </li>
                    </div>
                    <div data-aos="flip-left" data-aos-offset="300"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <p>soso1</p>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                        </li>
                    </div>
                    <div data-aos="flip-right" data-aos-offset="300"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <p>soso1</p>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                        </li>
                    </div>
                    <div data-aos="flip-left" data-aos-offset="300"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <p>soso1</p>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                        </li>
                    </div>
                    
                </ul>
            </div>
        </div>
    </section>

    <section class="fixed02"></section>

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
    
    <section class="fixed01"></section>

    <section class="map">
        <h3 class="title black">북메이트</h3>
        <div class="inner-wrap">
            <div class="map-one">
                <div class="first_map">
                <div id="daumRoughmapContainer1690883727026" class="root_daum_roughmap root_daum_roughmap_landing"></div>
                
                </div>
            </div>
            <div class="map-content pcol06 tcol06 mcol12">
                <ul>
                    <div data-aos="flip-right" data-aos-offset="400"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                            <p>북메이트</p>
                        </li>
                    </div>
                    <div data-aos="flip-left" data-aos-offset="400"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                            <p>주소 서울 강남구 테헤란로 124 삼원타워 5층 501호</p>
                        </li>
                    </div>
                    <div data-aos="flip-left" data-aos-offset="400"
                    data-aos-easing="ease-in-sine">
                        <li>
                            <span><img src="${path }/resources/images/main/3_icon_check.svg" alt="체크 아이콘"></span>
                            <p>대표전화 012-345-6789</p>
                        </li>
                    </div>
                </ul>
            </div>
        </div>
    </section>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>


   
    <!-- 글씨 타이핑 스크립트 -->
    <script>
        const content = "함께 하는 독서 모임 , 북메이트 ";
        const text = document.querySelector(".text");
        text.textContent = "";
        let txtIdx = 0;
        function typing(){
            let txt = content[txtIdx++];
            if (txt == undefined) return;
            text.innerHTML += txt=== "\n" ? "<br/>": txt;
            if (txtIdx > content.length) {
                txtIdx = 0;
            }else{
                setTimeout(typing, 300)
            }
        }
        typing();
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
    <!-- 카카오 지도 불러오기 -->
    <script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>
        <script charset="UTF-8">
             new daum.roughmap.Lander({
                    "timestamp" : "1690883727026",
                    "key" : "2fpum",
                    "mapWidth" : "700",
                    "mapHeight" : "450"
         }).render();
     </script>
     <script>
         const scrollTop = function () {
        // create HTML button element
        const scrollBtn = document.createElement("button");
        scrollBtn.innerHTML = "TOP";
        scrollBtn.setAttribute("id", "scroll-btn");
        document.body.appendChild(scrollBtn);
        // hide/show button based on scroll distance
        const scrollBtnDisplay = function () {
            window.scrollY > window.innerHeight
            ? scrollBtn.classList.add("show")
            : scrollBtn.classList.remove("show");
        };
        window.addEventListener("scroll", scrollBtnDisplay);
        // scroll to top when button clicked
        const scrollWindow = function () {
            if (window.scrollY != 0) {
            setTimeout(function () {
                window.scrollTo(0, window.scrollY - 50);
                scrollWindow();
            }, 10);
            }
        };
        scrollBtn.addEventListener("click", scrollWindow);
        };
        scrollTop();
     </script>
      
</body>
</html>