<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" style="height: 100%">
	사용자 정보를 수정합니다.
	<table id="memberTable" style="width:100%">
		<tr>
			<td class="thB" style="width:25%;">이름</td>
			<td><input type="text" class="text-input width100" name="name"/></td>
		</tr>
		
		<tr>
			<td class="thB">폰 번호</td>
			<td><input type="text"  class="text-input width100" name="phone" placeholder="01011112222" maxlength="13"/></td>
		</tr>
		<tr>
			<td class="thB">비밀번호</td>
			<td><input type="text" class="text-input width100" name="passwd" /></td>
		</tr>
		<tr>
			<td class="thB">생일</td>
			<td><input type="date" class="text-input width100" name="birthday" /></td>
		</tr>
		<tr>
			<td class="thB">E-mail</td>
			<td><input type="text" class="text-input width100" name="email" placeholder="aaa@naver.com" /></td>				
		</tr>
	</table>
	<div style="width: 100%;text-align: center;">
		<button id="infoModSave" class="button raised bg-blue-500 color-white">수정</button>
	</div>	
</div>
<script>
(function(){
	var memberTable = $("#memberTable");
	
	var loadUserInfo = function(){
		ajax.run({url:"member/"+cookie.get("mylordId")}, function(datas){
			
			if(datas.birthday && datas.birthday.length === 8){
				datas.birthday = datas.birthday.yyyymmdd("-");	
			}
			
			datas.passwd = "";
			
			memberTable.find(":text, [type=date]").each(function(){			
				$(this).val(datas[$(this).attr("name")]);
			});
		});
	}
	loadUserInfo();
	
	memberTable.on("blur", "[name=phone]", function(){
		var value = $(this).val();
		if(value.split("-").length > 0){
		}else if(!/^[\d]{10,11}$/.test(value) || !/^01/.test(value)){
			msg.alert("휴대폰 번호 양식에 맞지 않습니다.");
			value = "";
		}else{
			value = value.toPhone();
		}
		$(this).val(value);
	});
	
	$("#infoModSave").on("click", function(){
		var fields = memberTable.find("[type=date], :text"),
			datas = {},
			ajaxData = {},
			tempField;
		
		for(var i=0, n=fields.length; i<n; i++){
			tempField = fields.eq(i);
			datas[tempField.attr("name")] = tempField.val();
		}

		datas.member_id = cookie.get("mylordId");
		
		if(datas.passwd === ""){
			delete datas.passwd;
		}
		
		if(datas.birthday){
			datas.birthday = datas.birthday.split("-").join("");
		}
		
		ajaxData.data = datas;
		ajaxData.url = "member/"+ datas.member_id;
		ajaxData.method = "update";
		
		ajax.run(ajaxData, function(rtnValue){
			if(rtnValue.cnt > 0){				
				msg.alert("수정 되었습니다.");
				loadUserInfo();
			}
		});
	});
}());
</script>
