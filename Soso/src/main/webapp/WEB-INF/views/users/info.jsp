<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/users/usersInfo.css" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
		<jsp:param value="info" name="current" />
	</jsp:include>
	<section>
		<div class="info_container">
			<div class="info_title">가입 정보</div>
			<div id="info_header">
				<div id="info_body">
					<div>
						<c:choose>
							<c:when test="${empty dto.profile }">
								<div style="margin: 70px 100px">
									<i class="bi-person-circle" style="font-size:130px" id="profileImage"></i>
								</div>
							</c:when>
							<c:otherwise>
								<div>
									<img class="card-image" src="${pageContext.request.contextPath}${dto.profile}" />
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="info-body-main">
						<div class="info-body-content">
							<div class="body-header">이름 : </div>
							<div> ${dto.name }</div>
						</div>
						<div class="info-body-content">
							<div class="body-header">아이디 : </div>
							<div>${id }</div>
						</div>
						<div class="info-body-content">
							<div class="body-header">이메일 : </div>
							<div>${dto.email }</div>
						</div>
						<div class="info-body-content">
							<div class="body-header">가입일 : </div>
							<div>${dto.regdate }</div>
						</div>
					</div>
					<div class="buttons">
						<c:if test="${dto.social != 2 }">
							<div class="button" style="background-color: rgb(191, 191, 191)">
								<div><a href="${pageContext.request.contextPath}/users/pwd_updateform">비밀번호 변경</a></div>
							</div>
						</c:if>
						<div class="button" style="background-color: rgb(158 165 194 / 97%)">
							<div><a href="${pageContext.request.contextPath}/users/updateform">개인정보 수정</a></div>
						</div>
						<div class="button" style="margin-top:55px; background-color:rgb(241 146 146 / 97%)">
							<div class="deleteConfirm">회원 탈퇴</div>
						</div>
					</div>
				</div>
			</div>
			<div class="mb-5">
				<div class="activity">
					<h2 class="title">활동 내역</h2>
				</div>
				<ul class="nav justify-content-end nav-tabs">
					<li class="nav-item">
						<a class="nav-link" id="writingList" href="javascript:void(0);">작성글</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="commentList" href="javascript:void(0);">작성댓글</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" id="supportList" href="javascript:void(0);">문의사항</a>
					</li>
				</ul>
				<div id="Parse_Area"gt;lt;></div>
			</div>
		</div>
	</section>
	
	
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
	<script>
		//작성글 클릭 시 writing_list 페이지 로딩
		$("#writingList").click(function() {
			$.ajax({
				type : "GET", //전송방식을 지정한다 (POST,GET)
				url : "${pageContext.request.contextPath}/users/info/writing_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
				dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
				error : function(){
					console.log("통신실패");
				},
				success : function(Parse_data){
					$("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
				}
				
			});
			
			$(this).attr("class","nav-link active")
			$("#commentList").attr("class","nav-link");
			$("#supportList").attr("class","nav-link");
		});
		
		//작성 댓글 클릭 시 comment_list 페이지 로딩
		$("#commentList").click(function() {
			$.ajax({
				type : "GET", //전송방식을 지정한다 (POST,GET)
				url : "${pageContext.request.contextPath}/users/info/comment_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
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
			$("#supportList").attr("class","nav-link");
		})
		
		//문의사항 클릭 시 support_list 페이지 로딩 
		$("#supportList").click(function() {
			$.ajax({
				type : "GET", //전송방식을 지정한다 (POST,GET)
				url : "${pageContext.request.contextPath}/users/info/support_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
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
			$("#commentList").attr("class","nav-link");
			
		})
		
		//화면 로딩 시 writing_list 페이지 로딩
		$(document).ready(function() {
			
			$.ajax({
				type : "GET", //전송방식을 지정한다 (POST,GET)
				url : "${pageContext.request.contextPath}/users/info/writing_list",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
				dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
				error : function(){
					console.log("통신실패");
				},
				success : function(Parse_data){
					$("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
				}
				
			});
			
			$("#writingList").attr("class","nav-link active");
		});
		
		$(".deleteConfirm").css("cursor", "pointer").click(()=>{
			Swal.fire({
				title: `${id} 님 탈퇴 하시겠습니까?`,
				text: "신중히 생각하시고 결정하시길 바랍니다",
				icon: 'warning',
				confirmButtonColor: 'rgb(13, 110, 253)',
				cancelButtonColor: 'rgb(248, 162, 146)',
				confirmButtonText: '확인',
				cancelButtonText: '취소',
				showCancelButton: true
			}).then((result) => {
				if (result.isConfirmed) {
					postTo("${pageContext.request.contextPath}/users/delete");
				}
			})
		});
	</script>
</body>
</html>