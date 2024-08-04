<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<% pageContext.setAttribute("newLine", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width" />
<title>예판뉴스 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let isFetching = false;
	let totPage = 1;
	
	$(document).ready(function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		// 무한스크롤
		function rootData() {
			isFetching = true;
			
			$.ajax({
				url : "${ctp}/community/newsRootData",
				type : "post",
				data : {page : ${page}+totPage, part : 'sale'},
				success : function(res) {
					if(res) {
						isFetching = false;
						$("#root").append(res);
						removeLoadingPage();
					}
					else {
						isFetching = true;
					}
				},
				error : function() {
					alert("전송오류!");
					isFetching = false;
				}
			});
		}
		
		// 스크롤 이벤트
		const handleScroll = debounce(function() {
		    if (isFetching || totPage >= ${totPage}) {
		        return false;
		    }

		    const scrollPercentage = (window.scrollY + window.innerHeight) / document.documentElement.scrollHeight;
	        if (scrollPercentage > 0.9) { // 90% 지점에서 데이터를 불러오기
	            rootData();
	            totPage++;
	        }
		}, 50);
		
		$(window).on('scroll', handleScroll);
		
		
	    // 디바운스 함수
	    function debounce(func, wait) {
	        let timeout;
	        return function(...args) {
	            clearTimeout(timeout);
	            timeout = setTimeout(() => func.apply(this, args), wait);
	        };
	    }
    });
	
    // 페이지 로드 로딩페이지 제거
    $(window).on('load', function() {
    	removeLoadingPage();
    });
    
    // 로딩페이지 제거 함수
    function removeLoadingPage() {
        $('.mask').hide();
        $('html').css('overflow', 'auto');
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
					<span class="communityBtn" onclick="location.href='${ctp}/community/recent';">
			            <img src="https://img.icons8.com/ios-filled/50/b2bdce/chat.png" alt="Chat Icon"/>
			        </span>
			        <span class="cb-text"><b>인겜토리</b></span>
				</span>
				<span class="cn">
			        <span class="communityBtn cb-active" onclick="location.href='${ctp}/news/newsRecent';">
			            <img src="https://img.icons8.com/ios-filled/50/ffffff/news.png" alt="News Icon"/>
			        </span>
			        <span class="cb-text-active"><b>뉴스</b></span>
				</span>
			</span>
			<div style="width:100%;">
				<div class="c-buttons">
					<span class="c-button" onclick="location.href='${ctp}/news/newsRecent';">뉴스</span>
					<span class="c-button" onclick="location.href='${ctp}/news/newsReport';">취재</span>
					<span class="c-button c-button-active" onclick="location.href='${ctp}/news/newsSale';">예판</span>
				</div>
				<c:if test="${sLevel == 1}">
					<div class="cm-box">
						<div style="display:flex; align-items: center; justify-content: center;">
							<img src="${ctp}/member/${sMemImg}" alt="프로필" class="text-pic">
							<div class="text-input" onclick="location.href='${ctp}/news/newsInput?part=예판';">작성할 뉴스가 있으신가요?</div>
						</div>
					</div>
				</c:if>
				<c:forEach var="cmVO" items="${cmVOS}">
					<div class="cm-box" id="cmbox${cmVO.cmIdx}">
						<div class="newsCmBox">
							<div>
								<c:if test="${fn:indexOf(cmVO.newsThumnail, 'http') == -1}"><img src="${ctp}/community/${cmVO.newsThumnail}" alt="뉴스썸네일" class="news-gameImg"></c:if>
	            				<c:if test="${fn:indexOf(cmVO.newsThumnail, 'http') != -1}"><img src="${cmVO.newsThumnail}" alt="뉴스썸네일" class="news-gameImg"></c:if>
							</div>
							<div>
								<div style="color:#00c722; font-weight: bold;">${cmVO.part}</div>
								<div class="game-title" style="cursor: pointer;" onclick="location.href='${ctp}/news/${cmVO.cmIdx}';">${cmVO.newsTitle}</div>
								<div style="color:#b2bdce; font-size:12px;" class="mt-2">
									<c:if test="${cmVO.hour_diff < 1}">${cmVO.min_diff}분 전</c:if>
									<c:if test="${cmVO.hour_diff < 24 && cmVO.hour_diff >= 1}">${cmVO.hour_diff}시간 전</c:if>
									<c:if test="${cmVO.hour_diff >= 24}">${fn:substring(cmVO.cmDate, 0, 10)}</c:if>
								</div>
								<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="cm-likeCnt${cmVO.cmIdx}">이 글을 ${cmVO.likeCnt}명이 좋아합니다.</span></div>
							</div>
						</div>
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