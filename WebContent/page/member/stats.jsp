<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<div style="width:100%">
		<table style="width:100%">
			<tr>
				<td style="width:150px;">통계 날짜 범위</td>
				<td>
					<input type="date" class="input" name="startDate"> ~ <input type="date" class="input" name="endDate">		
				</td>
			</tr>
			<tr>
				<td>예배전 예외 조건</td>
				<td><input type="text" class="input" name="beforeCheckCond"></td>
			</tr>
			<tr>
				<td>예배후 예외 조건</td>
				<td><input type="text" class="input" name="afterCheckCond"></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: center" id="btnArea">
					<a class="btn" id="part">파트별</a>
					<a class="btn" id="one">개인별</a>
				</td>
			</tr>
		</table>
	</div>
	<div id="dateArea"></div>
	<div id="statsArea" style="margin-top:10px;"></div>
</div>

<div class="panel" id="partTab" style="display: none;">
	<div class="head">
		<ul class="tab top">
			<li class="active"><a data-value="all">전체</a></li>
			<li><a data-value="s">소프라노</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">베이스</a></li>
			<li><a data-value="e">지휘자 &amp; 반주자</a></li>			
		</ul>
	</div>
	<div class="body" id="tabBody">
	</div>
</div>
<script>
(function(){
	//var tempDate = new Date().format("yyyy-MM-dd");
	//$("[name=startDate], [name=endDate]").val(tempDate);

	$("#btnArea").on("click", "a", function(){
		var data = {};
		data.type = $(this).attr("id");
		if($("[name=startDate]").val() !== "" && $("[name=endDate]").val() !== ""){
			data.startDate = $("[name=startDate]").val().split("-").join("");
			data.endDate = $("[name=endDate]").val().split("-").join("");			
		}
		data.beforeCheckCond = $("[name=beforeCheckCond]").val();
		data.afterCheckCond = " || (before_check='Y' and attendance_date='20161225') " + $("[name=afterCheckCond]").val();
		
		delete userVars.oneInfos;
		if(data.type === "one"){
			$("#partTab").find("li.active").removeClass("active");
			$("#partTab").find("[data-value=all]").addClass("active");
			$("#partTab").show();
			$("#statsArea").hide();
		}else{
			$("#partTab").hide();
			$("#statsArea").show();
		}
		
		ajax.run({url:"/stats", data:data}, function(after, before){
			var names ,header, target;
			if(before.startDate && before.endDate){
				$("#dateArea").html(before.startDate.yyyymmdd("-") + ' ~ ' + before.endDate.yyyymmdd("-"));	
			}
			
			if(before.type === "part"){				
				names = ["파트","예배전 평균 수", "예배후 평균 수", "예배전 출석률","예배후 출석률"];	
				header = ["part","before_avg", "after_avg", "before_rate", "after_rate"];
				target = $("#statsArea"); 
			}else {
				names = ["파트","이름","예배전 출석률","예배후 출석률"];
				header = ["part","name", "before_rate", "after_rate"];
				target = $("#partTab #tabBody");
				userVars.oneInfos = {};
				userVars.oneInfos.names = names;
				userVars.oneInfos.header = header;
				userVars.oneInfos.datas = after;
			}
			
			query.setDatas(header, after);				
			target.html(query.setHtml());
			target.find("table").addClass("table classic hover");
			target.find("td").css("text-align", "center");
			
			names.forEach(function(item, idx){
				target.find("table").find("th").eq(idx).text(item);
			});
		});
	});
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		
		var target = $("#partTab #tabBody"),
			list,
			partText = $(this).find("a").data("value");
		if(partText === "s"){
			partText = "소프라노";
		}else if(partText === "a"){
			partText = "알토";
		}else if(partText === "t"){
			partText = "테너";
		}else if(partText === "b"){
			partText = "베이스";		
		}
		
		list = userVars.oneInfos.datas.filter(function(item){
			if(partText === "all"){
				return item;
			}else if(partText === item.part){
				return item;
			}else if(partText === "e" && _.indexOf(["소프라노", "알토","테너","베이스"], item.part) === -1){
				return item;
			}
		});
		
		query.setDatas(userVars.oneInfos.header, list);				
		target.html(query.setHtml());
		target.find("table").addClass("table classic hover");
		target.find("td").css("text-align", "center");
		
		userVars.oneInfos.names.forEach(function(item, idx){
			target.find("table").find("th").eq(idx).text(item);
		});
	});
}());
</script>