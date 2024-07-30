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
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let isFetching = false;
	let totPage = 1;
	let mid = '${sMid}';
    let currentRating = 0;
	let currentGameIdx = null;

	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		// 무한스크롤
		function rootData() {
			isFetching = true;
			
			$.ajax({
				url : "${ctp}/review/rootData",
				type : "post",
				data : {page : ${page}+totPage},
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
	    
        // 검색창 엔터로 검색
         let searchInput = document.getElementById('search');

	    if (searchInput) {
	        searchInput.addEventListener('keyup', function(e) {
	            if (e.key === 'Enter') {
	        		let viewpart = $("#viewpart").val();
	        		let search = $("#search").val();
	        		location.href = "${ctp}/review?page=${page}&viewpart="+viewpart+"&search="+search;
	            }
	        });
	    }
	    
	    if(document.getElementById('total-games')) {
		    const ratingCounts = [${rating1},${rating2},${rating3},${rating4},${rating5}];
		    const totalGames = ${totRatingCnt};
		    ratingChart(ratingCounts,totalGames);
	    }
	    
	 	// 이벤트 델리게이션을 사용하여 동적으로 추가된 별점 및 상태에 이벤트 등록
	    document.addEventListener('mouseover', handleMouseOver);
	    document.addEventListener('mouseout', handleMouseOut);
	    document.addEventListener('click', handleClick);

	    $(window).on('load', function() {
	        removeLoadingPage();
	    });

	    function handleMouseOver(e) {
	        if (e.target.classList.contains('review-star-add')) {
	            const star = e.target;
	            const index = parseInt(star.getAttribute('data-index'));
	            const container = star.closest('.cm-box');
	            const stars = container.querySelectorAll('.review-star-add');
	            highlightStars(stars, index);
	            const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	            updateTemporaryReviewText(gameIdx, index);
	        }
	    }

	    function handleMouseOut(e) {
	        if (e.target.classList.contains('review-star-add')) {
	            const star = e.target;
	            const container = star.closest('.cm-box');
	            const stars = container.querySelectorAll('.review-star-add');
	            const currentRating = parseInt(container.getAttribute('data-rating')) || 0;
	            resetStars(stars, currentRating);
	            const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	            updateReviewText(gameIdx, currentRating);
	        }
	    }

	    function handleClick(e) {
	        if (e.target.classList.contains('review-star-add')) {
	            handleStarClick(e);
	        } else if (e.target.id === 'zero-rating-area1' || e.target.id === 'zero-rating-area2') {
	            handleZeroRatingClick(e);
	        } else if (e.target.classList.contains('state-button') || e.target.closest('.state-button')) {
	            handleStateButtonClick(e);
	        }
	    }

	    function handleStarClick(e) {
	        if (mid == '') {
	            showPopupLogin();
	            return false;
	        }
	        const star = e.target;
	        const index = parseInt(star.getAttribute('data-index'));
	        const container = star.closest('.cm-box');
	        const stars = container.querySelectorAll('.review-star-add');
	        let currentRating = index;
	        container.setAttribute('data-rating', currentRating);
	        lockStars(stars, currentRating);
	        const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	        updateReviewText(gameIdx, currentRating);
	        $("#moreReviewInput" + gameIdx).show();

	        const stateButton = container.querySelector('.state-button.selected');
	        const state = stateButton ? stateButton.getAttribute('data-state') || 'none' : 'none';
	        inputReview(gameIdx, currentRating, state);
	    }

	    function handleZeroRatingClick(e) {
	        if (mid == '') {
	            showPopupLogin();
	            return false;
	        }
	        const zeroRatingArea = e.target;
	        const container = zeroRatingArea.closest('.cm-box');
	        const stars = container.querySelectorAll('.review-star-add');
	        let currentRating = 0;
	        container.setAttribute('data-rating', currentRating);
	        lockStars(stars, currentRating);
	        const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	        updateReviewText(gameIdx, currentRating);
	        $("#moreReviewInput" + gameIdx).hide();

	        const stateButton = container.querySelector('.state-button.selected');
	        const state = stateButton ? stateButton.getAttribute('data-state') || 'none' : 'none';
	        if (currentRating == 0 && state == 'none') deleteReview(gameIdx);
	        else inputReview(gameIdx, currentRating, state);
	    }

	    function handleStateButtonClick(e) {
	        const button = e.target.closest('.state-button');
	        const container = button.closest('.cm-box');
	        const buttons = container.querySelectorAll('.state-button');
	        const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	        const stateIcon = container.querySelector('#stateIcon');
	        const currentRating = parseInt(container.getAttribute('data-rating')) || 0;

	        buttons.forEach(btn => {
	            if (btn !== button) {
	                btn.classList.remove('selected');
	            }
	        });

	        const isSelected = button.classList.toggle('selected');
	        if (isSelected) {
	            const state = button.getAttribute('data-state');
	            switch (state) {
	                case 'play':
	                    stateIcon.src = '${ctp}/images/playIcon.svg';
	                    $("#statetext" + gameIdx).html("<font color=\"#fff\">하고있어요</font>");
	                    break;
	                case 'done':
	                    stateIcon.src = '${ctp}/images/doneIcon.png';
	                    $("#statetext" + gameIdx).html("<font color=\"#fff\">다했어요</font>");
	                    break;
	                case 'stop':
	                    stateIcon.src = '${ctp}/images/stopIcon.svg';
	                    $("#statetext" + gameIdx).html("<font color=\"#fff\">그만뒀어요</font>");
	                    break;
	                case 'folder':
	                    stateIcon.src = '${ctp}/images/folderIcon.svg';
	                    $("#statetext" + gameIdx).html("<font color=\"#fff\">모셔놨어요</font>");
	                    break;
	                case 'pin':
	                    stateIcon.src = '${ctp}/images/pinIcon.svg';
	                    $("#statetext" + gameIdx).html("<font color=\"#fff\">관심있어요</font>");
	                    break;
	                default:
	                    stateIcon.src = '${ctp}/images/noneIcon.svg';
	                    $("#statetext" + gameIdx).html("현재 게임 상태를 선택해주세요");
	                    break;
	            }
	        } else {
	            stateIcon.src = '${ctp}/images/noneIcon.svg';
	            $("#statetext" + gameIdx).html("현재 게임 상태를 선택해주세요");
	        }

	        const stateButton = container.querySelector('.state-button.selected');
	        const state = stateButton ? stateButton.getAttribute('data-state') || 'none' : 'none';
	        if (currentRating == 0 && state == 'none') deleteReview(gameIdx);
	        else inputReview(gameIdx, currentRating, state); // 별점 저장
	    }
	    
	    // 로딩페이지 제거 함수
	    function removeLoadingPage() {
	        $('.mask').hide();
	        $('html').css('overflow', 'auto');
	    }
	
	 	// 별점 색 채우기 함수
	    function highlightStars(stars, index) {
	        stars.forEach(star => {
	            const starIndex = parseInt(star.getAttribute('data-index'));
	            if (starIndex <= index) {
	                star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
	            } else {
	                star.style.backgroundImage = 'url("${ctp}/images/star.png")';
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
	                star.style.backgroundImage = 'url("${ctp}/images/star.png")';
	            }
	        });
	    }
	
	    function lockStars(stars, index) {
	        stars.forEach(star => {
	            const starIndex = parseInt(star.getAttribute('data-index'));
	            if (index === 0) {
	                star.style.backgroundImage = 'url("${ctp}/images/star.png")';
	            } else {
	                if (starIndex <= index) {
	                    star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
	                } else {
	                    star.style.backgroundImage = 'url("${ctp}/images/star.png")';
	                }
	            }
	        });
	    }
	
	    function updateTemporaryReviewText(gameIdx, rating) {
	        const reviewText = {
	            1: "😰 끔찍해요!",
	            2: "🤨 별로예요",
	            3: "🙂 괜찮아요",
	            4: "😊 맘에 들어요!",
	            5: "😍 완전 최고!"
	        };
	        if (rating >= 1 && rating <= 5) {
	            $("#startext"+gameIdx).html(reviewText[rating]);
	        } else {
	            $("#startext"+gameIdx).html("");
	        }
	    }
	
	    function updateReviewText(gameIdx, rating) {
	        const reviewText = {
	            0: "이 게임에 별점을 주세요!",
	            1: "<font color=\"#fff\">😰 끔찍해요!</font>",
	            2: "<font color=\"#fff\">🤨 별로예요</font>",
	            3: "<font color=\"#fff\">🙂 괜찮아요</font>",
	            4: "<font color=\"#fff\">😊 맘에 들어요!</font>",
	            5: "<font color=\"#fff\">😍 완전 최고!</font>"
	        };
	        $("#startext"+gameIdx).html(reviewText[rating]);
	    }
	
	    // 리뷰 추가 및 수정
	    function inputReview(gameIdx, rating, state) {
	    	if(state == null) state = 'none';
	    	
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
	});

	function showPopupReviewAllAdd(gameIdx, gameTitle, gameImg) {
    	const popup = document.querySelector('#popup-add');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
        
		const cmBox = document.querySelector('.cm-box[data-game-idx="'+gameIdx+'"]');
		if (cmBox) {
			if(gameImg.indexOf('http') == -1) {
				document.getElementById('gameImgPopup').innerHTML = '<img src="${ctp}/game/'+gameImg+'" width="50px" height="50px" style="border-radius: 8px; object-fit:cover;">';
			}
			else {
				document.getElementById('gameImgPopup').innerHTML = '<img src="'+gameImg+'" width="50px" height="50px" style="border-radius: 8px; object-fit:cover;">';
			}
			
			document.getElementById('gameTitlePopup').innerHTML = '<font color="#fff"><b>'+gameTitle+'</b></font>';
			
			// 별점 구하기
		    const starElements = cmBox.querySelectorAll('.review-star-add');
		    const filledStars = Array.from(starElements).filter(star => {
		        return star.style.backgroundImage.includes('/javaclassS4/images/starpull.png');
		    });
		    
		    let starText = '';
		    
		    for(let i=0; i<(filledStars.length/2); i++) {
		    	starText += '<img src="${ctp}/images/starpull.png" width="40px" height="40px">&nbsp;';
		    }
		    for(let i=0; i<5-(filledStars.length/2); i++) {
		    	starText += '<img src="${ctp}/images/star2.png" width="40px" height="40px">&nbsp;';
		    }
		
		    const starCountElement = document.getElementById('popupstars-count');
		    starCountElement.innerHTML = starText;
		    
		    // 상태 구하기
		    const stateElement = cmBox.querySelector('.state-button.selected');
		    const state = stateElement ? stateElement.getAttribute('data-state') || 'none' : 'none';
		    
		    let stateText = '';
		    if(state == 'play') stateText = '<img src="${ctp}/images/playIcon.svg">&nbsp;&nbsp;<font color="#fff"><b>하고있어요</b></font>';
		    else if(state == 'done') stateText = '<img src="${ctp}/images/doneIcon.png">&nbsp;&nbsp;<font color="#fff"><b>다했어요</b></font>';
		    else if(state == 'stop') stateText = '<img src="${ctp}/images/stopIcon.svg">&nbsp;&nbsp;<font color="#fff"><b>그만뒀어요</b></font>';
		    else if(state == 'folder') stateText = '<img src="${ctp}/images/folderIcon.svg">&nbsp;&nbsp;<font color="#fff"><b>모셔놨어요</b></font>';
		    else if(state == 'pin') stateText = '<img src="${ctp}/images/pinIcon.svg">&nbsp;&nbsp;<font color="#fff"><b>관심있어요</b></font>';
		    else stateText = '<img src="${ctp}/images/noneIcon.svg">&nbsp;&nbsp;<font color="#fff"><b>상태없음</b></font>';
		    document.getElementById('popupstars-state').innerHTML = stateText;
		    
		    document.getElementById('gameIdx').value = gameIdx;
		    document.getElementById('rating').value = filledStars.length/2;
		    document.getElementById('state').value = state;
		}
    }
	
	function reviewMoreInput() {
		let content = $('#summernote').summernote('code').trim();
		if(content.indexOf('<p>') == -1) content = '<p>'+content+'</p>';
        let gameIdx = $('#gameIdx').val();
        let rating = $('#rating').val();
        let state = $('#state').val();

        if (content == '' || content == '<p><br></p>') {
            alert("글 내용을 입력하세요!");
            $('#summernote2').focus();
            return false;
        }
        
        $.ajax({
        	url : "${ctp}/review/reviewMoreInput",
        	type : "post",
        	data : {cmContent: content, cmGameIdx: gameIdx, rating : rating, state : state, mid : mid},
        	success : function() {
        		closePopup('add');
			},
			error : function() {
				alert("전송오류!");
			}
        });
	}
	
 	function toggleContentMenu(gameIdx) {
 	   	const elements = document.querySelectorAll('[id^="contentMenu"]');
 	   	const otherElements = Array.from(elements).filter(element => element.id !== "contentMenu" + gameIdx); // 필터 적용해 조건부로 가져오기
 	    let dropdown = document.getElementById("contentMenu"+gameIdx);
 	   	
    	if(mid == '') {
    		showPopupLogin();
    		return false;
    	}
 	    
 	   otherElements.forEach(element => {
 	   		element.style.display = "none";
 		});
 	    
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	        
 	       // 바깥 부분 클릭 시 메뉴 닫기
 	       document.addEventListener('click', function outsideClickListener(event) {
 	          // 클릭된 요소가 메뉴나 메뉴 아이콘이 아니면 메뉴 닫기
 	          if (!dropdown.contains(event.target) && !event.target.matches('#stateIcon')) {
 	            dropdown.style.display = "none";
 	            document.removeEventListener('click', outsideClickListener);
 	          }
 	       });
 	    }
 	}
 	
 	function ratingChart(ratingCounts,totalGames) {
	    // 평균 별점 계산
	    let averageRating = 0.0;
	    const totalPoints = ratingCounts.reduce((sum, count, index) => sum + (count * (index + 1)), 0);
	    if(ratingCounts.length > 0 && totalGames > 0) averageRating = (totalPoints / totalGames).toFixed(2); // 소수점 두자리까지

	    if (isNaN(averageRating)) {
	        averageRating = 0.0;
	    }
	    
	    // HTML 요소 업데이트
	    document.getElementById('total-games').textContent = totalGames;
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
 	
 	function partchange() {
		let viewpart = $("#viewpart").val();
		let search = $("#search").val();
		location.href = "${ctp}/review?page=${page}&viewpart="+viewpart+"&search="+search;
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
			<div style="flex-grow:1">
				<div style="display: flex; align-items: center; justify-content: space-between;">
					<div id="searchlist" style="display: flex; align-items: center;">
						<i class="fa-solid fa-magnifying-glass mr-2"></i>
						<input type="text" name="search" id="search" value="${search}" placeholder="검색할 단어를 입력하세요" class="forminput mr-2" />
					</div>
					<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()" style="flex-shrink: 0">
						<option value="manyReview" ${viewpart == 'manyReview' ? 'selected' : ''}>많이 평가한순</option>
						<option value="showDate desc" ${viewpart == 'showDate desc' ? 'selected' : ''}>최신 발매일순</option>
						<option value="invenscore desc" ${viewpart == 'invenscore desc' ? 'selected' : ''}>인겜스코어 높은순</option>
						<option value="metascore desc" ${viewpart == 'metascore desc' ? 'selected' : ''}>메타스코어 높은순</option>
						<option value="random" ${viewpart == 'random' ? 'selected' : ''}>랜덤 게임들</option>
					</select>
				</div>
				<p><br/></p>
				<c:forEach var="vo" items="${vos}">
					<div class="cm-box" style="padding:0" data-game-idx="${vo.gameIdx}" data-rating="${vo.rating}">
						<div class="review-viewflex">
							<div>
								<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" class="review-game-i"></c:if>
								<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" class="review-game-i"></c:if>
							</div>
							<div class="review-add">
								<div style="display: flex; justify-content: space-between; align-items: center;">
									<div class="review-add-title" onclick="location.href='${ctp}/gameview/${vo.gameIdx}';">${vo.gameTitle}</div>
									<div style="position: relative; cursor: pointer;">
										<img id="stateIcon" src="${ctp}/images/${vo.state == null ? 'none' : vo.state}Icon.svg" onclick="toggleContentMenu(${vo.gameIdx})">
										<div id="contentMenu${vo.gameIdx}" class="review-menu">
								        	<div class="review-menu-star">
												<div id="zero-rating-area1" style="position: absolute; left: 0px; width: 20px; height: 24px; cursor: pointer;"></div>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="1"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="2"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="3"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="4"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="5"></span>
											</div>
											<div id="startext${vo.gameIdx}">이 게임에 별점을 주세요!</div>
											<div id="moreReviewInput${vo.gameIdx}" style="display: ${vo.rating != 0 ? 'block' : 'none'}" onclick="showPopupReviewAllAdd(${vo.gameIdx}, '${vo.gameTitle}', '${vo.gameImg}')"><i class="fa-solid fa-pencil"></i>&nbsp;&nbsp;평가도 남겨보세요</div>
											<hr/>
											<div class="state-buttons" style="display: flex;">
												<div class="state-button ${vo.state == 'play' ? 'selected' : ''}" data-state="play">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Play.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button ${vo.state == 'done' ? 'selected' : ''}" data-state="done">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Check.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button ${vo.state == 'stop' ? 'selected' : ''}" data-state="stop">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Cancel.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button ${vo.state == 'folder' ? 'selected' : ''}" data-state="folder">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Folder.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button ${vo.state == 'pin' ? 'selected' : ''}" data-state="pin">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Pin.svg&quot;);"></span>
													</div>
												</div>
											</div>
											<div id="statetext${vo.gameIdx}">
												<c:if test="${vo.state == 'play'}"><font color="#fff">하고있어요</font></c:if>
												<c:if test="${vo.state == 'done'}"><font color="#fff">다했어요</font></c:if>
												<c:if test="${vo.state == 'stop'}"><font color="#fff">그만뒀어요</font></c:if>
												<c:if test="${vo.state == 'folder'}"><font color="#fff">모셔놨어요</font></c:if>
												<c:if test="${vo.state == 'pin'}"><font color="#fff">관심있어요</font></c:if>
												<c:if test="${vo.state == null || vo.state == 'none'}">현재 게임 상태를 선택해주세요</c:if>
											</div>
								    	</div>
									</div>
								</div>
								<div style="margin-bottom: 30px;">${fn:substring(vo.showDate,0,4)}</div>
								<div style="display: flex; position: relative;">
									<div id="zero-rating-area2" style="position: absolute; left: -20px; width: 20px; height: 40px; cursor: pointer;"></div>
									<span class="review-star-add mr-1" data-index="1"></span>
									<span class="review-star-add mr-1" data-index="2"></span>
									<span class="review-star-add mr-1" data-index="3"></span>
									<span class="review-star-add mr-1" data-index="4"></span>
									<span class="review-star-add mr-1" data-index="5"></span>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
				<div id="root"></div>
			</div>
			<c:if test="${sMid != null}">
				<div class="userReview">
					<div class="chart-container">
				        <p style="color:#fff">${sNickname}님은 총 <span id="total-games">97</span>개의 게임을 평가했습니다.</p>
				        <p>평균 별점 <span class="average-rating" id="average-rating">3.81</span></p>
				        <div class="chart" id="chart">
				            <div class="bar" data-rating="1"></div>
				            <div class="bar" data-rating="2"></div>
				            <div class="bar" data-rating="3"></div>
				            <div class="bar" data-rating="4"></div>
				            <div class="bar" data-rating="5"></div>
				        </div>
				        <button class="my-games-btn mt-3">내 게임</button>
				    </div>
				</div>
			</c:if>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-add" class="hide">
  <div class="popup-add-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">평가 등록</div>
    		<div style="cursor:pointer;" onclick="closePopup('add')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-add-main" style="text-align: left;">
			<table class="table table-borderless" style="color:#fff">
					<tr>
						<th><span id="gameImgPopup"></span></th>
						<td><span style="font-size:20px;" id="gameTitlePopup"></span></td>
					</tr>
					<tr>
						<th>별점</th>
						<td><div id="popupstars-count"></div></td>
					</tr>
					<tr>
						<th>상태</th>
						<td><div id="popupstars-state"></div></td>
					</tr>
					<tr>
						<th>평가</th>
						<td><textarea id="summernote" name="content"></textarea></td>
					</tr>
					
			</table>
			<div class="text-right mt-3"><button class="post-button" onclick="reviewMoreInput()">게시하기</button></div>
			<input type="hidden" id="rating" name="rating" />
			<input type="hidden" id="state" name="state" />
			<input type="hidden" id="gameIdx" name="gameIdx" />

			<!-- Summernote JS -->
			<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
		    
		    <script>
			// 썸머노트 기본설정
			$(document).ready(function() {
			    let fontList = ['SUITE-Regular'];
			    $('#summernote').summernote({
			        lang: 'ko-KR',
			        tabsize: 2,
			        height: 200,
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
			</script>
		</div>
  </div>
</div>
</body>
</html>