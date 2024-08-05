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
 	
 	function newsChange(page, totPage) {
 		if(page == 0) page = 1;
 		else if(page > totPage) page = totPage;
 		else {
	 		$.ajax({
	 			url : "${ctp}/newsChange",
	 			type : "post",
	 			data : {page:page, totPage:totPage},
	 			success : function(res) {
	 				$("#newsBox").html(res);
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
				<div class="content-box" id="newsBox">
					<div class="news-img">
						<c:forEach var="newslist" items="${newslists}" varStatus="st1">
							<c:if test="${st1.index < 2}">
								<div style="cursor:pointer;" onclick="location.href='${ctp}/news/${newslist.cmIdx}';">
									<c:if test="${fn:indexOf(newslist.newsThumnail, 'http') == -1}"><img src="${ctp}/community/${newslist.newsThumnail}" alt="뉴스이미지"></c:if>
			            			<c:if test="${fn:indexOf(newslist.newsThumnail, 'http') != -1}"><img src="${newslist.newsThumnail}" alt="뉴스이미지"></c:if>
									<div>${newslist.newsTitle}</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
					<c:forEach var="newslist" items="${newslists}" varStatus="st2">
						<c:if test="${st2.index >= 2}">
							<hr/>
							<div class="news-text" onclick="location.href='${ctp}/news/${newslist.cmIdx}';">${newslist.newsTitle}</div>
						</c:if>
					</c:forEach>
					<div class="news-page">
						<button class="prev" onclick="newsChange(${page-1},${totPage})"><i class="fa-solid fa-chevron-left fa-2xs"></i></button>
				        <span class="page-info">${page}/${totPage}</span>
				        <button class="next" onclick="newsChange(${page+1},${totPage})"><i class="fa-solid fa-chevron-right fa-2xs"></i></button>
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
					            		<span class="game-item" style="cursor: default;"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            		</c:forEach>
			            		</c:if>
			            	</c:if>
			            	<c:if test="${sMid == null}">
				            	<span class="game-item" style="cursor: default;"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            	<span class="game-item" style="cursor: default;"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            	<span class="game-item" style="cursor: default;"><img src="${ctp}/images/nomygameimage.jpg"></span>
				            	<span class="game-item" style="cursor: default;"><img src="${ctp}/images/nomygameimage.jpg"></span>
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
						<c:forEach var="ht" items="${hotCommunity}" varStatus="st3">
							<c:if test="${st3.index < 2}">
								<div style="cursor:pointer;" onclick="gameViewCommunityView(${ht.cmIdx})">
									<c:if test="${fn:indexOf(ht.newsThumnail, 'http') == -1}"><img src="${ctp}/community/${ht.newsThumnail}" alt="커뮤니티이미지"></c:if>
			            			<c:if test="${fn:indexOf(ht.newsThumnail, 'http') != -1}"><img src="${ht.newsThumnail}" alt="커뮤니티이미지"></c:if>
									<div><span class="category">${ht.part}</span>${ht.onlyText}</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
					<c:forEach var="ht" items="${hotCommunity}" varStatus="st4">
						<c:if test="${st4.index >= 2}">
							<hr/>
							<div class="popcommunity-text" onclick="gameViewCommunityView(${ht.cmIdx})"><span class="category">${ht.part}</span>${ht.onlyText}</div>
						</c:if>
					</c:forEach>
				</div>
			</div>
			<div class="sale">
				<div class="sale-title">
					<span>💵 최신 세일정보</span>
					<span class="more" onclick="location.href='${ctp}/community/sale';">더보기</span>
				</div>
				<div class="content-box">
					<div class="sale-img">
					<c:forEach var="sc" items="${saleCommunity}" varStatus="st5">
							<c:if test="${st5.index < 2}">
								<div style="cursor:pointer;" onclick="gameViewCommunityView(${sc.cmIdx})">
									<c:if test="${fn:indexOf(sc.newsThumnail, 'http') == -1}"><img src="${ctp}/community/${sc.newsThumnail}" alt="커뮤니티이미지"></c:if>
			            			<c:if test="${fn:indexOf(sc.newsThumnail, 'http') != -1}"><img src="${sc.newsThumnail}" alt="커뮤니티이미지"></c:if>
									<div><span class="category">${sc.part}</span>${sc.onlyText}</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
					<c:forEach var="sc" items="${saleCommunity}" varStatus="st6">
						<c:if test="${st6.index >= 2}">
							<hr/>
							<div class="popcommunity-text" onclick="gameViewCommunityView(${sc.cmIdx})"><span class="category">${sc.part}</span>${sc.onlyText}</div>
						</c:if>
					</c:forEach>
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
</body>
</html>