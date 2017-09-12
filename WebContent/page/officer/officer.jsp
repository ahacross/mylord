<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
			<label>임기년도 : <select name="year" class="dropdown-menu"></select></label>
			<label>역할 : <select name="role" class="dropdown-menu"></select></label>
        </div>
		<div style="width: 2rem;position: relative;top: 5px;">
			<button id="addOfficer" class="fab bg-blue-500 color-white small hide" style="width: 1.1em;height: 1.1em;line-height: 20px;padding: .1em .05em;"><i class="icon-add"></i></button>
        </div>
    </div> 
	<div id="officersTable" style="margin-top:5px;"></div>
</div>
<script>
(function(){
	if(cookie.get("mylordAuth").indexOf("임원") > -1){
		// load 하는거
		userWindows.officerWindow = loadWindow("page/officer/officer_window.jsp");
		$("#addOfficer").show();
	}
	
	const getColumns = function(){
		return [
			{			
				title:"역할",
				name:"role",
				align:"center",
				formatter:function(value, rowData) {
					return value + ((value === "파트장")?' ('+userVars.partMap[rowData.part]+')':'');
				}
			},{
				title:"이름",
				name:"name",
				align:"center"
			},{
				title:"임기년도",
				name:"year",
				align:"center",
				formatter:function(value) {
					return value +' 년';
				}
			},{
				title:"임기 상태",
				name:"status",
				align:"center",
				formatter:function(value) {
					return (value === 'Y')?'임기중':'임기 종료';
				}
			}
		];
	}
	
	let officersGrid = tuiGrid.makeGrid({el:$('#officersTable'), columns: getColumns(), rowHeaders: true});
	officersGrid.on('click', function(e) {
		if(cookie.get("mylordAuth").indexOf("임원") > -1){
			if(e.columnName === "name") {
				windowOpen("update", e.instance.getRow(e.rowKey));
			}
		}
    });
	let setGridData = function(){
		ajax.run({url:"officer"}, function(datas){
			officersGrid.saveDatas(datas);
			setOptions("role", datas);
			setOptions("year", datas);
		});
	}
	setGridData();
	userFns.setGridData = setGridData; 
	
	function setOptions(key, datas) {
		let options = '<option value="">전체</option>';
		let values = _.sortBy(_.uniq(datas.map(data => data[key]))).reverse();
		
		values.forEach(function(value){
			options += '<option value="'+value+'">'+value+'</option>';	
		})
		
		const html = $("[name="+key+"]").html(options);
		
		if(key === "year") {
			html.val(values.first()).change();
		}
	}
	
	function searchDatas(key, value, datas) {
		datas = datas || officersGrid.datas;
		if(datas){
			let rows = datas.filter(row => (row[key]+"").indexOf(value) > -1);
			officersGrid.resetData(rows);	
		}
	}
	
	$(".panel").on("change", "select", function(){
		searchDatas($(this).attr("name"), $(this).val());
	});
	
	
	const windowOpen = function(type, row) {
		const targetWindow = userWindows.officerWindow;
		let params = {type:type};
		
		if(row) {
			params.row = row;
		}
		targetWindow.init(params);
		windowDialog.show(targetWindow, 400, 430);
	}
	
	$("#addOfficer").on("click", function(){
		windowOpen("insert");
	});
	
}());



</script>