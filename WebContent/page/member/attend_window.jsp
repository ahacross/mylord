<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="attendWindow" class="window">
	<div class="head hide">
		<div class="left">출석체크</div>
	</div>
	<div class="body" style="width:98%;">		
		<textarea class="text-input width100" rows="20" id="attendText"></textarea>
	</div>
	<div class="foot hide">	
        <button id="attend" class="button raised bg-blue-500 color-white">출석체크</button>&nbsp; 
        <button id="areaInit" class="button raised">초기화</button> &nbsp;
        <button id="close" class="button raised">닫기</button>
	</div>
</div>

<script>
(function(){ 
	var targetWindow = userWindows.attendWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);
	
	var isNoNames = function(name){
		var noNames = ["베이스", "소프라노", "알토", "테너", "예배전", "예배후", "예배", "전", "후", "주일"];
		
		return (_.indexOf(noNames, name) > -1)?true:false;
	}
	
	var attend = function(){
		var attendText = Content.find("#attendText").val(),
			tempNamesRow = [],
			tempNames = [],
			names = [],
			name,
			pattern = /\(*\d명\)*/ ,
			isBefore = true,
			omissions = {before:[], after:[]};
		
		attendText = attendText.split(",").join(" ");
		
	 	tempNamesRow = attendText.split("\n");
		
	 	tempNamesRow.forEach(function(names){
			tempNames = tempNames.concat(names.split(" "));
		});
	 	
	 	// 파트탭 이동
	 	var parts = ["베이스", "소프라노", "알토", "테너"];	 	
	 	tempNames.forEach(function(name){
	 		if(_.indexOf(parts, name) > -1){
	 			if(name === "베이스") {
	 				name="벵";
	 			}else if(name === "소프라노") {
	 				name="솦";
	 			}
	 			$("#partTab").find(":contains("+name+")").parent().click();
	 			return false;
	 		}
	 	});
	 	
	 	// 이름별 셋팅
	 	setTimeout(function(){
	 		const grid = tuiGrid.getGrid("gridPartList");
	 		let gridNameDatas = {};
	 		grid.getRows().forEach(function(data){
		 		gridNameDatas[data.name] = data;
		 	});
	 		
	 		tempNames.forEach(function(name){
	 			if(name.trim() !== ""){
					if(isNoNames(name) || /[\d]{2}\/[\d]{2}/.test(name)){
						return;
					}
					
					if(pattern.test(name)){
						isBefore = false;
						return;
					} 
					
					const datas = gridNameDatas[name];
					if(datas && datas.rowKey > -1){
						grid.$el.find(".tui-grid-rside-area tr[data-row-key]").eq(datas.rowKey).find(":checkbox").eq(isBefore?0:1).click();
					}else{
						if(isBefore){
							omissions.before.push(name);	
						}else{
							omissions.after.push(name);
						}	
					}
					if(omissions.before.length + omissions.after.length > 0){
						var omission = "누락자 명단 <br>예배 전 : "+omissions.before.join(", ")+"<br>" + "예배 후 : "+omissions.after.join(", ");
						msg.alert(omission);
					}
	 			}
			});
	 		
	 		// 등록된 재적이 없으면 재적 자동 등록
	 		ajax.run({url:"enroll", data:{attend_date:$("[name=attendanceDate]").val().split("-").join(""), part:$(".tabHead .active a").data("value")}}, function(data){
	 			if(!data){
	 				ajax.run({url:"/enroll",method:"insert", data: userFns.makeEnrollData()}, function(after, before){});
	 			}
	 		});
	 		
	 		Footer.find("#close").click();
	 	}, 1000);
	}
	
	
	
	var close = function(){
		targetWindow.userVars = {};
		targetWindow.close();
	}
	
	var areaInit = function(){
		Content.find("#attendText").val("");
	}
	
	setTimeout(function(){
		Footer.find("#close").on("click", close);
		Footer.find("#areaInit").on("click", areaInit);
		Footer.find("#attend").on("click", attend);	
	}, 500);
}());
</script>