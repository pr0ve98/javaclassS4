<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
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
<title>${vo.gameTitle} | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/wordcloud2.js/1.0.6/wordcloud2.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script>
	'use strict';
	
	let isWriteButtonClicked = false;
	
	let initialContent = '';
	let initialImages = [];
	let currentImages = [];
	let mid = '${sMid}';
	let currentRating = 0;
	
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
	    
		const ebuttons = document.querySelectorAll('.eg-button');
        
        ebuttons.forEach(ebutton => {
        	ebutton.addEventListener('click', function () {
                ebutton.classList.toggle('eg-button-active');
            });
        });
        
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
            // Summernote에 대한 로직
            if (initialImages.length > 0) {
                initialImages.forEach(function(src) {
                    deleteImage(src);
                });
            }
        }
    };
	
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
	
	function gameViewCommunityView(cmIdx) {
    	const popup = document.querySelector('#popup-edit');
    	const html = document.querySelector('html');
    	
    	$.ajax({
            url: "${ctp}/gameViewCommunityView",
            type: "post",
            data: {cmIdx : cmIdx},
            success: function(res) {
				$("#communityView").html(res);
		        popup.classList.remove('hide');
		        html.style.overflow = 'hidden';
            },
            error: function() {
               alert("전송오류!");
            }
    	});
	}
	
	function showPopupInput(gameIdx, flag) {
		if(mid == '') {
			showPopupLogin();
			return false;
		}
		
		$("#summernote2").summernote('code', '');
		$('.community-category').removeClass('active');
		
        if(flag == '일지') $('.community-category[data-category="일지"]').addClass('active');
        else if(flag == '소식/정보') $('.community-category[data-category="소식/정보"]').addClass('active');
        
		if (!isWriteButtonClicked) {
            // Summernote에 대한 로직
            if (initialImages.length > 0) {
                initialImages.forEach(function(src) {
                    deleteImage(src);
                });
            }
        }
		
    	const popup = document.querySelector('#popup-write');
    	const html = document.querySelector('html');
    	
		popup.classList.remove('hide');
		html.style.overflow = 'hidden';
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
	
	function communityInput() {
		let mid = '${sMid}';
        let content = $('#summernote2').summernote('code').trim();
        let gameIdx = $('#writeGameIdx').val();
        if(content.indexOf('<p>') == -1) content = '<p>'+content+'</p>';
        let category = $('.community-category.active').data('category');
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
				$("#viewLike"+cmIdx).html(r[0]);
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
					$("#viewLike"+cmIdx).html(r[0]);
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
 	
 	function showGameEditPopup() {
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
	            <div class="tab active" onclick="location.href='${ctp}/gameview/${vo.gameIdx}';">상세정보</div>
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/review';">리뷰 ${reviewContentCnt}</div>
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/record';">일지 ${ilgiCnt}</div>
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/info';">소식/정보 ${infoCnt}</div>
	        </div>
	        <button class="editplz-button" onclick="showGameEditPopup()">정보수정요청</button>
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
		    		<div class="cm-box mt-3 mb-3" onclick="gameViewCommunityView(${posiBest.cmIdx})">
						<div style="display:flex;justify-content: space-between; align-items: center;">
							<div>
								<img src="${ctp}/member/${posiBest.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b>${posiBest.nickname}</b>님이 평가를 남기셨습니다
							</div>
							<div class="badge badge-success">긍정리뷰 BEST</div>					
						</div>
						<hr/>
						<div style="display:flex; margin: 0 20px; align-items:center; gap:5px;">
							<c:forEach begin="1" end="${posiBest.rating}">
								<img src="${ctp}/images/starpull.png" width="30px" height="30px" />
							</c:forEach>
							<c:forEach begin="1" end="${5-posiBest.rating}">
								<img src="${ctp}/images/star.png" width="30px" height="30px" />
							</c:forEach>
						</div>
						<div class="community-content" style="color:#fff;">
							<div class="cm-content ${posiBest.longContent == 1 ? 'moreGra' : ''}">${posiBest.cmContent}</div>
							<c:if test="${posiBest.longContent == 1}"><div onclick="showAllContent(${posiBest.cmIdx})" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="viewLike${posiBest.cmIdx}">이 글을 ${posiBest.likeCnt}명이 좋아합니다.</span></div>
						</div>
					</div>
				</c:if>
				<c:if test="${negaBest != null}">
		    		<div class="cm-box mt-3 mb-3" onclick="gameViewCommunityView(${negaBest.cmIdx})">
						<div style="display:flex;justify-content: space-between; align-items: center;">
							<div>
								<img src="${ctp}/member/${negaBest.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b>${negaBest.nickname}</b>님이 평가를 남기셨습니다
							</div>
							<div class="badge badge-danger">비판리뷰 BEST</div>					
						</div>
						<hr/>
						<div style="display:flex; margin: 0 20px; align-items:center; gap:5px;">
							<c:forEach begin="1" end="${negaBest.rating}">
								<img src="${ctp}/images/starpull.png" width="30px" height="30px" />
							</c:forEach>
							<c:forEach begin="1" end="${5-negaBest.rating}">
								<img src="${ctp}/images/star.png" width="30px" height="30px" />
							</c:forEach>
						</div>
						<div class="community-content" style="color:#fff;">
							<div class="cm-content ${negaBest.longContent == 1 ? 'moreGra' : ''}">${negaBest.cmContent}</div>
							<c:if test="${negaBest.longContent == 1}"><div onclick="showAllContent(${negaBest.cmIdx})" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="viewLike${negaBest.cmIdx}">이 글을 ${negaBest.likeCnt}명이 좋아합니다.</span></div>
						</div>
					</div>
				</c:if>
				<c:if test="${myReview != null}">
		    		<div class="cm-box mt-3 mb-3" onclick="gameViewCommunityView(${myReview.cmIdx})">
						<div style="display:flex;justify-content: space-between; align-items: center;">
							<div>
								<img src="${ctp}/member/${myReview.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b>${myReview.nickname}</b>님이 평가를 남기셨습니다
							</div>
							<div class="badge badge-light">내 리뷰</div>					
						</div>
						<hr/>
						<div style="display:flex; margin: 0 20px; align-items:center; gap:5px;">
							<c:forEach begin="1" end="${myReview.rating}">
								<img src="${ctp}/images/starpull.png" width="30px" height="30px" />
							</c:forEach>
							<c:forEach begin="1" end="${5-myReview.rating}">
								<img src="${ctp}/images/star.png" width="30px" height="30px" />
							</c:forEach>
						</div>
						<div class="community-content" style="color:#fff;">
							<div class="cm-content ${myReview.longContent == 1 ? 'moreGra' : ''}">${myReview.cmContent}</div>
							<c:if test="${myReview.longContent == 1}"><div onclick="showAllContent(${myReview.cmIdx})" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
							<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="viewLike${myReview.cmIdx}">이 글을 ${myReview.likeCnt}명이 좋아합니다.</span></div>
						</div>
					</div>
				</c:if>
				<c:if test="${negaBest != null || posiBest != null || myReview != null}">
					<div class="editplz-button mt-2" style="background-color:#00c72299;" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/review';">${reviewContentCnt}개의 리뷰 모두 보기</div>
				</c:if>
				<c:if test="${negaBest == null && posiBest == null && myReview == null}">
					<div style="margin: 100px 20px; text-align: center;">
						<div>보여드릴 리뷰가 없습니다.</div>
						<div>가장 먼저 이 게임의 리뷰를 남겨보세요.</div>
						<div class="editplz-button mt-2" style="margin: 0 auto; width: 30%;" onclick="showPopupWrite()">리뷰 작성</div>
					</div>
				</c:if>
				<hr/>
		    		<h3>일지</h3>
		    		<c:if test="${fn:length(ilgilist) > 0}">
		    		<c:forEach var="ilgi" items="${ilgilist}">
						<div class="cm-box"  onclick="gameViewCommunityView(${ilgi.cmIdx})">
							<div style="display:flex;justify-content: space-between;">
								<div style="display:flex; align-items:center;">
									<img src="${ctp}/member/${ilgi.memImg}" alt="프로필" class="text-pic">
									<div>
										<c:if test="${ilgi.title != '없음'}"><div style="font-size:12px;">${ilgi.title}</div></c:if>
										<div style="font-weight:bold;">${ilgi.nickname}</div>
										<div>
											<div style="color:#b2bdce; font-size:12px; cursor:pointer;" onclick="location.href='${ctp}/gameview/${ilgi.cmGameIdx}';">
												<i class="fa-solid fa-gamepad fa-xs" style="color: #b2bdce;"></i>&nbsp;
												${ilgi.gameTitle}
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="community-content">
								<div class="cm-content ${ilgi.longContent == 1 ? 'moreGra' : ''}">${ilgi.cmContent}</div>
								<c:if test="${ilgi.longContent == 1}"><div style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
								<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="viewLike${ilgi.cmIdx}">이 글을 ${ilgi.likeCnt}명이 좋아합니다.</span></div>
							</div>
						</div>
					</c:forEach>
					<div class="editplz-button mt-2" style="background-color:#00c72299;" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/record';">${ilgiCnt}개의 일지 모두 보기</div>
					</c:if>
					<c:if test="${fn:length(ilgilist) == 0}">
						<div style="margin: 100px 20px; text-align: center;">
							<div>보여드릴 일지가 없습니다.</div>
							<div>가장 먼저 이 게임의 일지를 남겨보세요.</div>
							<div class="editplz-button mt-2" style="margin: 0 auto; width: 30%;" onclick="showPopupInput(${vo.gameIdx}, '일지')">일지 작성</div>
						</div>
					</c:if>
		    		<hr/>
		    		<h3>소식/정보</h3>
		    		<c:if test="${fn:length(infolist) > 0}">
		    		<c:forEach var="info" items="${infolist}">
						<div class="cm-box" onclick="gameViewCommunityView(${info.cmIdx})">
							<div style="display:flex;justify-content: space-between;">
								<div style="display:flex; align-items:center;">
									<img src="${ctp}/member/${info.memImg}" alt="프로필" class="text-pic">
									<div>
										<c:if test="${info.title != '없음'}"><div style="font-size:12px;">${info.title}</div></c:if>
										<div style="font-weight:bold;">${info.nickname}</div>
										<div>
											<span class="badge badge-secondary">소식/정보</span>&nbsp;
											<div style="color:#b2bdce; font-size:12px; cursor:pointer;" onclick="location.href='${ctp}/gameview/${info.cmGameIdx}';">
												<i class="fa-solid fa-gamepad fa-xs" style="color: #b2bdce;"></i>&nbsp;
												${info.gameTitle}
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="community-content">
								<div class="cm-content ${info.longContent == 1 ? 'moreGra' : ''}">${info.cmContent}</div>
								<c:if test="${info.longContent == 1}"><div style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
								<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="viewLike${info.cmIdx}">이 글을 ${info.likeCnt}명이 좋아합니다.</span></div>
							</div>
						</div>
					</c:forEach>
					<div class="editplz-button mt-2" style="background-color:#00c72299;" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/info';">${infoCnt}개의 소식/정보 모두 보기</div>
					</c:if>
					<c:if test="${fn:length(infolist) == 0}">
						<div style="margin: 100px 20px; text-align: center;">
							<div>보여드릴 소식/정보가 없습니다.</div>
							<div>가장 먼저 이 게임의 소식/정보를 남겨보세요.</div>
							<div class="editplz-button mt-2" style="margin: 0 auto; width: 30%;" onclick="showPopupInput(${vo.gameIdx}, '소식/정보')">소식/정보 작성</div>
						</div>
					</c:if>
		    		<hr/>
		    		<h3>게임 소개</h3>
		    		<div style="margin-bottom: 100px;">${fn:replace(vo.gameInfo, newLine, '<br>')}</div>
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
        <div class="category-selection">
            <button class="community-category active" data-category="일지">일지</button>
            <button class="community-category" data-category="소식/정보">소식/정보</button>
            <button class="community-category" data-category="자유">자유 주제</button>
            <button class="community-category" data-category="세일">세일 글</button>
        </div>
        <textarea id="summernote2" name="content"></textarea>
        <div class="footer">
            <select class="dropdown-btn" id="publicType" name="publicType">
                <option value="전체">전체 공개</option>
                <option value="비공개">비공개</option>
            </select>
            <button class="post-button" onclick="communityInput()">게시하기</button>
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
	                    $('#summernote2').summernote('insertImage', response, function($image) {
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
		        return $('#summernote2').next('.note-editor').find('.note-editable img').map(function() {
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
		</script>
    </div>
</div>
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
<div id="popup-edit" class="hide">
  <div class="popup-edit-content scrollbar" style="background-color: #161d25;">
  		<div class="popup-write-header">
            <span class="header-text"></span>
    		<div style="cursor:pointer;" onclick="closePopup('edit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
		</div>
		<hr/>
        <div id="communityView"></div>
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
						<th>출시일</th>
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