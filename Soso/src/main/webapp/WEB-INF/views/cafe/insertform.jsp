<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소모임 커뮤니티 글쓰기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_group_insert.css">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="home" name="current"/>
	</jsp:include>
	    <div class="container">
		<div id="insert_title">글 작성하기</div>
		<div id="insert_subtitle">북메이트 커뮤니티에 글을 남겨 보세요</div>
		<form action="insert" method="post">
			<input type="hidden"  id="group_num" name="group_num" value="${num}" />
			<div class="grid_wrapper">
				<select class="select_box" id="select" name="header" >
			      <option selected>게시글 말머리</option>
			      <option value="1">책 추천</option>
			      <option value="2">책 내용</option>
			      <option value="3">수다</option>
			      <option value="4">정보 / 일정</option>
			    </select>
             </div>
			<div class="form_header">
                <div class="form_label">
                     <label for="groupName">글제목</label>
                </div>
                <input class="form_input" type="text" name="title" id="title" placeholder="글 제목을 입력하세요"/>
           	</div>
           	<div class="form_header">
                <div class="form_label">
                     <label for="groupName">글내용</label>
                </div>
                <textarea name="content" id="content" rows="2" placeholder="글 내용을 입력하세요"></textarea>
           	</div>
			<div id="form_button">
				<button type="submit">등록</button>
			</div>
		</form>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script>
           document.querySelector("#image_btn").addEventListener("click", (e) => {
			e.preventDefault();
               document.querySelector("#image").click()
		});
		document.querySelector("#image").addEventListener("change", (e) => {
			const files = e.target.files;
			if(files.length > 0){
				const reader = new FileReader();
				reader.onload = (event) => {
					const data=event.target.result;
					document.querySelector("#image_preview").setAttribute("src", data);
				};
				reader.readAsDataURL(files[0]);
			}
		});
		document.querySelector("#on_off").addEventListener("change", (e) => {
			if(e.target.value == 0){
				document.querySelector("#meeting_loc").value = "온라인"
			} else {
				document.querySelector("#meeting_loc").value = ""
			}
		});
	</script>
</body>
</html>
