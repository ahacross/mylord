<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>        
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta charset="UTF-8">
	<title>마이로드</title>
	
	<spring:url value="/resources/css/loadWrap.css" var="loadWrapCSS" />
	<link rel="stylesheet" type="text/css" href="${loadWrapCSS }">
	
	<spring:url value="/resources/plugins/jquery/jquery.js" var="jqueryJS" />
	<script type="text/javascript" src="${jqueryJS }"></script>
	
	<spring:url value="/resources/plugins/LAB/LAB.js" var="LABJs" />
	<script type="text/javascript" src="${LABJs }"></script>
	
	<spring:url value="/resources/js/loadWrap.js" var="loadWrapJS" />
	<script type="text/javascript" src="${loadWrapJS }"></script>
	
	<spring:url value="/resources/js/html5/html5shiv.js" var="html5shivJs" />
	<spring:url value="/resources/js/html5/respond.min.js" var="respondJs" />
	<!--[if lt IE 9]>
	<script type="text/javascript" src="${html5shivJs}"></script>
	<script type="text/javascript" src="${respondJs }"></script>
	<![endif]-->
	<script>
	$.wait = function(time) {
		var defer = $.Deferred();
		setTimeout(defer.resolve, time);   
		return defer.promise();
	}
 
	// 재귀함수  // 사용예제는 bomTable.js 에 있음.
	var fnRecursive = function(delayTime, checkFn, actionFn, target){
		if(checkFn(target)){
			return actionFn(target);
		}else{
			$.wait(delayTime).then(function(){
				fnRecursive(delayTime, checkFn, actionFn, target);
			});
		}
	}
	</script>
	<style>
	
		
	</style>
</head>
<body>
	<div style="display: flex;flex-direction: row;">
        <div style="flex: auto;">
        	<div>
        		<select name="name" class="dropdown-menu"></select>
        		<button id="editJson" class="button raised bg-blue-500 color-white" style="padding: 5px 12px;">수정</button>
        	</div>
        	
    		<div style="display: flex;flex-direction: row;margin-top:10px;">
    			<div id="checkListArea" style="flex: auto;">
    				<ul class="toolbar tabs bg-green-500 color-white" id="marketTypesTab"></ul>
    				<div id="checklistTable" class="hide"></div>
    			</div>
    		</div>    	
        </div>		
    </div>	
	<div id="resultArea"></div>
	<div class="windowContent"></div>
<script>
	window.userWindows = {};
	var setNameOptions = function(){
		ajax.run({url:"jsonFilelist"}, function(datas){
			var options= '<option value="">선택</option>';
			datas.forEach(function(str){
				options += '<option value="'+str+'">'+str+'</option>';
			});
			$("select[name=name]").html(options);
		});
	}
	
	var setCheckList = function(checkList) {
		checklistGrid.resetData(checkList);		
	}
	
	const getColumns = function(){
		return [
			{
				title:"완료",
				name:"check",
				align:"center",
				width:50,
				editOptions: {
					type:"checkbox",
					listItems :[{value:true}],
		            useViewMode: false
				},
				onAfterChange: function(ev){
					saveJson(ev.rowKey, ev.columnName, (ev.value === true)?true:false);
            	}
			},{
				title:"물품",
				name:"title",
				width:300
			},{
				title:"수량/용량",
				name:"Volume",
				align:"center",
				width:100
			},{
				title:"예상가",
				name:"est",
				align:"center",
				width:150,
				formatter:function(value) {
					return comma.on(value) + ' 원'
				}
			},{
				title:"구매가",
				name:"price",
				align:"center",
				width:150,				
	            editOptions: {
	                type: 'text',
	                useViewMode: false,
	                onBlur: function(input, ev){
						saveJson(ev.rowKey, ev.columnName, input.target.value);
		            }	
	            }
			}
		];
	}
	const getFooter = function(){
		return {
			height: 30,
	        columnContent: {	            
	        	est: {
	                template: function(valueMap) {
	                    return 'TOTAL: ' + comma.on(valueMap.sum) ;
	                }
	            },
	            price: {
	                template: function(valueMap) {
	                    return 'TOTAL: ' + comma.on(valueMap.sum);
	                }
	            }
	        }
		};
	}
	
	$(document).ready(function(){
		fnRecursive(50,
			function(){return window.jsLodingComplate || false;},
			function(){
				delete window.jsLodingComplate;
				userWindows.jsonWindow = loadWindow("page/windows/json_window.jsp");
				setNameOptions();
		
				$("select[name=name]").on("change", function(){
					var name = $(this).val();
					if(name !== "") {
						ajax.run({url:"json", data:{name:name}}, function(datas){
							window.jsonData = JSON.parse(datas.string); 
							
							var marketTypeHtml = '';
							jsonData.forEach(function(markets, idx){
								marketTypeHtml += '<li ripple data-idx="'+idx+'"><a class="pointer">'+makeTabText (markets) +'</a></li>';
							});
							
							$("#marketTypesTab").html(marketTypeHtml).find("[ripple]").first().click();
						});		
					}
				});
				
				$("#marketTypesTab").on("click", "[data-idx]", function(){
					$("#marketTypesTab").find(".selected").removeClass("selected");
					$(this).addClass("selected");
					
					setCheckList(deepCopy(jsonData[$(this).data("idx")].checkList));
					$("#checklistTable").show();
				});
				
				$("#editJson").on("click", function(){
					userWindows.jsonWindow.init();
					windowDialog.show(userWindows.jsonWindow, 400, 430);
				});
				
				window.checklistGrid = tuiGrid.makeGrid({el:$('#checklistTable'), rowHeaders:true, columns: getColumns(), footer:getFooter(), bodyHeight:false});
			}
		);
	});
	
	function makeTabText (markets) {
		return markets.marketType + ' ('+(markets.checkList.filter((check)=> {return check.check} ).length)+' / '+markets.checkList.length+')';
	}

	function saveJson(rowKey, field, value){
		jsonData[$(".selected").data("idx")].checkList[rowKey][field] = value;
		$(".selected a").html(makeTabText (jsonData[$(".selected").data("idx")]));

		ajax.run({url:"json", method:"update", data:{name:$("[name=name]").val(), json:JSON.stringify(jsonData)}}, function(result){
			console.log(result);
		});
	}

	var comma = {
		on : function(str){
			return String(str).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		},
		off:function(str){
				return String(str).replace(/[^\d]+/g, '');
		}
	}
</script>
</body>
</html>