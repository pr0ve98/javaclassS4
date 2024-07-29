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
		
		window.addEventListener('load', function() {
			mask.style.display = 'none';
			html.style.overflow = 'auto';
		});
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
					<span class="more">더보기</span>
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
			                <select class="dropdown-btn">
			                    <option>최근 담은 게임</option>
			                    <option>최근 평가한 게임</option>
			                    <option>지금 하고있는 게임</option>
			                    <option>별점 높은 게임</option>
			                </select>
			            </div>
			            <div class="game-list">
			            	<c:if test="${sMid != null}">
				            	<span class="game-item"><img src="${ctp}/game/명조.jpg"><span class="playState"><img src="${ctp}/images/playIcon.svg"></span></span>
				            	<span class="game-item"><img src="${ctp}/game/사건탐정해결부.jpg"><span class="playState"><img src="${ctp}/images/pinIcon.svg"></span></span>
				            	<span class="game-item"><img src="${ctp}/game/스테퍼케이스.jpg"><span class="playState"><img src="${ctp}/images/doneIcon.svg"></span></span>
				            	<span class="game-item"><img src="${ctp}/game/원신.jpg"><span class="playState"><img src="${ctp}/images/playIcon.svg"></span></span>
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
							<div class="newgame-item">
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
					<span class="more">모두 보기</span>
				</div>
				<div class="content-box">
					<div class="review">
						<div class="review-box">
							<div class="review-header">
								<span class="review-h-img"><img src="${ctp}/member/member2.jpg"></span>
								<span class="review-h-nickName">nuwn3vv</span>
								<span class="review-h-date">· 24/04/22</span>
							</div>
							<hr/>
							<div>
								<div class="review-game">
									<img class="review-game-img" src="${ctp}/game/발더스게이트.jpg">
									<div class="review-info">
										<div class="game-title">발더스 게이트 3</div>
										<div class="review-game-info">
											<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;5.0</span>
											<span class="review-state-none"><i class="fa-solid fa-ellipsis"></i>&nbsp;상태없음</span>
										</div>
									</div>
								</div>
								<div>
									<div class="review-text">엄청난 양의 텍스트 내가 선택하는 선택지에 따른 확실한 답변과 결과 밀도높고 광활한 필드 독창적인 캐릭터성 괜히 2023 최다 goty가 아니다! 버그가 좀 있고 전투가 dnd 형식이다보니 취향을 안탄다곤 안하겠지만은 단언컨데 최고의 rpg게임이 아닐까 합니다 rpg를 좋아한다면 무조건 !</div>
									<div class="review-more">더 보기</div>
								</div>
							</div>
						</div>
						<div class="review-box">
							<div class="review-header">
								<span class="review-h-img"><img src="${ctp}/member/member3.jpg"></span>
								<span class="review-h-nickName">김은수</span>
								<span class="review-h-date">· 24/05/15</span>
							</div>
							<hr/>
							<div>
								<div class="review-game">
									<img class="review-game-img" src="${ctp}/game/로스트아크.jpg">
									<div class="review-info">
										<div class="game-title">로스트아크</div>
										<div class="review-game-info">
											<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;4.0</span>
											<span class="review-state-play"><i class="fa-solid fa-play fa-sm" style="color: #0085eb;"></i>&nbsp;하고있어요</span>
										</div>
									</div>
								</div>
								<div>
									<div class="review-text">2년째 꾸준히 하고있지만 이제야 에키드나 트라이 중입니다. 이게임은 스토리는 보면안되는 게임입니다. 스토리를 밀고 발탄부터 시작하는게임이에요. 예전 와우가 만렙찍고 시작이라는 말처럼 여기도 스토리는 빨리 패스하고(물론 좋아하시는분들도있습니다만) 레이드부터 시작입니다. 아직은 질리지 않기때문에 계속할 예정이예요. 뭔가 또 재밌는 mmorpg가 나오지않는한...</div>
									<div class="review-more">더 보기</div>
								</div>
							</div>
						</div>
						<div class="review-box">
							<div class="review-header">
								<span class="review-h-img"><img src="${ctp}/member/member1.jpg"></span>
								<span class="review-h-nickName">닉네임</span>
								<span class="review-h-date">· 24/03/12</span>
							</div>
							<hr/>
							<div>
								<div class="review-game">
									<img class="review-game-img" src="${ctp}/game/하이파이러시.jpg">
									<div class="review-info">
										<div class="game-title">하이파이 러시</div>
										<div class="review-game-info">
											<span class="review-star"><i class="fa-solid fa-star" style="color: #FFD43B;"></i>&nbsp;5.0</span>
											<span class="review-state-done"><i class="fa-solid fa-check" style="color: #00c722;"></i>&nbsp;다했어요</span>
										</div>
									</div>
								</div>
								<div>
									<div class="review-text">게임을 끄고 나서도 내 심장에 차이처럼 박혀있는 비트사운드! 어드벤쳐와 리듬게임의 조화도 더할 나위 없지만 캐릭터들, 연출과 그래픽디자인이 너무 경쾌해서 켤 때마다 너무 기대되고 그만큼 재밌게했다. 게임 행위성의 디자인은 클래식하지만 연출만 훌륭하게 해도 멋지게 나온다는 걸 증명하는 게임 같다. 이제는 락은 죽었지만 한 때 락스타를 꿈꿨던 학창시절의 대책없던 기분좋은 환상을 떠올리게 만드는 게임. 스토리의 익숙함도 뭐 흠이 될 정도가 아니니까 너무 짧은 게 기분좋은 흠이다!</div>
									<div class="review-more">더 보기</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="content1">
			<div class="popcommunity">
				<div class="popcommunity-title">
					<span>🔥 커뮤니티 인기글</span>
					<span class="more">더보기</span>
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
					<span class="more">더보기</span>
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
			<div class="content-box" style="width: 33.3%; cursor: pointer;">
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