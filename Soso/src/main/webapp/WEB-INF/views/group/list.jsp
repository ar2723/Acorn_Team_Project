<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>북메이트 찾기</title>
	<link rel="shortcut icon" type="image/x-icon" href="https://genfavicon.com/tmp/icon_7cacead7cd8483ca41a810db418dc8ab.ico">
	<link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="${path }/resources/css/group_list.css" type="text/css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
    <script src="${path }/resources/js/jquery.easing.1.3.js"></script>
    <script src="${path }/resources/js/common.js"></script>
    <script src="${path }/resources/js/gura_util.js"></script>
	
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>

    <main id="main-banner" class="main-banner-01">
        <div class="inner-wrap">
            <div class="title">
                <h2>북메이트 찾기</h2>
                <p>
			                    깊게 읽고 사유하는,<br>
			                    북메이트와 함께 취향의 독서를 나누세요.
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

    <section class="sub-contents mate_content">
        <div class="inner-wrap">
            <h3 class="title black" data-aos="fade-up"
            data-aos-offset="300"
            data-aos-easing="ease-in-sine">북메이트 찾기</h3>
            <div class="theme_search">
            	<form action="list" method="get">
            	<input type="text" placeholder="검색어.." value="${keyword}" name="keyword" />
            		<select name="condition" id="condition">
            			<option value="name_caption" ${condition eq 'name_caption' ? 'selected' : '' }>모임명 +내용</option>
            			<option value="name"  ${condition eq 'name' ? 'selected' : '' }>모임명 </option>
            			<option value="writer"  ${condition eq 'manager_id' ? 'selected' : '' }>모임장</option>
            		</select>
            	<button type="submit">검색</button>
            	</form>
            </div>
        </div>
        <div class="inner-wrap">
            <div class="mate_content_theme">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/group/list?genre=-1">전체보기</a></li>
			        <li><a href="${pageContext.request.contextPath}/group/list?genre=1">자기계발</a></li>
			        <li><a href="${pageContext.request.contextPath}/group/list?genre=2">인문</a></li>
			        <li><a href="${pageContext.request.contextPath}/group/list?genre=3">경제</a></li>
			        <li><a href="${pageContext.request.contextPath}/group/list?genre=4">문학</a></li>
			        <li><a href="${pageContext.request.contextPath}/group/list?genre=0">기타</a></li>
                </ul>
            </div>
            <div class="mate_content_theme">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/group/viewList">인기순</a></li>
                    <li><a href="${pageContext.request.contextPath}/group/list?genre=-1">최신순</a></li>
                </ul>
            </div>
        </div>

        <div class="inner-wrapper">
        		<c:forEach var="tmp" items="${list}" >
        		<div class="mate_content_list">
	               <div class="mate_contents">
	                   <a href="${pageContext.request.contextPath}/group/group_page?num=${tmp.num }">
	                       <div class="mate_content_img">
	                           <img src="${pageContext.request.contextPath}${tmp.img_path}">
	                           <!-- 신청 마감일시 마감버튼 보이게 -->
								<c:set var="now" value="<%= new java.util.Date() %>" />
								<c:set var="nowDate"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
								<c:choose>
									<c:when test="${tmp.deadline_dt lt nowDate}">
										<div class="deadline_btn">마감</div>
									</c:when>
									<c:otherwise>
									</c:otherwise>
								</c:choose>	                                  
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
        <div id="Parse_Area"gt;lt;></div>
        
    </section>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	  <script>
      	AOS.init();
        //페이지 번호를 관리할 변수를 만들고 초기값 1 대입하기
        let currentPage=1;
        //마지막 페이지는 totalPageCount 이다.  
        let lastPage=${totalPageCount};
        
        //주소창에서 genre의 값 얻어오기
        const urlParams = new URLSearchParams(window.location.search);
		let genre = urlParams.get('genre');

        
        /*
           window.scrollY => 위쪽으로 스크롤된 길이
           window.innerHeight => 웹브라우저의 창의 높이
           document.body.offsetHeight => body 의 높이 (문서객체가 차지하는 높이)
        */
        
        $(window).on("scroll", function() {
            // 바닥 까지 스크롤 했는지 여부
            const isBottom =
                window.innerHeight + window.scrollY +10 >= document.body.offsetHeight;

            // 현재 페이지가 마지막 페이지인지 여부 알아내기
            let isLast = currentPage == lastPage;

            // 현재 바닥까지 스크롤 했고 현재 페이지가 마지막이 아니라면
            if (isBottom && !isLast) {
                // 현재 페이지를 1 증가 시키고
                currentPage++;

                /*
                   해당 페이지의 내용을 ajax 요청을 통해서 받아온다.
                   "pageNum=xxx&num=xxx" 형식으로 GET 방식 파라미터를 전달한다.
                */
                $.ajax({
                    url: "${pageContext.request.contextPath}/group/ajax_list",
                    type: "get",
                    data: {
                        pageNum: currentPage,
                       	genre : genre
                    }
                })
                .done(function(data) {
                    // data는 html 형식의 문자열이다.
                    console.log(data);
                    // beforebegin | afterbegin | beforeend | afterend
                    $("#Parse_Area").append(data);
                });
            }
        });
    	
     </script>
</body>
</html>