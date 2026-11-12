<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>활동내역보기</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_memberInfo.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="info" name="current" />
	</jsp:include>
	<section class="info_container">
		<div class="info_title">유저 정보</div>
		<div>
			<div id="info_header">
				<div>
					<c:choose>
						<c:when test="${empty dto.profile }">
							<div style="margin: 70px 100px">
								<i class="bi-person-circle" style="font-size:130px" id="profileImage"></i>
							</div>
						</c:when>
						<c:otherwise>
							<div><img class="card-image" src="${pageContext.request.contextPath}${dto.profile}" /></div>
						</c:otherwise>
					</c:choose>
				</div>
				<div id="info_body">
					<div class="info-body-main">
						<div class="info-body-content">
							<div class="body-header">아이디</div>
							<div>${dto.user_id}</div>
						</div>
						<div>
							<div class="body-header">자기 소개</div>
							<div>${dto.intro}</div>
						</div>
					</div>
					<div>
						<div class="info-body-content" style="margin-bottom: 55px">
							<div class="body-header">가입 상태</div>
							<div>
								<c:choose>
									<c:when test="${dto.isJoin == 0 }">
										<div id="joined">소모임 가입</div>
									</c:when>
									<c:otherwise>
										<div id="kicked">소모임 추방</div>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div>
							<div class="body-header">소모임 가입일</div>
							<div>${dto.join_dt}</div>
						</div>
					</div>
				</div>
				<div id="info_kick">
					<div>
						<div><a href="javascript:kickConfirm()">소모임 추방</a></div>
					</div>
				</div>
			</div>
		</div>
		<div>
			<div class="info_title">활동 내역</div>
			<div>
				<ul class="nav justify-content-end nav-tabs">
					<li class="nav-item">
						<a class="nav-link" id="writingList" href="#">작성글</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="commentList" href="#">작성댓글</a>
					</li>
				</ul>
			</div>
		</div>
		<div id="Parse_Area"gt;lt;></div>
	</section>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
	<script>
		//작성글 클릭 시 writing_list 페이지 로딩
		$("#writingList").click(function() {
			$.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/group_managing/info/writing_list?writer=${dto.user_id}&group_num=${dto.group_num}",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
	            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	                console.log("통신 데이터 값 : " + Parse_data);
	            }
	            
        	});
			$(this).attr("class","nav-link active")
			$("#commentList").attr("class","nav-link");
		});
		
		//작성 댓글 클릭 시 comment_list 페이지 로딩
		$("#commentList").click(function() {
	        $.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/group_managing/info/comment_list?writer=${dto.user_id}&group_num=${dto.group_num}",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
	            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	            }
        	});
	        
	        $(this).attr("class","nav-link active");
	        $("#writingList").attr("class","nav-link");
		})
		//화면 로딩 시 해당 소모임에서 작성자가 작성한 게시글 list 페이지 로딩
		$(document).ready(function() {
			$.ajax({
	            type : "GET", //전송방식을 지정한다 (POST,GET)
	            url : "${pageContext.request.contextPath}/group_managing/info/writing_list?writer=${dto.user_id}&group_num=${dto.group_num}",//호출 URL을 설정 
	            dataType : "text", //호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
	            error : function(){
	                console.log("통신실패");
	            },
	            success : function(Parse_data){
	                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
	            }
	            
        	});
			
			$("#writingList").attr("class","nav-link active");
		});
	</script>
</body>
</html>