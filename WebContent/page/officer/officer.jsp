<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel">	
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
			
        </div>
		<div style="width: 8.5rem;">
			<button id="addHistory" class="fab bg-blue-500 color-white small hide" style="width: 1.1em;height: 1.1em;line-height: 20px;padding: .1em .05em;"><i class="icon-add"></i></button>
        </div>
    </div> 
	<div id="officersTable" style="margin-top:5px;"></div>
</div>
<script>
(function(){
	
	userWindows.officerWindow = loadWindow("page/officer/officer_window.jsp");
	
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
	
	var officersGrid;	
	var setGrid = function(){
		ajax.run({url:"officer"}, function(after){		
			officersGrid = tuiGrid.makeGrid({el:$('#officersTable'), data: after, columns: getColumns(), rowHeaders: true});
		});
	}
	setGrid();
	
}());



</script>