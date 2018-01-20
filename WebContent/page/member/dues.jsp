<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="partTab">	
	<div class="tabHead">
		<ul class="tab top">
			<li class="active"><a data-value="s">솦</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">벵</a></li>
			<li><a data-value="e">그외</a></li>			
		</ul>
	</div>
	<div class="body" id="tabBody">
		<div style="margin-bottom: 5px;font-size: 12px;">
			<div style="display:inline;">상태 : </div>
			<div style="display:inline;" id="statusArea"></div>
		</div>
		<div style="display:flex;">
			<div style="flex:1">
				<div class="tui-datepicker-input tui-datetime-input tui-has-focus">
	                <input type="text" id="datepicker-input" name="year" aria-label="Date-Time">
	                <span class="tui-ico-date"></span>
	            </div>
	            <div class="datepicker-cell" id="datepicker-year"></div>
			</div>
        	<button id="saveDues" class="button raised bg-blue-500 color-white" title="대원추가" style="float:right;padding: 2px 10px 2px 15px;margin-bottom: 5px;">회비 저장</button>    
		</div>
		
		<div id="gridPartList" style="margin-top:5px;"></div>
	</div>
</div>

<script>
(function(){ 
	userVars.collectDues = {};
	
	let year = new tui.DatePicker('#datepicker-year', {
    	date: new Date(),
        language: 'ko',
        type: 'year',
        input: {
            element: '#datepicker-input',
            format: 'yyyy'
		}
    });
	
	var statusHtml = '';
	_.keys(userVars.statusMap).forEach(function(item){
		statusHtml += '<label style="cursor:pointer;"><input type="checkbox" '+((item === "Y")?'checked="checked"':'')+' value="'+item+'"> '+userVars.statusMap[item]+'</label> &nbsp;';
	});
	
	$("#tabBody #statusArea").html(statusHtml).on("click", ":checkbox", function(){
		setTab($(".tabHead .active a").data("value"));
	});
	
	const getColumns = function(){
		return [
			{
				title:"이름",
				name:"name",
				align:"center"
			},{
				title:"회비 내역 수정",
				name:"dues_cnt",
				align:"center",
				formatter: function(value){
					return value || 0;
				},
				editOptions: {
	                type: 'select',
	                listItems: [
	                	{ text: '0 개월', value: 0 },
	                    { text: '1 개월', value: 1 },
	                    { text: '2 개월', value: 2 },
	                    { text: '3 개월', value: 3 },
	                    { text: '4 개월', value: 4 },
	                    { text: '5 개월', value: 5 },
	                    { text: '6 개월', value: 6 },
	                    { text: '7 개월', value: 7 },
	                    { text: '8 개월', value: 8 },
	                    { text: '9 개월', value: 9 },
	                    { text: '10 개월', value: 10 },
	                    { text: '11 개월', value: 11 },
	                    { text: '12 개월', value: 12 }
	                ],
	                useViewMode: false
	            },
	            onAfterChange: function(ev){
	            	collectChangeDues(ev.rowKey);
            	}
			}
		];
	}
	
	var gridPartList = tuiGrid.makeGrid({el:$('#gridPartList'), columns: getColumns(), rowHeight:25});
	
	var setTab = function(part){
		ajax.run({url:"dues", data:{part:part, year:$("[name=year]").val()}}, function(partList){
			let checkedStatus = [];
			$("#tabBody #statusArea :checkbox:checked").each(function(){
				checkedStatus.push($(this).val());
			});
			
			gridPartList.resetData(partList.filter(info => _.indexOf(checkedStatus, info.status) > -1));
		});		
	}
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).find("a").data("value"));
	});
	
	setTab($("#partTab").find(".active a").data("value"));

	var collectChangeDues = function(rowKey){
		const row = gridPartList.getRow(rowKey);
		userVars.collectDues[row.member_id] = row.dues_cnt;
	}
	
	var saveDues = function(member_id, dues_cnt) {
		return new Promise(function(resolve, reject) {
			ajax.run({url: "dues", method: "insert", data: {dues_cnt: Number(dues_cnt), member_id:member_id, year: $("[name=year]").val()}}, function(after, before){
				resolve(after);
			});
		});
	}
	
	var saveDuesWrap = function(){
		const collectDues = userVars.collectDues;
		let promises = [];
		_.each(collectDues, function(dues_cnt, member_id){
			promises.push(saveDues(member_id, dues_cnt));
		});
		
		Promise.all(promises).then(function(arguments) {
			console.log(arguments);
		    msg.alert("저장 되었습니다.");
		});
		
		userVars.collectDues = {};
	}
	$("#saveDues").on("click", saveDuesWrap);
	
}());
</script>