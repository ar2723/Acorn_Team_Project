<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소모임 커뮤니티 글 수정하기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_group_insert.css">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	  <div class="container">
		<div id="insert_title">글 수정하기</div>
		<form action="update" method="post">
			<input type="hidden" name="comu_num" value="${dto.comu_num }" />
			<input type="hidden"  id="group_num" name="group_num" value="${group_num }" />
             <div class="">
             <label for="title">작성자</label>
             	<input id="writer" value="${dto.writer }" disabled/>
             </div>
			<div class="form_header">
                <div class="form_label">
                     <label for="title">제목</label>
                </div>
                <input type="text" name="title" id="title" value="${dto.title }"/>
           	</div>
			<div>
				<label for="content">내용</label>
				<textarea name="content" id="content" rows="2">${dto.content }</textarea>
			</div>

			<div id="form_button">
				<button type="submit" onclick="submitContents(this);">수정확인</button>
				<button type="reset">취소</button>
			</div>
		</form>
		</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>