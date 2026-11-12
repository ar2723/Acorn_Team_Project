<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="${path }/resources/js/jquery-1.12.0.min.js"></script>
<script src="${path }/resources/js/jquery.easing.1.3.js"></script>
<link rel="stylesheet" href="${path }/resources/css/common.css" type="text/css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
<title>북메이트 책 등록하기</title>
<style>
	#Parse_Area{
		margin-top: 12%;
	}

</style>
<script src="${pageContext.request.contextPath}/resources/js/csrf.js"></script>
</head>
<body>
	<div class="container">
		<!-- method를 get으로 하면 주소창을 통해 text를 보낼 수 있다. -->
		<form action="${pageContext.request.contextPath}/test/bookTest" method="get">
			<label for="search" class="col-form-label">북메이트 책 찾기</label>
			<input type="text" id="search" name="search" value="" class="form-control col-2"/>
			<button type="button" id="searchBook" class="btn btn-outline-secondary" style="float: right;
    margin: 3% 0;">검색</button>
		</form>
	</div>
	<!-- 여기에 목록을 출력한다. -->
	<div class="container">
		<div id="Parse_Area"gt;lt;></div>
	</div>
    

	<script>
	
	const urlParams = new URLSearchParams(window.location.search);
	const num = urlParams.get('num');
	
	//ajax로 페이지 전환 없이 검색결과 표시
    function performSearch() {
        var searchValue = $("#search").val();
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/test/bookTest",
            data: {
                search: searchValue,
                group_num : num
            },
            dataType: "text",
            error: function () {
                console.log("통신실패");
            },
            success: function (Parse_data) {
                $("#Parse_Area").html(Parse_data);
            }
        });
    }

    // "click" 이벤트 처리
    $("#searchBook").click(function (event) {
        event.preventDefault();
        performSearch();
    });

    // "keydown" 이벤트 처리
    $("#search").keydown(function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            performSearch();
        }
    });
	</script>
</body>
</html>