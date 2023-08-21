<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/views/group_managing/group_userdetail.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing_user_detail.css" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
   	<div style="margin: 0 auto; margin-top:120px; margin-bottom: 250px; width: 776px;">
   		<div style="display:flex; height: 300px; margin-bottom:50px">
	   		<img style="height:100%" src="${pageContext.request.contextPath}${dto.img_path}"/>   
	  		<div class="card">
	        	<div class="card-body">
	               <p class="card-title"><strong>${dto.name}</strong></p>
	               <p class="card-text">${dto.caption}</p>
	     		</div>
	           	<ul class="list-group list-group-flush">
	               <li class="list-group-item card-info"><span class="info-label">모임장 :</span> ${dto.manager_id}</li>
	               <li class="list-group-item card-info"><span class="info-label">모임 시간 :</span> ${dto.meeting_time}</li>
	               <li class="list-group-item card-info"><span class="info-label">모임 장소 :</span> ${dto.meeting_loc}</li>
	               <li class="list-group-item card-info"><span class="info-label">가입 인원 :</span> ${dto.now_people}</li>
	           	</ul>
	        </div>
   		</div>
        <jsp:include page="/WEB-INF/views/cafe/list.jsp"></jsp:include>
    </div>   	         
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>

