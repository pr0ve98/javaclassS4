<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>나만의 인겜토리!</title>
<link rel="icon" type="image/x-icon" href="${ctp}/images/ingametory.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
	'use strict';
	
	function w3_open() {
	  document.getElementById("mySidebar").style.display = "block";
	}
	
	function w3_close() {
	  document.getElementById("mySidebar").style.display = "none";
	}
	
	function myAccFunc(flag) {
	  var x = document.getElementById("demoAcc"+flag);
	  if (x.className.indexOf("w3-show") == -1) {
	    x.className += " w3-show";
	    x.previousElementSibling.className += " darkmode-hover";
	  } else { 
	    x.className = x.className.replace(" w3-show", "");
	    x.previousElementSibling.className = 
	    x.previousElementSibling.className.replace(" darkmode-hover", "");
	  }
	}

    function showPopupJoin() {
    	const popup = document.querySelector('#popup-join');
    	const loginpopup = document.querySelector('#popup-login');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        loginpopup.classList.add('hide');
        html.classList.add('popup-open');
    }

    function showPopupLogin() {
    	const popup = document.querySelector('#popup-login');
    	const joinpopup = document.querySelector('#popup-join');
    	const html = document.querySelector('html');
        popup.classList.remove('hide');
        joinpopup.classList.add('hide');
        html.classList.add('popup-open');
    }
    
    function closePopup() {
    	const popup = document.querySelector('#popup-join');
    	const html = document.querySelector('html');
        popupJoin.classList.add('hide');
        popupLogin.classList.add('hide');
        html.classList.remove('popup-open');
    }
 	
 	document.addEventListener('DOMContentLoaded', function() {
 	    const email = document.getElementById('joinemail');
 	    const pwd = document.getElementById('joinpwd');
 	    const submitBtn = document.getElementById('submitBtn');

 	    const emailError = document.getElementById('email-error');
 	    const pwdError = document.getElementById('pwd-error');

 	    function validateForm() {
 	        let isValid = true;

 	        const emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
 	        if (!emailReg.test(email.value)) {
 	            emailError.textContent = '잘못된 형식입니다';
 	            emailError.style.display = 'inline';
 	           	email.classList.add('error-form');
 	            isValid = false;
 	        } else {
 	            emailError.style.display = 'none';
 	           	email.classList.remove('error-form');
 	        }

 	       if (email.value.length > 0 && emailReg.test(email.value)) {
	 	        const pwdReg = /^[a-zA-Z0-9!@#$%^&*]{4,}$/;
	 	        if (!pwdReg.test(pwd.value)) {
	 	        	pwdError.textContent = '4자 이상 영문,숫자,특수문자';
	 	        	pwdError.style.display = 'inline';
	 	        	pwd.classList.add('error-form');
	 	            isValid = false;
	 	        }
	 	        else {
	 	        	pwdError.style.display = 'none';
	 	        	pwd.classList.remove('error-form');
	 	        }
	 	   } 
 	       else {
	        	pwdError.style.display = 'none';
 	        	pwd.classList.remove('error-form');
 	        }

 	       submitBtn.disabled = !isValid;
 	    }

 	    email.addEventListener('input', validateForm);
 	    pwd.addEventListener('input', validateForm);
 	});
 	
 	function emailJoin() {
		$("#join-form").show();
		$("#emailjoin").hide();
	}
 	
 	function joinCheck() {
 		const email = document.getElementById('joinemail');
 	    const pwd = document.getElementById('joinpwd');

        const emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        const pwdReg = /^[a-zA-Z0-9!@#$%^&*]{4}$/;
        
        if (!emailReg.test(email.value)) return false;
        else if (!pwdReg.test(pwd.value)) return false;
        else joinform.submit();
	}
 	
 	function loginCheck() {
 		const email = document.getElementById('loginemail').value;
 	    const pwd = document.getElementById('loginpwd').value;
 	    
        if (email.trim() == '') return false;
        else if (pwd.trim() == '') return false;
        else loginform.submit();
	}
 	
 	// PC
 	function toggleProfileMenu() {
 	    var dropdown = document.getElementById("profileDropdown");
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	    }
 	}
 	
 	// 모바일
 	function mtoggleProfileMenu() {
 	    var dropdown = document.getElementById("mprofileDropdown");
 	    if (dropdown.style.display === "block") {
 	        dropdown.style.display = "none";
 	    } else {
 	        dropdown.style.display = "block";
 	    }
 	}

 	// 페이지의 다른 부분을 클릭하면 드롭다운이 닫히도록 이벤트 리스너 추가
 	window.onclick = function(event) {
 	    if (!event.target.matches('.profile-menu img')) {
 	        var dropdowns = document.getElementsByClassName("dropdown-content");
 	        for (var i = 0; i < dropdowns.length; i++) {
 	            var openDropdown = dropdowns[i];
 	            if (openDropdown.style.display === "block") {
 	                openDropdown.style.display = "none";
 	            }
 	        }
 	    }
 	}

 	window.Kakao.init("f1fade264b3d07d67f8e358b3d68803e");
 	
 	// 카카오 로그인
 	function kakaoLogin() {
 		window.Kakao.Auth.login({
			scope: 'profile_nickname, account_email',
			success : function(autoObj) {
				//alert(Kakao.Auth.getAccessToken(), "정상 토큰 발급됨");
				window.Kakao.API.request({
					url : '/v2/user/me',
					success : function(res) {
						const kakao_account = res.kakao_account;
						console.log(kakao_account);
						location.href = "${ctp}/member/kakaoLogin?nickname="+kakao_account.profile.nickname+"&email="+kakao_account.email+"&accessToken="+Kakao.Auth.getAccessToken();
					}
				});
			}
		});
	}
 	
  	// 카카오 로그아웃
	function kakaoLogout() {
		const accessToken = Kakao.Auth.getAccessToken();
		if(accessToken) {
			Kakao.Auth.logout(function(){
				window.location.href = "https://kauth.kakao.com/oauth/logout?client_id=f1fade264b3d07d67f8e358b3d68803e&logout_redirect_uri=http://localhost:9090/javaclassS4/member/kakaoLogout";
			});
		}
	}



</script>
<jsp:include page="/WEB-INF/views/include/maincss.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<main>
	<div class="container">
		<div class="banner"><img alt="배너" src="${ctp}/resources/images/banner1.jpg" width="100%"></div>
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
			                <div class="game-count">${sMid != null ? '109' : '-'}</div>
			                <c:if test="${sMid != null}">
				                <div class="game-details">
				                    <div class="cnt-item"><span>5점 게임</span><span>16</span></div>
				                    <div class="cnt-item"><span>3점이상 게임</span><span>93</span></div>
				                    <div class="cnt-item"><span>2점이하 게임</span><span>28</span></div>
				                </div>
			                </c:if>
			            </div>
			            <div class="status-info">
			                <div class="status">
			                    <div class="game-title">게임 상태</div>
			                    <div class="status-detail">
			                        <div class="cnt-item"><span><i class="fa-solid fa-play fa-sm" style="color: #0085eb;"></i>&nbsp;&nbsp;하고있어요</span><span>${sMid != null ? '3' : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-check" style="color: #00c722;"></i>&nbsp;&nbsp;다했어요</span><span>${sMid != null ? '42' : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-xmark" style="color: #f50000;"></i>&nbsp;&nbsp;그만뒀어요</span><span>${sMid != null ? '29' : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-thumbtack fa-sm" style="color: #fff700;"></i>&nbsp;&nbsp;관심있어요</span><span>${sMid != null ? '12' : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-folder fa-sm" style="color: #d9d9d9;"></i>&nbsp;&nbsp;모셔놨어요</span><span>${sMid != null ? '10' : '-'}</span></div>
			                        <div class="cnt-item"><span><i class="fa-solid fa-ellipsis" style="color:#37414cd6;"></i>&nbsp;&nbsp;상태없음</span><span>${sMid != null ? '12' : '-'}</span></div>
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
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/러브크레센도.jpg"></span>
							<span class="game-title">러브크레센도</span>
							<span>06.28</span>
							<span>PC</span>
							<span class="newgame-text">비주얼 노벨, 시뮬레이션, 캐주얼</span>
							<hr class="pc-line"/>
							<span class="newgame-info">백마탄 공주님은 없다! 비밀스러운 그녀들과 함께하는 밴드부 생활.</span>
							<hr class="mobile-line" />
						</div>
						<div class="v-line"></div>
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/루이지맨션2hd.jpg"></span>
							<span class="game-title">루이지 맨션 2 HD</span>
							<span>06.27</span>
							<span>닌텐도 스위치</span>
							<span class="newgame-text">어드벤처, 액션어드벤처</span>
							<hr class="pc-line"/>
							<span class="newgame-info">겁 많고 소심한 루이지가 유령이 사는 맨션을 모험!
							「아라따박사」에게 억지로 끌려온 루이지는 흩어진 「다크 문」의 조각을 모으기 위해 「유령 계곡」을 조사하게 되었습니다.
							과연 루이지는 「유령 계곡」의 평화를 되찾을 수 있을까요……?</span>
							<hr class="mobile-line" />
						</div>
						<div class="v-line"></div>
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/스파이패밀리오퍼레이션다이어리.jpg"></span>
							<span class="game-title">스파이패밀리 오퍼레이션 다이어리</span>
							<span>06.27</span>
							<span>PS5, PS4, 닌텐도 스위치, PC</span>
							<span class="newgame-text">어드벤처</span>
							<hr class="pc-line"/>
							<span class="newgame-info">이든 칼리지의 숙제로 그림일기를 그리게 된 아냐. 평일에는 학교에 가고 휴일에는 가족들하고 바다, 수족관 같은 다양한 장소로 나들이하며 그림일기의 소재를 모아봐요. 『스파이 패밀리』다운 일상을 체험할 수 있는 미니 게임도 15종류 이상 수록. 과연 아냐는 그림일기를 완성할 수 있을까요?</span>
							<hr class="mobile-line" />
						</div>
						<div class="v-line"></div>
						<div class="newgame-item">
							<span class="newgame-item-img mb-2"><img src="${ctp}/game/엘든링황금나무의그림자.jpg"></span>
							<span class="game-title">엘든 링: 황금 나무의 그림자</span>
							<span>06.21</span>
							<span>PS5, PS4, XBOX, PC</span>
							<span class="newgame-text">3인칭 오픈 월드 ARPG</span>
							<hr class="pc-line"/>
							<span class="newgame-info">다채로운 시추에이션을 지닌 탁 트인 필드와 복잡하면서 입체적으로 짜인 거대한 던전이 경계선 없이 이어지는 드넓은 세계. 탐색 끝에는 미지의 것들을 발견했다는 기쁨과 높은 성취감으로 이어지는 압도적인 위협이 플레이어를 기다립니다.</span>
						</div>
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
											<span class="review-state-none"><i class="fa-solid fa-ellipsis"></i></i>&nbsp;상태없음</span>
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
		<div class="content2">
			<div class="newgame">
				<div class="mygames-title">
					<span>❤️ 인기 스토어 게임</span>
					<span class="more">모두 보기</span>
				</div>
				<div class="content-box">
					<div class="store-game">
						<div class="s-game">
							<img src="${ctp}/game/디제이맥스.jpg">
							<div class="s-game-name">DJMAX RESPECT V</div>
							<div>#리듬게임</div>
							<div class="s-game-price">49,800원</div>
						</div>
						<hr class="mobile-line" />
						<div class="s-game">
							<img src="${ctp}/game/발더스게이트.jpg">
							<div class="s-game-name">발더스 게이트 3</div>
							<div>#턴제 #RPG</div>
							<div class="s-game-price">66,000원</div>
						</div>
						<hr class="mobile-line" />
						<div class="s-game">
							<img src="${ctp}/game/팰월드.jpg">
							<div class="s-game-name">Palworld / 팰월드</div>
							<div>#액션 #어드벤처 #RPG</div>
							<div class="s-game-price">32,000원</div>
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
			<div class="content-box" style="width: 33.3%;">
				<div class="sub-menu"><span>❔</span> 자주 묻는 질문</div>
			</div>
			<div class="content-box" style="width: 33.3%;">
				<div class="sub-menu"><span>🕹️</span> 게임 등록 요청</div>
			</div>
			<div class="content-box" style="width: 33.3%;">
				<div class="sub-menu"><span>🙋‍♀️</span> 1:1 문의하기</div>
			</div>
		</div>
	</div>
</main>
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<div id="popup-join" class="hide">
  <div class="popup-join-content scrollbar">
		<div class="popup-join-header">
			<span style="cursor: pointer;"><i class="fa-solid fa-headset fa-lg" style="color: #b2bdce;"></i>&nbsp;&nbsp;문의하기</span>
    		<a href="" onclick="closePopup()"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="popup-join-main">
			<div class="socialBtn" onclick="kakaoLogin()">
				<span class="mr-2"><img src="${ctp}/images/kakaoIcon.png"></span>
				<span>카카오로 시작하기</span>
			</div>
			<div class="socialBtn ingametory" id="emailjoin" onclick="emailJoin()">
				<span class="mr-2"><img src="${ctp}/images/ingametory.png" width="20px"></span>
				<span>이메일로 시작하기</span>
			</div>
			<div id="join-form" style="display: none;">
				<hr/>
				<form name="joinform" method="post" action="${ctp}/member/memberJoin">
					<input type="text" name="email" id="joinemail" placeholder="이메일을 입력하세요" class="form-control forminput" />
					<span id="email-error" class="error-message"></span><br/>
					<input type="password" name="pwd" id="joinpwd" placeholder="비밀번호를 입력하세요" class="form-control forminput" />
					<span id="pwd-error" class="error-message"></span>
					<div class="socialBtn ingametory mt-4" id="submitBtn" onclick="joinCheck()">
						<span class="mr-2"><img src="${ctp}/images/ingametory.png" width="20px"></span>
						<span>이메일로 가입하기</span>
					</div>
				</form>
			</div>
			<div style="margin: 30px 0 20px;">이미 계정이 있으신가요? <span style="font-weight: bold; color: #00c722; cursor: pointer;" onclick="showPopupLogin()" id="joinPopupLoginBtn">로그인</span></div>
		</div>
  </div>
</div>
<div id="popup-login" class="hide">
  <div class="popup-login-content scrollbar">
		<div class="popup-login-header">
    		<a href="" onclick="closePopup()"><i class="fa-solid fa-x fa-lg" style="color: #b2bdce;"></i></a>
		</div>
		<div class="popup-login-main">
			<h2><b>로그인</b></h2>
			<div style="margin: 20px 0 20px;">인겜토리 계정이 없으신가요? <span style="font-weight: bold; color: #00c722; cursor: pointer;" onclick="showPopupJoin()" id="loginPopupJoinBtn">회원가입</span></div>
			<div class="socialBtn" onclick="kakaoLogin()">
				<span class="mr-2"><img src="${ctp}/images/kakaoIcon.png"></span>
				<span>카카오로 로그인</span>
			</div>
			<hr class="mb-4"/>
			<form name="loginform" method="post" action="${ctp}/member/memberLogin">
				<input type="text" name="email" id="loginemail" placeholder="이메일을 입력하세요" class="form-control forminput" />
				<br/>
				<input type="password" name="pwd" id="loginpwd" placeholder="비밀번호를 입력하세요" class="form-control forminput" />
				<div class="text-right"><span class="pwdReset" onclick="pwdReset()">비밀번호를 잊으셨나요?</span></div>
				<div class="socialBtn ingametory mt-4" id="submitBtn" onclick="loginCheck()">
					<span class="mr-2"><img src="${ctp}/images/ingametory.png" width="20px"></span>
					<span>이메일로 로그인</span>
				</div>
			</form>
		</div>
		<hr/>
		<div class="popup-login-footer">
			<div style="margin: 20px 0 20px;">로그인에 문제가 있으신가요? <span style="font-weight: bold; color: #00c722; cursor: pointer;" onclick="showPopupSupport()" id="supportPopupBtn">문의하기</span></div>
		</div>
    </div>
</div>
</body>
</html>