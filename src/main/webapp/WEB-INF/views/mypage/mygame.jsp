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
<title>${member.nickname}님의 게임 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let isFetching = false;
	let totPage = 1;
	let editContent = '';
	let editCmIdx;
	let editCmGameIdx;
	let editGameTitle = '';
	let mid = '${sMid}';
	
	let initialContent = '';
	let initialImages = [];
	let currentImages = [];
	let editInitialImages = [];
	let editCurrentImages = [];
	
    let currentRating = 0;
	
	$(document).ready(function() {
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
	    
	    const gameContainers = document.querySelectorAll('.cm-box');
	
	    gameContainers.forEach(container => {
	        const stars = container.querySelectorAll('.review-star-add');
	        const zeroRatingArea1 = container.querySelector('#zero-rating-area1');
	        const zeroRatingArea2 = container.querySelector('#zero-rating-area2');
	        const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	        let currentRating = parseInt(container.getAttribute('data-rating')) || 0; // 초기 별점 값을 가져옴(이미 리뷰한 게임)
	
	        // 초기 별점 설정
	        if (currentRating) {
	            lockStars(stars, currentRating);
	            updateReviewText(gameIdx, currentRating); // 초기 별점에 맞게 텍스트 업데이트
	        }
	
	     	// 각 별에 마우스를 올렸을 때 별점과 임시 텍스트를 업데이트
	        stars.forEach(star => {
	            star.addEventListener('mouseover', function() {
	                const index = parseInt(this.getAttribute('data-index'));
	                highlightStars(stars, index);
	                updateTemporaryReviewText(gameIdx, index);
	            });
				
	         	// 마우스가 별에서 벗어났을 때 별점과 텍스트를 초기화
	            star.addEventListener('mouseout', function() {
	                resetStars(stars, currentRating); // 별점을 현재 고정된 값으로 초기화
	                updateReviewText(gameIdx, currentRating); // 별점 초기화 후 텍스트도 초기화
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
	                updateReviewText(gameIdx, currentRating);
	                $("#moreReviewInput"+gameIdx).show();
	                
	                const stateButton = container.querySelector('.state-button.selected');
	                const state = stateButton ? stateButton.getAttribute('data-state') || 'none' : 'none';
	               	inputReview(gameIdx, currentRating, state); // 별점 저장
	            });
	        });
			
	     	// 별점 삭제 영역을 클릭했을 때 별점을 0으로 설정하고 텍스트를 초기화
	        const zeroRatingAreas = [zeroRatingArea1];
	        zeroRatingAreas.forEach(zeroRatingArea => {
	            zeroRatingArea.addEventListener('click', function() {
	            	if(mid == '') {
	            		showPopupLogin();
	            		return false;
	            	}
	                currentRating = 0;
	                lockStars(stars, currentRating);
	                updateReviewText(gameIdx, currentRating);
	                $("#moreReviewInput"+gameIdx).hide();
	                
	                const stateButton = container.querySelector('.state-button.selected');
	                const state = stateButton ? stateButton.getAttribute('data-state') || 'none' : 'none';
	                if(currentRating == 0 && state == 'none') deleteReview(gameIdx);
	                else inputReview(gameIdx, currentRating, state); // 별점 저장
	            });
	        });
	        
	        const buttonss = container.querySelectorAll('.state-button');

	        buttonss.forEach(button => {
	            button.addEventListener('click', function() {
	                // 모든 버튼에서 selected 클래스를 제거
	                buttons.forEach(btn => {
	                    if (btn !== button) {
	                        btn.classList.remove('selected');
	                    }
	                });
	                
	                // 클릭된 버튼의 selected 클래스를 토글
	                const isSelected = button.classList.toggle('selected');
	                if (isSelected) {
	    	            const state = this.getAttribute('data-state');
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
	            });
	        });

	    });
	    
	    
	
    	
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
	        $.ajax({
	        	url : "${ctp}/review/reviewAdd",
	        	type : "post",
	        	data : {gameIdx:gameIdx, rating:rating, state:state, mid:mid},
	        	success : function(response) {
	        		let res = response.split("|");
	        		let ratingCount = [res[0], res[1], res[2], res[3], res[4]];
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
	
	function showPopupWrite() {
    	const popup = document.querySelector('#popup-write');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
    }
	
 	function reviewGameEdit(gameIdx, gameImg, gameTitle, rating, state, cmContent) {
 		currentRating = rating;
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		const buttons = document.querySelectorAll('.state-button');
		
 	    buttons.forEach(function(button) {
 	        button.classList.remove('selected');
 	    });
		
 		document.getElementById("writeGameIdx").value = gameIdx;
 		if(gameImg.indexOf('http') == -1) {
	 		document.getElementById("reviewWriteImg").src = "${ctp}/game/"+gameImg;
 		}
 		else document.getElementById("reviewWriteImg").src = gameImg;
 		document.getElementById("reviewWriteTitle").innerHTML = "<font color='#fff' size='5'><b>"+gameTitle+"</b></font>";
 		
 		const stars = document.querySelectorAll('.review-star-add2');
 		stars.forEach(star => {
            const starIndex = parseInt(star.getAttribute('data-index'));
            if (starIndex <= rating) {
                star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
            } else {
                star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
            }
        });
 		
 	    buttons.forEach(function(button) {
 	        if (button.getAttribute('data-state') == state) {
 	            button.classList.add('selected');
 	        }
 	    });
 		
 		$('#summernote').summernote('code', cmContent);
 		showPopupWrite();
	}
 	
 	function toggleReviewMenu(gameIdx, revMid) {
 	   	const elements = document.querySelectorAll('[id^="contentMenu"]');
 	   	const otherElements = Array.from(elements).filter(element => element.id !== "contentMenu" + gameIdx); // 필터 적용해 조건부로 가져오기
 	    let dropdown = document.getElementById("contentMenu"+gameIdx);
 	   	
    	if(mid == '') {
    		showPopupLogin();
    		return false;
    	}

    	if(mid != revMid) {
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
 	
    // 리뷰 삭제
    function deleteReview(gameIdx) {
    	let ans = confirm("리뷰를 삭제하시겠습니까?");
    	if(ans) {
	        $.ajax({
	        	url : "${ctp}/review/reviewDelete",
	        	type : "post",
	        	data : {gameIdx:gameIdx, mid:mid},
	        	success : function(response) {
	        		location.reload();
				},
				error : function() {
					alert("전송오류!");
				}
	        });
    	}
    }
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main style="padding: 0;">
	<div class="mask">
	  <img class="loadingImg" src='${ctp}/images/loding.gif'>
	</div>
	<div class="tabs" style="justify-content: center; padding: 0; background-color: #161d25;">
        <div class="tab-container">
            <div class="tab" onclick="location.href='${ctp}/mypage/${member.mid}';">
            	<c:if test="${sMid == member.mid}"><img src="${ctp}/member/${member.memImg}" class="reply-pic" style="width: 25px; height: 25px;">&nbsp;마이페이지</c:if>
            	<c:if test="${sMid != member.mid}"><img src="${ctp}/member/${member.memImg}" class="reply-pic" style="width: 25px; height: 25px;">&nbsp;${member.nickname}님의 페이지</c:if>
            </div>
            <div class="tab active" style="border-bottom: 5px solid #00c722;" onclick="location.href='${ctp}/mypage/${member.mid}/mygame';">게임</div>
            <div class="tab" onclick="location.href='${ctp}/mypage/${member.mid}/myreview';">리뷰</div>
            <div class="tab" onclick="location.href='${ctp}/mypage/${member.mid}/myrecord';">일지</div>
        </div>
    </div>
	<div class="container">
		<p><br/></p>
		<div style="display: flex; align-items: center; justify-content: space-between;">
			<div>총 ${totRecCnt}개</div>
			<select id="viewpart" name="part" class="dropdown-btn" onchange="partchange()">
				<option value="gameIdx desc" ${viewpart == 'gameIdx desc' ? 'selected' : ''}>최신순</option>
			</select>
		</div>
		<p><br/></p>
		<div style="display: flex; flex-wrap: wrap; gap:30px; justify-content: center;">
			<c:forEach var="vo" items="${vos}">
				<div class="cm-box mygame-box" data-game-idx="${vo.revGameIdx}" data-rating="${vo.rating}">
					<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" class="mygame-backimg"></c:if>
					<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" class="mygame-backimg"></c:if>
					<div class="review-add">
						<div style="display: flex; justify-content: space-between; align-items: center;">
							<div class="review-add-title" onclick="location.href='${ctp}/gameview/${vo.gameIdx}';">${vo.gameTitle}</div>
							<div style="position: relative; ${sMid != vo.revMid ? '' : 'cursor:pointer;'}">
								<img id="stateIcon" src="${ctp}/images/${vo.state == null ? 'none' : vo.state}Icon.svg" onclick="toggleReviewMenu(${vo.revIdx}, '${vo.revMid}')">
								<div id="contentMenu${vo.revIdx}" class="review-menu">
						        	<div class="review-menu-star">
										<div id="zero-rating-area1" style="position: absolute; left: 0px; width: 20px; height: 24px; cursor: pointer;"></div>
										<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="1"></span>
										<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="2"></span>
										<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="3"></span>
										<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="4"></span>
										<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="5"></span>
									</div>
									<div id="startext${vo.revGameIdx}">이 게임에 별점을 주세요!</div>
									<c:if test="${vo.cmContent == null}"><div id="moreReviewInput${vo.gameIdx}" style="display: block;" onclick="reviewGameEdit(${vo.gameIdx}, '${vo.gameImg}', '${vo.gameTitle}', ${vo.rating}, '${vo.state}', '${vo.cmContent}')"><i class="fa-solid fa-pencil"></i>&nbsp;&nbsp;평가도 남겨보세요</div></c:if>
									<c:if test="${vo.cmContent != null}"><div id="moreReviewInput${vo.gameIdx}" style="display: block;" onclick="reviewGameEdit(${vo.gameIdx}, '${vo.gameImg}', '${vo.gameTitle}', ${vo.rating}, '${vo.state}', '${vo.cmContent}')"><i class="fa-solid fa-pencil"></i>&nbsp;&nbsp;평가 수정</div></c:if>
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
									<div id="statetext${vo.revGameIdx}">
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
						<div style="display:flex; align-items:center; gap:2px;">
							<c:if test="${sMid == vo.revMid}">
					        	<div class="review-menu-star">
									<div id="zero-rating-area1" style="position: absolute; left: -10px; width: 10px; height: 24px; cursor: pointer;"></div>
									<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="1"></span>
									<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="2"></span>
									<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="3"></span>
									<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="4"></span>
									<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="5"></span>
								</div>
							</c:if>
							<c:if test="${sMid != vo.revMid}">
								<div style="display:flex;align-items:center; gap:5px;">
									<c:forEach begin="1" end="${vo.rating}">
										<img src="${ctp}/images/starpull.png" width="25px" height="25px" />
									</c:forEach>
									<c:forEach begin="1" end="${5-vo.rating}">
										<img src="${ctp}/images/star.png" width="25px" height="25px" />
									</c:forEach>
								</div>
							</c:if>
						</div>
						<c:if test="${sMid == vo.revMid}">
							<div class="mt-4" style="display: flex; justify-content: space-between;">
									<c:if test="${vo.cmContent == null}"><div style="cursor: pointer;" onclick="reviewGameEdit(${vo.gameIdx}, '${vo.gameImg}', '${vo.gameTitle}', ${vo.rating}, '${vo.state}', '${vo.cmContent}')"><i class="fa-solid fa-pencil"></i>&nbsp;&nbsp;평가 작성</div></c:if>
									<c:if test="${vo.cmContent != null}"><div style="cursor: pointer;" onclick="reviewGameEdit(${vo.gameIdx}, '${vo.gameImg}', '${vo.gameTitle}', ${vo.rating}, '${vo.state}', '${vo.cmContent}')"><i class="fa-solid fa-pencil"></i>&nbsp;&nbsp;평가 수정</div></c:if>
								<div style="cursor: pointer; color: #e75f5b;" onclick="deleteReview(${vo.gameIdx})">삭제</div>
							</div>
						</c:if>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="news-page">
			<c:if test="${page > 1}"><button class="prev" onclick="location.href='${ctp}/mypage/${member.mid}/mygame?page=${page-1}&viewpart=${viewpart}';"><i class="fa-solid fa-chevron-left fa-2xs"></i></button></c:if>
	        <span class="page-info">${page}/${totPage}</span>
	        <c:if test="${page < totPage}"><button class="next" onclick="location.href='${ctp}/mypage/${member.mid}/mygame?page=${page+1}&viewpart=${viewpart}';"><i class="fa-solid fa-chevron-right fa-2xs"></i></button></c:if>
		</div>
	</div>
	<p><br/></p>
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
					<div class="state-button ${vo.state == 'play' ? 'selected' : ''}" data-state="play" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Play.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${vo.state == 'done' ? 'selected' : ''}" data-state="done" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Check.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${vo.state == 'stop' ? 'selected' : ''}" data-state="stop" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Cancel.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${vo.state == 'folder' ? 'selected' : ''}" data-state="folder" style="width: 60px; height: 55px;">
						<div class="button-background" style="align-items: center;">
							<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Folder.svg&quot;);
							width: 30px; height: 30px; margin-top: 0;"></span>
						</div>
					</div>
					<div class="state-button ${vo.state == 'pin' ? 'selected' : ''}" data-state="pin" style="width: 60px; height: 55px;">
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
            <button class="post-button">게시하기</button>
        </div>
        <!-- Summernote JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
	    
	    <script>
	        // 게시하기 버튼 클릭 이벤트
	        $('.post-button').click(function(event) {
	            event.preventDefault();

		        let mid = '${sMid}';
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
		        
		        if (content == '<p></p>' || content == '<p><br></p>') {
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