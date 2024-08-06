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
<title>${vo.gameTitle} 리뷰 | 인겜토리</title>
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
		
		// 무한스크롤
		function rootData() {
			isFetching = true;
			let gameIdx = ${gameIdx};
			
			$.ajax({
				url : "${ctp}/community/rootDataReview",
				type : "post",
				data : {page : ${page}+totPage, part : '리뷰', gameIdx:gameIdx},
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
		if(mid == '') {
			showPopupLogin();
			return false;
		}
		
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
 			currentRating = rating;
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
 		
    	const popup = document.querySelector('#popup-reviewwrite');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
	
 	function reviewGameAdd(gameIdx, gameImg, gameTitle) {
 		closePopup('search');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
 		document.getElementById("writeGameIdx").value = gameIdx;
 		if(gameImg.indexOf('http') == -1) {
	 		document.getElementById("reviewWriteImg").src = "${ctp}/game/"+gameImg;
 		}
 		else document.getElementById("reviewWriteImg").src = gameImg;
 		document.getElementById("reviewWriteTitle").innerHTML = "<font color='#fff' size='5'><b>"+gameTitle+"</b></font>";
 		
 		const stars = document.querySelectorAll('.review-star-add2');
 		stars.forEach(star => {
            const starIndex = parseInt(star.getAttribute('data-index'));
            if (starIndex <= 0) {
                star.style.backgroundImage = 'url("${ctp}/images/starpull.png")';
            } else {
                star.style.backgroundImage = 'url("${ctp}/images/star2.png")';
            }
        });
 		
 		const buttons = document.querySelectorAll('.state-button');
 	    buttons.forEach(function(button) {
 	        button.classList.remove('selected');
 	    });
 		
 		$('#summernote').summernote('code', '');
	}
 	
 	function reviewGameEdit(gameIdx, gameImg, gameTitle, rating, state, cmContent) {
 		currentRating = rating;
 		showPopupWrite();
 		closePopup('search');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
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
 		
 		const buttons = document.querySelectorAll('.state-button');
 	    buttons.forEach(function(button) {
 	        if (button.getAttribute('data-state') == state) {
 	            button.classList.add('selected');
 	        }
 	    });
 		
 		$('#summernote').summernote('code', cmContent);
	}
 	
 	function reviewInput() {
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
	}
 	
 	function showGameRequestEditPopup() {
 		let platforms = '${vo.platform}'.split(", ");
		platforms.forEach(platform => {
		    document.querySelectorAll('.eg-button').forEach(button => {
		        if (button.getAttribute('data-platform') === platform) {
		            button.classList.add('eg-button-active');
		        }
		    });
		});
 		
    	const popup = document.querySelector('#popup-gameedit');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
 	
 	function gameEdit() {
 		let gameIdx = document.getElementById("writeGameIdx").value;
		let gameTitle = document.getElementById("egameTitle").value.trim();
		let gameSubTitle = document.getElementById("egameSubTitle").value.trim();
		let jangre = document.getElementById("ejangre").value.trim();
		let showDate = document.forms["egameaddform"]["eshowDate"].value;
		let price = document.getElementById("eprice").value.trim();
		let metascore = document.getElementById("emetascore").value.trim();
		let steamscore = document.getElementById("esteamscore").value.trim();
		let steamPage = document.getElementById("esteamPage").value.trim();
		let developer = document.getElementById("edeveloper").value.trim();
		let gameInfo = document.getElementById("egameInfo").value.trim();
		
		const platformActive = document.querySelectorAll('.eg-button-active');

		let platform = '';

		platformActive.forEach((button) => {
			platform += button.getAttribute('data-platform') + ', ';
		});
		
		platform = platform.substring(0, platform.length-2);
		
		if(gameTitle == '' || gameTitle == null) {
			alert("게임 이름은 필수 항목입니다!");
			return false;
		}
		
		if(showDate == '' || showDate == null) {
			alert("출시일은 필수 항목입니다!");
			return false;
		}
		
		let query = {
				reqMid : '${sMid}',
				gameIdx : gameIdx,
				gameTitle : gameTitle,
				gameSubTitle : gameSubTitle,
				jangre:jangre,
				platform:platform,
				showDate:showDate,
				price:price,
				metascore:metascore,
				steamscore:steamscore,
				steamPage:steamPage,
				developer:developer,
				gameInfo:gameInfo
		}
		
 		$.ajax({
 			url : "${ctp}/admin/gameRequestInput",
 			type : "post",
            data: JSON.stringify(query),
            contentType: "application/json",
 			success : function() {
 				alert("요청이 정상접수 되었습니다!");
 				closePopup('gameedit');
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
<main style="padding: 0 20px 70px;">
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
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}';">상세정보</div>
	            <div class="tab active" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/review';">리뷰 ${totRecCnt}</div>
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/record';">일지 ${ilgiCnt}</div>
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/info';">소식/정보 ${infoCnt}</div>
	        </div>
	        <c:if test="${sMid != null}"><button class="editplz-button" onclick="showGameRequestEditPopup()">정보수정요청</button></c:if>
	    </div>
	    <hr/>
	    <c:if test="${fn:length(cmVOS) != 0}">
		    <c:if test="${revVO == null}"><div class="editplz-button mt-2" style="background-color:#00c72299;" onclick="showPopupWrite()">리뷰 작성</div></c:if>
		    <c:if test="${revVO != null}"><div class="editplz-button mt-2" style="background-color:#00c72299;" onclick="showPopupWrite(${revVO.revGameIdx}, ${revVO.rating}, '${revVO.state}', '${cmContent}')">리뷰 수정</div></c:if>
		</c:if>
		<div style="width:100%; color:#fff;;" class="mt-2">
			<c:forEach var="cmVO" items="${cmVOS}">
				<div class="cm-box" id="cmbox${cmVO.cmIdx}">
					<div style="display:flex;justify-content: space-between;">
						<div>
							<img src="${ctp}/member/${cmVO.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b style="font-weight:bold; cursor: pointer;" onclick="location.href='${ctp}/mypage/${cmVO.mid}';">${cmVO.nickname}</b>님이 평가를 남기셨습니다
						</div>
						<c:if test="${sMid != null}">
							<div style="display: flex; align-items: center;">
								<div style="position:relative;">
									<i class="fa-solid fa-bars fa-xl" onclick="toggleContentMenu(${cmVO.cmIdx})" style="color: #D5D5D5;cursor:pointer;"></i>
						 			<div id="contentMenu${cmVO.cmIdx}" class="content-menu">
								        <c:if test="${sMid == cmVO.mid}"><div onclick="reviewGameEdit(${cmVO.cmGameIdx}, '${cmVO.gameImg}', '${cmVO.gameTitle}', ${cmVO.rating}, '${cmVO.state}','${fn:replace(cmVO.cmContent, '\'', '')}')">수정</div></c:if>
									    <c:if test="${sMid == cmVO.mid || sLevel == 0}"><div onclick="contentDelete(${cmVO.cmIdx})"><font color="red">삭제</font></div></c:if>
								        <c:if test="${sMid != cmVO.mid && sLevel == 0}"><div onclick="location.href='${ctp}/admin/userlist?page=1&viewpart=all&searchpart=아이디&search=${cmVO.mid}';">사용자 제재</div></c:if>
								        <c:if test="${sMid != cmVO.mid && sLevel != 0}"><div onclick="reportPopup(${cmVO.cmIdx}, '게시글', '${cmVO.mid}')">신고</div></c:if>
							    	</div>
					 			</div>
					 		</div>
				 		</c:if>
					</div>
					<hr/>
					<div style="display:flex; margin: 0 20px; align-items:center; gap:20px; cursor: pointer;" onclick="location.href='${ctp}/gameview/${cmVO.gameIdx}';">
						<div>
							<c:if test="${fn:indexOf(cmVO.gameImg, 'http') == -1}"><img src="${ctp}/game/${cmVO.gameImg}" alt="${vo.gameTitle}" class="re-gameImg"></c:if>
            				<c:if test="${fn:indexOf(cmVO.gameImg, 'http') != -1}"><img src="${cmVO.gameImg}" alt="${vo.gameTitle}" class="re-gameImg"></c:if>
						</div>
						<div class="review-info">
							<div class="game-title">${cmVO.gameTitle}</div>
							<div class="review-game-info">
								<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;${cmVO.rating}</span>
								<span class="review-state-${cmVO.state}">
									<c:if test="${cmVO.state == 'play'}"><i class="fa-solid fa-play"></i>&nbsp;하고있어요</c:if>
									<c:if test="${cmVO.state == 'stop'}"><i class="fa-solid fa-xmark"></i>&nbsp;그만뒀어요</c:if>
									<c:if test="${cmVO.state == 'done'}"><i class="fa-solid fa-check"></i>&nbsp;다했어요</c:if>
									<c:if test="${cmVO.state == 'folder'}"><i class="fa-solid fa-folder"></i>&nbsp;모셔놨어요</c:if>
									<c:if test="${cmVO.state == 'pin'}"><i class="fa-solid fa-thumbtack"></i>&nbsp;관심있어요</c:if>
									<c:if test="${cmVO.state == 'none'}"><i class="fa-solid fa-ellipsis"></i>&nbsp;상태없음</c:if>
								</span>
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
							<span onclick="replyPreview(${cmVO.cmIdx})"><i class="fa-solid fa-comment-dots"></i>&nbsp;&nbsp;댓글</span>
						</div>
						<hr/>
					</c:if>
					<div id="replyList${cmVO.cmIdx}" class="replyList">
						<c:if test="${cmVO.replyCount > 2}"><div id="moreReply${cmVO.cmIdx}" onclick="parentReplyMore(${cmVO.cmIdx})" class="moreReply">${cmVO.replyCount}개의 댓글 모두 보기</div></c:if>
						<c:forEach var="parentReply" items="${cmVO.parentsReply}">
							<div style="display:flex; align-items:flex-start;" class="mb-4">
								<img src="${ctp}/member/${parentReply.memImg}" alt="프로필" class="reply-pic">
								<div>
									<c:if test="${parentReply.title != '없음'}"><div style="font-size:12px;">${parentReply.title}</div></c:if>
									<div style="font-weight:bold;">${parentReply.nickname}</div>
									<div>${fn:replace(parentReply.replyContent, newLine, "<br/>")}</div>
									<div style="color:#b2bdce; font-size:12px;" class="mt-2">
										<c:if test="${parentReply.hour_diff < 1}">${parentReply.min_diff}분 전</c:if>
										<c:if test="${parentReply.hour_diff < 24 && parentReply.hour_diff >= 1}">${parentReply.hour_diff}시간 전</c:if>
										<c:if test="${parentReply.hour_diff >= 24}">${fn:substring(parentReply.replyDate, 0, 10)}</c:if>
										<c:if test="${sMid != null}">
											<div class="replymenu">
												<span class="mr-2" onclick="rreplyPreview(${parentReply.replyIdx})">답글</span>
												<c:if test="${sMid == parentReply.replyMid}"><span class="mr-2" onclick="replyEditPopup(${parentReply.replyIdx}, '${parentReply.replyContent}')">수정</span></c:if>
												<c:if test="${(sMid == parentReply.replyMid && sLevel != 0) || sLevel == 0}"><span class="mr-2" onclick="replyDelete(${parentReply.replyIdx}, 0)">삭제</span></c:if>
												<span class="mr-2" onclick="reportPopup(${parentReply.replyIdx}, '댓글', '${parentReply.replyMid}')">신고</span>
											</div>
										</c:if>
									</div>
								</div>
							</div>
							<div id="rreplyList${parentReply.replyIdx}" class="rreplyList">
								<c:if test="${parentReply.childReplyCount > 1}"><div id="moreRReply${parentReply.replyIdx}" onclick="childReplyMore(${parentReply.replyIdx},${cmVO.cmIdx})" class="moreReply"> ──&nbsp;&nbsp;${parentReply.childReplyCount}개의 답글 모두 보기</div></c:if>
								<c:forEach var="childReply" items="${cmVO.childReply}">
									<c:if test="${childReply.replyParentIdx == parentReply.replyIdx}">
										<div style="display:flex; align-items:flex-start;" class="mb-4">
											<img src="${ctp}/member/${childReply.memImg}" alt="프로필" class="reply-pic">
											<div>
												<c:if test="${childReply.title != '없음'}"><div style="font-size:12px;">${childReply.title}</div></c:if>
												<div style="font-weight:bold;">${childReply.nickname}</div>
												<div>${fn:replace(childReply.replyContent, newLine, "<br/>")}</div>
												<div style="color:#b2bdce; font-size:12px;" class="mt-2">
													<c:if test="${childReply.hour_diff < 1}">${childReply.min_diff}분 전</c:if>
													<c:if test="${childReply.hour_diff < 24 && childReply.hour_diff >= 1}">${childReply.hour_diff}시간 전</c:if>
													<c:if test="${childReply.hour_diff >= 24}">${fn:substring(childReply.replyDate, 0, 10)}</c:if>
													<c:if test="${sMid != null}">
														<div class="replymenu">
															<span class="mr-2" onclick="rreplyPreview(${parentReply.replyIdx})">답글</span>
															<c:if test="${sMid == childReply.replyMid}"><span class="mr-2" onclick="replyEditPopup(${childReply.replyIdx}, '${childReply.replyContent}')">수정</span></c:if>
															<c:if test="${(sMid == childReply.replyMid && sLevel != 0) || sLevel == 0}"><span class="mr-2" onclick="replyDelete(${childReply.replyIdx}, 1)">삭제</span></c:if>
															<span class="mr-2" onclick="reportPopup(${childReply.replyIdx}, '댓글', '${childReply.replyMid}')">신고</span>
														</div>
													</c:if>
												</div>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>
							<div id="rreplyWrite${parentReply.replyIdx}" style="display:none; justify-content: center;">
								<div style="display:flex;">
									<img src="${ctp}/member/${sMemImg}" alt="프로필" class="reply-pic">
									<textarea id="rreplyContent${parentReply.replyIdx}" name="rreplyContent" rows="2" placeholder="답글을 작성해 보세요." class="form-control textarea" style="background-color:#32373d;"></textarea>
								</div>
								<div style="display:flex; justify-content: flex-end; margin-top: 5px;">
									<div class="replyno-button mr-2" onclick="rreplyPreview(${parentReply.replyIdx})">취소</div>
									<div class="replyok-button" onclick="rreplyInput(${parentReply.replyIdx}, ${cmVO.cmIdx})">작성</div>
								</div>
							</div>
						</c:forEach>
					</div>
					<c:if test="${sMid != null}">
						<div id="replyPreview${cmVO.cmIdx}" style="display:flex; align-items: center; justify-content: center;">
							<img src="${ctp}/member/${sMemImg}" alt="프로필" class="reply-pic">
							<div class="text-input" onclick="replyPreview(${cmVO.cmIdx})">댓글을 작성해 보세요.</div>
						</div>
						<div id="replyWrite${cmVO.cmIdx}" style="display:none; justify-content: center;">
							<div style="display:flex;">
								<img src="${ctp}/member/${sMemImg}" alt="프로필" class="reply-pic">
								<textarea id="replyContent${cmVO.cmIdx}" name="replyContent" rows="2" placeholder="댓글을 작성해 보세요." class="form-control textarea" style="background-color:#32373d;"></textarea>
							</div>
							<div style="display:flex; justify-content: flex-end; margin-top: 5px;">
								<div class="replyno-button mr-2" onclick="replyCancel(${cmVO.cmIdx})">취소</div>
								<div class="replyok-button" onclick="replyInput(${cmVO.cmIdx})">작성</div>
							</div>
						</div>
					</c:if>
				</div>
			</c:forEach>
			<c:if test="${fn:length(cmVOS) == 0}">
				<div style="margin: 100px 20px; text-align: center;">
					<div>보여드릴 리뷰가 없습니다.</div>
					<div>가장 먼저 이 게임의 리뷰를 남겨보세요.</div>
					<div class="editplz-button mt-2" style="margin: 0 auto; width: 30%;" onclick="showPopupWrite()">리뷰 작성</div>
				</div>
			</c:if>
			<span id="root"></span>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-reviewwrite" class="hide">
  <div class="popup-reviewwrite-content scrollbar">
  		<div class="popup-write-header">
            <span class="header-text"></span>
    		<div style="cursor:pointer;" onclick="closePopup('reviewwrite')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
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
            <button class="post-button" onclick="reviewInput()">게시하기</button>
        </div>
        <!-- Summernote JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
    </div>
</div>
<div id="popup-gamesearch" class="hide">
  <div class="popup-gamesearch-content scrollbar">
  		<div class="popup-gamesearch-header mb-4">
            <span class="gs-header-text">게임 검색</span>
    		<div style="cursor:pointer;" onclick="closePopup('search')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="search-container">
	 		<input type="text" id="gamesearch" name="gamesearch" class="search-bar gamesearch-bar" placeholder="Search...">
	 	</div>
        <div class="results-container scrollbar mt-4" id="results-container"></div>
    </div>
</div>
<div id="popup-gameedit" class="hide">
  <div class="popup-gameedit-content scrollbar">
		<div class="popup-add-header">
			<div class="e-header-text">게임 수정</div>
    		<div style="cursor:pointer;" onclick="closePopup('gameedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="popup-add-main">
			<form name="egameaddform" method="post">
				<table class="table table-borderless" style="color:#fff">
					<tr>
						<td colspan="2" id="imgView"></td>
					</tr>
					<tr>
						<th><font color="#ff5e5e">*</font> 이름</th>
						<td><input type="text" name="egameTitle" id="egameTitle" value="${vo.gameTitle}" placeholder="게임 한글 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>외국어 이름</th>
						<td><input type="text" name="egameSubTitle" id="egameSubTitle" value="${vo.gameSubTitle}" placeholder="게임 외국어 이름을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>장르</th>
						<td><input type="text" name="ejangre" id="ejangre" placeholder="장르를 입력하세요" value="${vo.jangre}" class="forminput" /></td>
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
						<th><font color="#ff5e5e">*</font> 출시일</th>
						<td><input type="date" name="eshowDate" id="eshowDate" value="${vo.showDate}" class="forminput" /></td>
					</tr>
					<tr>
						<th>가격</th>
						<td><input type="number" name="eprice" id="eprice" value="${vo.price}" placeholder="가격을 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>메타스코어</th>
						<td><input type="number" name="emetascore" id="emetascore" value="${vo.metascore}" placeholder="메타스코어를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀평가</th>
						<td><input type="text" name="esteamscore" id="esteamscore" value="${vo.steamscore}" placeholder="스팀 평가(전체)를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>스팀링크</th>
						<td><input type="text" name="esteamPage" id="esteamPage" value="${vo.steamPage}" placeholder="스팀 스토어 링크를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>개발사</th>
						<td><input type="text" name="edeveloper" id="edeveloper" value="${vo.developer}" placeholder="개발사를 입력하세요" class="forminput" /></td>
					</tr>
					<tr>
						<th>게임소개</th>
						<td><textarea rows="3" name="egameInfo" id="egameInfo" placeholder="게임소개를 입력하세요" class="form-control textarea">${vo.gameInfo}</textarea></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" class="joinBtn-sm" value="수정 요청" onclick="gameEdit()" /></td>
					</tr>
				</table>
			</form>
		</div>
  </div>
</div>
</body>
</html>