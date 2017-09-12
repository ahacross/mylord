<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="historyWindow" class="window">
	<div class="head hide">
		<div class="left">부른 곡 추가</div>
	</div>
	<div class="body">		
		<table id="historyTable" style="width:98%;">
			<tr>
				<td class="thB" style="width:25%;">부르는 날</td>
				<td><input type="date" class="text-input width100" name="singed_date"/></td>
			</tr>
			<tr>
				<td class="thB">제목</td>
				<td><input type="text" class="text-input width100" name="title"/></td>			
			</tr>
			<tr>
				<td class="thB">부른 영상</td>
				<td><textarea class="text-input width100" rows="5" name="link"></textarea></td>
			</tr>
			<tr>
				<td class="thB">출처</td>
				<td><textarea class="text-input width100" rows="5" name="source"></textarea></td>
			</tr>
			<tr>
				<td class="thB">악보자료</td>
				<td><textarea class="text-input width100" rows="5" name="scanning"></textarea></td>
			</tr>
			<tr>
				<td class="thB">연습</td>
				<td><textarea class="text-input width100" rows="5" name="practice"></textarea></td>
			</tr>			
			<tr>
				<td class="thB">절기</td>
				<td><textarea class="text-input width100" rows="5" name="etc"></textarea></td>
			</tr>
		</table>
	</div>
	<div class="foot hide">		
        <button id="save" class="button raised bg-blue-500 color-white">저장</button>
        <button id="close" class="button raised">닫기</button>
	</div>
</div>

<script>
(function(){ 
	var targetWindow = userWindows.historyWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);
	
	var close = function(){
		targetWindow.userVars = {};
		targetWindow.close();
	}
	
	targetWindow.init = function(params) {
		Content.find("#historyTable").find(":text, [type=date], textarea").val("");
		let title = "부른 곡 ";
		if(params.type === "update"){
			initMod(Content.find("#historyTable"), params.row)
			title += "수정";
		}else{
			title += "추가";
		}
		windowDialog.setTitle(targetWindow, title);
		targetWindow.userVars.params = params;
	}
	
	Footer.on("click", "#save", function(){
		const datas = makeFormDatas(Content.find("#historyTable").find(":text, [type=date], textarea"));
		let url = "history";
		
		if(targetWindow.userVars.params.type === "update") {
			url += ("/"+cookie.get("mylordId"));
		}
		
		ajax.run({url:url, method: targetWindow.userVars.params.type, data:datas}, function(after){
			if(after.cnt > 0) {
				msg.alert("저장 하였습니다.");
				userFns.setGridHistory();
				Footer.find("#close").click();
			}
		});
	});
	
	
	Footer.on("click", "#close", close);	
}());
</script>