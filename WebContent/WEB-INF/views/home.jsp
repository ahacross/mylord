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
		window.userVars = {};
		window.userFns = {};
		
		let partMap = {};
		partMap["s"] = "소프라노";
		partMap["a"] = "알토";
		partMap["t"] = "테너";
		partMap["b"] = "베이스";
		userVars.partMap = partMap;
		
		var selectMenu = function(that){
			var classNames = "selected color-blue-500";
			
			that.parents(".menu").find(".selected").removeClass(classNames);
			that.parent().addClass(classNames);
			document.querySelector(".main-content").scrollTop = 0;
		}
		
		
		var changeMenu = function(id) {
			let url = ["page"];
			
			if(id === "etc" || id==="infoMod") {				
				url.push("link");
			}else{
				url.push(id);
			}
			
			url.push(id+".jsp");			
			naviSectionArea.load(url.join("/"));
		}
		
		$(document).ready(function(){
			fnRecursive(50,
				function(){return window.jsLodingComplate || false;},
				function(){
					delete window.jsLodingComplate;
					
					window.naviSectionArea  = $(".navigation-section");
					var md = new Material({
							options: {
								FancyHeader: {
									header: document.querySelector(".toolbar"),
									scrollTarget: document.querySelector(".main-content")
								}
							}
						}),
						sm = document.getElementById("navigation-sidemenu");
					
					let menuRun = true;
					if(cookie.get("mylordId") === ""){
						naviSectionArea.html(naviSectionArea.html() + "<br> 사용자 정보가 없습니다. 휴대폰 번호를 입력해 주세요.");
						login();
						menuRun = false;
					}
					
					if(menuRun){
						naviSectionArea.html(naviSectionArea.html() + "<br><br> 권한 정보를 설정합니다.");
						
						Promise.resolve()
					    	.then(setAuth)
					    	.then(auth => {
					    		let authHtml = '';					    		
					    		if(auth.indexOf("임원") > -1) {
					    			authHtml += '<li class="divider"></li>';
					    			authHtml += '<li ripple><a class="pointer" id="officer"><i class="fa fa-users" aria-hidden="true"></i>임원 명단</a></li>';
					    		}
					    		
					    		if(auth !== ''){
					    			$("#navigation-sidemenu .menu").append(authHtml);	
					    		}
					    	}
					    );
					}
					
					$("#navigation-sidemenu .menu").on("click", "> li:not(.divider) a", function(){				
						SideMenu.hide(sm);						
						selectMenu($(this));
						changeMenu($(this).attr("id"));
					});
					
					if(menuRun) {
						SideMenu.hide(sm);
						$(".menu > li").first().find("a").click();	
					}
					
					$("#menuBtn").on("click", function(){
						SideMenu.toggle(sm);
					});
					
					$("#logout").on("click", function(){
						cookie.del("mylordId");
						cookie.del("mylordAuth");
						location.href = "/mylord";
					}).css("cursor", "pointer");
				}
			);
		});

		var login = function(){
			msg.prompt("전화번호가 어떻게 되세요? (하이픈없이 숫자만 입력해 주세요.)", function(btn, phone){
				if(/^[\d]{10,11}$/.test(phone)){
					phone = phone.toPhone();
				}
				ajax.run({url:"member", data:{type:"login", phone:phone}}, function(after){
					if(after.length > 0){
						cookie.set("mylordId", after[0].member_id+"", 365*24*60);
						location.href="";
					}else{
						msg.alert("해당 번호로 등록된 사용자가 없습니다.", function(){
							login();
						});
					}
				});
			}, function(){
				location.reload();
			});
		}
		
		var setAuth = function() {
			return new Promise(function(resolve, reject) {
				ajax.run({url:"officer", data:{member_id: cookie.get("mylordId"), status:'Y'}}, function(afterDatas){
					let auth = {};
					afterDatas.forEach(function(role){
						auth[role.role] = 1;
					});
					const myloadAuth = _.keys(auth).join(",");					
					
					cookie.set("mylordAuth", myloadAuth);
					resolve(myloadAuth);
				});
			});
		} 
	</script>
</head>
<body>
	<div class="sidemenu sidebar responsive" id="navigation-sidemenu" hidden>
		<div class="sidemenu-hero">			
			<div class="serif" id="userName" style="text-align: center;"></div>
		</div>
		<ul class="menu">
			<li ripple><a class="pointer" id="status"><i class="icon-chart"></i>출석 현황</a></li>		
			<li ripple><a class="pointer" id="infoMod"><i class="fa fa-user-circle" aria-hidden="true"></i>정보 수정</a></li>
			<li class="divider"></li>
			<li ripple><a class="pointer" id="history"><i class="fa fa-book" aria-hidden="true"></i>했던 곡들</a></li>
			<li ripple><a class="pointer" id="etc"><i class="icon-content-copy"></i>기타 정보들</a></li>
			<!-- <li ripple><a class="pointer" id="etc"><i class="icon-content-copy"></i>회비보고</a></li> -->
			
		</ul>
	</div>
	<div class="main-content">
		<div class="toolbar header bg-black color-white">
			<button class="icon-button" id="menuBtn"><i class="icon-menu"></i></button>
			<label class="toolbar-label">마이로드</label>
			<span class="float-right" id="switch-container">
				<label id="logout" class="form-control-label">로그아웃</label>
			</span>	
		</div>
		<div class="navigation-section">
			휴대폰 번호로 로긴하세요~ 
		</div>
	</div>
	
	
	<div class="windowContent"></div>
</body>
</html>
