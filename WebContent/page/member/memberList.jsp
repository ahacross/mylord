<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="panel" id="partTab">
	<div class="tabHead">
		<ul class="tab top">
			<li><a data-value="all">전체</a></li>
			<li class="active"><a data-value="s">솦</a></li>
			<li><a data-value="a">알토</a></li>
			<li><a data-value="t">테너</a></li>
			<li><a data-value="b">벵</a></li>
			<li><a data-value="e">그외</a></li>			
		</ul>
	</div>
	<div class="body" id="tabBody">
		<div style="display: flex;">
			<div style="margin-bottom: 5px;flex:1;font-size: 12px;">
				<div style="display:inline;">상태 : </div>
				<div style="display:inline;" id="statusArea"></div>
			</div>
			<div style="width:75px;">
				<span id="switchTxt">간단</span>
	            <div class="switch">
					<input type="checkbox" id="switch"/>
					<label for="switch"></label>
				</div>
			</div>
		</div>
		<div id="gridPartList" style="margin-top:5px;"></div>		
	</div>
</div>
<script>
(function(){
	var statusHtml = '';
	_.keys(userVars.statusMap).forEach(function(item){
		statusHtml += '<label style="cursor:pointer;"><input type="checkbox" '+((item === "Y")?'checked="checked"':'')+' value="'+item+'"> '+userVars.statusMap[item]+'</label> &nbsp;';
	});
	
	$("#statusArea").html(statusHtml).on("click", ":checkbox", function(){
		setTab($("#partTab").find(".active a").data("value"));
	});
	
	if(cookie.get("mylordAuth").indexOf("파트장") > -1){
		setTimeout(function(){
			$(".tabHead a[data-value="+cookie.get("part")+"]").click();
		}, 500);
	}else{
		setTimeout(function(){
			setTab($("#partTab").find(".active a").data("value"));	
		}, 500);
	}
	
	const getSimpleColumns = function(){
		return [
			{
				title:"이름",
				name:"name",
				align:"center"
			},{
				title:"상태",
				name:"status",
				align:"center",
				formatter:function(value) {
					return userVars.statusMap[value]; 
				}
			},{
				title:"마지막 출석일",
				name:"last_attend",
				align:"center",
				formatter:function(value) {
					if(value) {
						let lastDate = new Date(value.yyyymmdd("-")),
							colorClass;
						const weekCnt = lastDate.getWeekState();
						if(weekCnt < 4){
							colorClass = "green";
						}else if(weekCnt < 12){
							colorClass = "orange";
						}else{
							colorClass = "red";
						}
							
						return '<div class="attendState '+colorClass+'">'+lastDate.format('yyyy년 MM월 dd일') + '</div>' ; 
					}else{
						return "";
					}
				}
			}
		];
	}
	
	const getDetailColumns = function(){
		return [
			{
				title:"이름",
				name:"name",
				align:"center"
			},{
				title:"폰 번호",
				name:"phone",
				align:"center"
			},{
				title:"생일",
				name:"birthday",
				align:"center",
				formatter:function(value) {
					return (value)?(value.yyyymmdd("-") + " / " + (new Date().getFullYear() - Number(value.yyyymmdd("-").split("-")[0]) + 1) + "세"): "";
				}
			},{
				title:"이메일",
				name:"email",
				align:"center"
			},{
				title:"상태",
				name:"status",
				align:"center",
				formatter:function(value) {
					return userVars.statusMap[value]; 
				}
			},{
				title:"마지막 출석일",
				name:"last_attend",
				align:"center",
				formatter:function(value) {
					if(value) {
						let lastDate = new Date(value.yyyymmdd("-")),
							colorClass;
						const weekCnt = lastDate.getWeekState();
						if(weekCnt < 4){
							colorClass = "green";
						}else if(weekCnt < 12){
							colorClass = "orange";
						}else{
							colorClass = "red";
						}
							
						return '<div class="attendState '+colorClass+'">'+lastDate.format('yyyy년 MM월 dd일') + '</div>' ; 
					}else{
						return "";
					}
				}
			}
		];
	}
	
	const getSummary = function(){
		return {
			height: 25,
	        columnContent: {	            
	        	name: {
	                template: function(valueMap) {
	                    return '재적수: ' + comma.on(valueMap.cnt) ;
	                }
	            }
	        }
		};
	}
	
	var getColumns = function(){
		const txtDom = $("#switchTxt");
		let columns;
		if($("#switch").prop("checked")){
			txtDom.text("상세");
			columns = getDetailColumns();
		}else{
			txtDom.text("간단");
			columns = getSimpleColumns();
		}
		
		if(cookie.get("mylordAuth").indexOf("임원") > -1){
			columns[0].formatter = function(value) {
				return '<a class="pointer">'+value+'</a>';
			} 
		}
		return columns;
	}
	
	var gridPartList = tuiGrid.makeGrid({el:$('#gridPartList'), columns: getColumns(), summary: getSummary()});
	
	var setTab = function(part){
		ajax.run({url:"member", data:{part:part}}, function(after, before){
			var statusArr = [],
				list;
			
			$("#statusArea").find(":checkbox:checked").each(function(item){
				statusArr.push($(this).val());
			});
			
			list = after.filter(function(item){
				if(_.indexOf(statusArr, item.status) > -1){
					return item;
				}
			});

			if(part === "all"){
				list.sort(compare.part("part"));
			}
			
			gridPartList.resetData(list);			
		});
	}
	userFns.setTab = setTab;
	
	$("#partTab").on("click", ".tab > li", function(){
		$(this).parent().find(".active").removeClass("active");
		$(this).addClass("active");
		setTab($(this).find("a").data("value"));
	});
	
	if(cookie.get("mylordAuth").indexOf("임원") > -1){
		gridPartList.on('click', function(e) {
			if(e.columnName === "name") {
				userWindows.memberWindow.init({type:"mod", row: e.instance.getRow(e.rowKey)});
				windowDialog.show(userWindows.memberWindow, 400, 430);
			}
    	});
	}
	
	$("#switch").on("change", function(){
		gridPartList.setColumns(getColumns());
	});
	
}());
</script>