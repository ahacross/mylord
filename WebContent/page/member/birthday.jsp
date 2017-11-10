<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="monthTab">
	<div class="monthHead">
		월 선택 : 
		<select class="dropdown-menu" name="month">
			<option value="01">1월</option>
			<option value="02">2월</option>
			<option value="03">3월</option>
			<option value="04">4월</option>
			<option value="05">5월</option>
			<option value="06">6월</option>
			<option value="07">7월</option>
			<option value="08">8월</option>
			<option value="09">9월</option>
			<option value="10">10월</option>
			<option value="11">11월</option>
			<option value="12">12월</option>
		</select>
	</div>
	<div class="body" id="tabBody">
		<div style="margin-bottom: 5px;flex:1;font-size: 12px;">
			<div style="display:inline;">상태 : </div>
			<div style="display:inline;" id="statusArea"></div>
		</div>
		<div id="monthList" style="margin-top:10px;font-size: 20px;"></div>
		<div id="enrollment" style="margin-top:10px;font-size: 20px;"></div>
	</div>
	

</div>
<script>
(function(){
	var statusHtml = '';
	_.keys(userVars.statusMap).forEach(function(item){
		let checked = "";
		if(item === "Y"){
			checked = 'checked="checked"';	
		}
		
		statusHtml += '<label style="cursor:pointer;"><input type="checkbox" '+checked+' value="'+item+'"> '+userVars.statusMap[item]+'</label> &nbsp;';
	});
	
	$("#tabBody #statusArea").html(statusHtml).on("click", ":checkbox", function(){
		setTab($("#monthTab [name=month]").val());
	});
	
	var setPartText = function(part){
		var returnValue = userVars.partMap[part];
		
		if(!returnValue){
			returnValue = part;
		}
		return returnValue;
	}
	var setTab = function(month){
		ajax.run({url:"member", data:{birthday:month, type:"birthday"}}, function(after){
			var nameHtml = '<table>',
				list;
			if(after.length === 0){
				nameHtml += '<tr><td>없음</td></tr>'
			}else{
				list = after.sort(compare.birthday("birthday"));
				let checkedStatus = [];
				$("#tabBody #statusArea :checkbox:checked").each(function(){
					checkedStatus.push($(this).val());
				});
				
				list = list.filter(info => _.indexOf(checkedStatus, info.status) > -1);
				list.forEach(function(rtn){
					nameHtml += '<tr>';
					nameHtml += '<td style="width:180px;">'+rtn.name+ ' ('+setPartText(rtn.part)+')'+'</td>';					
					nameHtml += '<td>'+( new Date(rtn.birthday.yyyymmdd("-")).format("yyyy년 MM월 dd일") )+'</td>';
					nameHtml += '</tr>';
				});	
			}
			nameHtml += '</table>';
			$("#monthList").html(nameHtml);
			$("#enrollment").text("월별 생일자 수 : " + list.length + " 명"); 
		});
	}
	
	$("#monthTab").on("change", "[name=month]", function(){
		setTab($(this).val());
	});
	
	var tempDate = new Date();
	if(tempDate.getDay() > 0){
		tempDate = tempDate.minus("date", tempDate.getDay());
	}
	
	$("#monthTab [name=month]").val(tempDate.plus("date", 7).format("MM")).change();

	
}());
</script>
