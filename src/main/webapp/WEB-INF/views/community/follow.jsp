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
<title>팔로우 | 인겜토리</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	let isFetching = false;
	let totPage = 1;
	
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
				data : {page : ${page}+totPage, part : 'follow'},
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
					<span class="communityBtn cb-active" onclick="location.href='${ctp}/community/recent';">
			            <img src="https://img.icons8.com/ios-filled/50/ffffff/chat.png" alt="Chat Icon"/>
			        </span>
			        <span class="cb-text-active"><b>인겜토리</b></span>
				</span>
				<span class="cn">
			        <span class="communityBtn" onclick="location.href='${ctp}/news/newsRecent';">
			            <img src="https://img.icons8.com/ios-filled/50/b2bdce/news.png" alt="News Icon"/>
			        </span>
			        <span class="cb-text"><b>뉴스</b></span>
				</span>
			</span>
			<div style="width:100%;">
				<div class="c-buttons">
					<c:if test="${sMid != null}"><span class="c-button c-button-active" onclick="location.href='${ctp}/community/follow';">팔로우</span></c:if>
					<span class="c-button" onclick="location.href='${ctp}/community/recent';">최신</span>
					<span class="c-button" onclick="location.href='${ctp}/community/review';">리뷰</span>
					<span class="c-button" onclick="location.href='${ctp}/community/info';">소식/정보</span>
					<span class="c-button" onclick="location.href='${ctp}/community/sale';">세일</span>
					<c:if test="${sMid != null}"><span class="c-button" onclick="location.href='${ctp}/community/my';">내글</span></c:if>
				</div>
				<c:if test="${fn:length(cmVOS) == 0}">
					<div class="text-center" style="margin: 200px 0; font-size: 32px; color:#b2bdce;">팔로우한 유저가 없습니다!</div>
				</c:if>
				<c:forEach var="cmVO" items="${cmVOS}">
					<div class="cm-box" id="cmbox${cmVO.cmIdx}">
						<div style="display:flex;justify-content: space-between;">
							<div style="display:flex; align-items:center;">
								<img src="${ctp}/member/${cmVO.memImg}" alt="프로필" class="text-pic">
								<div>
									<c:if test="${cmVO.title != '없음'}"><div style="font-size:12px;">${cmVO.title}</div></c:if>
									<div style="font-weight:bold; cursor: pointer;" onclick="location.href='${ctp}/mypage/${cmVO.mid}';">${cmVO.nickname}</div>
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
</body>
</html>