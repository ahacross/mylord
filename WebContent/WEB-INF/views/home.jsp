<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>        
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta charset="UTF-8">
	<title>마이로드</title>
	
	<spring:url value="/resources/css/loadWrap.css" var="loadWrapCSS" />
	<link rel="stylesheet" type="text/css" href="${loadWrapCSS }">
	
	<spring:url value="/resources/plugins/jquery/jquery.js" var="jqueryJS" />
	<script type="text/javascript" src="${jqueryJS }"></script>
	
	<spring:url value="/resources/plugins/LAB/LAB.js" var="LABJs" />
	<script type="text/javascript" src="${LABJs }"></script>
	
	<spring:url value="/resources/js/loadWrap.js" var="loadWrapJS" />
	<script type="text/javascript" src="${loadWrapJS }"></script>
	
	<spring:url value="/resources/js/html5/html5shiv.js" var="html5shivJs" />
	<spring:url value="/resources/js/html5/respond.min.js" var="respondJs" />
	<!--[if lt IE 9]>
	<script type="text/javascript" src="${html5shivJs}"></script>
	<script type="text/javascript" src="${respondJs }"></script>
	<![endif]-->
	<script>
	$.wait = function(time) {
		var defer = $.Deferred();
		setTimeout(defer.resolve, time);   
		return defer.promise();
	}
 
	// 재귀함수  // 사용예제는 bomTable.js 에 있음.
	var fnRecursive = function(delayTime, checkFn, actionFn, target){
		if(checkFn(target)){
			return actionFn(target);
		}else{
			$.wait(delayTime).then(function(){
				fnRecursive(delayTime, checkFn, actionFn, target);
			});
		}
	}
	</script>
	
	<script>
		window.userWindows = {};
		
		var selectMenu = function(that){
			var classNames = "selected color-blue-500";
			
			that.parents(".menu").find(".selected").removeClass(classNames);
			that.parent().addClass(classNames);
			document.querySelector(".main-content").scrollTop = 0;
		}
		
		var changeMenu = function(id) {
			if(id === "status"){
				
			}
		}
		
		$(document).ready(function(){
			fnRecursive(50,
				function(){return window.jsLodingComplate || false;},
				function(){
					delete window.jsLodingComplate;
					var md = new Material({
							options: {
								FancyHeader: {
									header: document.querySelector(".toolbar"),
									scrollTarget: document.querySelector(".main-content")
								}
							}
						}),
						sm = document.getElementById("navigation-sidemenu");
					
					SideMenu.hide(sm);
					$("#navigation-sidemenu").find(".menu > li:not(.divider)").on("click", "a", function(){
						if (Responsive.device != "desktop") {
							SideMenu.hide(sm);
						}
						
						selectMenu($(this));
						var id = $(this).attr("id");
						console.log(id);
					});
					$(".menu > li").first().find("a").click();
					
					$("#menuBtn").on("click", function(){
						SideMenu.toggle(sm);
					});
					
				}
			);
		});
	/* 
		var loginableMember = function(name){
			var loginableMember = ["cad526f449dec4e838c5d0aba5de948ec94778ec77f36537d4368e3aa3a0f7de", "adbc432a627844edf654e8d1e477a409c98c3a0260d5bd590e2c6f3f13a7bda6", "2c1249b640aaa3eb355c9e6a4df48c07fefa304616ecf8cd0689ec2d7f1754cf", "2c312280cbffa9bea959aa0993196a37f751620254e47ddb010cdeaef2a941e0", "1b80421cdec2c9f2d8506eea369dfce8df7cc6964a244c9aad9cca6649ccbc9b", "6d6eb9caa061609392dea1746d7c5d8117f422c0521332b6e70f754b4fcb9e21"],
				check = false;
			
			if(_.indexOf(loginableMember, Sha256.hash(name)) > -1){
				check = true;
			}
			return check;
		}
		var login = function(){
			msg.prompt("전화번호가 어떻게 되세요? (하이픈없이 숫자만 입력해 주세요.)", function(btn, phone){
				if(/^[\d]{10,11}$/.test(phone)){
					ajax.getAjaxObj().makeDatas({url:"member", data:{type:"login", phone:phone.toPhone()}}).run(function(after){
						if(after.length > 0){
							cookie.set("mylord", JSON.stringify(after[0]), 365*24*60);
							topMenu.changeMenu("성가대원");	
						}else{
							msg.alert("해당 번호로 등록된 사용자가 없습니다.", function(){
								login();	
							});
						}
					})
				}else{
					msg.alert("전화번호가 아닙니다.", function(){
						login();
					})
				}
			}, function(){
				location.reload();
			});
		}
		$(document).ready(function(){
 			fnRecursive(50,
				function(){return window.jsLodingComplate || false;},
				function(){
					userWindows.categoryWindow = loadWindow("page/bbs/category_window.jsp");
					userWindows.memberWindow = loadWindow("page/member/member_window.jsp");
					
					$(".child_menu li[data-url]").on("click", function(){
						var url = $(this).data("url");
						
						if($(this).data("type") === "window"){
							var windowName = url.split("/").last().toCamel().split(".").removeLast().join("");
							userWindows[windowName].show2();
						}else{
							window.userVars = {windows:{}};
							window.userFns = {};
							
							$(".right_col").load(url);
						}
					}).css("cursor", "pointer");
				}
			);
		});		 */
	</script>
</head>
<body>
	<div class="sidemenu sidebar responsive" id="navigation-sidemenu" hidden>	
		<ul class="menu">
			<li ripple><a class="pointer" id="status"><i class="icon-chart"></i>출석 현황</a></li>		
			<li ripple><a class="pointer" id="infoMod"><i class="fa fa-user-circle" aria-hidden="true"></i>정보 수정</a></li>
			<li class="divider"></li>			
			<li ripple><a class="pointer" id="songHistory"><i class="fa fa-book" aria-hidden="true"></i>했던 곡들</a></li>
			<li ripple><a class="pointer" id="facebook"><i class="fa fa-facebook-official" aria-hidden="true"></i>페이스북</a></li>
			<li ripple><a class="pointer" id="practice"><i class="icon-content-copy"></i>연습실</a></li>
		</ul>
	</div>
	<div class="main-content">
		<div class="toolbar header bg-black color-white">
			<button class="icon-button" id="menuBtn"><i class="icon-menu"></i></button>
			<label class="toolbar-label">마이로드</label>
			<span class="float-right" id="switch-container">
				<label class="form-control-label">로그아웃</label>
			</span>	
		</div>
		<div class="navigation-section">
			12312
		</div>
	</div>
	
	
	<div class="windowContent"></div>
</body>
</html>
