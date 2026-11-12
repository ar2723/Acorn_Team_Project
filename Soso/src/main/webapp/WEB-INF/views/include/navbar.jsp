<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<%
	String id = (String)session.getAttribute("id");
%>
	<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
    <link rel="stylesheet" href="${path }/resources/css/common.css" type="text/css">
    <link rel="stylesheet" href="${path }/resources/css/reset.css" type="text/css">

    <script src="${path }/resources/js/common.js"></script>
<!-- mobile -->
    <div class="panel">  	
        <nav class="pGnb">
            <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/group/list?genre=-1" class="mainNav">북메이트 찾기</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/group_managing/user_main_all" class="mainNav">나의 북메이트</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/group_managing/admin_main_all" class="mainNav">북메이트 관리</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/support/support_main" class="mainNav">고객센터</a>
                    </li>
                    <c:choose>
            		<c:when test="${empty sessionScope.id }">
            		<li>
            			<a href="${pageContext.request.contextPath}/users/loginform" class="mainNav" >로그인 </a>
            			<a href="${pageContext.request.contextPath}/users/signup_form" class="mainNav" >회원가입</a>
            		</li>       
            		</c:when>
            		<c:otherwise>
            		<li>
            			<a href="${pageContext.request.contextPath}/users/info" class="mainNav">마이 페이지</a>
            		</li>
            		<li>
            			<a href="${pageContext.request.contextPath}/group/jjim_list" class="mainNav">북마크</a>
            		</li>
            		<li>
            			<a data-post href="${pageContext.request.contextPath}/users/logout" class="mainNav">로그아웃</a>
            		</li>
            		</c:otherwise>
            		</c:choose>   
                </ul>
        </nav>
    </div>
    <header>
    <!-- pc -->
        <div class="inner-wrap">
            <h1><a href="${pageContext.request.contextPath}/" class="logo"  onclick="fn()"; return false;><img src="${path }/resources/images/common/bookmate_logo_w_main.svg" alt="로고화이트"></a></h1>
            <nav class="gnb">
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/group/list?genre=-1" class="mainNav">북메이트 찾기</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/group_managing/user_main_all" class="mainNav">나의 북메이트</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/group_managing/admin_main_all" class="mainNav">북메이트 관리</a>
                    </li>
                    <li class="nav_cs">
                        <a href="${pageContext.request.contextPath}/support/support_main" class="mainNav">고객센터</a>
                    </li>
                    <c:choose>
            		<c:when test="${empty sessionScope.id }">
            		<li>
            			<a href="${pageContext.request.contextPath}/users/loginform" class="mainNav" >로그인</a>
            		</li>
            		<li>
            			<a href="${pageContext.request.contextPath}/users/signup_form" class="mainNav" >회원가입</a>
            		</li>       
            		</c:when>
            		<c:otherwise>
            		<li>
            			<a href="${pageContext.request.contextPath}/users/info" class="mainNav">마이 페이지</a>
            		</li>
            		<li>
            			<a href="${pageContext.request.contextPath}/group/jjim_list" class="mainNav">북마크</a>
            		</li>
            		<li>
            			<a data-post href="${pageContext.request.contextPath}/users/logout" class="mainNav">로그아웃</a>
            		</li>
            		</c:otherwise>
            		</c:choose>           
                </ul>	
			 </nav>
			 <div class="sns">
                <div class="iconWrap">
                    <a href="#" class="btn" onclick="return false;">
                        <span class="circle01"></span>
                        <span class="circle02"></span>
                        <span class="circle03"></span>
                    </a>
                </div>
            </div>
        </div>
    </header>