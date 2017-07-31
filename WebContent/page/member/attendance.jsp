<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="partTab">
	출석 일자 : <input type="date" class="input width100" name="attendanceDate" />
	&nbsp;&nbsp;&nbsp;
	<a class="btn" id="attend">출석 체크</a>
	<div class="head" style="margin-top:10px;">
		<ul class="tab top">
			<li class="active"><a data-value="s">소프라노</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">베이스</a></li>
			<li><a data-value="e">지휘자 &amp; 반주자</a></li>			
		</ul>
	</div>
	<div class="body" id="tabBody">
		<table id="partTable" class="table classic hover width100">
			<thead>
				<tr>			
					<th style="width:25%;">이름</th>
					<th style="width:25%;">생일</th>
					<th style="width:25%;">예배 전</th>
					<th style="width:25%;">예배 후</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		
		<table class="width100">
			<tr>
				<td colspan="2" style="width:50%">
					<div id="enrollment"></div>
				</td>
				<td style="width:25%;text-align:center;" id="before_count"></td>
				<td style="width:25%;text-align:center;" id="after_count"></td>
			</tr>
		</table>
		
	</div>
	
	<div id="attendList" style="margin-top:10px;">		
		예배전 재적 : <input type="text" class="input" name="before_count"/> &nbsp;&nbsp;
		예배후 재적 : <input type="text" class="input" name="after_count"/>
		<a class="btn" id="saveEnroll">재적 등록</a> 
		
		<table class="width100">
			<tr>
				<td class="listTd">
					예배전 연습 참석자. <span id="count"></span>
					<div id="beforeList" class="list"></div>
				</td>
				<td class="listTd">
					예배후 연습 참석자. <span id="count"></span>
					<div id="afterList" class="list"></div>
				</td>
			</tr>
		</table>
	</div>
</div>
<script>
(function(){
	var filepath = "page/member/";
	userVars.attendWindow = loadWindow(filepath + "attend_window.jsp");
	
	var today = new Date();
	if(today.getDay() > 0){
		today = today.minus("date", today.getDay());
	}
	$("[name=attendanceDate]").val(today.format("yyyy-MM-dd"));
	
	
	
	var getAge = function(birthday){
		var age = '';
		if(birthday){
			age = birthday.yyyymmdd("-");
		}
		
		return age;		
	}
	
	var tableInfos = table.initTable({
		table : $("#partTable"),
		template : function(row, index){
			var trHtml = "";
		    trHtml += '<tr>';
		    trHtml += '<td class="center">'+ row.name +'</td>';
		    trHtml += '<td class="center">'+ getAge(row.birthday) +'</td>';
		    trHtml += '<td class="center bigInput"><input type="checkbox" title="'+row.name+'" name="before_check" '+ ((row.before_check === "Y")?'checked="checked"':'') +'/></td>';
		    trHtml += '<td class="center bigInput"><input type="checkbox" title="'+row.name+'" name="after_check" '+ ((row.after_check === "Y")?'checked="checked"':'') +'/></td>';
		    trHtml += '</tr>';
		    return trHtml;
		},
		tdCnt : 4,
		rowData : []
	});
	
	var setTab = function(part){
		ajax.run({url:"attendance", data:{part:part, status:"Y", "attendance_date":$("[name=attendanceDate]").val().split("-").join("")}}, function(after){
		
			tableInfos.updateRows(after);
			//console.log(rtnValue[key]);
			$("#enrollment").text("파트별 재적 수 : " + after.length);
			setCheckedListWrap();
			$("[name=before_count]").val(after.length);
			$("[name=after_count]").val(after.length);
		});
	}
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).find("a").data("value"));
	});
	
	setTab($("#partTab").find(".active a").data("value"));
	
	var getData = function(that){
		var row = tableInfos.getData(that),
			data = {},
			datas = {},
			before_check = that.parents("tr").find("[name=before_check]").prop("checked"),
			after_check = that.parents("tr").find("[name=after_check]").prop("checked"),
			type;
		
		if(!before_check && !after_check){
			type = "delete";
		}else{
			type = "update";
		}
		
		data.url = "attendance/"+row.member_id ;
		data.method = type;
		datas.attendance_date = $("[name=attendanceDate]").val().split("-").join("");
		datas.part = $("#partTab").find(".active a").data("value");
		if(datas.part === "e"){
			datas.part = row.part;
		}
		
		if(type === "update"){
			datas["before_check"] = (before_check)?"Y":"N";
			datas["after_check"] = (after_check)?"Y":"N";
		}
		data.data = datas;
		return data;
	}
	
	var setCheckedListWrap = function(){
		setCheckedList("before");
		setCheckedList("after");
	}
	
	var setCheckedList = function(name){
		var tempList = [];
		tableInfos.table.find("tbody tr [name="+name+"_check]:checked").each(function(){
			tempList.push(tableInfos.getData($(this)).name);
		});
		
		$("#"+name+"List").text(tempList.join(", "));
		$("#"+name+"List").parents(".listTd").find("#count").text(tempList.length+" 명");
		$("#"+name+"_count").text(tempList.length + " 명");
	}
	
	var saveData = function(that){
		ajax.run(getData(that), function(rtnValue, before){
			if(rtnValue.cnt > 0){
				setCheckedListWrap();
			}
		});
	}
	tableInfos.table.find("tbody").on("click", "[name=before_check]", function(){
		saveData($(this));
	});
	
	tableInfos.table.find("tbody").on("click", "[name=after_check]", function(){
		saveData($(this));
	});
	
	$("[name=attendanceDate]").on("change", function(){
		setTab($("#partTab").find(".active a").data("value"));
	});
	
	userVars.tableInfos	= tableInfos; 
	$("#attend").on("click", function(){
		windowDialog.show(userVars.attendWindow, 400, 430);
	});
	
	$("#saveEnroll").on("click", function(){
		var data = {};
		data.attend_date = $("[name=attendanceDate]").val().split("-").join("");
		data.part = $("#partTab").find(".active a").data("value");
		data.before_count = $("[name=before_count]").val();
		data.after_count = $("[name=after_count]").val();
		
		ajax.run({url:"/enroll",method:"insert", data:data}, function(after, before){
			if(after > 0){
				msg.alert("재적이 등록 되었습니다.");	
			}
		});
	});
	
}());
</script>
