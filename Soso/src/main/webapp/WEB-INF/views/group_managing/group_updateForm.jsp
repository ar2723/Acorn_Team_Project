<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소모임 정보 수정</title>
<link rel="shortcut icon" type="image/x-icon" href="${path }/resources/images/main/favicon.jpg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group_managing/group_managing_group_insert.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/jquery.datetimepicker.min.css" />
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/navbar_c.jsp">
        <jsp:param value="login" name="current"/>
    </jsp:include>
	<div class="container">
		<div id="insert_title" style="margin-bottom:80px">소모임 정보 수정</div>
		
		<div class="image_container" style="display:flex; flex-direction:column; align-items:center">
			<c:choose>
				<c:when test="${fn:length(dto.img_path) < 32}">
					<img id="image_preview" src="${pageContext.request.contextPath}/resources/images/main/001.jpg" 
				style="width:150px; height:150px; border-radius:50%; border: 1px solid rgb(222, 226, 230)" alt="소모임 이미지"/>
				</c:when>
				<c:otherwise>
					<img id="image_preview" src="${pageContext.request.contextPath}${dto.img_path}" 
				style="width:150px; height:150px; border-radius:50%; border: 1px solid rgb(222, 226, 230)" alt="소모임 이미지"/>
				</c:otherwise>
			</c:choose>
			<div style="margin-top:20px; margin-bottom:20px; font-size: 15px;">소모임 이미지</div>
		</div>
		<form action="${pageContext.request.contextPath}/group_managing/group_update" method="post" id="myForm" enctype="multipart/form-data">
			<div class="form_header">
				<input type="hidden" name="num" value="${dto.num}"/>
				<div class="form_label">
					<label for="groupName">TITLE</label>
				</div>
				<input class="form_input" type="text" name="name" id="groupName" placeholder="Add text..." autocomplete="off" value="${dto.name}"/>
			</div>
			<div class="form_header">
				<input class="form_input" type="text" name="manager_comment" id="manager_comment" autocomplete="off" placeholder="이 소모임을 한마디로 표현해주세요!" value="${dto.manager_comment}" />		
			</div>
			<div class="grid_wrapper">
				<select name="genre" id="genre" class="select_box">
					<option selected>장르</option>
					<option value=1 ${dto.genre == 1 ? "selected" : "" }>자기계발</option>
					<option value=2 ${dto.genre == 2 ? "selected" : "" }>인문/역사/예술</option>
					<option value=3 ${dto.genre == 3 ? "selected" : "" }>경영/경제</option>
					<option value=4 ${dto.genre == 4 ? "selected" : "" }>문학</option>
					<option value=0 ${dto.genre == 0 ? "selected" : "" }>기타</option>
				</select>
	            <select name="max_people" id="max_people" class="select_box">
                     <option selected>모임 정원</option>
                     <option value = 2 ${dto.max_people == 2 ? "selected" : "" }>2명</option>
                     <option value = 3 ${dto.max_people == 3 ? "selected" : "" }>3명</option>
                     <option value = 4 ${dto.max_people == 4 ? "selected" : "" }>4명</option>
                     <option value = 5 ${dto.max_people == 5 ? "selected" : "" }>5명</option>
                     <option value = 6 ${dto.max_people == 6 ? "selected" : "" }>6명</option>
                     <option value = 7 ${dto.max_people == 7 ? "selected" : "" }>7명</option>
                     <option value = 8 ${dto.max_people == 8 ? "selected" : "" }>8명</option>
                     <option value = 9 ${dto.max_people == 9 ? "selected" : "" }>9명</option>
                </select>
				<select name="on_off" id="on_off" class="select_box">
					<option selected>온/오프라인 선택</option>
					<option value = 0 ${dto.on_off == 0 ? "selected" : "" }>온라인</option>
					<option value = 1 ${dto.on_off == 1 ? "selected" : "" }>오프라인</option>
				</select>
				<div class="select_box" style="display:flex; align-items:center; justify-content:space-between">변경할 소모임의 이미지를 선택해주세요
                 	<button id="image_btn" style="width: 65px; height: 27px; color: white;
                    				 			background-color: rgb(195, 181, 157); border:none; border-radius: 15px;">file</button>
                </div> 
			</div>			
			<script>
				document.querySelector("#on_off").addEventListener("change", (e) => {
					if(e.target.value == 0){
						document.querySelector("#meeting_loc").value = "온라인"
					} else {
						document.querySelector("#meeting_loc").value = ""
					}
				});
			</script>
			<div class="loc_time">
				<div>
					<input class="form_input" id="meeting_loc" type="text" name="meeting_loc" autocomplete="off" placeholer="모임 장소" value = "${dto.meeting_loc}"/>
				</div>
				<div>
					<input id="meeting_time" class="form_input" type="time" name="meeting_time" autocomplete="off" placeholer="모임 시간" value = ${dto.meeting_time} />
				</div>
			</div>
			<div class="date_pickers">
				<div>
					<input id="start_dt" class="form_input" type="text" name="start_dt" placeholer="모임 시작일" autocomplete="off" value=${dto.start_dt}/>
				</div>
				<div>
					<input id="ended_dt" class="form_input" type="text" name="ended_dt" placeholer="모임 종료일" autocomplete="off" value=${dto.ended_dt}/>
				</div>
				<div>
					<input id="deadline_dt" class="form_input" type="text" name="deadline_dt" placeholer="모임 모집 종료일" autocomplete="off" value=${dto.deadline_dt}/>
				</div>
			</div>
			<script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
			<!-- 플러그인 javascript 로딩 -->
			<script src="${pageContext.request.contextPath}/resources/js/jquery.datetimepicker.full.min.js"></script>
			<script>
				//언어
			    $.datetimepicker.setLocale("ko");
				//날짜 선택
				$("#start_dt").datetimepicker({
					timepicker:false,
					format:"Y.m.d"
				});
				//날짜 선택
				$("#ended_dt").datetimepicker({
					timepicker:false,
					format:"Y.m.d"
				});
				//날짜 선택
				$("#deadline_dt").datetimepicker({
					timepicker:false,
					format:"Y.m.d"
				});
				//시간 선택
				$("#meeting_time").datetimepicker({
			        datepicker:false,
			        format:"H:i"
			    });
			</script>
			<div>
				<textarea name="caption" id="caption" rows="5" placeholder="Add Text...">${dto.caption}</textarea>
				<div style = "display:flex; justify-content:end">
					<div id="currentTextLength">0 / 200</div> 
				</div>
				<div class="invalid-feedback">소모임 소개는 최소 100자이상 최대 200자 미만으로 적어주시길 바랍니다</div>
			</div>
			<script>
				$(".invalid-feedback").css("color", "red").css("font-size", "13px").css("font_weight", "600").hide();
				$("#caption").on("input", function(){
					const textNum = $(this).val().length;
					$("#currentTextLength").text(textNum + " / 200");
					if(textNum >= 200 || textNum < 100) {
						$("#caption").removeClass("is-valid").addClass("is-invalid");
						$(".invalid-feedback").show();
					} else {
						$("#caption").removeClass("is-invalid").addClass("is-valid");
			  		 	$(".invalid-feedback").hide();
					}
				});
			</script>
			<div id="form_button">
				<button type="submit">수정</button>
				<a style="background-color: black; color:white" class="deleteBtn">해산하기</a>
				<a style="background-color: black; color:white; margin-left:1rem;" class="btn mt-3" 
					href="${pageContext.request.contextPath}/test/bookUpdateForm?group_num=${dto.num}" id="bookUpdateLink" name="bookUpdateLink">책 수정&삭제</a>
			</div>
			<!-- db에 저장하기 위한 이미지 경로 값 -->
			<input type="hidden" name="img_path" value="${ dto.img_path }"/>
		</form>
		<form style="display:hidden" id="imageForm" action="${pageContext.request.contextPath}/group_managing/image_upload" method="post" enctype="multipart/form-data">
				<input id="image" name="image" type="file" style="display: none;"
                    		accept=".jpg, .png, .gif, .JPG, .JPEG, .jpeg"/>
			<button type="submit"></button>
		</form>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
		
		<script>
			$("#bookUpdateLink").click(function (event) {
				event.preventDefault();
			    // 새 창을 열기 위한 URL
			    var newWindowUrl = "${pageContext.request.contextPath}/test/bookUpdateForm?group_num=${dto.num}";
			
			    // 새 창 열기
			    window.open(newWindowUrl, "bookUpdateForm", "width=600,height=400");
			});
		
			$(".deleteBtn").css("cursor", "pointer").click(()=>{
				Swal.fire({
		      		title: `정말로 소모임을 해산하겠습니까?`,
		      		text: "소모임을 해산하면 다시 복구할 수 없습니다",
		      		icon: 'warning',
		      		confirmButtonColor: 'rgb(13, 110, 253)',
		      		cancelButtonColor: 'rgb(248, 162, 146)',
		      		confirmButtonText: '확인',
		      		cancelButtonText: '취소',
		      		showCancelButton: true,
		   		}).then((result) => {
			      	if (result.isConfirmed) {
			      		postTo("${pageContext.request.contextPath}/group_managing/group_delete?num=${dto.num}");
			      	}
			    })
			})
		</script>
		<script src="${pageContext.request.contextPath }/resources/js/gura_util.js"></script>
		<script>
			//file 버튼을 클릭하면 input type="file" 을 강제 클릭
			document.querySelector("#image_btn").addEventListener("click", (e) => {
				e.preventDefault();
                document.querySelector("#image").click()
			});
			
			document.querySelector("#image").addEventListener("change", (e) => {
				//ajax 전송할 폼의 참조값 얻어오기
				const form = document.querySelector("#imageForm");
				//gura_util.js 에 있는 함수를 이용해서 ajax 전송하기 
				ajaxFormPromise(form)
				.then(function(response){
					return response.json();
				})
				.then(function(data){
					console.log(data);
					// input name="profile" 요소의 value 값으로 이미지 경로 넣어주기
					document.querySelector("input[name=img_path]").value=data.imagePath;
					// img 요소를 문자열로 작성한 다음 
					let img=`<img id="image_preview" style="width:150px; height:150px; border-radius:50%; border: 1px solid rgb(222, 226, 230)" alt="소모임 이미지"
						src="${pageContext.request.contextPath }\${data.imagePath}">`;
					//class 가 image_container 인 요소의 내부(자식요소)에 덮어쓰기 하면서 html 형식으로 해석해 주세요 라는 의미 
					document.querySelector(".image_container").innerHTML=img;
				});
			});
			
		</script>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
</body>
</html>