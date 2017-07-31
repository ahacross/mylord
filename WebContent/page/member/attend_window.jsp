<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="attendWindow" class="window jui">
	<div class="head hide">
		<div class="left">출석체크</div>
	</div>
	<div class="body">		
		<textarea rows="20" style="width:98%;" id="attendText"></textarea>
	</div>
	<div class="foot hide">
		<a id="attend" class="focus btn">출석체크</a>
		<a id="areaInit" class="btn">초기화</a>		
        <a id="close" class="btn">닫기</a>
	</div>
</div>

<script>
(function(){ 
	var targetWindow = userVars.attendWindow,
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
	 			$("#partTab").find(":contains("+name+")").parent().click();
	 			return false;
	 		}
	 	});
		
	 	// 이름별 셋팅
	 	setTimeout(function(){
	 		tempNames.forEach(function(name){
	 			if(name.trim() !== ""){
					if(isNoNames(name) || /[\d]{2}\/[\d]{2}/.test(name)){
						return;
					}
					
					if(pattern.test(name)){
						isBefore = false;
						return;
					} 
					
					var datas = userVars.tableInfos.findData("name", name);
					if(!isNaN(datas.index)){
						userVars.tableInfos.table.find("tbody tr").eq(datas.index).find(":checkbox").eq(isBefore?0:1).click();	
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
	 		Footer.find("#close").click();
	 	}, 500);
	 	
	}
	
	var close = function(){
		targetWindow.userVars = {};
		targetWindow.close();
	}
	
	
	var areaInit = function(){
		$("#attendText").val("");
	}
	
	setTimeout(function(){
		Footer.find("#close").on("click", close);
		Footer.find("#areaInit").on("click", areaInit);
		Footer.find("#attend").on("click", attend);
	}, 1000);
}());
</script>