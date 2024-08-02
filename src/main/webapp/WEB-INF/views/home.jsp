<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width" />
<title>나만의 인겜토리!</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
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
	
 	function bannerChange() {
		$("#inputImgs").trigger('click');
	}
	
	function bannerChangeImg() {
		let fName = document.getElementById("inputImgs").value;
		let ext = fName.substring(fName.lastIndexOf(".")+1).toLowerCase();
		
		if(fName.trim() == ""){
			alert("업로드할 파일을 선택하세요");
			return false;
		}
		
		if(ext != 'jpg'){
			alert("jpg 파일만 업로드해주세요");
		}
		else {
			let formData = new FormData();
			formData.append("fName", document.getElementById("inputImgs").files[0]);
			
			$.ajax({
				url : "${ctp}/admin/bannerChange",
				type : "post",
				data : formData,
				processData: false,
				contentType: false,
				success : function(res) {
					alert("변경완료!");
					location.reload();
				},
				error : function() {
					alert("오류!!");
				}
			});
		}
	}
	
	function mygamePartChange() {
		let part = $("#mygamePart").val();
		$.ajax({
			url : "${ctp}/mygamePartChange",
			type : "post",
			data : {part:part},
			success : function(res) {
				$("#mygameList").html(res);
			},
			error : function() {
				alert("오류!!");
			}
		});
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
		<div class="banner"><img alt="배너" src="${ctp}/resources/images/banner1.jpg" width="100%"></div>
		<c:if test="${sLevel == 0}">
			<div class="text-right" style="cursor:pointer" onclick="bannerChange()"><i class="fa-solid fa-repeat fa-xs"></i></div>
			<div style="display:none"><input type="file" name="fName" id="inputImgs" accept=".jpg" onchange="bannerChangeImg()" /></div>
		</c:if>
		<div class="content1">
			<div class="news">
				<div class="news-title">
					<span>📰 뉴스</span>
					<span class="more" onclick="location.href='${ctp}/news/newsRecent';">더보기</span>
				</div>
				<div class="content-box">
					<div class="news-img">
						<div>
							<img src="${ctp}/resources/images/news1.jpg" alt="뉴스이미지">
							<div>서머 게임 페스트 2024 발표 게임 총정리 (1/2)</div>
						</div>
						<div>
							<img src="${ctp}/resources/images/news2.jpg" alt="뉴스이미지">
							<div>2024년 6월 닌텐도 다이렉트 총정리</div>
						</div>
					</div>
					<hr/>
					<div class="news-text">[6월 넷째 주 뉴스레터] 크래프톤 : 해당 문제 가능성에 대해 충분히 예상</div>
					<hr/>
					<div class="news-text">7년째 개발 중! 슬롯 매니징 로그라이크 'RP7'을 개발한 박선용 디렉터 인터뷰</div>
					<hr/>
					<div class="news-text">닌텐도 스위치용 ‘에이스 컴뱃 7: 스카이즈 언노운 디럭스 에디션’(한국어판) 패키지 선주문 판매 6월 26일(수) 오후 3시 시작!</div>
					<hr/>
					<div class="news-text">'슈퍼 몽키 볼 바나나 럼블', 6월 25일(화) 발매</div>
					<div class="news-page">
						<button class="prev" onclick="prevPage()"><i class="fa-solid fa-chevron-left fa-2xs"></i></button>
				        <span class="page-info">1/4</span>
				        <button class="next" onclick="nextPage()"><i class="fa-solid fa-chevron-right fa-2xs"></i></button>
					</div>
				</div>
			</div>
			<div class="mygames">
				<div class="mygames-title">
					<span>🎮 내 게임</span>
					<c:if test="${sMid != null}"><span class="more">내 게임</span></c:if>
				</div>
				<div class="content-box">
			        <div class="game-status">
			            <div class="game-info">
			                <div class="game-title">내 게임</div>
			                <div class="game-count">${sMid != null ? myGameAllCount : '-'}</div>
			                <c:if test="${sMid != null}">
				                <div class="game-details">
				                    <div class="cnt-item"><span>5점 게임</span><span>${myGame5Star}</span></div>
				                    <div class="cnt-item"><span>3점이상 게임</span><span>${myGame3Star}</span></div>
				                    <div class="cnt-item"><span>2점이하 게임</span><span>${myGame2Star}</span></div>
				                </div>
			                </c:if>
			            </div>
			            <div class="status-info">
			                <div class="status">
			                    <div class="game-title">게임 상태</div>
			                    <div class="status-detail">
			                        <div class="cnt-item"><span><i class="fa-solid fa-play fa-sm" style="color: #0085eb;"></i>&nbsp;&nbsp;하고있어요</span><span>${sMid != null ? myGamePlay : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-check" style="color: #00c722;"></i>&nbsp;&nbsp;다했어요</span><span>${sMid != null ? myGameDone : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-xmark" style="color: #f50000;"></i>&nbsp;&nbsp;그만뒀어요</span><span>${sMid != null ? myGameStop : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-folder fa-sm" style="color: #d9d9d9;"></i>&nbsp;&nbsp;모셔놨어요</span><span>${sMid != null ? myGameFolder : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-thumbtack fa-sm" style="color: #fff700;"></i>&nbsp;&nbsp;관심있어요</span><span>${sMid != null ? myGamePin : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-ellipsis" style="color:#37414cd6;"></i>&nbsp;&nbsp;상태없음</span><span>${sMid != null ? myGameNone : '-'}</span></div>
			                    </div>
			                </div>
			            </div>
			        </div>
			        <hr/>
			        <div class="recent-games">
			            <div class="dropdown">
			                <select id="mygamePart" class="dropdown-btn" onchange="mygamePartChange()">
			                    <option value="recent">최근 담은 게임</option>
			                    <option value="recentReview">최근 평가한 게임</option>
			                    <option value="nowPlaying">지금 하고있는 게임</option>
			                    <option value="highStar">별점 높은 게임</option>
			                </select>
			            </div>
			            <div class="game-list" id="mygameList">
			            	<c:if test="${sMid != null}">
			            		<c:forEach var="mygameVO" items="${mygameVOS}">
			            			<span class="game-item" onclick="location.href='${ctp}/gameview/${mygameVO.gameIdx}';">
			            				<c:if test="${fn:indexOf(mygameVO.gameImg, 'http') == -1}"><img src="${ctp}/game/${mygameVO.gameImg}"></c:if>
			            				<c:if test="${fn:indexOf(mygameVO.gameImg, 'http') != -1}"><img src="${mygameVO.gameImg}"></c:if>
			            				<span class="playState">
			            				<img src="${ctp}/images/${mygameVO.state}Icon.svg">
			            				</span>
			            			</span>
			            		</c:forEach>
			            		<c:if test="${fn:length(mygameVOS) < 4}">
				            		<c:forEach begin="1" end="${4-fn:length(mygameVOS)}">
					            		<span class="game-item"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            		</c:forEach>
			            		</c:if>
			            	</c:if>
			            	<c:if test="${sMid == null}">
				            	<span class="game-item"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            	<span class="game-item"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            	<span class="game-item"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            	<span class="game-item"><img src="${ctp}/images/nomygameimage.jpg"></span>
			            	</c:if>
			            </div>
			        </div>
				</div>
			</div>
		</div>
		<div class="content2">
			<div class="newgame">
				<div class="mygames-title">
					<span>💡 최근 발매된 게임</span>
				</div>
				<div class="content-box">
					<div class="newgame-list">
						<c:forEach var="newgame" items="${newgamelist}" varStatus="st">
							<div class="newgame-item" onclick="location.href='${ctp}/gameview/${newgame.gameIdx}';">
								<span class="newgame-item-img mb-2">
									<c:if test="${fn:indexOf(newgame.gameImg, 'http') != -1}"><img src="${newgame.gameImg}"></c:if>
									<c:if test="${fn:indexOf(newgame.gameImg, 'http') == -1}"><img src="${ctp}/game/${newgame.gameImg}"></c:if>
								</span>
								<span class="game-title">${newgame.gameTitle}</span>
								<span>
									<c:set var="showDate" value="${fn:split(newgame.showDate, '-')}" />
									${showDate[1]}.${showDate[2]}
								</span>
								<span>${newgame.platform}</span>
								<span class="newgame-text">${newgame.jangre}</span>
								<hr class="pc-line"/>
								<span class="newgame-info">${newgame.gameInfo}</span>
								<hr class="mobile-line" />
							</div>
							<c:if test="${fn:length(newgamelist) != st.count}"><div class="v-line"></div></c:if>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
		<div class="content2">
			<div class="newgame">
				<div class="mygames-title">
					<span>📑 추천 리뷰</span>
					<span class="more" onclick="location.href='${ctp}/community/review';">모두 보기</span>
				</div>
				<div class="content-box">
					<div class="review">
						<c:forEach var="bestReview" items="${bestReviews}">
							<div class="review-box" onclick="gameViewCommunityView(${bestReview.cmIdx})">
								<div class="review-header">
									<span class="review-h-img"><img src="${ctp}/member/${bestReview.memImg}"></span>
									<span class="review-h-nickName">${bestReview.nickname}</span>
									<span class="review-h-date">· 
										<c:if test="${bestReview.hour_diff < 1}">${bestReview.min_diff}분 전</c:if>
										<c:if test="${bestReview.hour_diff < 24 && bestReview.hour_diff >= 1}">${bestReview.hour_diff}시간 전</c:if>
										<c:if test="${bestReview.hour_diff >= 24}">${fn:substring(bestReview.cmDate, 0, 10)}</c:if>
									</span>
								</div>
								<hr/>
								<div>
									<div class="review-game">
										<c:if test="${fn:indexOf(bestReview.gameImg, 'http') != -1}"><img class="review-game-img" src="${bestReview.gameImg}"></c:if>
										<c:if test="${fn:indexOf(bestReview.gameImg, 'http') == -1}"><img class="review-game-img" src="${ctp}/game/${bestReview.gameImg}"></c:if>
										<div class="review-info">
											<div class="game-title">${bestReview.gameTitle}</div>
											<div class="review-game-info">
												<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;${bestReview.rating}</span>
												<span class="review-state-${bestReview.state}">
													<c:if test="${bestReview.state == 'play'}"><i class="fa-solid fa-play"></i>&nbsp;하고있어요</c:if>
													<c:if test="${bestReview.state == 'stop'}"><i class="fa-solid fa-xmark"></i>&nbsp;그만뒀어요</c:if>
													<c:if test="${bestReview.state == 'done'}"><i class="fa-solid fa-check"></i>&nbsp;다했어요</c:if>
													<c:if test="${bestReview.state == 'folder'}"><i class="fa-solid fa-folder"></i>&nbsp;모셔놨어요</c:if>
													<c:if test="${bestReview.state == 'pin'}"><i class="fa-solid fa-thumbtack"></i>&nbsp;관심있어요</c:if>
													<c:if test="${bestReview.state == 'none'}"><i class="fa-solid fa-ellipsis"></i>&nbsp;상태없음</c:if>
												</span>
											</div>
										</div>
									</div>
									<div>
										<div class="review-text">${bestReview.onlyText}</div>
										<div class="review-more">더 보기</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
		<div class="content1">
			<div class="popcommunity">
				<div class="popcommunity-title">
					<span>🔥 커뮤니티 인기글</span>
					<span class="more" onclick="location.href='${ctp}/community/recent';">더보기</span>
				</div>
				<div class="content-box">
					<div class="popcommunity-img">
						<div>
							<img src="${ctp}/community/cm1.png" alt="커뮤니티이미지">
							<div><span class="category">일지</span>6월 초에 [페이퍼 마리오 1000년의 문 (2024)] 플레이하다가 갑자기 스위치 본체가 뜨거워져서 강제 슬립 모드 되는 증상을 처음 겪어봤는데요. 또 희한한게 [스플래툰 3] 빅런 (6월 8일~10일)</div>
						</div>
						<div>
							<img src="${ctp}/community/cm2.png" alt="커뮤니티이미지">
							<div><span class="category">소식/정보</span>[Steam] 클라이언트에 녹화기능이 들어갔습니다. 게다가 [Steam Deck]에서도 된다하네요.스팀 게임 아닌 곳에서도 사용 가능이라 하여, nvidia나 ms의 게임바 도 대체할 수 있을듯</div>
						</div>
					</div>
					<hr/>
					<div class="popcommunity-text"><span class="category">소식/정보</span>#소식</div>
					<hr/>
					<div class="popcommunity-text"><span class="category">일지</span>스팀에 라이브러리에 사놓기만 하고 하지 않은 게임이 무려 26조 규모!</div>
					<hr/>
					<div class="popcommunity-text"><span class="category">일지</span>흠 ... 이게 뭘까~</div>
				</div>
			</div>
			<div class="sale">
				<div class="sale-title">
					<span>💵 최신 세일정보</span>
					<span class="more" onclick="location.href='${ctp}/community/sale';">더보기</span>
				</div>
				<div class="content-box">
					<div class="sale-img">
						<div>
							<img src="${ctp}/community/cm3.jpg" alt="커뮤니티이미지">
							<div><span class="category">일지</span>[EA 스포츠 FC 24] 이건데 되게 싸네요.. 여름세일 좋아용 😍</div>
						</div>
						<div>
							<img src="${ctp}/community/sale_thumbnail.png" alt="커뮤니티이미지">
							<div><span class="category">일지</span>#스팀 #여름세일 이하는 "스팀 평가 매우 긍정적(80%이상 긍정적) & 3만원 이하 & 역대 최저가 경신" 에 해당하는 게임 일부를 소개합니다.</div>
						</div>
					</div>
					<hr/>
					<div class="sale-text"><span class="category">일지</span>[최대 90% 할인] ⛱️ 인겜토리 스토어 여름 세일</div>
					<hr/>
					<div class="sale-text"><span class="category">일지</span>음!? 스팀 여름 할인이네???? 이건 못 참지 ㅋㅋㅋㅋ</div>
					<hr/>
					<div class="sale-text"><span class="category">일지</span>[Steam] 에서 여름할인을 시작하면서, "대폭 할인" 으로 별도의 페이지를 만들었습니다. 하나 -85% 빼고, 나머지 다 -90%가 넘는데, 뭐 사실 그게 중요한건 아니고.</div>
				</div>
			</div>
		</div>
		<div class="content3">
			<div class="content-box" style="width: 33.3%; cursor: pointer;">
				<div class="sub-menu"><span>❔</span> 자주 묻는 질문</div>
			</div>
			<div class="content-box" style="width: 33.3%; cursor: pointer;" onclick="showGameEditPopup()">
				<div class="sub-menu"><span>🕹️</span> 게임 등록 요청</div>
			</div>
			<div class="content-box" style="width: 33.3%; cursor: pointer;" onclick="showPopupSupport()">
				<div class="sub-menu"><span>🙋‍♀️</span> 1:1 문의하기</div>
			</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
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
</body>
</html>