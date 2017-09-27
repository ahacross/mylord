<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="jsonWindow" class="window">
	<div class="head hide">
		<div class="left">JSON 수정</div>
	</div>
	<div class="body">
		<table class="width100">
			<tr>
				<td>
					<textarea class="text-input width100" rows="20" id="jsonText"></textarea>		
				</td>
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
	var targetWindow = userWindows.jsonWindow,
		Content = windowDialog.getContent(targetWindow),
		Footer = windowDialog.getFooter(targetWindow);
	
	targetWindow.init = function() {
		Content.find("#jsonText").val(JSON.stringify(jsonData, null, 4));
	}
	console.log(targetWindow);
	
	Footer.on("click", "#save", function(){		
		jsonData = JSON.parse(Content.find("#jsonText").val());		
		ajax.run({url:"json", method:"update", data:{name:$("[name=name]").val(), json:JSON.stringify(jsonData)}}, function(result){
			if(result.update === "Y"){
				msg.alert("저장 되었습니다.");
				$(".selected a").html(makeTabText (jsonData[$(".selected").data("idx")]));
				var marketTypesTab = $("#marketTypesTab");
				jsonData.forEach(function(markets, idx){
					marketTypesTab.find("[data-idx="+idx+"]").html(makeTabText (markets));
				});
				$("[data-idx].selected").click();
		    }
			Footer.find("#close").click();
		});
	});
	
	Footer.on("click", "#close", function(){
		targetWindow.userVars = {};
		targetWindow.close();
	});	
}());
</script>