<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width" />
<title>최신피드 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");
	
	let isWriteButtonClicked = false;
	
	let isFetching = false;
	let totPage = 1;
	
	
	$(document).ready(function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
    });
	
	window.addEventListener('load', function() {
		const mask = document.querySelector('.mask');
        const html = document.querySelector('html');
        
		mask.style.display = 'none';
		html.style.overflow = 'auto';
	});
	
	window.addEventListener('scroll', () => {
	    if (isFetching || totPage >= ${totPage}) {
	        return false;
	    }

	    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
	    	rootData();
			totPage++;
	    }
	});
	
	// 무한스크롤
	function rootData() {
		isFetching = true;
		
		$.ajax({
			url : "${ctp}/community/rootData",
			type : "post",
			data : {page : ${page}+totPage, part : 'my'},
			success : function(res) {
				isFetching = false;
				$("#root").append(res);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	
	function showAllContent(cmIdx) {
		$.ajax({
			url : "${ctp}/community/showAllContent",
			type : "post",
			data : {cmIdx : cmIdx},
			success : function(res) {
				$("#cmContent"+cmIdx).html(res);
				$("#cmContent"+cmIdx).removeClass("moreGra");
				$("#cmContent"+cmIdx).addClass("expanded");
				$("#moreBtn"+cmIdx).hide();
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	function likeAdd(cmIdx) {
		$.ajax({
			url : "${ctp}/community/likeAdd",
			type : "post",
			data : {cmIdx : cmIdx},
			success : function(res) {
				let r = res.split("%");
				$("#cm-likeCnt"+cmIdx).html(r[0]);
				$("#cm-like"+cmIdx).html(r[1]);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	function likeDelete(cmIdx) {
		$.ajax({
			url : "${ctp}/community/likeDelete",
			type : "post",
			data : {cmIdx : cmIdx},
			success : function(res) {
				let r = res.split("%");
				$("#cm-likeCnt"+cmIdx).html(r[0]);
				$("#cm-like"+cmIdx).html(r[1]);
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
		<p></p>
		<div class="community">
			<span class="cm-menu">
				<span class="cb mb-4">
					<span class="communityBtn cb-active">
			            <img src="https://img.icons8.com/ios-filled/50/ffffff/chat.png" alt="Chat Icon"/>
			        </span>
			        <span class="cb-text-active"><b>인겜토리</b></span>
				</span>
				<span class="cn">
			        <span class="communityBtn">
			            <img src="https://img.icons8.com/ios-filled/50/b2bdce/news.png" alt="News Icon"/>
			        </span>
			        <span class="cb-text"><b>뉴스</b></span>
				</span>
			</span>
			<div style="width:100%;">
				<div class="c-buttons">
					<span class="c-button">팔로우</span>
					<span class="c-button" onclick="location.href='${ctp}/community/recent';">최신</span>
					<span class="c-button">리뷰</span>
					<span class="c-button" onclick="location.href='${ctp}/community/info';">소식/정보</span>
					<span class="c-button" onclick="location.href='${ctp}/community/sale';">세일</span>
					<c:if test="${sMid != null}"><span class="c-button c-button-active" onclick="location.href='${ctp}/community/my';">내글</span></c:if>
				</div>
				<c:forEach var="cmVO" items="${cmVOS}">
					<div class="cm-box">
						<div style="display:flex; align-items: center;">
							<img src="${ctp}/member/${cmVO.memImg}" alt="프로필" class="text-pic">
							<div>
								<div style="font-size:12px;">${cmVO.title}</div>
								<div style="font-weight:bold;">${cmVO.nickname}</div>
								<div>
									<c:if test="${cmVO.part == '소식/정보'}"><span class="badge badge-secondary">소식/정보</span>&nbsp;</c:if>
									<c:if test="${cmVO.part == '자유'}"><span class="badge badge-secondary">자유글</span>&nbsp;</c:if>
									<c:if test="${cmVO.part == '세일'}"><span class="badge badge-secondary">세일정보</span>&nbsp;</c:if>
									<c:if test="${cmVO.part != '자유'}">
									<span style="color:#b2bdce; font-size:12px;">
										<i class="fa-solid fa-gamepad fa-xs" style="color: #b2bdce;"></i>&nbsp;
										${cmVO.gameTitle}
									</span>
									</c:if>
								</div>
							</div>
						</div>
						<div class="community-content">
							<div class="cm-content ${cmVO.longContent == 1 ? 'moreGra' : ''}" id="cmContent${cmVO.cmIdx}">${cmVO.cmContent}</div>
							<c:if test="${cmVO.longContent == 1}"><div onclick="showAllContent(${cmVO.cmIdx})" id="moreBtn${cmVO.cmIdx}" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2">
								<c:if test="${cmVO.hour_diff < 1}">${cmVO.min_diff}분 전</c:if>
								<c:if test="${cmVO.hour_diff < 24 && cmVO.hour_diff >= 1}">${cmVO.hour_diff}시간 전</c:if>
								<c:if test="${cmVO.hour_diff >= 24}">${fn:substring(cmVO.cmDate, 0, 10)}</c:if>
							</div>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="cm-likeCnt${cmVO.cmIdx}">이 글을 ${cmVO.likeCnt}명이 좋아합니다.</span></div>
						</div>
						<c:if test="${sMid != null}">
							<hr/>
							<div class="community-footer">
								<span id="cm-like${cmVO.cmIdx}">
									<c:if test="${cmVO.likeSW == 0}"><span onclick="likeAdd(${cmVO.cmIdx})"><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요</span></c:if>
									<c:if test="${cmVO.likeSW == 1}"><span style="color:#00c722;" onclick="likeDelete(${cmVO.cmIdx})"><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요</span></c:if>
								</span>
								<span><i class="fa-solid fa-comment-dots"></i>&nbsp;&nbsp;댓글</span>
							</div>
							<hr/>
							<div style="display:flex; align-items: center; justify-content: center;">
								<img src="${ctp}/member/${sMemImg}" alt="프로필" class="text-pic">
								<div class="text-input">댓글을 작성해 보세요.</div>
							</div>
						</c:if>
					</div>
				</c:forEach>
				<span id="root"></span>
			</div>
		</div>
	</div>
	<p></p>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>