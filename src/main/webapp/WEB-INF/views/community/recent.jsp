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
	
	$(document).ready(function() {
		// 처음 창 뜰 때 첫번째 게임 선택
        const firstGameButton = $('.game-button').first();
        firstGameButton.addClass('active');
        
        const initialGame = firstGameButton.data('game');
        let initialHtml = '<font color="#00c722"><b>' + initialGame + '</b></font>에 대한 일지';
        $(".header-text").html(initialHtml);
        
        const game = document.getElementById('gamesearch');
        
        function gameSearchForm() {
        	if(game.value.length >= 2) {
	        	$.ajax({
	        		url : "${ctp}/community/gameSearch",
	        		type : "post",
	        		data : {game : gamesearch.value},
	        		success : function(res) {
	        			$("#results-container").html(res);
	        			$("#results-container").show();
					},
					error : function() {
						alert("전송오류!");
					}
		        });
        	}
        }
        gamesearch.addEventListener('input', gameSearchForm);
        
        // 이벤트 델리게이션을 사용하여 동적으로 추가된 요소에 이벤트 핸들러 설정
        $(document).on('click', '.game-button', function() {
            $('.game-button').removeClass('active');
            $(this).addClass('active');

            let html = '';
            const game = $(this).data('game');
            const category = $('.community-category.active').data('category');
            if (category == '일지') html = '<font color="#00c722"><b>' + game + '</b></font>에 대한 일지';
            else if (category == '소식/정보') html = '<font color="#00c722"><b>' + game + '</b></font>에 대한 소식/정보';
            else html = '<font color="#00c722"><b>' + game + '</b></font>에 대한 세일 정보';
            $(".header-text").html(html);
        });
        
        // 카테고리 버튼 클릭 이벤트
        $('.community-category').click(function() {
            $('.community-category').removeClass('active');
            $(this).addClass('active');
            
            let html = '';
            const category = $(this).data('category');
            if(category == '자유'){
            	$(".game-selection").hide();
            	html = '<font color="#00c722"><b>자유 주제</b></font>';
	            $(".header-text").html(html);
            }
            else {
            	$(".game-selection").show();
	            const game = $('.game-button.active').data('game');
	            if(category == '일지') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 일지';
	            else if(category == '소식/정보') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 소식/정보';
	            else html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 세일 정보';
	            $(".header-text").html(html);
            }
            
        });

        // 게임 버튼 클릭 이벤트
        $('.game-button').click(function() {
            $('.game-button').removeClass('active');
            $(this).addClass('active');
            
            let html = '';
            const game = $(this).data('game');
            const category = $('.community-category.active').data('category');
            if(category == '일지') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 일지';
            else if(category == '소식/정보') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 소식/정보';
            else html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 세일 정보';
            $(".header-text").html(html);
        });

        // 게시하기 버튼 클릭 이벤트
        $('.post-button').click(function(event) {
            event.preventDefault();

	        let mid = '${sMid}';
	        let content = $('#summernote').summernote('code').trim();
	        let category = $('.community-category.active').data('category');
	        let gameIdx = $('.game-button.active').data('idx');
	        let publicType = $('select[name="publicType"]').val();

	        if (content == '' || content == '<p><br></p>') {
	            alert("글 내용을 입력하세요!");
	            $('#summernote').focus();
	            return false;
	        }

	        let query = {
	            mid: mid,
	            cmContent: content,
	            section: '피드',
	            part: category,
	            cmGameIdx: gameIdx,
	            publicType: publicType
	        };

	        $.ajax({
	            url: "${ctp}/community/communityInput",
	            type: "post",
	            data: query,
	            success: function(res) {
	                if (res != "0") {
	                	isWriteButtonClicked = true;
	                    location.reload();
	                }
	                else {
						alert("작성 실패...");
	                }
	            },
	            error: function() {
	               alert("전송오류!");
	            }
	        });
        });
    });
	
	function showPopupWrite() {
    	const popup = document.querySelector('#popup-write');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.classList.add('popup-open');
    }
	
	function showPopupGameSearch() {
		document.getElementById("gamesearch").value = "";
		$("#results-container").hide();
    	const popup = document.querySelector('#popup-gamesearch');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.classList.add('popup-open');
    }
	
	function gamelistAdd(gameIdx) {
		$.ajax({
            url: '${ctp}/community/memGameListEdit',
            type: 'POST',
            data: {gameIdx : gameIdx},
            success: function(res) {
            	if(res != "0") {
            		let str = '<button class="gamesearch-button" onclick="showPopupGameSearch()">'
                    		+ '<img src="${ctp}/images/plus.jpg" alt="">'
                			+ '<div class="game-name">게임 선택</div></button>';
                	str = str + res + '</div>';
            		$("#game-selection").html(str);
            		
            		let html = '';
    	            const game = $('.game-button.active').data('game');
    	            const category = $('.community-category.active').data('category');
    	            if(category == '일지') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 일지';
    	            else if(category == '소식/정보') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 소식/정보';
    	            else html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 세일 정보';
    	            $(".header-text").html(html);
    	            
            		document.querySelector('#popup-gamesearch').classList.add('hide');
            	}
            },
            error: function(error) {
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
</script>
<jsp:include page="/WEB-INF/views/include/navjs.jsp" />
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
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
					<span class="c-button c-button-active">최신</span>
					<span class="c-button">리뷰</span>
					<span class="c-button">소식/정보</span>
					<span class="c-button">세일</span>
					<span class="c-button">내글</span>
				</div>
				<c:if test="${sMid != null}">
					<div class="cm-box">
						<div style="display:flex; align-items: center; justify-content: center;">
							<img src="${ctp}/member/${sMemImg}" alt="프로필" class="text-pic">
							<div class="text-input" onclick="showPopupWrite()">요즘 관심있는 게임은 무엇인가요?</div>
						</div>
					</div>
				</c:if>
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
							<div style="color:#b2bdce; font-size:14px;" class="mt-2">이 글을 nn명이 좋아합니다.</div>
						</div>
						<hr/>
						<div class="community-footer">
							<span><i class="fa-solid fa-heart"></i>&nbsp;&nbsp;좋아요</span>
							<span><i class="fa-solid fa-comment-dots"></i>&nbsp;&nbsp;댓글</span>
						</div>
						<hr/>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<p></p>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
<div id="popup-write" class="hide">
  <div class="popup-write-content scrollbar">
  		<div class="popup-write-header">
            <span class="header-text"></span>
    		<a href="" onclick="closePopup('write')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
        <div class="category-selection">
            <button class="community-category active" data-category="일지">일지</button>
            <button class="community-category" data-category="소식/정보">소식/정보</button>
            <button class="community-category" data-category="자유">자유 주제</button>
            <button class="community-category" data-category="세일">세일 글</button>
        </div>
        <div class="game-selection scrollbar" id="game-selection">
            <button class="gamesearch-button" onclick="showPopupGameSearch()">
            	<img src="${ctp}/images/plus.jpg" alt="">
            	<div class="game-name">게임 선택</div>
            </button>
            <c:forEach var="vo" items="${vos}">
                <button class="game-button" data-game="${vo.gameTitle}" data-idx="${vo.gameIdx}">
	            	<img src="${vo.gameImg}" alt="${vo.gameTitle}">
	            	<div class="game-name">${vo.gameTitle}</div>
	            </button>
            </c:forEach>
        </div>
        <textarea id="summernote" name="content"></textarea>
        <div class="footer">
            <select class="dropdown-btn" id="publicType" name="publicType">
                <option value="전체">전체 공개</option>
                <option value="친구">친구만 공개</option>
                <option value="비공개">비공개</option>
            </select>
            <button class="post-button">게시하기</button>
        </div>
        <!-- Summernote JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
	    
	    <script>
		let initialImages = [];
		let currentImages = [];
		
		// 썸머노트 기본설정
		$(document).ready(function() {
		    let fontList = ['SUITE-Regular'];
		    $('#summernote').summernote({
		        lang: 'ko-KR',
		        tabsize: 2,
		        height: 350,
		        toolbar: [
		            ['fontsize', ['fontsize']],
		            ['insert', ['picture', 'link', 'video']]
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
		            },
		            onImageUpload: function(files) {
		                if (files.length > 0) {
		                    for (let i = 0; i < files.length; i++) {
		                        uploadImage(files[i]);
		                    }
		                }
		            },
		            onChange: function(contents, $editable) {
		                currentImages = getCurrentImages();
		                detectDeletedImages(initialImages, currentImages);
		                initialImages = currentImages;
		            }
		        }
		    });
		});
	
			// 이미지 업로드
		    function uploadImage(file) {
				let fileSize = file.size;
				let maxSize = 1024 * 1024 * 15;
				
				const imgType = ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'];
				if(imgType.indexOf(file.type) == -1){
					alert("이미지 파일만 업로드 해주세요!");
	                return;
				}
				if(fileSize > maxSize) {
					alert("파일의 최대 크기는 15MB입니다");
	                return;
				}
				
		        let data = new FormData();
		        data.append("file", file);
	
		        $.ajax({
		            url: '${ctp}/community/imageUpload',
		            cache: false,
		            contentType: false,
		            processData: false,
		            data: data,
		            type: "POST",
		            success: function(response) {
	                    $('#summernote').summernote('insertImage', response, function($image) {
	                        initialImages.push(response);
	                    });
		            },
		            error: function() {
		                alert("전송오류!");
		            }
		        });
		    }
	
		    // 현재 창에 있는 이미지 가져오기
		    function getCurrentImages() {
		        return $('#summernote').next('.note-editor').find('.note-editable img').map(function() {
		            return $(this).attr('src');
		        }).get();
		    }
	
		    // 이미지 삭제 실행함수
		    function detectDeletedImages(initialImages, currentImages) {
		        initialImages.forEach(function(src) {
		            if (!currentImages.includes(src)) {
		                deleteImage(src);
		            }
		        });
		    }
	
		    // 이미지 삭제 ajax
		    function deleteImage(src) {
		        $.ajax({
		            url: '${ctp}/community/deleteImage',
		            type: 'POST',
		            data: { src: src },
		            error: function() {
		                console.log('이미지 삭제 실패');
		            }
		        });
		    }
		    
		    
	 	    // 페이지 떠날 때 작성하지 않은 파일들 삭제
			window.onbeforeunload = function() {
	 	    	if(isWriteButtonClicked == false) {
				    if (initialImages.length > 0) {
				        initialImages.forEach(function(src) {
				            deleteImage(src);
				        });
				    }
	 	    	}
			};


		</script>
    </div>
</div>
<div id="popup-gamesearch" class="hide">
  <div class="popup-gamesearch-content scrollbar">
  		<div class="popup-gamesearch-header mb-4">
            <span class="gs-header-text">게임 검색</span>
    		<a href="" onclick="closePopup('search')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="search-container">
	 		<input type="text" id="gamesearch" name="gamesearch" class="search-bar gamesearch-bar" placeholder="Search...">
	 	</div>
        <div class="results-container scrollbar mt-4" id="results-container"></div>
    </div>
</div>
</body>
</html>