<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\r\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>문의목록 | 관리자모드</title>
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
	        		location.href = "${ctp}/admin/supportlist?page=${page}&viewpart="+viewpart+"&search="+search;
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
		let search = $("#search").val();
		location.href = "${ctp}/admin/supportlist?page=${page}&viewpart="+viewpart+"&search="+search;
	}
	
	function supportView(supIdx, supEmail, main, sub, supImg, supContent) {
		if(sub != '') $("#viewMain").text(main+"/"+sub);
		else $("#viewMain").text(main);
		
		if(supImg != '') $("#viewImg").html('<img src="${ctp}/data/support/'+supImg+'" width="100%"/>');
		$("#viewContent").html(supContent);
		$("#viewEmail").val(supEmail);
		$("#viewIdx").val(supIdx);
		
    	const popup = document.querySelector('#popup-add');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
	
	function reSupport() {
		let main = $("#viewMain").text();
		let email = $("#viewEmail").val();
		let idx = $("#viewIdx").val();
		let content = $("#viewContent").html();
		let reContent = $("#supReContent").val();
		
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		mask.style.display = 'block';
		html.style.overflow = 'hidden';
		
		$.ajax({
            url: "${ctp}/admin/reSupport",
            type: "post",
            data: {main: main, supEmail: email, supIdx: idx, supContent : content, reContent:reContent},
            success: function() {
 				mask.style.display = 'none';
 				html.style.overflow = 'auto';
 				alert("답변 완료!");
            	location.reload();
            },
            error: function() {
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
				<h2>문의목록</h2>
				<div style="display: flex; justify-content: space-between;">
					<div id="searchlist" style="display: flex;">
						<select id="searchpart" name="searchpart" class="dropdown-btn mr-4">
							<option>이메일</option>
						</select>
						<input type="text" name="search" id="search" value="${search}" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" style="width: 100%;" />
					</div>
					<span id="resetpc"><button class="joinBtn-sm" onclick="location.href='${ctp}/admin/supportlist';">초기화면으로</button></span>
				</div>
				<div id="resetmobile" class="text-right mt-3"><button class="badge badge-success" onclick="location.href='${ctp}/admin/supportlist';">초기화면으로</button></div>
			</div>
		</div>
		<hr/>
		<div style="display: flex; align-items: center; justify-content: space-between;">
			<div>총 ${totRecCnt}개의 문의</div>
			<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()">
				<option value="supIdx desc" ${viewpart == 'reIdx desc' ? 'selected' : ''}>최근순</option>
				<option value="supIdx" ${viewpart == 'reIdx' ? 'selected' : ''}>오래된순</option>
				<option value="notComplete" ${viewpart == 'notComplete' ? 'selected' : ''}>미처리 문의만</option>
				<option value="complete" ${viewpart == 'complete' ? 'selected' : ''}>처리완료 문의만</option>
			</select>
		</div>
		<p><br/></p>
		<c:if test="${fn:length(vos) == 0}">
			<div style="margin: 200px 0; font-size:20px;" class="text-center">해당 문의가 없습니다!</div>
		</c:if>
		<c:if test="${fn:length(vos) > 0}">
			<table id="custom-responsive-table" class="table table-borderless text-center" style="color:#fff;">
				<tr id="thbody" class="text-center">
					<th>이메일</th>
					<th>대분류</th>
					<th>소분류</th>
					<th>비고</th>
				</tr>
				<c:forEach var="vo" items="${vos}">
					<tr>
						<td data-title="이메일">&nbsp;&nbsp;${vo.supEmail}</td>
						<td data-title="대분류">&nbsp;&nbsp;${vo.main}</td>
						<td data-title="소분류">&nbsp;&nbsp;${vo.sub}</td>
						<td>
							<c:if test="${vo.supComplete == 0}">
								<button class="badge badge-success" onclick="supportView(${vo.supIdx}, '${vo.supEmail}','${vo.main}','${vo.sub}','${vo.supImg}', '${fn:replace(vo.supContent, newLine, '<br>')}')">답변하기</button>
							</c:if>
							<c:if test="${vo.supComplete == 1}">
								<font color="#00c722"><b>처리 완료</b></font>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
			<div class="news-page">
				<c:if test="${page > 1}"><button class="prev" onclick="location.href='${ctp}/admin/supportlist?page=${page-1}&viewpart=${viewpart}&search=${search}';"><i class="fa-solid fa-chevron-left fa-2xs"></i></button></c:if>
		        <span class="page-info">${page}/${totPage}</span>
		        <c:if test="${page < totPage}"><button class="next" onclick="location.href='${ctp}/admin/supportlist?page=${page+1}&viewpart=${viewpart}&search=${search}';"><i class="fa-solid fa-chevron-right fa-2xs"></i></button></c:if>
			</div>
		</c:if>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-add" class="hide">
  <div class="popup-add-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">문의 내용</span>
    		<div style="cursor:pointer;" onclick="closePopup('add')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-add-main">
			<label class="support-title mt-3">문의 유형</label>
			<div id="viewMain" style="color:#fff; font-weight: bold;"></div>
			<label class="support-title mt-3">문의 내용</label>
			<div id="viewImg" class="mb-2"></div>
			<div id="viewContent"></div>
			<input type="hidden" id="viewEmail" />
			<input type="hidden" id="viewIdx" />
			<hr/>
			<label class="support-title mt-3">답변하기</label>
			<div><textarea id="supReContent" rows="10" class="textarea" placeholder="답변 내용을 적어주세요" style="width: 100%;"></textarea></div>
			<div class="text-right"><button class="edit-button" onclick="reSupport()">답변하기</button></div>
		</div>
    </div>
</div>
</body>
</html>