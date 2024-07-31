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
<title>${vo.gameTitle} 소식/정보 | 인겜토리</title>
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
	
	let mid = '${sMid}';
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
				data : {page : ${page}+totPage, part : 'recent'},
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
        
       	editCmIdx = vo.cmIdx;
       	editCmGameIdx = vo.cmGameIdx;
       	editGameTitle = vo.gameTitle;
        
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
 	
 	function showPopupInput(gameIdx, flag) {
		if(mid == '') {
			showPopupLogin();
			return false;
		}
		
		$("#summernote").summernote('code', '');
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
 	
 	function communityInput() {
		let mid = '${sMid}';
        let content = $('#summernote').summernote('code').trim();
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
<main>
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
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/review';">리뷰 ${reviewCnt}</div>
	            <div class="tab" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/record';">일지 ${ilgiCnt}</div>
	            <div class="tab active" onclick="location.href='${ctp}/gameview/${vo.gameIdx}/info';">소식/정보 ${infoCnt}</div>
	        </div>
	        <button class="editplz-button" onclick="showGameEditPopup()">정보수정요청</button>
	    </div>
		<div style="width:100%;">
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
			<c:if test="${fn:length(cmVOS) == 0}">
				<div style="margin: 100px 20px; text-align: center;">
					<div>보여드릴 소식/정보가 없습니다.</div>
					<div>가장 먼저 이 게임의 소식/정보를 남겨보세요.</div>
					<div class="editplz-button mt-2" style="margin: 0 auto; width: 30%;" onclick="showPopupInput(${vo.gameIdx}, '소식/정보')">소식/정보 작성</div>
				</div>
			</c:if>
			<span id="root"></span>
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
            <button class="community-category" data-category="일지">일지</button>
            <button class="community-category active" data-category="소식/정보">소식/정보</button>
            <button class="community-category" data-category="자유">자유 주제</button>
            <button class="community-category" data-category="세일">세일 글</button>
        </div>
        <textarea id="summernote" name="content"></textarea>
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
<div id="popup-edit" style="z-index:999;" class="hide">
  <div class="popup-edit-content scrollbar">
  		<div class="popup-edit-header">
            <span class="header-edittext"></span>
    		<div style="cursor:pointer;" onclick="closePopup('edit')"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></div>
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
            <button class="community-editcategory" data-category="일지">일지</button>
            <button class="community-editcategory active" data-category="소식/정보">소식/정보</button>
            <button class="community-editcategory" data-category="자유">자유 주제</button>
            <button class="community-editcategory" data-category="세일">세일 글</button>
        </div>
        <textarea id="summernote2" name="content"></textarea>
        <div class="footer">
            <select class="dropdown-btn" id="publicType2" name="publicType2">
                <option value="전체">전체 공개</option>
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
		        if(content.indexOf('<p>') == -1) content = '<p>'+content+'</p>';
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