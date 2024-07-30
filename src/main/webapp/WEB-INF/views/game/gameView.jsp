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
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let initialContent = '';
	let currentRating = 0;
	let mid = '${sMid}';
	
	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		// 별점 및 상태 추가
        const stars = document.querySelectorAll('.review-star-add2');
        const zeroRatingArea2 = document.querySelector('#zero-rating-area2');
        
     	// 각 별에 마우스를 올렸을 때 별점과 임시 텍스트를 업데이트
        stars.forEach(star => {
            star.addEventListener('mouseover', function() {
                const index = parseInt(this.getAttribute('data-index'));
                highlightStars(stars, index);
            });
			
         	// 마우스가 별에서 벗어났을 때 별점과 텍스트를 초기화
            star.addEventListener('mouseout', function() {
                resetStars(stars, currentRating); // 별점을 현재 고정된 값으로 초기화
            });

         	// 별을 클릭했을 때 별점을 고정하고 텍스트를 업데이트
            star.addEventListener('click', function() {
            	if(mid == '') {
            		showPopupLogin();
            		return false;
            	}
                const index = parseInt(this.getAttribute('data-index'));
                currentRating = index;
                lockStars(stars, currentRating);
            });
        });
		
     	// 별점 삭제 영역을 클릭했을 때 별점을 0으로 설정하고 텍스트를 초기화
        const zeroRatingAreas = [zeroRatingArea2];
        zeroRatingAreas.forEach(zeroRatingArea => {
            zeroRatingArea.addEventListener('click', function() {
            	if(mid == '') {
            		showPopupLogin();
            		return false;
            	}
                currentRating = 0;
                lockStars(stars, currentRating);
            });
        });
        
     	// 상태 버튼
        const buttons = document.querySelectorAll('.state-button');

        buttons.forEach(button => {
            button.addEventListener('click', function() {
                // 모든 버튼에서 selected 클래스를 제거
                buttons.forEach(btn => {
                    if (btn !== button) {
                        btn.classList.remove('selected');
                    }
                });
                
                // 클릭된 버튼의 selected 클래스를 토글
                const isSelected = button.classList.toggle('selected');
            });
        });
	
	 	// 별점 색 채우기 함수
	    function highlightStars(stars, index) {
	        stars.forEach(star => {
	            const starIndex = parseInt(star.getAttribute('data-index'));
	            if (starIndex <= index) {
	                star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
	            } else {
	                star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
	            }
	        });
	    }
	
	 	// 별점 초기화 함수
	    function resetStars(stars, currentRating) {
	        stars.forEach(star => {
	            const starIndex = parseInt(star.getAttribute('data-index'));
	            if (currentRating && starIndex <= currentRating) {
	                star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
	            } else {
	                star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
	            }
	        });
	    }
	
	    function lockStars(stars, index) {
	        stars.forEach(star => {
	            const starIndex = parseInt(star.getAttribute('data-index'));
	            if (index === 0) {
	                star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
	            } else {
	                if (starIndex <= index) {
	                    star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
	                } else {
	                    star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
	                }
	            }
	        });
	    }
	
	    // 리뷰 추가 및 수정
	    function inputReview(gameIdx, rating, state) {
	        $.ajax({
	        	url : "${ctp}/review/reviewAdd",
	        	type : "post",
	        	data : {gameIdx:gameIdx, rating:rating, state:state, mid:mid},
	        	success : function(response) {
	        		let res = response.split("|");
	        		let ratingCount = [res[0], res[1], res[2], res[3], res[4]];
	        		ratingChart(ratingCount,res[5]);
				},
				error : function() {
					alert("전송오류!");
				}
	        });
	    }
	    
	    // 리뷰 삭제
	    function deleteReview(gameIdx) {
	        $.ajax({
	        	url : "${ctp}/review/reviewDelete",
	        	type : "post",
	        	data : {gameIdx:gameIdx, mid:mid},
	        	success : function(response) {
	        		let res = response.split("|");
	        		let ratingCount = [res[0], res[1], res[2], res[3], res[4]];
	        		ratingChart(ratingCount,res[5]);
				},
				error : function() {
					alert("전송오류!");
				}
	        });
	    }
        
        let fontList = ['SUITE-Regular'];
	    $('#summernote').summernote({
	        lang: 'ko-KR',
	        tabsize: 2,
	        height: 150,
	        toolbar: [
	            ['fontsize', ['fontsize']]
	        ],
	        fontNames: fontList,
	        fontNamesIgnoreCheck: fontList,
	        fontSizes: ['10', '11', '12', '14', '16', '18', '20', '22', '24'],
	        callbacks: {
	            onInit: function() {
	                // 초기 내용 저장
	                initialContent = $('#summernote').summernote('code');
	                $('.note-editable').css({
	                	'font-family':'SUITE-Regular',
	                	'color':'#b2bdce',
	                	'cursor':'text'
	                });
	            }
	        }
	    });
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
	
	function showPopupWrite(gameIdx, rating, state, cmContent) {
 		$('#summernote').summernote('code', '');
 		
 		const stars = document.querySelectorAll('.review-star-add2');
 		stars.forEach(star => {
        	star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
        });
 		
 		const buttons = document.querySelectorAll('.state-button');
        buttons.forEach(button => {
           buttons.forEach(btn => {
               if (btn !== button) {
                   btn.classList.remove('selected');
               }
           });
        });
        
 		if(gameIdx != null && gameIdx != ''){
 			stars.forEach(star => {
	            const starIndex = parseInt(star.getAttribute('data-index'));
	            if (rating === 0) {
	                star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
	            } else {
	                if (starIndex <= rating) {
	                    star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
	                } else {
	                    star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
	                }
	            }
	        });
 			
 			const element = document.querySelector('[data-state="'+state+'"]');
 		    if (element) {
 		        element.classList.add('selected');
 		    }
 		   $('#summernote').summernote('code', cmContent);
 		}
 		
    	const popup = document.querySelector('#popup-write');
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
	            <div class="tab">리뷰 ${totRatingCnt}</div>
	            <div class="tab">일지 80</div>
	            <div class="tab">소식/정보 11</div>
	        </div>
	        <button class="editplz-button">정보수정요청</button>
	    </div>
	    <div class="gameviewContent">
	    	<div class="gvc-width">
	    		<div style="display: flex; justify-content: space-between; align-items: center;">
	    			<h3>게임 리뷰</h3>
	    			<c:if test="${revVO == null}"><div class="editplz-button" onclick="showPopupWrite()">리뷰 작성</div></c:if>
	    			<c:if test="${revVO != null}"><div class="editplz-button" onclick="showPopupWrite(${revVO.revGameIdx}, ${revVO.rating}, '${revVO.state}', '${cmContent}')">리뷰 수정</div></c:if>
	    		</div>
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
			    <c:if test="${posiBest != null}">
		    		<div class="cm-box mt-3 mb-3" id="cmbox${posiBest.cmIdx}">
						<div style="display:flex;justify-content: space-between; align-items: center;">
							<div>
								<img src="${ctp}/member/${posiBest.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b>${posiBest.nickname}</b>님이 평가를 남기셨습니다
							</div>
							<div class="badge badge-success">긍정리뷰 BEST</div>					
						</div>
						<hr/>
						<div style="display:flex; margin: 0 20px; align-items:center; gap:5px; cursor: pointer;" onclick="location.href='${ctp}/gameview/${negaBest.gameIdx}';">
							<c:forEach begin="1" end="${posiBest.rating}">
								<img src="${ctp}/images/starpull.png" width="30px" height="30px" />
							</c:forEach>
							<c:forEach begin="1" end="${5-posiBest.rating}">
								<img src="${ctp}/images/star.png" width="30px" height="30px" />
							</c:forEach>
						</div>
						<div class="community-content" style="color:#fff;">
							<div class="cm-content ${posiBest.longContent == 1 ? 'moreGra' : ''}" id="cmContent${posiBest.cmIdx}">${posiBest.cmContent}</div>
							<c:if test="${posiBest.longContent == 1}"><div onclick="showAllContent(${posiBest.cmIdx})" id="moreBtn${posiBest.cmIdx}" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="cm-likeCnt${posiBest.cmIdx}">이 글을 ${posiBest.likeCnt}명이 좋아합니다.</span></div>
						</div>
					</div>
				</c:if>
				<c:if test="${negaBest != null}">
		    		<div class="cm-box mt-3 mb-3" id="cmbox${negaBest.cmIdx}">
						<div style="display:flex;justify-content: space-between; align-items: center;">
							<div>
								<img src="${ctp}/member/${negaBest.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b>${negaBest.nickname}</b>님이 평가를 남기셨습니다
							</div>
							<div class="badge badge-danger">비판리뷰 BEST</div>					
						</div>
						<hr/>
						<div style="display:flex; margin: 0 20px; align-items:center; gap:5px; cursor: pointer;" onclick="location.href='${ctp}/gameview/${negaBest.gameIdx}';">
							<c:forEach begin="1" end="${negaBest.rating}">
								<img src="${ctp}/images/starpull.png" width="30px" height="30px" />
							</c:forEach>
							<c:forEach begin="1" end="${5-negaBest.rating}">
								<img src="${ctp}/images/star.png" width="30px" height="30px" />
							</c:forEach>
						</div>
						<div class="community-content" style="color:#fff;">
							<div class="cm-content ${negaBest.longContent == 1 ? 'moreGra' : ''}" id="cmContent${negaBest.cmIdx}">${negaBest.cmContent}</div>
							<c:if test="${negaBest.longContent == 1}"><div onclick="showAllContent(${negaBest.cmIdx})" id="moreBtn${negaBest.cmIdx}" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="cm-likeCnt${negaBest.cmIdx}">이 글을 ${negaBest.likeCnt}명이 좋아합니다.</span></div>
						</div>
					</div>
				</c:if>
				<c:if test="${negaBest == null && posiBest == null}">
					<div style="margin: 100px 20px; text-align: center;">
						<div>보여드릴 리뷰가 없습니다.</div>
						<div>가장 먼저 이 게임의 리뷰를 남겨보세요.</div>
						<div class="editplz-button mt-2" style="margin: 0 auto; width: 30%;" onclick="showPopupWrite()">리뷰 작성</div>
					</div>
				</c:if>
				<hr/>
		    		<h3>일지</h3>
		    		<h3>소식/정보</h3>
		    		<h3>게임 소개</h3>
		    		<div>${vo.gameInfo}</div>
	    		</div>
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
<div id="popup-write" class="hide">
  <div class="popup-write-content scrollbar">
  		<div class="popup-write-header">
            <span class="header-text"></span>
    		<div style="cursor:pointer;" onclick="closePopup('write')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
        <div style="display: flex; align-items: center;">
        	<div style="width:100px; font-weight: bold; color: #fff; text-align: center;">게임</div>
        	<div style="flex-grow: 1">
        		<div style="display: flex; gap: 30px; align-items: center;">
        			<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" id="reviewWriteImg" width="50px" height="50px" style="border-radius: 8px; object-fit: cover;"/></c:if>
        			<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" id="reviewWriteImg" width="50px" height="50px" style="border-radius: 8px; object-fit: cover;"/></c:if>
        			<div id="reviewWriteTitle">${vo.gameTitle}</div>
        			<input type="hidden" id="writeGameIdx" name="writeGameIdx" value="${vo.gameIdx}" />
        		</div>
        	</div>
        </div>
        <hr/>
        <div style="display: flex; align-items: center;">
        	<div style="width:100px; font-weight: bold; color: #fff; text-align: center;">별점</div>
        	<div style="flex-grow: 1">
				<div style="display: flex; position: relative;">
					<div id="zero-rating-area2" style="position: absolute; left: -20px; width: 20px; height: 60px; cursor: pointer;"></div>
					<span class="review-star-add2 mr-1" data-index="1"></span>
					<span class="review-star-add2 mr-1" data-index="2"></span>
					<span class="review-star-add2 mr-1" data-index="3"></span>
					<span class="review-star-add2 mr-1" data-index="4"></span>
					<span class="review-star-add2 mr-1" data-index="5"></span>
				</div>
			</div>
		</div>
		<hr/>
		<div style="display: flex; align-items: center;">
        	<div style="width:100px; font-weight: bold; color: #fff; text-align: center;">상태</div>
        	<div style="flex-grow: 1">
				<div class="state-buttons" style="display: flex;">
					<div class="state-button ${gameVO.state == 'play' ? 'selected' : ''}" data-state="play" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Play.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${gameVO.state == 'done' ? 'selected' : ''}" data-state="done" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Check.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${gameVO.state == 'stop' ? 'selected' : ''}" data-state="stop" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Cancel.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${gameVO.state == 'folder' ? 'selected' : ''}" data-state="folder" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Folder.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${gameVO.state == 'pin' ? 'selected' : ''}" data-state="pin" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Pin.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<hr/>
        <textarea id="summernote" name="content"></textarea>
        <div class="footer text-right" style="display: block;">
            <button class="post-button" onclick="">게시하기</button>
        </div>
        <!-- Summernote JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
	    
	    <script>
	        // 게시하기 버튼 클릭 이벤트
	        $('.post-button').click(function(event) {
	            event.preventDefault();

		        let content = $('#summernote').summernote('code');
		        if(content.indexOf('<p>') == -1) content = '<p>'+content+'</p>';
		        let gameIdx = $('#writeGameIdx').val();
		        let rating = $('.review-star-add2').filter(function() {
	                return $(this).css('background-image').includes('/javaclassS4/images/starpull.png');
	            }).length;
		        let state = $('.state-button.selected').data('state') || 'none';

		        if(gameIdx == '') {
		        	return false;
		        }
		        
		        if (content == '' || content == '<p><br></p>') {
		            alert("글 내용을 입력하세요!");
		            $('#summernote').focus();
		            return false;
		        }

		        $.ajax({
		            url: "${ctp}/review/reviewInput",
		            type: "post",
		            data: {mid: mid, cmContent: content, cmGameIdx: gameIdx, rating : rating, state : state},
		            success: function(res) {
		            	location.reload();
		            },
		            error: function() {
		               alert("전송오류!");
		            }
		        });
	        });
		</script>
    </div>
</div>
</body>
</html>