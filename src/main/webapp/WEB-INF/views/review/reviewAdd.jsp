<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게임평가 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");

	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		window.addEventListener('load', function() {
			const mask = document.querySelector('.mask');
	        const html = document.querySelector('html');
	        
			mask.style.display = 'none';
			html.style.overflow = 'auto';
		});
		
        
        // 검색창 엔터로 검색
         let searchInput = document.getElementById('search');

	    if (searchInput) {
	        searchInput.addEventListener('keyup', function(e) {
	            if (e.key === 'Enter') {
	        		let viewpart = $("#viewpart").val();
	        		let searchpart = $("#searchpart").val();
	        		let search = $("#search").val();
	        		location.href = "${ctp}/admin/gamelist?page=${page}&viewpart="+viewpart+"&searchpart="+searchpart+"&search="+search;
	            }
	        });
	    }
	});

	function showPopupAdd() {
    	const popup = document.querySelector('#popup-add');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
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
				<h2>게임 평가</h2>
			</div>
		</div>
		<div style="display: flex;">
			<div style="flex-grow:2">
				<div style="display: flex; align-items: center; justify-content: space-between;">
					<div id="searchlist" style="display: flex; align-items: center;">
						<i class="fa-solid fa-magnifying-glass mr-2"></i>
						<input type="text" name="search" id="search" value="${search}" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" />
					</div>
					<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()" style="flex-shrink: 0">
						<option value="gameIdx desc">많이 평가한순</option>
						<option value="showDate desc" ${viewpart == 'showDate desc' ? 'selected' : ''}>최신 발매일순</option>
						<option value="gameIdx desc">인겜스코어 높은순</option>
						<option value="metascore desc" ${viewpart == 'metascore desc' ? 'selected' : ''}>메타스코어 높은순</option>
						<option value="random" ${viewpart == 'random' ? 'selected' : ''}>랜덤 게임들</option>
					</select>
				</div>
				<p><br/></p>
				<div class="cm-box" style="padding:0">
					<div style="display: flex">
						<div>
							<img src="${ctp}/game/발더스게이트.jpg" class="review-game-img">
							<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${ctp}/game/${vo.gameImg}" class="review-game-img"></c:if>
							<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" class="review-game-img"></c:if>
						</div>
						<div class="review-text">
							<div>
								<div>게임 이름</div>
							</div>
							<div>출시일</div>
							<div>
								<span><img class="review-star-add" src="${ctp}/images/star.png"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="flex-grow:1">유저가 평가한 게임수</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-add" class="hide">
  <div class="popup-add-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 등록</div>
    		<a href="" onclick="closePopup('add')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="popup-add-main">
			<form name="gameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
					<tr>
						<th><font color="#ff5e5e">*</font> 이름</th>
						<td><input type="text" name="gameTitle" id="gameTitle" placeholder="게임 한글 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>외국어 이름</th>
						<td><input type="text" name="gameSubTitle" id="gameSubTitle" placeholder="게임 외국어 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>장르</th>
						<td><input type="text" name="jangre" id="jangre" placeholder="장르를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>플랫폼</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="g-button" data-platform="PC">PC</span>
			                    <span class="g-button" data-platform="PS4">PS4</span>
			                    <span class="g-button" data-platform="PS5">PS5</span>
			                    <span class="g-button" data-platform="XBO">XBO</span>
			                    <span class="g-button" data-platform="XSX">XSX</span>
			                    <span class="g-button" data-platform="XSS">XSS</span>
			                    <span class="g-button" data-platform="Switch">Switch</span>
			                    <span class="g-button" data-platform="Android">Android</span>
			                    <span class="g-button" data-platform="iOS">iOS</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>출시일</th>
						<td><input type="date" name="showDate" id="showDate" class="forminput" /></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><input type="number" name="price" id="price" placeholder="가격을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>메타스코어</th>
						<td><input type="number" name="metascore" id="metascore" placeholder="메타스코어를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀평가</th>
						<td><input type="text" name="steamscore" id="steamscore" placeholder="스팀 평가(전체)를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀링크</th>
						<td><input type="text" name="steamPage" id="steamPage" placeholder="스팀 스토어 링크를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>개발사</th>
						<td><input type="text" name="developer" id="developer" placeholder="개발사를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이미지</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="i-button" onclick="imageUpload()">직접 등록</span>
			                    <span style="display:none"><input type="file" name="file" id="inputImgs" accept=".jpg,.gif,.png,.jpeg" /></span>
			                    <span class="i-button" onclick="gameImgFormOpen()">주소로 등록</span>
							</div>
							<div id="gameImgForm" style="display:none"><input type="text" name="gameImg" id="gameImg" placeholder="이미지 주소를 입력하세요" class="forminput" /></div>
						</td>
					</tr>
					<tr>
						<th>게임소개</th>
						<td><textarea rows="3" name="gameInfo" id="gameInfo" placeholder="게임소개를 입력하세요" class="form-control textarea"></textarea></td>
					</tr>
					<tr>
						<td colspan="2">
							<input type="hidden" name="gameIdx" id="gameIdx" />
							<input type="button" class="joinBtn-sm" value="추가" onclick="gameAdd()" />
						</td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>
<div id="popup-gameedit" class="hide">
  <div class="popup-gameedit-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 수정</div>
    		<a href="" onclick="closePopup('gameedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="popup-add-main">
			<form name="egameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
					<tr>
						<td colspan="2" id="imgView"></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이름</th>
						<td><input type="text" name="egameTitle" id="egameTitle" placeholder="게임 한글 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>외국어 이름</th>
						<td><input type="text" name="egameSubTitle" id="egameSubTitle" placeholder="게임 외국어 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>장르</th>
						<td><input type="text" name="ejangre" id="ejangre" placeholder="장르를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>플랫폼</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="eg-button" data-platform="PC">PC</span>
			                    <span class="eg-button" data-platform="PS4">PS4</span>
			                    <span class="eg-button" data-platform="PS5">PS5</span>
			                    <span class="eg-button" data-platform="XBO">XBO</span>
			                    <span class="eg-button" data-platform="XSX">XSX</span>
			                    <span class="eg-button" data-platform="XSS">XSS</span>
			                    <span class="eg-button" data-platform="Switch">Switch</span>
			                    <span class="eg-button" data-platform="Android">Android</span>
			                    <span class="eg-button" data-platform="iOS">iOS</span>
							</div>
						</td>
					</tr>
					<tr>
						<th>출시일</th>
						<td><input type="date" name="eshowDate" id="eshowDate" class="forminput" /></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><input type="number" name="eprice" id="eprice" placeholder="가격을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>메타스코어</th>
						<td><input type="number" name="emetascore" id="emetascore" placeholder="메타스코어를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀평가</th>
						<td><input type="text" name="esteamscore" id="esteamscore" placeholder="스팀 평가(전체)를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀링크</th>
						<td><input type="text" name="esteamPage" id="esteamPage" placeholder="스팀 스토어 링크를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>개발사</th>
						<td><input type="text" name="edeveloper" id="edeveloper" placeholder="개발사를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이미지</th>
						<td>
							<div class="g-buttons" style="margin: 0 auto;">
			                    <span class="i-button" onclick="eimageUpload()">직접 등록</span>
			                    <span style="display:none"><input type="file" name="file" id="einputImgs" accept=".jpg,.gif,.png,.jpeg" /></span>
			                    <span class="i-button" onclick="egameImgFormOpen()">주소로 등록</span>
							</div>
							<div id="egameImgForm" style="display:none"><input type="text" name="egameImg" id="egameImg" placeholder="이미지 주소를 입력하세요" class="forminput" /></div>
						</td>
					</tr>
					<tr>
						<th>게임소개</th>
						<td><textarea rows="3" name="egameInfo" id="egameInfo" placeholder="게임소개를 입력하세요" class="form-control textarea"></textarea></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" class="joinBtn-sm" value="수정" onclick="gameEdit()" /></td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>
</body>
</html>