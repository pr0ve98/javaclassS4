<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${vo.gameTitle} | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/wordcloud2.js/1.0.6/wordcloud2.min.js"></script>
<script>
	'use strict';
	
	document.addEventListener('DOMContentLoaded', function() {
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
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main style="padding: 0 20px;">
	<div class="mask">
	  <img class="loadingImg" src='${ctp}/images/loding.gif'>
	</div>
	<div class="container">
		<div class="view-wrap">
			<div class="gamebackground">
				<div class="backgroud-cover">
					<div class="background-b"></div>
				</div>
				<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" class="backImg"></c:if>
				<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" class="backImg"></c:if>
				<div class="game-title-info">
					<div class="platform-info">
						<c:if test="${fn:indexOf(vo.platform, 'PC') != -1}"><span class="platform-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/LogoPC.svg&quot;);"></span></c:if>
						<c:if test="${fn:indexOf(vo.platform, 'Switch') != -1}"><span class="platform-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/LogoNintendo.svg&quot;);"></span></c:if>
						<c:if test="${fn:indexOf(vo.platform, 'PS') != -1}"><span class="platform-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/LogoPlaystation.svg&quot;);"></span></c:if>
						<c:if test="${fn:indexOf(vo.platform, 'X') != -1}"><span class="platform-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/LogoXbox.svg&quot;);"></span></c:if>
						<c:if test="${fn:indexOf(vo.platform, 'iOS') != -1}"><span class="platform-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/LogoApple.svg&quot;);"></span></c:if>
						<c:if test="${fn:indexOf(vo.platform, 'Android') != -1}"><span class="platform-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/LogoAndroid.svg&quot;);"></span></c:if>
					</div>
					<div class="game-title-view">${vo.gameTitle}</div>
					<div>${vo.gameSubTitle}</div>
					<hr/>
					<div class="score-info">
						<div>
							<div><img src="${ctp}/images/invenscore.png"></div>
							<div class="score">
								<c:if test="${vo.invenscore == null || vo.invenscore == 0}">평점 부족</c:if>
								<c:if test="${vo.invenscore != null && vo.invenscore != 0}">${vo.invenscore}</c:if>
							</div>
						</div>
						<c:if test="${vo.metascore != null && vo.metascore != 0}"><div>
							<div><img src="https://djf7qc4xvps5h.cloudfront.net/resource/minimap/illust/LogoFullMetacriticDark.svg" alt="" class="score-logo"></div>
							<div class="score">${vo.metascore}</div>
						</div></c:if>
						<c:if test="${vo.steamscore != null && vo.steamscore != '' && vo.steamscore != '사용자 평가 없음'}"><div>
							<div><img src="https://djf7qc4xvps5h.cloudfront.net/resource/minimap/illust/LogoFullSteamDark.svg" alt="" class="score-logo"></div>
							<div class="score">${vo.steamscore}</div>
						</div></c:if>
					</div>
				</div>
			</div>
		</div>
		<div class="tabs">
	        <div class="tab-container">
	            <div class="tab active">상세정보</div>
	            <div class="tab">리뷰 60</div>
	            <div class="tab">일지 80</div>
	            <div class="tab">소식/정보 11</div>
	        </div>
	        <button class="editplz-button">정보수정요청</button>
	    </div>
	    <div class="gameviewContent">
	    	<div class="gvc-width">
	    		<h3>게임 리뷰</h3>
	    		<div class="gvc-box">
			  		<div class="chart-gvc">
				        <p>평균 별점 <span class="average-rating" id="average-rating">평가 부족</span></p>
				        <div id="total-games"></div>
				        <div class="chart" id="chart" style="height:100px; margin: 0 0 40px;">
				            <div class="bar" data-rating="1"></div>
				            <div class="bar" data-rating="2"></div>
				            <div class="bar" data-rating="3"></div>
				            <div class="bar" data-rating="4"></div>
				            <div class="bar" data-rating="5"></div>
				        </div>
				    </div>
				    <hr/>
		    		<div class="reviewTotalContainer">
		    			<div style="width: 50%;">
					        <div class="gvc-title"><i class="fa-solid fa-thumbs-up fa-sm"></i>&nbsp;긍정리뷰 키워드</div>
				    		<div class="word-cloud" id="positive-word-cloud"><img src="${ctp}/images/noreview.png" width="100%" height="100%" style="object-fit:cover;"></div>
		    			</div>
		    			<div style="width: 50%;">
					        <div class="gvc-title"><i class="fa-solid fa-thumbs-down fa-sm"></i>&nbsp;부정리뷰 키워드</div>
					        <div class="word-cloud" id="negative-word-cloud"><img src="${ctp}/images/noreview.png" width="100%" height="100%" style="object-fit:cover;"></div>
		    			</div>
			        </div>
		        </div>
		        <script>
			        document.addEventListener("DOMContentLoaded", function() {
			            // 서버에서 전달된 JSON 데이터를 자바스크립트 변수로 할당
			            let positiveTest = ${positiveKeywordsJson};
			            let negativeTest = ${negativeKeywordsJson};
			            if (positiveTest != '' && negativeTest != '') {
			                var positiveKeywords = JSON.parse('${positiveKeywordsJson}');
			                var negativeKeywords = JSON.parse('${negativeKeywordsJson}');
	
			                function generateWordCloud(elementId, keywords, color) {
			                    var entries = [];
			                    for (var key in keywords) {
			                        if (keywords.hasOwnProperty(key)) {
			                            entries.push([key, keywords[key]]);
			                        }
			                    }
	
			                    // 크기 순으로 정렬하여 가장 큰 단어가 중심에 오도록
			                    entries.sort(function(a, b) { return b[1] - a[1]; });
	
			                    WordCloud(document.getElementById(elementId), { 
			                        list: entries,
			                        gridSize: Math.round(16 * $('#' + elementId).width() / 180), // 그리드 크기 반응형 조정
			                        weightFactor: function(size) {
			                        	return Math.log(size + 1) * 10 * ($('#' + elementId).width() / 100); // 글자 크기 조정
			                        },
			                        fontFamily: 'SUITE-Regular',
			                        color: color,
			                        backgroundColor: '#32373d',
			                        rotateRatio: 0, // 글자가 항상 가로로 정렬되도록 설정
			                        shape: 'circle', // 중앙에 집중되도록 설정
			                        clearCanvas: true, // 이전 상태를 지우고 새로 그리도록 설정
			                        drawOutOfBound: false, // 경계 밖으로 그리지 않도록 설정
			                    });
			                }
	
			                if (positiveTest && Object.keys(positiveTest).length > 0) {
			                    generateWordCloud('positive-word-cloud', positiveTest, '#48a9ff');
			                }

			                if (negativeTest && Object.keys(negativeTest).length > 0) {
			                    generateWordCloud('negative-word-cloud', negativeTest, '#ff5959');
			                }
			            }
			            
		                const ratingCounts = [${rating1},${rating2},${rating3},${rating4},${rating5}];
		                const totalGames = ${totRatingCnt};
			                
			            if(totalGames != ''){    
			                // 평균 별점 계산
			                let averageRating = 0.0;
			                const totalPoints = ratingCounts.reduce((sum, count, index) => sum + (count * (index + 1)), 0);
			                if (ratingCounts.length > 0 && totalGames > 0) averageRating = (totalPoints / totalGames).toFixed(1); // 소수점 두자리까지
	
			                if (isNaN(averageRating)) {
			                    averageRating = 0.0;
			                }
			                
			                // HTML 요소 업데이트
			                document.getElementById('total-games').textContent = '(' + totalGames + '명 평가함)';
			                document.getElementById('average-rating').textContent = averageRating;
	
			                // 차트 업데이트
			                const chart = document.getElementById('chart');
			                const bars = chart.getElementsByClassName('bar');
			                for (let i = 0; i < bars.length; i++) {
			                    const bar = bars[i];
			                    const count = ratingCounts[i];
			                    let height = (count / totalGames) * 100;
			                    
			                    // 평가한 게임이 하나도 없을 때 막대 비우기
			                    if (totalGames == 0) {
			                        height = 0;
			                    }
			                    
			                    bar.style.height = height + '%';
			                    bar.setAttribute('data-count', count); // 데이터 개수를 속성으로 추가
			                }
			            }
			        });
			    </script>
	    		<h3>일지</h3>
	    		<h3>소식/정보</h3>
	    		<h3>게임 소개</h3>
	    		<div>${vo.gameInfo}</div>
	    	</div>
	    	<div style="flex-grow: 1">
	    		<div class="gvcontent-info">
	    			<h3>게임 정보</h3>
	    			<table class="table table-borderless" style="color:#b2bdce;">
	    				<tr>
		    				<th>개발사</th>
		    				<td>${vo.developer}</td>
	    				</tr>
	    				<tr>
		    				<th>플랫폼</th>
		    				<td>${vo.platform}</td>
	    				</tr>
	    				<tr>
		    				<th>발매일</th>
		    				<td>${vo.showDate}</td>
	    				</tr>
	    				<c:if test="${vo.steamPage != null && vo.steamPage != ''}">
		    				<tr>
			    				<th>링크</th>
			    				<td><a href="${vo.steamPage}" target="_blank"><i class="fa-solid fa-link fa-sm"></i>&nbsp;스팀페이지로 이동</a></td>
		    				</tr>
	    				</c:if>
	    			</table>
	    		</div>
	    	</div>
	    </div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>