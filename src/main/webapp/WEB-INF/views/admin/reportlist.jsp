<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>신고목록 | 관리자모드</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';

	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		// 검색창 엔터로 검색
        let searchInput = document.getElementById('search');

	    if (searchInput) {
	        searchInput.addEventListener('keyup', function(e) {
	            if (e.key === 'Enter') {
	        		let viewpart = $("#viewpart").val();
	        		let searchpart = $("#searchpart").val();
	        		let search = $("#search").val();
	        		location.href = "${ctp}/admin/reportlist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	            }
	        });
	    }
	});
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
	});
	
	function partchange() {
		let viewpart = $("#viewpart").val();
		let searchpart = $("#searchpart").val();
		let search = $("#search").val();
		location.href = "${ctp}/admin/reportlist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	}
	
 	function viewContent(contentPart, contentIdx) {
 		$.ajax({
 			url : "${ctp}/admin/viewContent",
 			type : "post",
 			data : {contentPart:contentPart, contentIdx:contentIdx},
 			success : function(response) {
 				let res = response.split("|");
 				$("#contentPartTitle").html(res[0]);
 				$("#cmContent").html(res[1]);
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
 		
    	const popup = document.querySelector('#popup-report');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
 	
 	function reportOk(reIdx, banMid, banReason, contentPart, contentIdx) {
 		let ans = confirm("게시글/댓글이 삭제되며 유저는 활동 중지 처리됩니다 처리하겠습니까?");
 		if(ans) {
 			const mask = document.querySelector('.mask');
 			const html = document.querySelector('html');
 			mask.style.display = 'block';
 			html.style.overflow = 'hidden';

	 		$.ajax({
	 			url : "${ctp}/admin/reportOk",
	 			type : "post",
	 			data : {reIdx:reIdx, banMid:banMid, banReason:banReason, contentPart:contentPart, contentIdx:contentIdx},
	 			success : function() {
	 				mask.style.display = 'none';
	 				html.style.overflow = 'auto';
	 				alert("처리 완료!");
					location.reload();
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
 		}
	}
 	
 	function reportDel(reIdx, contentPart, contentIdx) {
 		let ans = confirm("게시글/댓글이 삭제됩니다 처리하겠습니까?");
 		if(ans) {
	 		$.ajax({
	 			url : "${ctp}/admin/reportDel",
	 			type : "post",
	 			data : {reIdx:reIdx, contentPart:contentPart, contentIdx:contentIdx},
	 			success : function() {
	 				alert("처리 완료!");
					location.reload();
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
 		}
	}
 	
 	function reportNo(reIdx) {
 		$.ajax({
 			url : "${ctp}/admin/reportNo",
 			type : "post",
 			data : {reIdx:reIdx},
 			success : function() {
 				alert("처리 완료!");
				location.reload();
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
	
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
	<div class="mask">
	  <img class="loadingImg" src='${ctp}/images/loding.gif'>
	</div>
	<div class="container">
		<div class="setting-main">
			<div class="setting-right">
				<h2>신고목록</h2>
				<div style="display: flex; justify-content: space-between;">
					<div id="searchlist" style="display: flex;">
						<select id="searchpart" name="searchpart" class="dropdown-btn mr-4">
							<option ${searchpart == '신고자' ? 'selected' : ''}>신고자</option>
							<option ${searchpart == '피신고자' ? 'selected' : ''}>피신고자</option>
						</select>
						<input type="text" name="search" id="search" value="${search}" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" style="width: 100%;" />
					</div>
					<span id="resetpc"><button class="joinBtn-sm" onclick="location.href='${ctp}/admin/reportlist';">초기화면으로</button></span>
				</div>
				<div id="resetmobile" class="text-right mt-3"><button class="badge badge-success" onclick="location.href='${ctp}/admin/reportlist';">초기화면으로</button></div>
			</div>
		</div>
		<hr/>
		<div style="display: flex; align-items: center; justify-content: space-between;">
			<div>총 ${totRecCnt}개의 신고</div>
			<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()">
				<option value="reIdx desc" ${viewpart == 'reIdx desc' ? 'selected' : ''}>최근순</option>
				<option value="reIdx" ${viewpart == 'reIdx' ? 'selected' : ''}>오래된순</option>
				<option value="notComplete" ${viewpart == 'notComplete' ? 'selected' : ''}>미처리 신고만</option>
				<option value="complete" ${viewpart == 'complete' ? 'selected' : ''}>처리완료 신고만</option>
				<option value="acquittal" ${viewpart == 'acquittal' ? 'selected' : ''}>무혐의 신고만</option>
			</select>
		</div>
		<p><br/></p>
		<c:if test="${fn:length(vos) == 0}">
			<div style="margin: 200px 0; font-size:20px;" class="text-center">해당되는 신고가 없습니다!</div>
		</c:if>
		<c:if test="${fn:length(vos) > 0}">
			<table id="custom-responsive-table" class="table table-borderless text-center" style="color:#fff;">
				<tr id="thbody" class="text-center">
					<th>신고자</th>
					<th>피신고자</th>
					<th>신고한 글/댓글</th>
					<th>사유</th>
					<th>비고</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td data-title="신고자">&nbsp;&nbsp;${vo.reportMid}</td>
						<td data-title="피신고자">&nbsp;&nbsp;${vo.sufferMid}</td>
						<td data-title="신고한 글/댓글">&nbsp;&nbsp;
							<c:if test="${vo.complete == 0}"><span onclick="viewContent('${vo.contentPart}',${vo.contentIdx})" class="viewContent">내용 확인</span></c:if>
							<c:if test="${vo.complete == 1}">삭제됨</c:if>
							<c:if test="${vo.complete == 2}"><span onclick="viewContent('${vo.contentPart}',${vo.contentIdx})" class="viewContent">내용 확인(무혐의)</span></c:if>
						</td>
						<td data-title="사유">&nbsp;&nbsp;${vo.reason}</td>
						<td>
							<c:if test="${vo.complete == 0}">
								<button id="levelBtn${vo.reIdx}" class="badge badge-danger" onclick="reportOk(${vo.reIdx},'${vo.sufferMid}','${vo.reason}', '${vo.contentPart}', ${vo.contentIdx})">처리하기</button>
								<button id="levelDelBtn${vo.reIdx}" class="badge badge-warning" onclick="reportDel(${vo.reIdx},'${vo.contentPart}', ${vo.contentIdx})">글만 삭제</button>
								<button id="levelOkBtn${vo.reIdx}" class="badge badge-secondary" onclick="reportNo(${vo.reIdx})">대상아님</button>
							</c:if>
							<c:if test="${vo.complete == 1 || vo.complete == 2}">
								<font color="#00c722"><b>처리 완료</b></font>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
			<div class="news-page">
				<c:if test="${page > 1}"><button class="prev" onclick="location.href='${ctp}/admin/reportlist?page=${page-1}&viewpart=${viewpart}&searchpart=${searchpart}&search=${search}';"><i class="fa-solid fa-chevron-left fa-2xs"></i></button></c:if>
		        <span class="page-info">${page}/${totPage}</span>
		        <c:if test="${page < totPage}"><button class="next" onclick="location.href='${ctp}/admin/reportlist?page=${page+1}&viewpart=${viewpart}&searchpart=${searchpart}&search=${search}';"><i class="fa-solid fa-chevron-right fa-2xs"></i></button></c:if>
			</div>
		</c:if>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-report" class="hide">
  <div class="popup-report-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">내용 확인하기</span>
    		<div style="cursor:pointer;" onclick="closePopup('report')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="text-center mb-4" id="contentPartTitle"></div>
		<hr/>
		<div class="text-center mb-4" id="cmContent"></div>
    </div>
</div>
</body>
</html>