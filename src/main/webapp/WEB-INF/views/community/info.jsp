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
<title>소식/정보 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let isWriteButtonClicked = false;
	
	let isFetching = false;
	let totPage = 1;
	let editContent = '';
	let editCmIdx;
	let editCmGameIdx;
	let editGameTitle = '';
	
	let initialContent = '';
	let initialImages = [];
	let currentImages = [];
	let editInitialImages = [];
	let editCurrentImages = [];
	
	$(document).ready(function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
		
		// 무한스크롤
		function rootData() {
			isFetching = true;
			
			$.ajax({
				url : "${ctp}/community/rootData",
				type : "post",
				data : {page : ${page}+totPage, part : 'info'},
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
	    
		// 처음 창 뜰 때 첫번째 게임 선택
        const firstGameButton = $('.game-button').first();
        firstGameButton.addClass('active');
        const firstGameButton2 = $('.gameedit-button').first();
        firstGameButton2.addClass('active');
        
        const initialGame = firstGameButton.data('game');
        let initialHtml = '<font color="#00c722"><b>' + initialGame + '</b></font>에 대한 소식/정보';
        $(".header-text").html(initialHtml);
        
        const game = document.getElementById('gamesearch');
        
        // 게임 검색
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
        // 수정 이벤트 델리게이션을 사용하여 동적으로 추가된 요소에 이벤트 핸들러 설정
        $(document).on('click', '.gameedit-button', function() {
            $('.gameedit-button').removeClass('active');
            $(this).addClass('active');

            let html = '';
            const game = $(this).data('game');
            const category = $('.community-editcategory.active').data('category');
            if (category == '일지') html = '<font color="#00c722"><b>' + game + '</b></font>에 대한 일지';
            else if (category == '소식/정보') html = '<font color="#00c722"><b>' + game + '</b></font>에 대한 소식/정보';
            else html = '<font color="#00c722"><b>' + game + '</b></font>에 대한 세일 정보';
            $(".header-edittext").html(html);
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
        
        // 수정 카테고리 버튼 클릭 이벤트
        $('.community-editcategory').click(function() {
            $('.community-editcategory').removeClass('active');
            $(this).addClass('active');
            
            let html = '';
            const category = $(this).data('category');
            if(category == '자유'){
            	$("#game-selection2").hide();
            	html = '<font color="#00c722"><b>자유 주제</b></font>';
	            $(".header-edittext").html(html);
            }
            else {
            	$("#game-selection2").show();
	            let game = $('.gameedit-button.active').data('game');
	            if(game === undefined) game = editGameTitle;
	            if(category == '일지') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 일지';
	            else if(category == '소식/정보') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 소식/정보';
	            else html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 세일 정보';
	            $(".header-edittext").html(html);
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
        
        // 수정 게임 버튼 클릭 이벤트
        $('.gameedit-button').click(function() {
            $('.gameedit-button').removeClass('active');
            $(this).addClass('active');
            
            let html = '';
            const game = $(this).data('game');
            const category = $('.community-editcategory.active').data('category');
            if(category == '일지') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 일지';
            else if(category == '소식/정보') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 소식/정보';
            else html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 세일 정보';
            $(".header-edittext").html(html);
        });
        
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
        
        $('#summernote2').summernote({
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
	                initialContent = $('#summernote2').summernote('code');
	                $('.note-editable').css({
	                	'font-family':'SUITE-Regular',
	                	'color':'#b2bdce',
	                	'cursor':'text'
	                });
	            },
	            onImageUpload: function(files) {
	                if (files.length > 0) {
	                    for (let i = 0; i < files.length; i++) {
	                        uploadImage2(files[i]);
	                    }
	                }
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

    // 페이지 떠날 때 이미지 제거
    window.onbeforeunload = function() {
        if (!isWriteButtonClicked) {
            if ($('#summernote').is(':visible')) {
                // Summernote에 대한 로직
                if (initialImages.length > 0) {
                    initialImages.forEach(function(src) {
                        deleteImage(src);
                    });
                }
            } else if ($('#summernote2').is(':visible')) {
                // Summernote2에 대한 로직
                editCurrentImages = getCurrentImages('#summernote2');
                detectDeletedImages(editInitialImages, editCurrentImages);
            }
        }
    };
	
	function showPopupWrite() {
    	const popup = document.querySelector('#popup-write');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
    }
	
	async function showPopupEdit(voString) {
		isWriteButtonClicked = false;
    	const popup = document.querySelector('#popup-edit');
    	const html = document.querySelector('html');
    	
    	const vo = parseCommunityVO(voString);
    	
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
        $("#contentMenu"+vo.cmIdx).hide();
        
        let headertext = '';
        $('.community-editcategory').removeClass('active');
        $('.community-editcategory').each(function() {
            if ($(this).data('category') === vo.part) {
                $(this).addClass('active');
            }
        });
        
        if(vo.part == '일지') headertext = '<font color="#00c722"><b>'+ vo.gameTitle + '</font></b>에 대한 일지';
        else if(vo.part == '소식/정보') headertext = '<font color="#00c722"><b>'+ vo.gameTitle + '</font></b>에 대한 소식/정보';
        else if(vo.part == '세일') headertext = '<font color="#00c722"><b>'+ vo.gameTitle + '</font></b>에 대한 세일 정보';
        else {
        	headertext = '<font color="#00c722"><b>자유 주제</font></b>';
        	$("#game-selection2").hide();
        }
        document.querySelector('.popup-edit-header .header-edittext').innerHTML = headertext;
        
        // 게임 선택
        $('.gameedit-button').each(function() {
            if ($(this).data('editidx') === vo.gameIdx) {
                $(this).addClass('active');
            }
        });
        
       	editCmIdx = vo.cmIdx;
       	editCmGameIdx = vo.cmGameIdx;
       	editGameTitle = vo.gameTitle;
       	
        const buttons = document.querySelectorAll('.gameedit-button');
        buttons.forEach(button => {
            const editIdx = button.getAttribute('data-editidx');
            
            if (editIdx == editCmGameIdx) button.classList.add('active');
       	});
        
        $('select[name="publicType2"]').val(vo.publicType);
        
        try {
            const res = await new Promise((resolve, reject) => { // await로 요청이 완료될 때까지 대기
                $.ajax({
                    url: "${ctp}/community/getCmContent",
                    type: "post",
                    data: { cmIdx: vo.cmIdx },
                    success: function(res) {
                        resolve(res);
                    },
                    error: function() {
                        reject("전송오류!");
                    }
                });
            });
            editContent = res;
            $('#summernote2').summernote('code', editContent);
            $('#summernote2').next('.note-editor').find('.note-editable img').each(function() {
                let src = $(this).attr('src');
                if (src.indexOf('http') === -1) {
                    editInitialImages.push(src);
                }
            });

        } catch (error) {
            alert(error);
        }
    }
	
	
	// CommunityVO 형식의 문자열을 파싱하여 객체로 변환하는 함수
    function parseCommunityVO(voString) {
    	voString = voString.replace(/^CommunityVO\((.*)\)$/, '$1'); // 마지막 괄호 제거
       const regex = /(\w+)=([^,]+)(?=,|$)/g;
       const vo = {};
       let match;

       while ((match = regex.exec(voString)) !== null) {
           const key = match[1];
           let value = match[2];

           // 숫자 변환
           if (!isNaN(value) && value.trim() !== '') {
               value = Number(value);
           }

           // Boolean 변환
           if (value === 'true') {
               value = true;
           } else if (value === 'false') {
               value = false;
           }

           // 특수문자 복원 (문자열에 대해서만)
           if (typeof value === 'string') {
               value = value.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
           }

           vo[key] = value;
       }

       return vo;
   }

	
	function showPopupGameSearch() {
		document.getElementById("gamesearch").value = "";
		$("#results-container").hide();
    	const popup = document.querySelector('#popup-gamesearch');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
    }
	
	function gamelistAdd(gameIdx) {
		$.ajax({
            url: '${ctp}/community/memGameListEdit',
            type: 'POST',
            data: {gameIdx : gameIdx},
            success: function(res) {
            	let r = res.split("|");
           		let str = '<button class="gamesearch-button" onclick="showPopupGameSearch()">'
                   		+ '<img src="${ctp}/images/plus.jpg" alt="">'
               			+ '<div class="game-name">게임 선택</div></button>';
               	str = str + r[0] + '</div>';
           		let str2 = '<button class="gamesearch-button" onclick="showPopupGameSearch()">'
                   		+ '<img src="${ctp}/images/plus.jpg" alt="">'
               			+ '<div class="game-name">게임 선택</div></button>';
               	str2 = str2 + r[1] + '</div>';
           		$("#game-selection").html(str);
           		$("#game-selection2").html(str2);
           		
           		let html = '';
   	            const game = $('.game-button.active').data('game');
   	            const category = $('.community-category.active').data('category');
   	            if(category == '일지') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 일지';
   	            else if(category == '소식/정보') html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 소식/정보';
   	            else html = '<font color="#00c722"><b>'+game+'</b></font>에 대한 세일 정보';
   	            $(".header-text").html(html);
   	            
           		let html2 = '';
   	            const game2 = $('.gameedit-button.active').data('game');
   	            const category2 = $('.community-editcategory.active').data('category');
   	            if(category2 == '일지') html2 = '<font color="#00c722"><b>'+game2+'</b></font>에 대한 일지';
   	            else if(category2 == '소식/정보') html2 = '<font color="#00c722"><b>'+game2+'</b></font>에 대한 소식/정보';
   	            else html2 = '<font color="#00c722"><b>'+game2+'</b></font>에 대한 세일 정보';
   	            $(".header-edittext").html(html2);
   	            
           		document.querySelector('#popup-gamesearch').classList.add('hide');
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
		let ans = confirm("좋아요를 취소하시겠어요?");
		
		if(ans) {
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
	}
	
 	function toggleContentMenu(cmIdx) {
 	   	const elements = document.querySelectorAll('[id^="contentMenu"]');
 	   	const otherElements = Array.from(elements).filter(element => element.id !== "contentMenu" + cmIdx); // 필터 적용해 조건부로 가져오기
 	    let dropdown = document.getElementById("contentMenu"+cmIdx);
 	    
 	   otherElements.forEach(element => {
 	   		element.style.display = "none";
 		});
 	    
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	    }
 	}
 	
 	function contentDelete(cmIdx) {
		let ans = confirm("정말로 삭제하시겠습니까?");
		if(ans) {
			$.ajax({
				url : "${ctp}/community/communityDelete",
				type : "post",
				data : {cmIdx:cmIdx},
				success : function(res) {
					if(res != "0") location.reload();
					else alert("삭제실패!");
				},
				error : function() {
					alert("전송오류!");
				}
			});
		}
	}
 	
 	function replyPreview(cmIdx) {
		document.getElementById("replyPreview"+cmIdx).style.display = "none";
		document.getElementById("replyWrite"+cmIdx).style.display = "block";
		document.getElementById("replyContent"+cmIdx).focus();
	}
 	
 	function replyCancel(cmIdx) {
		document.getElementById("replyPreview"+cmIdx).style.display = "flex";
		document.getElementById("replyWrite"+cmIdx).style.display = "none";
	}
 	
 	function replyInput(cmIdx) {
 		let replyContent = $("#replyContent"+cmIdx).val().trim();
 		
 		if(replyContent == "") {
 			alert("댓글을 입력해주세요");
 			return false;
 		}
 		
		$.ajax({
			url : "${ctp}/community/replyInput",
			type : "post",
			data : {replyCmIdx : cmIdx, replyContent : replyContent},
			success : function(response) {
				let res = response.split("|");
				if(res[0] != "0") {
					replyCancel(cmIdx);
					$("#replyList"+cmIdx).html(res[1]);
					$("#replyContent"+cmIdx).val("");
				}
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function parentReplyMore(cmIdx) {
		$.ajax({
			url : "${ctp}/community/parentReplyMore",
			type : "post",
			data : {replyCmIdx : cmIdx},
			success : function(res) {
				$("#replyList"+cmIdx).html(res);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function rreplyPreview(replyIdx) {
 	   	const elements = document.querySelectorAll('[id^="rreplyWrite"]');
 	   	const otherElements = Array.from(elements).filter(element => element.id !== "rreplyWrite" + replyIdx); // 필터 적용해 조건부로 가져오기
 	    let toggle = document.getElementById("rreplyWrite"+replyIdx);
 	    
 	   otherElements.forEach(element => {
 	   		element.style.display = "none";
 		});
 	    
 	    if (toggle.style.display === "block") {
 	    	toggle.style.display = "none";
 	    } else {
 	    	toggle.style.display = "block";
 	    }
	}
 	
 	function rreplyInput(replyIdx, cmIdx) {
 		let rreplyContent = $("#rreplyContent"+replyIdx).val().trim();
 		
 		if(rreplyContent == "") {
 			alert("답글을 입력해주세요");
 			return false;
 		}
 		
		$.ajax({
			url : "${ctp}/community/rreplyInput",
			type : "post",
			data : {replyCmIdx : cmIdx, replyParentIdx : replyIdx, replyContent : rreplyContent},
			success : function(response) {
				let res = response.split("|");
				if(res[0] != "0") {
					rreplyPreview(replyIdx);
					$("#rreplyList"+replyIdx).html(res[1]);
					$("#rreplyContent"+replyIdx).val("");
				}
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function childReplyMore(replyIdx, cmIdx) {
		$.ajax({
			url : "${ctp}/community/childReplyMore",
			type : "post",
			data : {replyCmIdx : cmIdx, replyParentIdx : replyIdx},
			success : function(res) {
				$("#rreplyList"+replyIdx).html(res);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
 	
 	function replyEditPopup(replyIdx, replyContent) {
    	const popup = document.querySelector('#popup-replyedit');
    	const html = document.querySelector('html');
        $("#replyedit").val(replyContent);
        $("#replyIdx").val(replyIdx);
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
	}
 	
 	function replyEdit(cmIdx) {
 		let replyedit = $("#replyedit").val().trim();
 		let replyIdx = $("#replyIdx").val();
 		let replyMid = $("#replyMid").val();
 		
 		$.ajax({
 			url : "${ctp}/community/replyEdit",
 			type : "post",
 			data : {replyContent : replyedit, replyIdx : replyIdx, replyMid : replyMid},
 			success : function(response) {
				let res = response.split("|");
				if(res[0] != "0") {
					$("#replyList"+res[2]).html(res[1]);
					closePopup('replyedit');
				}
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function replyDelete(replyIdx, sw) {
		let ans = '';
		if(sw == 0) ans = confirm("댓글을 삭제하시겠어요?\n답글도 전부 삭제됩니다!");
		else ans = confirm("답글을 삭제하시겠어요?");
		
		if(ans) {
	 		$.ajax({
	 			url : "${ctp}/community/replyDelete",
	 			type : "post",
	 			data : {replyIdx : replyIdx},
	 			success : function(res) {
					if(res != "0") {
						location.reload();
					}
				},
	 			error : function() {
					alert("전송오류!");
				}
	 		});
		}
	}
 	
 	function followAdd(youMid) {
 		$.ajax({
 			url : "${ctp}/community/followInput",
 			type : "post",
 			data : {youMid : youMid},
 			success : function() {
				const elements = document.querySelectorAll('.fb'+youMid);
				elements.forEach(element => {
		 	   		element.style.display = "none";
		 		});
				
				const elements2 = document.querySelectorAll('.ufb'+youMid);
				elements2.forEach(element2 => {
		 	   		element2.style.display = "block";
		 		});
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function followDelete(youMid) {
 		$.ajax({
 			url : "${ctp}/community/followDelete",
 			type : "post",
 			data : {youMid : youMid},
 			success : function() {
				const elements = document.querySelectorAll('.fb'+youMid);
				elements.forEach(element => {
		 	   		element.style.display = "block";
		 		});
				
				const elements2 = document.querySelectorAll('.ufb'+youMid);
				elements2.forEach(element2 => {
		 	   		element2.style.display = "none";
		 		});
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function reportPopup(contentIdx, contentPart, sufferMid) {
    	const popup = document.querySelector('#popup-report');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        html.style.overflow = 'hidden';
        $("#contentIdx").val(contentIdx);
        $("#contentPart").val(contentPart);
        $("#sufferMid").val(sufferMid);
	}
 	
 	function reportInput() {
		let reason = $("select[name=reason]").val();
		let contentIdx = $("#contentIdx").val();
		let contentPart = $("#contentPart").val();
		let sufferMid = $("#sufferMid").val();
		
		if(reason == '') {
			alert("신고사유를 선택해주세요");
			return false;
		}
		
 		$.ajax({
 			url : "${ctp}/community/reportInput",
 			type : "post",
 			data : {reportMid : '${sMid}', sufferMid:sufferMid, contentPart:contentPart, contentIdx:contentIdx, reason:reason},
 			success : function() {
 				alert("신고가 정상접수 되었습니다!");
 				closePopup('report');
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
					<span class="c-button" onclick="location.href='${ctp}/community/follow';">팔로우</span>
					<span class="c-button" onclick="location.href='${ctp}/community/recent';">최신</span>
					<span class="c-button" onclick="location.href='${ctp}/community/review';">리뷰</span>
					<span class="c-button c-button-active" onclick="location.href='${ctp}/community/info';">소식/정보</span>
					<span class="c-button" onclick="location.href='${ctp}/community/sale';">세일</span>
					<c:if test="${sMid != null}"><span class="c-button" onclick="location.href='${ctp}/community/my';">내글</span></c:if>
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
					<div class="cm-box" id="cmbox${cmVO.cmIdx}">
						<div style="display:flex;justify-content: space-between;">
							<div style="display:flex; align-items:center;">
								<img src="${ctp}/member/${cmVO.memImg}" alt="프로필" class="text-pic">
								<div>
									<c:if test="${cmVO.title != '없음'}"><div style="font-size:12px;">${cmVO.title}</div></c:if>
									<div style="font-weight:bold;">${cmVO.nickname}</div>
									<div>
										<c:if test="${cmVO.part == '소식/정보'}"><span class="badge badge-secondary">소식/정보</span>&nbsp;</c:if>
										<c:if test="${cmVO.part == '자유'}"><span class="badge badge-secondary">자유글</span>&nbsp;</c:if>
										<c:if test="${cmVO.part == '세일'}"><span class="badge badge-secondary">세일정보</span>&nbsp;</c:if>
										<c:if test="${cmVO.part != '자유'}">
										<div style="color:#b2bdce; font-size:12px; cursor:pointer;" onclick="location.href='${ctp}/gameview/${cmVO.cmGameIdx}';">
											<i class="fa-solid fa-gamepad fa-xs" style="color: #b2bdce;"></i>&nbsp;
											${cmVO.gameTitle}
										</div>
										</c:if>
									</div>
								</div>
							</div>
							<c:if test="${sMid != null}">
								<div style="display: flex; align-items: center;">
									<c:if test="${sMid != cmVO.mid && cmVO.follow == 0}"><div class="replyok-button mr-4 fb${cmVO.mid}" onclick="followAdd('${cmVO.mid}')"><i class="fa-solid fa-plus fa-sm"></i>&nbsp;팔로우</div></c:if>
									<div style="position:relative;">
										<i class="fa-solid fa-bars fa-xl" onclick="toggleContentMenu(${cmVO.cmIdx})" style="color: #D5D5D5;cursor:pointer;"></i>
							 			<div id="contentMenu${cmVO.cmIdx}" class="content-menu">
									        <c:if test="${sMid == cmVO.mid}"><div onclick="showPopupEdit('${fn:replace(fn:replace(cmVO, newLine, '<br>'), '\"', '&quot;')}')">수정</div></c:if>
										    <c:if test="${sMid == cmVO.mid || sLevel == 0}"><div onclick="contentDelete(${cmVO.cmIdx})"><font color="red">삭제</font></div></c:if>
									        <c:if test="${sLevel == 0}"><div onclick="location.href='${ctp}/admin/userlist?page=1&viewpart=all&searchpart=아이디&search=${cmVO.mid}';">사용자 제재</div></c:if>
									        <c:if test="${sMid != cmVO.mid && sLevel != 0}">
									        	<div class="ufb${cmVO.mid}" style="display:${cmVO.follow == 1 ? 'block' : 'none'};" onclick="followDelete('${cmVO.mid}')">언팔로우</div>
									        	<div onclick="reportPopup(${cmVO.cmIdx}, '게시글', '${cmVO.mid}')">신고</div>
									        </c:if>
								    	</div>
						 			</div>
						 		</div>
					 		</c:if>
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
				<span id="root"></span>
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
    		<div style="cursor:pointer;" onclick="closePopup('write')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
        <div class="category-selection">
            <button class="community-category" data-category="일지">일지</button>
            <button class="community-category active" data-category="소식/정보">소식/정보</button>
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
	            	<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" alt="${vo.gameTitle}"></c:if>
	            	<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" alt="${vo.gameTitle}"></c:if>
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
		</script>
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
<div id="popup-edit" style="z-index:999;" class="hide">
  <div class="popup-edit-content scrollbar">
  		<div class="popup-edit-header">
            <span class="header-edittext"></span>
    		<div style="cursor:pointer;" onclick="closePopup('edit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
        <div class="category-selection">
            <button class="community-editcategory active" data-category="일지">일지</button>
            <button class="community-editcategory" data-category="소식/정보">소식/정보</button>
            <button class="community-editcategory" data-category="자유">자유 주제</button>
            <button class="community-editcategory" data-category="세일">세일 글</button>
        </div>
        <div class="game-selection scrollbar" id="game-selection2">
            <button class="gamesearch-button" onclick="showPopupGameSearch()">
            	<img src="${ctp}/images/plus.jpg" alt="">
            	<div class="game-name">게임 선택</div>
            </button>
            <c:forEach var="vo" items="${vos}">
                <button class="gameedit-button" data-game="${vo.gameTitle}" data-editidx="${vo.gameIdx}">
	            	<c:if test="${fn:indexOf(vo.gameImg, 'http') == -1}"><img src="${ctp}/game/${vo.gameImg}" alt="${vo.gameTitle}"></c:if>
	            	<c:if test="${fn:indexOf(vo.gameImg, 'http') != -1}"><img src="${vo.gameImg}" alt="${vo.gameTitle}"></c:if>
	            	<div class="game-name">${vo.gameTitle}</div>
	            </button>
            </c:forEach>
        </div>
        <textarea id="summernote2" name="content"></textarea>
        <div class="footer">
            <select class="dropdown-btn" id="publicType2" name="publicType2">
                <option value="전체">전체 공개</option>
                <option value="친구">친구만 공개</option>
                <option value="비공개">비공개</option>
            </select>
            <button class="edit-button" onclick="editCommunity()">수정하기</button>
        </div>
        <!-- Summernote JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
	    
	    <script>
			// 이미지 업로드
		    function uploadImage2(file) {
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
		            success: function(res) {
	                    $('#summernote2').summernote('insertImage', res, function($image) {});
		            },
		            error: function() {
		                alert("전송오류!");
		            }
		        });
		    }
	
		    // 현재 창에 있는 이미지 가져오기
		    function getCurrentImages2() {
		        return $('#summernote2').next('.note-editor').find('.note-editable img').map(function() {
		            return $(this).attr('src');
		        }).get();
		    }
	
		    // 이미지 삭제 실행함수
		    function detectDeletedImages2(editInitialImages, editCurrentImages) {
		    	editInitialImages.forEach(function(src) {
		            if (!editCurrentImages.includes(src)) {
		                deleteImage(src);
		            }
		        });
		    }
		    
		 	// 수정하기 버튼 클릭
	        function editCommunity() {
		        let content = $('#summernote2').summernote('code').trim();
		        let category = $('.community-editcategory.active').data('category');
		        let gameIdx = $('.gameedit-button.active').data('editidx');
		        let publicType = $('select[name="publicType2"]').val();
		        
		        if(gameIdx === undefined) {
		        	gameIdx = editCmGameIdx;
		        }

		        if (content == '' || content == '<p><br></p>') {
		            alert("글 내용을 입력하세요!");
		            $('#summernote2').focus();
		            return false;
		        }

		        let query = {
		            cmContent: content,
		            part: category,
		            cmGameIdx: gameIdx,
		            publicType: publicType,
		            cmIdx : editCmIdx
		        };

		        $.ajax({
		            url: "${ctp}/community/communityEdit",
		            type: "post",
		            data: query,
		            success: function(res) {
		                if (res != "0") {
		                	isWriteButtonClicked = true;
		                    editCurrentImages = getCurrentImages2();
		                    detectDeletedImages2(editInitialImages, editCurrentImages);
		                    editInitialImages = [...editCurrentImages];
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
		 	}
		</script>
    </div>
</div>
<div id="popup-replyedit" class="hide">
  <div class="popup-replyedit-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">댓글 수정</span>
    		<div style="cursor:pointer;" onclick="closePopup('replyedit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
 		<div><input type="text" id="replyedit" name="replyedit" class="forminput mb-3" style="width:100%" placeholder="수정할 댓글을 입력하세요"></div>
 		<input type="hidden" id="replyIdx" name="replyIdx" />
 		<input type="hidden" id="replyMid" name="replyMid" value="${sMid}" />
	 	<div class="text-right"><button class="edit-button" onclick="replyEdit()">수정하기</button></div>
    </div>
</div>
<div id="popup-report" class="hide">
  <div class="popup-report-content scrollbar">
  		<div class="popup-replyedit-header mb-4">
            <span class="e-header-text">신고하기</span>
    		<div style="cursor:pointer;" onclick="closePopup('report')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<div class="mb-3">확실히 신고사유가 되는지 확인하고 신고하여 주십시오 무분별한 신고 시 <b style="color:red;">신고자가 제재</b>를 당할 수 있습니다</div>
		<div class="text-center mb-4"><select class="dropdown-btn" name="reason">
			<option value="">신고사유 선택</option>
			<option>스팸</option>
			<option>스포일러</option>
			<option value="선정성">나체이미지 또는 성적행위</option>
			<option>사기</option>
			<option value="욕설혐오">욕설, 혐오 발언</option>
			<option>지식재산권 침해</option>
			<option value="명예훼손">타인의 명예 훼손</option>
		</select></div>
 		<input type="hidden" id="contentIdx" name="contentIdx" />
 		<input type="hidden" id="contentPart" name="contentPart" />
 		<input type="hidden" id="sufferMid" name="sufferMid" />
	 	<div class="text-center"><button class="btn btn-danger" onclick="reportInput()">신고하기</button></div>
    </div>
</div>
</body>
</html>