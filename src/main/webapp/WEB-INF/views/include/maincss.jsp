<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
		@font-face{
		font-family:'DNFBitBitv2';
		font-style:normal;
		font-weight:400;
		src:url('//cdn.df.nexon.com/img/common/font/DNFBitBitv2.otf')format('opentype')
	}
	@font-face {
	    font-family: 'SUITE-Regular';
	    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-Regular.woff2') format('woff2');
	    font-weight: 400;
	    font-style: normal;
	}
	@font-face {
	    font-family: 'SUITE-ExtraBold';
	    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-ExtraBold.woff2') format('woff2');
	    font-weight: 800;
	    font-style: normal;
	}
	* {box-sizing: border-box;}
	html, body, .darkmode {
		background-color: #161d25;
		color: #b2bdce;
		font-family: 'SUITE-Regular';
		cursor: default;
	}
	p {margin-bottom: 0}
	main {
		padding: 20px;
		background-color: #32373d;
	}
	#hambuger-menu {
		display: none;
	}
	#pc-menu {
		font-family: DNFBitBitv2;
		border-bottom: 1px #32373d solid;
	}
	nav {
		position: sticky;
		top: 0;
		z-index: 1000;
		
	}
	.p-menu {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	.p-menu a:hover {
		color: #00c722;
		text-decoration: none;
	}
	.menu-item {
		padding: 5px 10px;
		font-size: 18px;
	}
	.selected {
		color: #00c722;
	}
	.right-menu {
		display: flex;
		gap: 30px;
		align-items: center;
	}
	.right-menu img {
		border-radius: 50%;
		object-fit: cover;
	}
	.profile-menu img {
		width: 50px;
		height: 50px;
	}
	.search-container {
	    position: relative;
	}
	.search-bar {
	    width: 200px;
	    height: 40px;
	    padding: 0 15px 0 46px;
	    border-radius: 20px;
	    border: none;
	    outline: none;
	    background-color: #32373d;
	    color: #fff;
	    font-size: 14px;
	    box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
	}
	.gamesearch-bar {
		width: 100%;
		background-color: #161d25;
	}
	.search-bar::placeholder {
	    color: #aaa;
	}
	.search-container::before {
	    content: '\1F50D';
	    position: absolute;
	    left: 15px;
	    top: 50%;
	    transform: translateY(-50%);
	    font-size: 20px;
	    color: #aaa;
	}
	.banner img {
		width: 100%;
		height: 200px;
		border-radius: 10px;
		object-fit: cover;
	}
	.content1 {
		display: flex;
		margin-top: 30px;
		gap: 30px;
	}
	.news, .mygames, .popcommunity, .sale {
		width: 50%;
	}
	.news-title, .mygames-title, .popcommunity-title, .sale-title {
		font-family: 'SUITE-ExtraBold';
		font-size: 24px;
		color: #fff;
		margin-bottom: 5px;
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	.more {
		color: #b2bdce;
		font-family: 'SUITE-Regular';
		font-size: 16px;
	}
	.content-box {
		flex-wrap: wrap;
		padding: 20px;
		background-color: #161d25;
		border-radius: 10px;
		height: calc(100% - 38px);
	}
	.news-text, .newgame-text, .popcommunity-text, .sale-text {
	  	overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 1;
	  	-webkit-box-orient: vertical;
	}
	.news hr {
		border-top: 1px solid #b2bdce30;
    	margin: 10px 0;
	}
	hr {
		border-top: 1px solid #b2bdce30;
    	margin: 15px 0;
	}
	.news-img, .popcommunity-img, .sale-img {
		display: flex;
		justify-content: center;
		gap: 0 15px;
	}
	.news-img div, .popcommunity-img div, .sale-img div, .newgame-info {
	    flex: 1;
	    display: flex;
	    flex-direction: column;
	  	overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 2;
	  	-webkit-box-orient: vertical;
	}
	.news-img img {
		width: 100%;
		height: 110px;
		object-fit: cover;
		border-radius: 10px;
		margin-bottom: 10px;
	}
	.popcommunity-img img, .sale-img img {
		width: 100%;
		height: 150px;
		object-fit: cover;
		border-radius: 10px;
		margin-bottom: 10px;
	}
	.news-page {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin: 30px 0 20px;
	    gap:20px;
	}
	
	.prev, .next {
	    background-color: #32373d;
	    border: none;
	    border-radius: 50%;
	    color: #b2bdce;
	    cursor: pointer;
	    padding: 1px 8px;
	    margin: 0 15px;
	}
	.game-status {
	    display: flex;
	    margin-bottom: 20px;
	    justify-content: space-between;
	    gap: 40px;
	}
	
	.game-info, .status-info {
	    width: 50%;
	    display: flex;
	    flex-direction: column;
	}
	
	.game-title {
	    font-size: 1.2em;
	    margin-bottom: 5px;
	    color: #fff;
	    font-weight: bold;
	    overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 1;
	  	-webkit-box-orient: vertical;
	}
	
	.game-count {
	    font-size: 2em;
	    margin-bottom: 30px;
	   	color: #fff;
	    font-weight: bold;
	}
	
	.game-details div, .status-detail div {
	    margin: 5px 0;
	}
	.dropdown {
	    position: static;
	}
	.dropdown-btn {
	    background-color: #161d25;
	    color: #b2bdce;
	    padding: 10px;
	    border: none;
	    cursor: pointer;
	    text-align: left;
	    font-size: 1em;
	    border-radius: 8px;
	}
	.dropdown-btn:focus {
	    outline: none;
	}
	.joinBtn {
		border-radius: 15px;
		padding: 5px 10px;
		background-color: #00c722;
		color: #fff;
		border-color: #00c722;
		min-width: 120px;
		text-align: center;
	}
	.cnt-item {
		display: flex;
		justify-content: space-between;
	}
	.game-list {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin: 5px 0;
	}
	.game-item {
		display: inline-block;
		position: relative;
	    width: 90px;
	    height: 90px;
	    margin-right: 8px;
	}
	.playState {
		position: absolute;
	    width: 28px;
	    height: 28px;
	    right: -4px;
	    bottom: -5px;
	    z-index: 2;
	}
	.game-item img, .newgame-item img {
	    width: 100%;
	    height: 100%;
	    border-radius: 8px;
	    object-fit: cover;
	}
	.content2 {
		margin: 40px 0;
	}
	.newgame-list {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin-top: 5px;
	}
	.newgame-item {
		display: flex;
		flex-direction: column;
		width: 180px;
	}
	.newgame-item-img {
		display: inline-block;
		width: 180px;
	    height: 180px;
	    margin-right: 8px;
	}
	.v-line {
		border-left : thin solid #b2bdce30;
		height: 330px;
		margin: 0 20px;
	}
	.newgame {width: 100%;}
	.mobile-line {display: none;}
	.pc-line {
		border-top: 1px dotted #b2bdce30;
	}
	.category {
		font-weight: bold;
		color: #fff;
		margin-right: 10px;
	}
	.content3 {
		display: flex;
		margin: 50px 0;
		gap: 30px;
	}
	.sub-menu {
		display: flex;
		flex-direction: column;
		font-size: 20px;
		text-align: center;
		font-weight: bold;
	}
	.review {
		display: flex;
		gap: 20px;
		flex-wrap: wrap;
		justify-content: center;
	}
	.review-box {
		width: 31.5%;
		padding: 20px;
		background-color: #32373d;
		border-radius: 10px;
		height: calc(100% - 38px);
		box-shadow: 0 4px 5px rgba(0,0,0,.06),0 1px 10px rgba(0,0,0,.12),0 2px 4px rgba(0,0,0,.4);
	}
	.review-box:hover {
		background-color: #50748e24;
	}
	.review-h-img {
		display: inline-block;
		width: 20px;
	    height: 20px;
	    margin-right: 4px;
	}
	.review-h-img img, .review-game-img img {
	    border-radius: 50%;
		width: 100%;
		height: 100%;
	}
	.review-h-nickName {
		color: white;
		font-weight: bold;
	}
	.review-h-date {
		font-size: 12px;
	}
	.review-game {
		display: flex;
		margin-bottom: 10px;
	}
	.review-info {
		display: flex;
		flex-direction: column;
	}
	.review-game-img {
		width: 56px;
	    height: 56px;
	    border-radius: 8px;
	    margin-right: 12px;
	    object-fit: cover;
	}
	.review-star {
	    border: 2px solid #FFD43B;
	    border-radius: 5px;
	    color: #FFD43B;
	    padding: 2px 3px;
	    font-size: 12px;
	    margin-right: 3px;
	}
	.review-state-none {
	    border: 2px solid #9b9b9bb5;
	    border-radius: 5px;
	    color: #9b9b9bb5;
	    padding: 2px 5px;
	    font-size: 12px;
	}
	.review-state-play {
	    border: 2px solid #0085eb;
	    border-radius: 5px;
	    color: #0085eb;
	    padding: 2px 5px;
	    font-size: 12px;
	}
	.review-state-done {
	    border: 2px solid #00c722;
	    border-radius: 5px;
	    color: #00c722;
	    padding: 2px 5px;
	    font-size: 12px;
	}
	.review-text {
		overflow: hidden;
	  	text-overflow: ellipsis;
	  	display: -webkit-box;
	  	-webkit-line-clamp: 4;
	  	-webkit-box-orient: vertical;
	  	margin-bottom: 10px;
	}
	.review-more {
		font-weight: bold;
		color: #00c722;
	}
	.store-game {
		display: flex;
		gap: 30px;
	}
	.s-game {
		width: 33.3%;
	}
	.s-game img {
		width: 100%;
		height: 150px;
		border-radius: 8px;
		object-fit: cover;
	}
	.s-game-name {
		margin-top: 15px;
		color: #fff;
		font-weight: bold;
		font-size: 16px;
	}
	.s-game-price {
		margin-top: 25px;
		color: #fff;
		font-weight: bolder;
		font-size: 20px;
	}
	footer {
		margin: 80px 0;
		text-align: center;
		background-color: #161d25;
	}
	.footer-menu {
		display: flex;
		align-items: flex-start;
		justify-content: center;
		gap: 45px;
		font-size: 20px;
		font-weight: bold;
		margin-bottom: 50px;
	}
	#popup-join, #popup-login, #popup-write, #popup-gamesearch {
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  position: fixed;
	  top: 0;
	  left: 0;
	  width: 100%;
	  height: 100%;
	  background: rgba(0, 0, 0, .7);
	  z-index: 1000;
	  overflow: hidden;
	}
	
	#popup-join.hide, #popup-login.hide, #popup-write.hide, #popup-gamesearch.hide {
	  display: none;
	}
	
	#popup-join .popup-join-content, #popup-login .popup-login-content, #popup-write .popup-write-content, #popup-gamesearch .popup-gamesearch-content {
	  padding: 20px;
	  background: #32373d;
	  border-radius: 5px;
	  box-shadow: 1px 1px 3px rgba(0, 0, 0, .3);
	  overflow-y: auto;
   	  max-height: 80vh;
	  min-width: 330px;
	}
	#popup-write .popup-write-content, #popup-gamesearch .popup-gamesearch-content {min-width: 700px;}
	
	.popup-open {
		overflow: hidden;
	}
	.popup-join-header {
		display: flex;
		justify-content: space-between;
		margin-bottom: 30px;
	}
	.popup-login-header {
		display: flex;
		justify-content: flex-end;
		margin-bottom: 30px;
	}
	.popup-join-main, .popup-login-main {
		text-align: center;
		padding: 0 20px 20px;
	}
	.popup-login-footer {
		margin: 15px 0;
		text-align: center;
	}
	.socialBtn {
		position: relative;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    width: 100%;
	    padding: 0 28px;
	    text-align: center;
	    line-height: 48px;
	    border-radius: 25px;
	    cursor: pointer;
	    border: 2px solid #e9d51c;
	    font-size: 15px;
	    letter-spacing: -.36px;
	    background-color: #fee500;
	    color: #181600;
	    margin-bottom: 10px;
	}
	.ingametory {
	    border: 2px solid #079920;
		background-color: #00c722;
	    color: #fff;
	}
	#join-form {
		margin: 20px auto 0;
	}
	.forminput {
		border: none;
		background-color: #32373d;
		border-bottom: 2px solid #b2bdce;
		border-radius: 0;
		width: 80%;
		margin: 0 auto;
		color: #b2bdce;
	}
	.form-control:disabled {
		background-color: #32373d;
		color: #68717f;
	}
	.form-control:focus {
	    color: #b2bdce;
    	background-color: #32373d;
    	border-color: #b2bdce;
		box-shadow: 0 0 0;
	}
	.textarea {
		border: none;
		background-color: #161d25;
		border-radius: 8px;
		margin: 0 auto;
		color: #b2bdce;
	}
	.textarea:focus {
		background-color: #161d25;
	}
	input:-webkit-autofill,
	input:-webkit-autofill:hover,
	input:-webkit-autofill:focus {
	    background-color: #32373d !important;
	    color: #b2bdce !important;
	    border-bottom: 2px solid #b2bdce;
	    -webkit-text-fill-color: #b2bdce !important;
	    transition: background-color 5000s ease-in-out 0s;
	}
	/* 자동 완성 목록의 텍스트 색상 */
	input:-webkit-autofill::first-line {
	    color: #b2bdce;
	}
	.error-message {
	    color: #ff5e5e;
	    font-size: 14px;
	    display: none;
	    text-align: left;
	}
	.error-msg {
		color: #ff5e5e;
		font-size: 14px;
		margin-top: 3px;
	}
	.loding-msg {color: #8dc3ff;}
	.success-msg {color: #00c722;}
	.error-form {
		border-color: red;
	}
	.scrollbar { 
	  overflow-y: scroll; /*  */
	}
	
	/* 스크롤바의 폭 너비 */
	.scrollbar::-webkit-scrollbar {
	    width: 3px;  
	}
	
	.scrollbar::-webkit-scrollbar-thumb {
	    background: #b2bdce38; /* 스크롤바 색상 */
	    border-radius: 10px; /* 스크롤바 둥근 테두리 */
	}
	
	.scrollbar::-webkit-scrollbar-track {
	    background: #32373d;  /*스크롤바 뒷 배경 색상*/
	}
	.pwdReset {
		font-size: 12px;
		margin-right: 22px;
		cursor: pointer;
	}
	
	/* 프로필 드롭다운 메뉴 스타일 */
	#profileDropdown {
		display: none;
	    position: absolute;
	    right: 1px;
	    top: 60px;
	    background-color: #32373d;
	    color: #b2bdce;
	    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
	    z-index: 1;
	    border-radius: 5px;
	    padding: 10px;
	    font-family: 'SUITE-Regular';
	    width: 260px;
	}
	#mprofileDropdown {
	    display: none;
	    position: absolute;
	    right: 1px;
	    top: 50px;
	    background-color: #32373d;
	    color: #b2bdce;
	    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
	    z-index: 1;
	    border-radius: 5px;
	    padding: 10px;
	    font-family: 'SUITE-Regular';
	    width: 200px;
	}
	
	#profileDropdown a, #mprofileDropdown a {
	    color: #b2bdce;
	    padding: 12px 16px;
	    text-decoration: none;
	    display: block;
	}
	
	#profileDropdown a:hover, #mprofileDropdown a:hover {
	    background-color: #161d25;
	}
	
	.profile-info {
	    display: flex;
	    align-items: center;
	    padding: 10px;
	}
	
	.profile-pic {
	    border-radius: 50%;
	    width: 50px;
	    height: 50px;
	    margin-right: 10px;
	    object-fit: cover;
	}
	.community {
		color: #fff;
		display: flex;
		gap: 40px;
		
	}
	.cm-menu {
		position: sticky;
	    top: 130px;
	    left: 0;
	    height: 100%;
	}
	.cb, .cn {
       display: flex;
       flex-direction: column;
       align-items: center;
		cursor: pointer;
		justify-content: center;
		
	}
	.cb img, .cn img {
		width: 35px;
		height: 35px;
	}
	.communityBtn {
       width: 60px;
       height: 60px;
       padding: 12px;
       border-radius: 50%;
       text-align: center;
       background-color: #161d25;
       color: #b2bdce;
       margin-bottom: 5px;
    }
    .cb-active {
    	background-color: #00c722;
    	color: #00c722;
    }
    .cb-text {
    	color: #b2bdce;
    }
    .cb-text-active {
    	color: #00c722;
    }
    .c-buttons{
    	margin-bottom: 20px;
    }
    .c-button {
    	background: #161d25;
    	color: #b2bdce;
    	font-size: 18px;
    	padding: 10px 15px;
    	margin-right: 6px;
    	border-radius: 8px;
    	text-wrap: nowrap;
		display: inline-block;
		cursor: pointer;
    }
    .c-button-active {
    	background: #00c722;
    	color: #fff;
    	font-weight: bold;
    }
   	.cm-box {
		flex-wrap: wrap;
		padding: 20px;
		background-color: #161d25;
		border-radius: 10px;
		box-shadow: 0 4px 5px rgba(0, 0, 0, .06), 0 1px 10px rgba(0, 0, 0, .12), 0 2px 4px rgba(0, 0, 0, .4);
		margin-bottom: 20px;
	}
	.text-pic {
		border-radius: 50%;
	    width: 50px;
	    height: 50px;
	    margin-right: 10px;
	}
	.text-input {
		white-space: nowrap;
	    border-radius: 20px;
	    background-color: #32373d;
	    line-height: 22px;
	    padding: 9px 16px;
	    cursor: text;
	    font-size: 15px;
	    color: #b2bdce;
	    width: 100%;
	}
	.mobile {display: none;}
	.setting-main {
		display: flex;
		gap: 30px;
		padding: 0 20px;
		margin-bottom: 50px;
		color: #fff;
	}
	.setting-left {
		flex-grow: 1;
	}
	.setting-right {
		flex-grow: 2;
		min-width: 719px;
	}
	.setting-right h2 {
		font-family: DNFBitBitv2;
		margin-bottom: 30px;
	}
	.setting-title {
		font-weight: bold;
		font-size: 16px;
		margin-bottom: 20px;
	}
	.category-selection {
	    display: flex;
	    justify-content: space-between;
	    margin: 20px 0;
	}
	
	.community-category {
	    flex-grow: 1;
	    padding: 10px;
	    background-color: #161d25;
	    border: none;
	    cursor: pointer;
	    margin: 0 5px;
	    border-radius: 5px;
	    color: #b2bdce;
	}
	
	.community-category.active {
		font-weight: bold;
	    background-color: #00c722;
	    color: #fff;
	}
	
	.game-selection {
	    display: flex;
	    overflow-x: auto;
	    margin-bottom: 20px;
	    justify-content: space-around;
	}
	
	.game-button, .gamesearch-button {
	    background: none;
	    border: none;
	    margin-right: 10px;
	    padding: 0;
	    cursor: pointer;
	    width: 55px;
	}
	
	.game-button img, .gamesearch-button img {
	    width: 50px;
	    height: 50px;
	    border-radius: 5px;
	    object-fit: cover;
	}
	
	.game-button.active img {
	    border: 3px solid #00c722;
	}
	
	.game-name {
		white-space: nowrap;
	    overflow: hidden;
	    text-overflow: ellipsis;
	    color: #fff;
	    margin-top: 2px;
	}
	
	.journal-entry {
	    width: 100%;
	    height: 100px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    padding: 10px;
	    box-sizing: border-box;
	    margin-bottom: 20px;
	}
	
	.footer {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-top: 10px;
	}
	
	.visibility {
	    padding: 5px;
	    border-radius: 5px;
	}
	
	.post-button {
	    background-color: #00c722;
	    color: #fff;
	    border: none;
	    padding: 10px 20px;
	    border-radius: 5px;
	    cursor: pointer;
	}
	.note-modal-backdrop {position: static;}
	.popup-write-header, .popup-gamesearch-header {
		display: flex;
		justify-content: space-between;
	}
	.header-text, .gs-header-text {
		font-size: 20px;
    	margin: 0 5px;
	}
	.results-container {
		display: none;
	    background-color: #23272a;
	    border-radius: 5px;
	    max-height: 300px;
	    overflow-y: auto;
	}
	.result-item {
	    display: flex;
	    align-items: center;
	    padding: 10px;
	    cursor: pointer;
	}
	.result-item img {
	    width: 40px;
	    height: 40px;
	    border-radius: 5px;
	    margin-right: 10px;
	}
	.result-item span {
	    flex: 1;
	}
	.result-item:hover, .result-item.selected {
	    background-color: #7289da;
	}
	@media screen and (min-width: 1200px) {
		.game-item {
			width: 110px;
		}
		.newgame-item {
			width: 220px;
		}
		.newgame-item-img {
			width: 220px;
		}
		.v-line {
			margin: 0 30px;
		}
		#popup-join .popup-join-content {
			min-width: 450px;
		}
	}
	@media screen and (max-width: 991px) {
		main {
			padding: 20px 0;
			background-color: #32373d;
		}
		.mobile {
			display: block;
		}
		#pc-menu {
			display: none;
		}
		#hambuger-menu {
			display: block;
		}
		.header .w3-button {
			padding: 0;
		}
		.w3-button:hover {
			color: #00c722!important;
			background-color: #32373d!important;
		}
		.litiledark {
			background-color: #b2bdce;
			color: #32373d;
		}
		.darkmode-hover {
			color: #fff;
			background-color: #161d25;
		}
		.header {
			display: flex;
			align-items: center;
			justify-content: space-around;
		}
		.right-menu {
			gap: 20px;
		}
		.banner img {
			width: 100%;
			height: 60%;
			border-radius: 10px;
			object-fit: cover;
		}
		.content1 {
			flex-direction: column;
		}
		.game-list {
			margin: 3px;
		}
		.game-item {
			width: 150px;
			height: 70px;
		}
		.news, .mygames, .popcommunity, .sale {
			width: 100%;
		}
		.newgame-list {
		    flex-wrap: wrap;
		}
		.newgame-item {
			width: 100%;
			margin-bottom: 20px;
		}
		.newgame-item-img {
			width: 100%;
		}
		.v-line {
			display: none;
		}
		.mobile-line {display: block;}
		.pc-line {display: none;}
		.content3 {
			margin: 30px 0;
		}
		.sub-menu {
			font-size: 16px;
		}
		.review-box {
			width: 100%;
		}
		.store-game {
			flex-direction: column;
			gap: 0;
		}
		.s-game {
			width: 100%;
		}
		.s-game-price {
			margin-top: 10px;
		}
		.joinBtn {
			min-width: 80px;
			font-family: DNFBitBitv2;
		}
		footer {
			text-align: left;
			margin: 50px 10px;
		}
		.footer-menu img {display: none;}
		.footer-menu {
			flex-direction: column;
			gap: 10px;
			font-size: 16px;
			margin: 30px 10px;
		}
		.layer_profile {
			top: 67px;
		    right: 20px;
		}
		.cm-menu {display: none;}
		.cm-box img {
			width: 40px;
			height: 40px;
		}
		.c-button {
	    	font-size: 14px;
	    	padding: 5px 8px;
	    	margin-right: 2px;
	    	border-radius: 8px;
	    }
	    .profile-menu img {
			width: 40px;
			height: 40px;
		}
		.setting-right {
			min-width: 0px;
		}
		#popup-write .popup-write-content {
		    min-width: 300px;
		}
	}
	@media screen and (max-width: 359px) {
		.c-button {
	    	font-size: 12px;
	    }
	}
</style>