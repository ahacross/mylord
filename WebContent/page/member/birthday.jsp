<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="monthTab">	
	<div class="head" style="margin-top:10px;">
		<ul class="tab top">
			<li class="active"><a data-value="12">12월</a></li>
			<li><a data-value="01">1월</a></li>
			<li><a data-value="02">2월</a></li>
			<li><a data-value="03">3월</a></li>
			<li><a data-value="04">4월</a></li>
			<li><a data-value="05">5월</a></li>
			<li><a data-value="06">6월</a></li>
			<li><a data-value="07">7월</a></li>
			<li><a data-value="08">8월</a></li>			
			<li><a data-value="09">9월</a></li>
			<li><a data-value="10">10월</a></li>
			<li><a data-value="11">11월</a></li>
		</ul>
	</div>
	<div class="body" id="tabBody">
		<div id="monthList" style="margin-top:10px;font-size: 20px;"></div>
		<div id="enrollment" style="margin-top:10px;font-size: 20px;"></div>
	</div>
	

</div>
<script>
(function(){
	var setPartText = function(part){
		var returnValue = '';
		if(part === "s"){
			returnValue = '소프라노';
		}else if(part === "a"){
			returnValue = '알토';
		}else if(part === "t"){
			returnValue = '테너';
		}else if(part === "b"){
			returnValue = '베이스';
		}else{
			returnValue = part;
		}
		return returnValue;
	}
	var setTab = function(month){
		ajax.run({url:"member", data:{status:"Y",birthday:month, type:"birthday"}}, function(after){
			var nameHtml = '<table>',
				list;
			if(after.length === 0){
				nameHtml += '<tr><td>없음</td></tr>'
			}else{
				list = after.sort(compare.birthday("birthday"));
				list.forEach(function(rtn){
					nameHtml += '<tr>';
					nameHtml += '<td style="width:100px;">'+rtn.name+'</td>';
					nameHtml += '<td style="width:150px;">'+setPartText(rtn.part)+'</td>';
					nameHtml += '<td>'+( new Date(rtn.birthday.yyyymmdd("-")).format("yyyy년 MM월 dd일") )+'</td>';
					nameHtml += '</tr>';
				});	
			}
			nameHtml += '</table>';
			$("#monthList").html(nameHtml);
			$("#enrollment").text("월별 생일자 수 : " + after.length + " 명"); 
		});
	}
	
	$("#monthTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).children().eq(0).data("value"));
	});
	
	var tempDate = new Date(),
		selectMonth;
	if(tempDate.getDay() > 0){
		tempDate = tempDate.minus("date", tempDate.getDay());
	}
	selectMonth = tempDate.plus("date", 7).format("MM");
	$("#monthTab a[data-value="+selectMonth+"]").click();

	
}());
</script>
