<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="partTab">
	출석 일자 : <input type="date" class="input" name="attendanceDate" />
	&nbsp;&nbsp;&nbsp;
	<button id="attend" class="button raised bg-blue-500 color-white" style="padding: 3px 10px;">출석 체크</button> &nbsp;&nbsp;
	<button id="attendInit" class="button raised" style="padding: 3px 10px;">초기화</button> &nbsp;&nbsp;
	<button id="report" class="button raised" style="padding: 3px 10px;">보고</button>
	<div class="tabHead">
		<ul class="tab top">			
			<li class="active"><a data-value="s">솦</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">벵</a></li>
			<li><a data-value="e">그외</a></li>			
		</ul>
	</div>
	
	<div id="gridPartList" style="margin-top:5px;"></div>	
	<div id="attendList" style="margin-top:10px;">
		<div style="display:flex">
			<label style="flex:1">예배전 재적 : <input type="text" class="input" name="before_count" style="width:100px;"/></label> &nbsp;&nbsp;
			<label style="flex:1">예배후 재적 : <input type="text" class="input" name="after_count"  style="width:100px;"/></label> &nbsp;&nbsp;
			<button id="saveEnroll" class="button raised bg-blue-500 color-white" style="padding: 3px 10px;min-width: 90px;">재적 수정</button>	
		</div>
	</div>
</div>
<script>
(function(){
	userWindows.attendWindow = loadWindow("page/member/attend_window.jsp");
	
	var today = new Date();
	if(today.getDay() > 0){
		today = today.minus("date", today.getDay());
	}
	$("[name=attendanceDate]").val(today.format("yyyy-MM-dd"));
	
	const getColumns = function(){
		return [
			{
				title:"이름",
				name:"name",
				align:"center"
			},{
				title:"생일",
				name:"birthday",
				align:"center",
				formatter:function(value) {
					return (value)?(value.yyyymmdd("-")): "";
				}
			},{
				title:"예배 전",
				name:"before_check",
				align:"center",				
				editOptions: {
					type:"checkbox",
					listItems :[{value: "Y"}],
		            useViewMode: false
				},
				onAfterChange: function(ev){
					saveData(ev.rowKey);
            	}
			},{
				title:"예배 후",
				name:"after_check",
				align:"center",				
				editOptions: {
					type:"checkbox",
					listItems :[{value:"Y"}],
		            useViewMode: false
				},
				onAfterChange: function(ev){
					saveData(ev.rowKey);
            	}
			}
		];
	}
	
	const getSummary = function(){
		return {
			position: 'bottom',
			height: 30,
	        columnContent: {	            
	        	before_check: {
	                template: function(summary) {
	                   return  '';
	                }
	            },
	            after_check: {
	                template: function(summary) {
	                	return '';
	                }
	            }
	        }
		};
	}
	
	let gridPartList = tuiGrid.makeGrid({el:$('#gridPartList'), columns: getColumns(), summary : getSummary()});
	
	var setTab = function(part){
		ajax.run({url:"attendance", data:{part:part, status:"Y", "attendance_date":$("[name=attendanceDate]").val().split("-").join("")}}, function(memberList){
			gridPartList.resetData(memberList);
			getEnroll(memberList.length);
			setTextData('before');
			setTextData('after');
		});
	}
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).find("a").data("value"));
	});
	
	setTab($("#partTab").find(".active a").data("value"));
	
	var makeBody = function(rowKey){
		var row = gridPartList.getRow(rowKey),
			data = {},
			datas = {},
			type;
		
		if(row.before_check === "" && row.after_check === ""){
			type = "delete";
		}else{
			type = "update";
		}
		
		datas.url = "attendance/"+row.member_id ;
		datas.method = type;
		data.attendance_date = $("[name=attendanceDate]").val().split("-").join("");
		data.part = $(".tabHead .tab .active a").data("value");
		if(data.part === "e"){
			data.part = row.part;
		}
		
		if(type === "update"){
			data.before_check = row.before_check;
			data.after_check = row.after_check;
		}
		datas.data = data;
		return datas;
	}
	
	var saveData = function(rowKey){
		ajax.run(makeBody(rowKey), function(rtnValue, before){
			if(rtnValue.cnt > 0){
				setTextData('before');
				setTextData('after');
			}
		});
	}
	
	var setTextData = function(name){
		const attendTargets = $('#gridPartList .tui-grid-rside-area .tui-grid-table-container .tui-grid-table tbody tr').find("td[data-column-name="+name+"_check] :checkbox:checked"), 
			attendCnt = attendTargets.length;
		let names = [];
		
		attendTargets.each(function(){
			names.push(gridPartList.getRow($(this).parents("tr").data("row-key")).name);
		});
		
		$('#gridPartList .tui-grid-rside-area .tui-grid-summary-area .tui-grid-table tbody tr').find("th[data-column-name="+name+"_check]").text(attendCnt+' 명');
	}
	

	$("[name=attendanceDate]").on("change", function(){
		setTab($(".tabHead .tab .active a").data("value"));
	});
	
	 
	$("#attend").on("click", function(){
		windowDialog.show(userWindows.attendWindow, 400, 430);
	});
	
	const makeEnrollData = function(){
		let data = {};
		data.attend_date = $("[name=attendanceDate]").val().split("-").join("");
		data.part = $("#partTab").find(".active a").data("value");
		data.before_count = $("[name=before_count]").val();
		data.after_count = $("[name=after_count]").val();
		return data;
	}
	userFns.makeEnrollData = makeEnrollData;
	
	$("#saveEnroll").on("click", function(){
		ajax.run({url:"/enroll",method:"insert", data: makeEnrollData()}, function(after, before){
			if(after > 0){
				msg.alert("재적이 수정 되었습니다.");	
			}
		});
	});
	
	var getEnroll = function(defaultCnt){
		ajax.run({url:"/enroll", data:{attend_date:$("[name=attendanceDate]").val().split("-").join(""), part:$(".tabHead .tab .active a").data("value")}}, function(datas){
			$("#attendList [name=before_count]").val(datas.before_count || defaultCnt);
			$("#attendList [name=after_count]").val(datas.after_count || defaultCnt);
		});
	}
	
	$("#attendInit").on("click", function(){
		msg.confirm("초기화 하시겠습니까?", function(){
			const rows = gridPartList.getRows(),
				rowKeyTr = gridPartList.$el.find(".tui-grid-rside-area tr[data-row-key]");
			rows.forEach(function(datas){
				if(datas.before_check === "Y") {
					rowKeyTr.eq(datas.rowKey).find(":checkbox").eq(0).click();
				}
				
				if(datas.after_check === "Y") {
					rowKeyTr.eq(datas.rowKey).find(":checkbox").eq(1).click();	
				}
			});	
		});
	});
	
	$("#report").on("click", function(){
		let reportMsg = new Date($("[name=attendanceDate]").val()).format("MM/dd"),
			partText = $(".tabHead .tab .active a").text(),
			beforeList = [],
			afterList = [];
		
		if(partText === "벵"){
			partText = "베이스";
		}else if(partText === "솦"){
			partText = "소프라노";
		}
		
		const rows = gridPartList.getRows(),
			rowKeyTr = gridPartList.$el.find(".tui-grid-rside-area tr[data-row-key]");
		rows.forEach(function(datas){
			if(datas.before_check === "Y") {
				beforeList.push(datas.name);
			}
			
			if(datas.after_check === "Y") {
				afterList.push(datas.name);	
			}
		});
		
		
		reportMsg = reportMsg +" " + partText + "<br/>";
		reportMsg = reportMsg + "예배 전 <br/>";
		reportMsg = reportMsg + (beforeList.join(" ")) + " " + beforeList.length + " 명" + "<br/>";
		reportMsg = reportMsg + "예배 후 <br/>";
		reportMsg = reportMsg + (afterList.join(" ")) + " " + afterList.length + " 명" + "<br/>";
		
		msg.alert(reportMsg);
	});
	
	
}());
</script>
