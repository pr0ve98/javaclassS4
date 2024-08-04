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
<title>${member.nickname}의 프로필 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/wordcloud2.js/1.0.6/wordcloud2.min.js"></script>
<script>
	'use strict';
	
	document.addEventListener('DOMContentLoaded', function() {
		// 페이지가 로딩될 때 로딩페이지 보여주기
		const mask = document.querySelector('.mask');
		const html = document.querySelector('html');
		html.style.overflow = 'hidden';
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
    
    function fInput(youMid) {
 		$.ajax({
 			url : "${ctp}/community/followInput",
 			type : "post",
 			data : {youMid : youMid},
 			success : function() {
				location.reload();
			},
 			error : function() {
				alert("전송오류!");
			}
 		});
	}
 	
 	function fDelete(youMid) {
 		$.ajax({
 			url : "${ctp}/community/followDelete",
 			type : "post",
 			data : {youMid : youMid},
 			success : function() {
 				location.reload();
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
<main style="padding: 0;">
	<div class="mask">
	  <img class="loadingImg" src='${ctp}/images/loding.gif'>
	</div>
	<div class="tabs" style="justify-content: center; padding: 0; background-color: #161d25;">
        <div class="tab-container">
            <div class="tab active" style="border-bottom: 5px solid #00c722;" onclick="location.href='${ctp}/mypage/${member.mid}';">
            	<c:if test="${sMid == member.mid}"><img src="${ctp}/member/${member.memImg}" class="reply-pic" style="width: 25px; height: 25px;">&nbsp;마이페이지</c:if>
            	<c:if test="${sMid != member.mid}"><img src="${ctp}/member/${member.memImg}" class="reply-pic" style="width: 25px; height: 25px;">&nbsp;${member.nickname}님의 페이지</c:if>
            </div>
            <div class="tab" onclick="location.href='${ctp}/mypage/${member.mid}/mygame';">내 게임</div>
            <div class="tab" onclick="location.href='${ctp}/mypage/${member.mid}/myreview';">리뷰</div>
            <div class="tab" onclick="location.href='${ctp}/mypage/${member.mid}/myrecord';">일지</div>
        </div>
    </div>
	<div class="container">
		<div class="gameviewContent" style="margin: 50px auto;">
			<div class="cm-box" style="min-width:300px; height: 100%;">
				<div style="display: flex; justify-content: space-between; align-items: flex-start;">
					<img src="${ctp}/member/${member.memImg}" class="text-pic" style="width:80px; height: 80px;">
					<c:if test="${sMid == member.mid}"><span style="cursor:pointer;" onclick="location.href='${ctp}/setting/profile';"><i class="fa-solid fa-gear"></i></span></c:if>
				</div>
				<div class="mt-3" style="font-size: 24px; font-weight: bold; color:#fff;">${member.nickname}</div>
				<div style="font-size:12px;">@${member.mid}</div>
				<div class="mt-2" style="color:#fff;">${fn:replace(member.memInfo, newLine, '<br/>')}</div>
				<div class="mt-2" style="color:#fff;">팔로워&nbsp;&nbsp;${follower}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;팔로잉&nbsp;&nbsp;${following}</div>
				<c:if test="${sMid != null}">
					<c:if test="${sMid == member.mid}"><button class="editplz-button mt-4" style="width:100%" onclick="location.href='${ctp}/setting/profile';">프로필 변경</button></c:if>
					<c:if test="${sMid != member.mid}">
						<c:if test="${isFollow == 'NO'}"><button class="editplz-button mt-4" style="width:100%" onclick="fInput('${member.mid}')"><i class="fa-solid fa-user-plus"></i>&nbsp;팔로우</button></c:if>
						<c:if test="${isFollow == 'OK'}"><button class="editplz-button mt-4" style="width:100%; background-color: #ce5353;" onclick="fDelete('${member.mid}')"><i class="fa-solid fa-user-minus"></i>&nbsp;언팔로우</button></c:if>
					</c:if>
				</c:if>
			</div>
			<div style="flex-grow: 1;">
				<div class="stats-box">
			        <div class="stat-item">
			            <span>${mygame}</span>
			            게임
			        </div>
			        <div class="stat-item">
			            <span>${myreview}</span>
			            리뷰
			        </div>
			        <div class="stat-item">
			            <span>${myilji}</span>
			            일지
			        </div>
			    </div>
		    	<h3 class="mt-5">최근 담은 게임</h3>
		    	<div class="game-list" id="mygameList">
		    		<c:if test="${mygameVOS != null}">
			    		<c:forEach var="mygameVO" items="${mygameVOS}">
		  					<span class="game-item" onclick="location.href='${ctp}/gameview/${mygameVO.gameIdx}';">
		           				<c:if test="${fn:indexOf(mygameVO.gameImg, 'http') == -1}"><img src="${ctp}/game/${mygameVO.gameImg}"></c:if>
		           				<c:if test="${fn:indexOf(mygameVO.gameImg, 'http') != -1}"><img src="${mygameVO.gameImg}"></c:if>
		           				<span class="playState">
		           				<img src="${ctp}/images/${mygameVO.state}Icon.svg">
		           				</span>
		           			</span>
		           		</c:forEach>
	           			<c:if test="${fn:length(mygameVOS) != 0 && fn:length(mygameVOS) < 6}">
		            		<c:forEach begin="1" end="${6-fn:length(mygameVOS)}">
			            		<span class="game-item" style="cursor: default;"><img src="${ctp}/images/nomygameimage.jpg"></span>
		            		</c:forEach>
				        </c:if>
				    </c:if>
			        <c:if test="${fn:length(mygameVOS) == 0}">
						<div style="margin: 100px 20px; text-align: center;">
							<div>최근 담은 게임이 없습니다.</div>
						</div>
					</c:if>
		    	</div>
		    	<hr class="mt-5"/>
		    	<h3>최근 작성한 리뷰</h3>
		    	<c:if test="${fn:length(myreviewVOS) != 0}">
		    		<c:forEach var="myreviewVO" items="${myreviewVOS}">
				    	<div class="cm-box" id="cmbox${myreviewVO.cmIdx}">
							<div style="display:flex;justify-content: space-between;">
								<div>
									<img src="${ctp}/member/${myreviewVO.memImg}" alt="프로필" class="text-pic" style="width:20px; height:20px;"><b>${myreviewVO.nickname}</b>님이 평가를 남기셨습니다
								</div>
							</div>
							<hr/>
							<div style="display:flex; margin: 0 20px; align-items:center; gap:20px; cursor: pointer;" onclick="location.href='${ctp}/gameview/${myreviewVO.gameIdx}';">
								<div>
									<c:if test="${fn:indexOf(myreviewVO.gameImg, 'http') == -1}"><img src="${ctp}/game/${myreviewVO.gameImg}" alt="${myreviewVO.gameTitle}" class="re-gameImg"></c:if>
		            				<c:if test="${fn:indexOf(myreviewVO.gameImg, 'http') != -1}"><img src="${myreviewVO.gameImg}" alt="${myreviewVO.gameTitle}" class="re-gameImg"></c:if>
								</div>
								<div class="review-info">
									<div class="game-title">${myreviewVO.gameTitle}</div>
									<div class="review-game-info">
										<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;${myreviewVO.rating}</span>
										<span class="review-state-${myreviewVO.state}">
											<c:if test="${myreviewVO.state == 'play'}"><i class="fa-solid fa-play"></i>&nbsp;하고있어요</c:if>
											<c:if test="${myreviewVO.state == 'stop'}"><i class="fa-solid fa-xmark"></i>&nbsp;그만뒀어요</c:if>
											<c:if test="${myreviewVO.state == 'done'}"><i class="fa-solid fa-check"></i>&nbsp;다했어요</c:if>
											<c:if test="${myreviewVO.state == 'folder'}"><i class="fa-solid fa-folder"></i>&nbsp;모셔놨어요</c:if>
											<c:if test="${myreviewVO.state == 'pin'}"><i class="fa-solid fa-thumbtack"></i>&nbsp;관심있어요</c:if>
											<c:if test="${myreviewVO.state == 'none'}"><i class="fa-solid fa-ellipsis"></i>&nbsp;상태없음</c:if>
										</span>
									</div>
								</div>
							</div>
							<div class="community-content">
								<div class="cm-content ${myreviewVO.longContent == 1 ? 'moreGra' : ''}" id="cmContent${myreviewVO.cmIdx}">${myreviewVO.cmContent}</div>
								<c:if test="${myreviewVO.longContent == 1}"><div onclick="showAllContent(${myreviewVO.cmIdx})" id="moreBtn${myreviewVO.cmIdx}" style="cursor:pointer; color:#00c722; font-weight:bold;">더 보기</div></c:if>
								<div style="color:#b2bdce; font-size:12px;" class="mt-2">
									<c:if test="${myreviewVO.hour_diff < 1}">${myreviewVO.min_diff}분 전</c:if>
									<c:if test="${myreviewVO.hour_diff < 24 && myreviewVO.hour_diff >= 1}">${myreviewVO.hour_diff}시간 전</c:if>
									<c:if test="${myreviewVO.hour_diff >= 24}">${fn:substring(myreviewVO.cmDate, 0, 10)}</c:if>
								</div>
								<div style="color:#b2bdce; font-size:12px;" class="mt-2"><span id="cm-likeCnt${myreviewVO.cmIdx}">이 글을 ${myreviewVO.likeCnt}명이 좋아합니다.</span></div>
							</div>
						</div>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(myreviewVOS) == 0}">
					<div style="margin: 100px 20px; text-align: center;">
						<div>최근 작성한 리뷰가 없습니다.</div>
					</div>
				</c:if>
				<hr/>
			</div>
		</div>
	</div>
	<p><br/></p>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<jsp:include page="/WEB-INF/views/include/navPopup.jsp" />
</body>
</html>