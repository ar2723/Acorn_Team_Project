<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>소모임 문의 게시판</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

</head>
<body>
	<div class="container">
			<br>	
			<h2 style="text-align: center">문의하기</h2>
			<div style="width:100%; text-align:right;">
				<a href="${pageContext.request.contextPath }/group/faq/insertform?num=${num}" class="btn btn-outline-dark" tabindex="-1" role="small-button" aria-disabled="true" >글 쓰기</a>
				<a id="faqInsert" href="#">문의하기2</a>
			</div>
			<br>
			<div class="altertable">
			 <table class="table">
		        <tbody>
		            <c:forEach var="tmp" items="${list}">
		                <tr class="faq-row">
		                    <td>${tmp.q_writer}</td>
		                    <td class="title-cell">
		                        <a style="color: black;" class="text-decoration-none q-title" href="#" data-content-id="content-${tmp.num}">${tmp.q_title}</a>
		                    </td>
		                    <td style="text-align: center">${tmp.regdate}</td>
		                </tr>
		                <tr id="content-${tmp.num}" class="hidden-content">
						    <td colspan="3">
						        <div>${tmp.q_content}</div>
						        <c:if test="${empty tmp.a_answer }">
						        	<a href="${pageContext.request.contextPath}/group/faq/updateform?num=${tmp.num}"id="update">수정</a>

						        	<a href="${pageContext.request.contextPath}/group/faq/delete?num=${tmp.num}&group_num=${tmp.group_num}">삭제</a>

						        </c:if>
						        <div class="answer" style="background-color: lightgrey;">${tmp.a_answer }</div> <!-- 이 부분을 추가 -->
						        <!-- session id과 manger id를 검증해서 조건부 출력 -->
						        <c:if test="${dto.manager_id == sessionScope.id }">
						        	<a href="${pageContext.request.contextPath}/group/answer/insertform?num=${tmp.num}" id="answer">답변&수정</a>
							        <a href="${pageContext.request.contextPath}/group/answer/updateform?num=${tmp.num}" id="updateAnswer" >답변 수정</a>

						        <a href="${pageContext.request.contextPath}/group/answer/delete?num=${tmp.num}&group_num=${tmp.group_num}">답변 삭제(실제로는 update)</a>						        

						        </c:if>
						    </td>
						</tr>
		            </c:forEach>
		        </tbody>
		    </table>
			<br />
				<ul class="pagination" style="justify-content: center;">
					<%--
						startPageNum 이 1 이 아닌 경우에만 Prev 링크를 제공한다. 
					 --%>
					<c:if test="${startPageNum ne 1 }">
						<li class="page-item">
							<a class="page-link animate__animated" href=${pageContext.request.contextPath}/group/faq/list?num=${num }&pageNum=${startPageNum-1 }">Prev</a>
						</li>
					</c:if>
					<c:forEach var="i" begin="${startPageNum }" end="${endPageNum }">
						<li class="page-item ${pageNum eq i ? 'active' : '' }">
							<a id="nowPage" class="page-link animate__animated" href="${pageContext.request.contextPath}/group/faq/list?num=${num }&pageNum=${i }" data-page-num=${i }>${i }</a>
						</li>
					</c:forEach>
					<%--
						마지막 페이지 번호가 전체 페이지의 갯수보다 작으면 Next 링크를 제공한다. 
					 --%>
					<c:if test="${endPageNum lt totalPageCount }">
						<li class="page-item">
							<a class="page-link animate__animated" href="${pageContext.request.contextPath}/group/faq/list?num=${num }&pageNum=${endPageNum+1 }">Next</a>
						</li>
					</c:if>				
				</ul>
		<br />
		</div>
	    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script>
			
			//페이징 처리 시 링크 전송을 막는다.
			$(document).ready(function() {
		    $(".page-link").on("click", function(e) {
		        e.preventDefault(); // 클릭된 링크의 기본 동작(페이지 이동)을 막습니다.
		
		        // 클릭한 페이지의 번호를 가져옵니다.
		        var pageNum = $(this).data("page-num");
	
		        // TODO: AJAX 처리를 통해 페이지 내용을 갱신하는 코드를 추가합니다.
		        $.ajax({
		            type: "GET",
		            url: "${pageContext.request.contextPath}/group/faq/paginglist?num=${num }&pageNum=" + pageNum,
		            dataType: "text",
		            error: function() {
		                console.log("통신실패");
		            },
		            success: function(data) {
		                // TODO: 받아온 데이터를 사용하여 페이지 내용을 갱신하는 코드를 작성합니다.
		                $(".altertable").html(data);
		            }
		        });
		    });
		});

			
			$(document).ready(function () {
			    $(".q-title").on("click", function (e) {
			        e.preventDefault();

			        var contentId = $(this).data("content-id");
			        var contentRow = $("#" + contentId);

			        contentRow.slideToggle(0);
			    });

			    // 처음에는 숨겨두기
			    $(".hidden-content").hide();
			});

			//여기서부터 ajax faq
			  //작성글 클릭 시 faq 페이지 로딩
			  $("#faqInsert").click(function() {
				  $.ajax({
			            type : "GET", //전송방식을 지정한다 (POST,GET)
			            url : "${pageContext.request.contextPath}/group/faq/insertform?num=${num }",//호출 URL을 설정한다. GET방식일경우 뒤에 파라티터를 붙여서 사용해도된다.
			            dataType : "text",//호출한 페이지의 형식이다. xml,json,html,text등의 여러 방식을 사용할 수 있다.
			            error : function(){
			                console.log("통신실패");
			            },
			            success : function(Parse_data){
			                $("#Parse_Area").html(Parse_data); //div에 받아온 값을 넣는다.
			                console.log("통신 데이터 값 : " + Parse_data);
			            }
			            
		        	});
				});
			
			//문의 수
			  $(document).ready(function() {
			        $("#update").click(function(event) {
			            event.preventDefault(); // 앵커의 기본 동작을 막습니다.

			            var href = $(this).attr("href"); // 앵커의 href 속성을 가져옵니다.
			            var tmpNum = href.split("num=")[1]; // href에서 num 값을 추출합니다.

			            $.ajax({
			                type: "GET",
			                url: href,
			                dataType: "text",
			                error: function() {
			                    console.log("통신실패");
			                },
			                success: function(Parse_data) {
			                    $("#Parse_Area").html(Parse_data);
			                    console.log("통신 데이터 값: " + Parse_data);
			                }
			            });
			        });
			    });
			
			//답변
			  $(document).ready(function() {
			        $("#answer").click(function(event) {
			            event.preventDefault(); // 앵커의 기본 동작을 막습니다.

			            var href = $(this).attr("href"); // 앵커의 href 속성을 가져옵니다.
			            var tmpNum = href.split("num=")[1]; // href에서 num 값을 추출합니다.

			            $.ajax({
			                type: "GET",
			                url: href,
			                dataType: "text",
			                error: function() {
			                    console.log("통신실패");
			                },
			                success: function(Parse_data) {
			                    $("#Parse_Area").html(Parse_data);
			                    console.log("통신 데이터 값: " + Parse_data);
			                }
			            });
			        });
			    });
			//답변 수정
			  $(document).ready(function() {
			        $("#updateAnswer").click(function(event) {
			            event.preventDefault(); // 앵커의 기본 동작을 막습니다.

			            var href = $(this).attr("href"); // 앵커의 href 속성을 가져옵니다.
			            var tmpNum = href.split("num=")[1]; // href에서 num 값을 추출합니다.

			            $.ajax({
			                type: "GET",
			                url: href,
			                dataType: "text",
			                error: function() {
			                    console.log("통신실패");
			                },
			                success: function(Parse_data) {
			                    $("#Parse_Area").html(Parse_data);
			                    console.log("통신 데이터 값: " + Parse_data);
			                }
			            });
			        });
			    });
		</script>
	</div>
</body>
</html>