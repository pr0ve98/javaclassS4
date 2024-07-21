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
	
	let isFetching = false;
	let totPage = 1;

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
	    
	    // 페이지 로드 로딩페이지 제거
	    $(window).on('load', function() {
	    	removeLoadingPage();
	    });
	    
	    // 로딩페이지 제거 함수
	    function removeLoadingPage() {
	        $('.mask').hide();
	        $('html').css('overflow', 'auto');
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
	    
	    // 별점 및 상태 추가
	    const gameContainers = document.querySelectorAll('.cm-box');
	
	    gameContainers.forEach(container => {
	        const stars = container.querySelectorAll('.review-star-add');
	        const zeroRatingArea1 = container.querySelector('#zero-rating-area1');
	        const zeroRatingArea2 = container.querySelector('#zero-rating-area2');
	        const gameIdx = parseInt(container.getAttribute('data-game-idx'));
	        const state = container.querySelectorAll('.review-star-add');
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
	                const index = parseInt(this.getAttribute('data-index'));
	                currentRating = index;
	                lockStars(stars, currentRating);
	                updateReviewText(gameIdx, currentRating);
	                inputReview(gameIdx, currentRating); // 별점 저장
	            });
	        });
			
	     	// 별점 삭제 영역을 클릭했을 때 별점을 0으로 설정하고 텍스트를 초기화
	        const zeroRatingAreas = [zeroRatingArea1, zeroRatingArea2];
	        zeroRatingAreas.forEach(zeroRatingArea => {
	            zeroRatingArea.addEventListener('click', function() {
	                currentRating = 0;
	                lockStars(stars, currentRating);
	                updateReviewText(gameIdx, currentRating);
	                deleteReview(gameIdx); // 별점 삭제
	            });
	        });
	        
	     	// 상태 버튼
	        const buttons = container.querySelectorAll('.state-button');
	        const stateIcon = container.querySelector('#stateIcon');

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
	                
	                if (isSelected) {
	                    const state = button.getAttribute('data-state');
	                    switch (state) {
	                        case 'play':
	                            stateIcon.src = '${ctp}/images/playIcon.svg';
	                            $("#statetext"+gameIdx).html("<font color=\"#fff\">하고있어요</font>");
	                            break;
	                        case 'done':
	                            stateIcon.src = '${ctp}/images/doneIcon.png';
	                            $("#statetext"+gameIdx).html("<font color=\"#fff\">다했어요</font>");
	                            break;
	                        case 'stop':
	                            stateIcon.src = '${ctp}/images/stopIcon.svg';
	                            $("#statetext"+gameIdx).html("<font color=\"#fff\">그만뒀어요</font>");
	                            break;
	                        case 'folder':
	                            stateIcon.src = '${ctp}/images/folderIcon.svg';
	                            $("#statetext"+gameIdx).html("<font color=\"#fff\">모셔놨어요</font>");
	                            break;
	                        case 'pin':
	                            stateIcon.src = '${ctp}/images/pinIcon.svg';
	                            $("#statetext"+gameIdx).html("<font color=\"#fff\">관심있어요</font>");
	                            break;
	                        default:
	                            stateIcon.src = '${ctp}/images/noneIcon.svg';
	                            $("#statetext"+gameIdx).html("현재 게임 상태를 선택해주세요");
	                            break;
	                    }
	                } else {
	                    stateIcon.src = '${ctp}/images/noneIcon.svg';
	                    $("#statetext"+gameIdx).html("현재 게임 상태를 선택해주세요");
	                }
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
	    function inputReview(gameIdx, rating) {
	        
	    }
	    
	    // 리뷰 삭제
	    function deleteReview(gameIdx) {
	        
	    }
	});

	function showPopupAdd() {
    	const popup = document.querySelector('#popup-add');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
    }
	
 	function toggleContentMenu(gameIdx) {
 	   	const elements = document.querySelectorAll('[id^="contentMenu"]');
 	   	const otherElements = Array.from(elements).filter(element => element.id !== "contentMenu" + gameIdx); // 필터 적용해 조건부로 가져오기
 	    let dropdown = document.getElementById("contentMenu"+gameIdx);
 	    
 	   otherElements.forEach(element => {
 	   		element.style.display = "none";
 		});
 	    
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	    }
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
						<option value="gameIdx desc">많이 평가한순</option>
						<option value="showDate desc" ${viewpart == 'showDate desc' ? 'selected' : ''}>최신 발매일순</option>
						<option value="gameIdx desc">인겜스코어 높은순</option>
						<option value="metascore desc" ${viewpart == 'metascore desc' ? 'selected' : ''}>메타스코어 높은순</option>
						<option value="random" ${viewpart == 'random' ? 'selected' : ''}>랜덤 게임들</option>
					</select>
				</div>
				<p><br/></p>
				<c:forEach var="vo" items="${vos}">
					<div class="cm-box" style="padding:0" data-game-idx="${vo.gameIdx}" data-rating="${vo.rating}">
						<div style="display: flex">
							<div>
								<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" class="review-game-i"></c:if>
								<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" class="review-game-i"></c:if>
							</div>
							<div class="review-add">
								<div style="display: flex; justify-content: space-between; align-items: center;">
									<div class="review-add-title">${vo.gameTitle}</div>
									<div style="position: relative;">
										<img id="stateIcon" src="${ctp}/images/noneIcon.svg" onclick="toggleContentMenu(${vo.gameIdx})">
										<div id="contentMenu${vo.gameIdx}" class="review-menu">
								        	<div class="review-menu-star">
												<div id="zero-rating-area1" style="position: absolute; left: -20px; width: 20px; height: 40px; cursor: pointer;"></div>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="1"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="2"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="3"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="4"></span>
												<span class="review-star-add mr-1" style="width: 25px; height: 25px;" data-index="5"></span>
											</div>
											<div id="startext${vo.gameIdx}">이 게임에 별점을 주세요!</div>
											<hr/>
											<div class="state-buttons" style="display: flex;">
												<div class="state-button" data-state="play">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Play.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button" data-state="done">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Check.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button" data-state="stop">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Cancel.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button" data-state="folder">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Folder.svg&quot;);"></span>
													</div>
												</div>
												<div class="state-button" data-state="pin">
													<div class="button-background">
														<span class="state-icon" style="mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Pin.svg&quot;);"></span>
													</div>
												</div>
											</div>
											<div id="statetext${vo.gameIdx}">현재 게임 상태를 선택해주세요</div>
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