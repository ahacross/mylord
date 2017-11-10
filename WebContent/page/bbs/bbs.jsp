<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
			<div class="text-input-container card">
				<select name="search_category_id" class="dropdown-menu"></select>
				<i class="icon-search text-input-icon"></i>
				<input type="text" name="search" class="text-input" placeholder="제목 검색"/>
			</div>
        </div>
		<div style="width: 7.5rem;">
			<button id="addBbs" class="fab bg-blue-500 color-white small hide" style="width: 1.1em;height: 1.1em;line-height: 20px;padding: .1em .05em;"><i class="icon-add"></i></button>
			<span id="switchTxt">간단</span>
            <div class="switch">
				<input type="checkbox" id="switch"/>
				<label for="switch"></label>
			</div>
        </div>
    </div> 
	<div id="gridBbs" style="margin-top:5px;"></div>
</div>
<script>
(function(){
	if(cookie.get("mylordAuth").indexOf("임원") > -1){
		// load 하는거
		userWindows.bbsWindow = loadWindow("page/bbs/bbs_window.jsp");
		$("#addBbs").show();
	}
	
	if(Responsive.device !== "desktop"){
		$("[name=search]").css("width", "150px");
		
	}

	const getDetailColumns = function(){
		return [
			{
				title:"카테고리",
				name:"category_names",
				align:"center",
				width:100
				
			},{
				title:"제목",
				name:"title"
			},{
				title:"조회수",
				name:"count",
				align:"center",
				width:100,
				formatter:function(value) {
					return comma.on(value);
				}
			},{
				title:"작성자",
				name:"regi_member_name",
				align:"center",
				width:100
			},{
				title:"등록일시",
				name:"regi_date",
				align:"center",
				width:150
			}
		];
	}

	const getSimpleColumns = function(){
		return [
			{
				title:"제목",
				name:"title"
			},{
				title:"작성자",
				name:"regi_member_name",
				align:"center",
				width:100
			}
		];
	}

	var getColumns = function(){
		const txtDom = $("#switchTxt");
		let columns,
			number = 0;
		if($("#switch").prop("checked")){
			txtDom.text("상세");
			columns = getDetailColumns();
			number = 1;
		}else{
			txtDom.text("간단");
			columns = getSimpleColumns();
		}
		
		/* if(cookie.get("mylordAuth").indexOf("임원") > -1){
			columns[number].formatter = function(value) {
				return '<a class="pointer">'+value+'</a>';
			} 
		} */
		return columns;
	}
	
	var gridBbs = tuiGrid.makeGrid({el:$('#gridBbs'), columns: getColumns(),rowHeaders: true});
	
	if(cookie.get("mylordAuth").indexOf("임원") > -1){
		gridBbs.on('click', function(e) {
			if(e.columnName === "title") {
				//historyWindowOpen("update", e.instance.getRow(e.rowKey));
			}
	    });
	}

	let setGridBbs = function(bbs_id){	
		var params = {url:"bbs"},
		search_category_id = $("[name=search_category_id]").val();

		if(typeof bbs_id === "number"){
			params.data = {bbs_id: bbs_id};	
		}
		
		if(search_category_id){
			if(!params.data){			
				params.data = {};
			}
			params.data.search_category_id = search_category_id;
		}
		
		ajax.run(params, function(datas){
			gridBbs.resetData(datas);
			gridBbs.saveDatas(datas);
		});
	}
	setGridBbs();
	userFns.setGridBbs = setGridBbs;
	 
	$("#switch").on("change", function(){
		gridBbs.setColumns(getColumns());
	});

	const bbsWindowOpen = function(type, row) {
		const targetWindow = userWindows.bbsWindow;
		let params = {type:type};
		
		if(row) {
			params.row = row;
		}
		targetWindow.init(params);
		windowDialog.show(targetWindow, 400, 430);
	}
	
	$("#addBbs").on("click", function(){
		bbsWindowOpen("insert");
	});
	
	$("[name=search]").on("keyup", function(event){
		if(event.keyCode === 13){
			const search = $(this).val().trim();
			let rows = gridBbs.datas.filter(row => (row.title+"").indexOf(search) > -1);
			gridBbs.resetData(rows);
		}		
	});

	setSelectBox({url:"bbs/category", target:$("[name=search_category_id]"), name:"category_name", value:"category_id"});
	$("[name=search_category_id]").on("change", setGridBbs);
	
}());
</script>
