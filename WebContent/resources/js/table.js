var table = (function(table, $, undefined){
	var options = {
		tdCnt   : 0,
		rowData : [],
		userFns : {},
		table : null,
		needPager : false,
		template : null,
		rowIdx 	: 1,
		indexToIdx : function(index){ // row.index 를 가지고 rowData 의 순서(idx)의 값을 리턴한다.
			var datas = this.getDatas(),
				tempData,
				returnValue;
		
			for(var i=0, n=datas.length; i<n; i++){
				tempData = datas[i];
				if(index === tempData.index){
					break;
				}
			}
			return i;
		},
		getRowIdx : function(){ return (this.rowIdx++ ); },
		findIdx : function(target){return target.parents("tr").index();},
		getData : function(target){
			var idx = target;
			if(isNaN(target)){
				idx = this.findIdx(target);
			}
			return this.rowData[idx];
		},		
		getDatas : function(){return this.rowData;},
		setDatas : function(datas){this.rowData = datas;},
		insertRows : function(datas, index){
			if(datas.constructor !== Array){
				datas = [datas];
			}
			
			table.insertTrs(this, datas, index);
		},
		updateRows : function(newRows, startNum){table.updateRowData(this, newRows, startNum);},
		insertTr : function(newRow){ table.insertTr(this, newRow); },
		updateTr : function(newRow){ table.updateTr(this, newRow); },
		updateRow: function(newRow, idx){ table.updateRow(this, newRow, idx); },
		removeTr : function(removeIdx){ table.removeTr(this, removeIdx); },
		removeRow : function(target){table.removeRow(this, this.findIdx(target)); },
		isOpen : function(trTarget, tdIdx){
			var trIdx = (trTarget === null)?0:this.findIdx(trTarget),
				targetI = this.table.find("tbody tr").eq(trIdx).children().eq(tdIdx).find("i");
			
			return (targetI.hasClass("icon-right"));			
		},
		toggleArrow : function(trTarget, tdIdx, row){
			var trIdx = (trTarget === null)?0:this.findIdx(trTarget),
				targetI = this.table.find("tbody tr").eq(trIdx).children().eq(tdIdx).find("i"),
				newClass;
			
			if(targetI.hasClass("icon-left")){
				newClass = "icon-right";
				row.arrowRight = true;
			}else{
				newClass = "icon-left";
				row.arrowRight = false;
			}
			targetI.removeAttr("class").addClass(newClass);
			
		},
		open : function(index){
			findTargetTr(this, index, false);
		},
		fold : function(index){
			findTargetTr(this, index, true);
		},
		openAll : function(){
			findTargetTr(this, "0", false);
		}, 
		foldAll : function(){
			findTargetTr(this, "0", true);
		},
		toggleOpen : function(e, that, tdIdx){			
			var row = this.getData(that),
				index = row.index;
			
			if(this.isOpen(that, tdIdx)){ // open
				this.fold(index);
			}else{	// fold 일때;
				this.open(index);
			}
			
			this.toggleArrow(that, tdIdx, row);
			e.stopPropagation();
		},
		getIndexData : function(index){ return getIndexData(this, index); },
		getPath : function(index){ 
			var path = getPath(this, index, []);
			//console.log(getPath(this, index, []));
			//return getPath(this, index, []);
			return path;
		},
		reload : function(){ makeTr(this); },
		getMaxIdx : function(idxType){		
			return getMaxIdx(this, idxType);
		},
		findData : function(name, value){
			var datas = this.getDatas(),
				returnData = {};
			
			_.forEach(datas, function(data, dataIndex){
				if(data[name] === value){
					returnData.data = data;
					returnData.index = dataIndex;
					return false;
				}				
			});
			
			return returnData;
		},
		getChildrens : function(findData){
			var datas = this.getDatas(),
			indexPattern = new RegExp("^"+(findData.index)+"." ),
			indexDepth = findData.depth,
			tempData,
			dataIndex,
			childrens = [];
		
			for(var i=0,n=datas.length; i<n; i++){
				tempData = datas[i];
				dataIndex = tempData.index+".";
				
				if(indexPattern.test(dataIndex) && indexDepth <= tempData.depth){
					childrens.push(tempData);
				}
			}
			
			return childrens;
		}
	}
	
	
	
	var getIndexData = function(tableInfos, index){		
		var datas = tableInfos.getDatas();
		
		for(var i=0,n=datas.length; i<n; i++){
			if(datas[i].index === index){
				break;
			}
		}
		return datas[i];
	}
	
	var getPath = function(tableInfos, index, pathArr){
		var tempIndex = index.split("."),
			tempData = getIndexData(tableInfos, index).data;
		
		pathArr.push(tempData.znodeName);
		
		if(index !== "0"){
			index = tempIndex.removeLast().join(".");
			getPath(tableInfos, index, pathArr);
		}else{
			pathArr.reverse();
		}
		return pathArr.join("/"); 
	}
	
	// open/fold에서 접거나 펼칠 대상을 찾음.
	var findTargetTr = function(tableInfos, index, isFold){
		var datas = tableInfos.getDatas(),
			tempData,
			idxPattern = new RegExp("^"+index+"\\."),
			targetIdxArr = [],
			eqListArr = [], 
			targetTrs;
		
		
		for(var i=0, n=datas.length; i<n; i++){
			tempData = datas[i];
			
			if(idxPattern.test(tempData.index)){
				if(tempData.data){
					tempData.data.isFold = isFold;	
				}else{
					tempData.isFold = isFold;
				}
								
				targetIdxArr.push(i);
			}
		}
		
		for(i=0, n=targetIdxArr.length; i<n; i++){
			eqListArr.push("tr:eq("+targetIdxArr[i]+")");			
		}
		
		targetTrs = tableInfos.table.find("tbody").find(eqListArr.join(", "));
		
		//console.log(eqListArr.join(", "));
		
		if(isFold){
			targetTrs.hide();
		}else{
			targetTrs.show();
		}
	}
	
	table.initTable = function(arguOptions){
		var tempOptions = {};
		$.extend(tempOptions, options);
		$.extend(tempOptions, arguOptions);
		
		if(tempOptions.table !== null &&  tempOptions.template !== null){
			makeTr(tempOptions);
			
			if(tempOptions.tableHeight){
				tempOptions.table.fixedHeaderTable({cloneHeadToFoot: false, fixedColumn:true, height: tempOptions.tableHeight});
				tempOptions.table.css("width", "100%").parents(".fht-fixed-body").css("width", "100%");
				tempOptions.table.parent().css({"overflow-y":"auto", "overflow-x":"hidden"});
				//tempOptions.table.css({"width":(Number(tempOptions.table.css("width").split("px")[0]) + 10)+"px"});
				tempOptions.table.parents(".fht-table-wrapper").find(".fht-fixed-column .fht-tbody").css({"overflow":"hidden"});
				var trHeight = Number(tempOptions.table.parents(".fht-table-wrapper").find(".fht-fixed-column .fht-thead .fht-table").css("height").split("px")[0]);
				tempOptions.table.css("margin-top", "-"+ ((trHeight === 30)?35:trHeight) + "px");
				//tempOptions.table.fixedHeaderTable("destroy"); // destroy 할때
				
				fnFactorial(50, // delayTime
					function(tempOptions){ // checkFn
						var tempArea = tempOptions.table.parents(".fht-table-wrapper").find(".fht-tbody");
						return (tempArea.length > 0 && tempArea.eq(0).html() !== "")?true:false;
					},
					function(tempOptions){ // actionFn
						tempOptions.table.parents(".fht-table-wrapper").find(".fht-tbody").eq(0).hide(); // 데이터가 없습니다. 하고 보임.
					},
					tempOptions
				)
			}
		}else{
			if(tempOptions.table === null){
				msg.alert("table이 설정 되지 않았습니다.");
			}
			
			if(tempOptions.template === null){
				msg.alert("template이 설정 되지 않았습니다.");
			}
		}
		
		return tempOptions;
	}
	
	var makeTr = function(targetOptions, startNum){
		var trHtml = "",
			rowDatas = targetOptions.rowData;
		
		startNum = startNum || 0;
		
		if(rowDatas.length === 0){
			trHtml += '<tr><td colspan="'+targetOptions.tdCnt+'" class="none" align="center">데이터가 없습니다.</td></tr>';
		}else{
			for(var i=0, n=rowDatas.length; i<n; i++){				
				trHtml += targetOptions.template(rowDatas[i], (i+1 + startNum), n);
			}	
		}
		targetOptions.table.find("tbody").html(trHtml);
	}
	
	var makeIndex = function(index, depth, num){
		var tempIndex = index.split(".");
		if(tempIndex.length > depth){	
			tempIndex = tempIndex.slice(0, depth);
			tempIndex[tempIndex.length-1] = num;
		}else if(tempIndex.length < depth){
			tempIndex.push(num);			
		}else{
			tempIndex[tempIndex.length-1] = num;
		}
		return tempIndex.join(".");
	}
	
	var getMaxIdx = function(tableInfos,idxType){
		var datas = tableInfos.getDatas(),
			index,
			indexPattern = new RegExp("^"+(idxType.split(/[\d]+/).join("[\\d]+")) + "$"),
			maxIndex,
			dataIndex;
		
		for(var i=0,n=datas.length; i<n; i++){
			index = datas[i].index;
			if(indexPattern.test(index)){
				maxIndex = index;
				dataIndex = i;
			}
		}
		
		return {index : maxIndex, dataIndex : dataIndex};
	}
	
	table.updateRowData = function(tableInfos, newRows, startNum){
		tableInfos.rowIdx = 1;
		tableInfos.rowData = newRows || [];
		makeTr(tableInfos, startNum);
	}	
	
	table.insertTrs = function(tableInfos, insertDatas, index){
		var rowData = tableInfos.rowData,
			tempRow,
			tempData;
		
		for(var i=0, n=rowData.length; i<n; i++){
			tempRow = rowData[i];
			
			if(index === tempRow.index){
				for(var ii=0, nn=insertDatas.length; ii<nn; ii++){
					rowData.splice(i + ii + 1 , 0 , insertDatas[ii]);
				}
			}
		}
		makeTr(tableInfos);
	}
	
	table.insertTr = function(tableInfos, insertData){
		var addIdx = insertData.index+"",
			rowData = tableInfos.rowData,			
			row;
		
		if(addIdx.split(".").length > 1){
			var findIdx,
				newRowData = [];
			
			if(addIdx.substring(addIdx.lastIndexOf(".")+1) === "0"){ // 0.0.1 insertData.index의 가장 마지막 값이 0일때
				findIdx = addIdx.substring(0, addIdx.lastIndexOf("."));
			}else{
				findIdx = addIdx.substring(0, addIdx.lastIndexOf(".")+1) + (Number(addIdx.substring(addIdx.lastIndexOf(".")+1)) - 1);
			}
			
			for(var i=0, n=rowData.length; i<n; i++){
				row =rowData[i];
				newRowData.push(row);
				if(row.index+"" === findIdx){
					newRowData.push(insertData);
				}
			}
			rowData = newRowData;
		} else{	// addData.index에 .이 포함되어 있지 않을 때
			var maxIdx = getMaxIdx(tableInfos, addIdx).index;
			
			if(Number(addIdx) < Number(maxIdx)){ 
				for(var i=0, n=rowData.length; i<n; i++){
					if(maxIdx === rowData[i].index){
						break;
					}
				}
			}
			rowData.splice(i || rowData.length , 0, insertData);
			//rowData.push(insertData);
		}
		tableInfos.rowData = rowData;
		makeTr(tableInfos);
	}
	
	table.updateTr = function(tableInfos, updateData){
		var rowData = tableInfos.rowData,			
			row;
		
		for(var i=0, n=rowData.length; i<n; i++){
			row = rowData[i];
			if(row.index+"" === updateData.index){
				$.extend(row , updateData);
			}
		}
		
		makeTr(tableInfos);
	}
	
	table.updateRow = function(tableInfos, newRow, idx){
		var rowData = tableInfos.rowData;
		rowData.splice(idx, 1, newRow);
		makeTr(tableInfos);
	}	
	
	table.removeChildTr = function(tableInfos, removeIdx){
		var rowData = tableInfos.rowData,
			row,
			pattern = new RegExp("^"+removeIdx+"\\.[\\d]+"),
			newRowData = [];
		
		for(var i=0, n=rowData.length; i<n; i++){
			row = rowData[i];

			if(!pattern.test(row.index)){
				newRowData.push(row);
			}
		}
		
		tableInfos.rowData = newRowData;
		makeTr(tableInfos);
	}
	
	table.removeTr = function(tableInfos, removeIdx){
		var rowData = tableInfos.rowData,
			row,
			newRowData = [];
		
		for(var i=0, n=rowData.length; i<n; i++){
			row = rowData[i];
			if(row.index === removeIdx){
				rowData.splice(i, 1);
				break;
			}
		}
		
		makeTr(tableInfos);
	}
	
	// removeRow는 기존에 removeTr이 row의 index에 기반해서 지우는데 반해 removeRow는 rowData의 순번에 의해 삭제한다.
	table.removeRow = function(tableInfos, dataIdx){
		var rowData = tableInfos.rowData;
      
		rowData.splice(dataIdx, 1);
		makeTr(tableInfos);
	}
   
	table.removeAllTr = function(tableInfos){
		tableInfos.rowData = [];
		makeTr(tableInfos);
	}
	
	var indexLastNumber = function(index){
		return Number(index.split(".").getLast());
	}
	
	// index : 새로 추가되는 data의 index 임.
	var updateIndex = function(index, datas){
		var dataIndex,
			firstCheck = true,
			lastCheck = true,
			dataIdx,
			returnObj = {},
			tempData,
			siblingPattern = new RegExp("^"+(index.split(".").removeLast().join("."))+"\.[\\d]+$"),
			indexPattern = new RegExp("^"+(index) ),			
			indexDepth = index.split(".").length,
			lastNum = indexLastNumber(index),
			changeIndexPattern = indexPattern,
			changeIndex = index.split(".").setLast((Number(index.split(".").getLast())+1)+"").join("."); // 인덱스가 1.2.3 이라면 마지막 값 3이 온다.
		
		// indexPattern 과 매칭되는 
		for(var i=0,n=datas.length; i<n; i++){
			tempData = datas[i];
			dataIndex = tempData.index;
			
			// 중간에 껴 들어오면 하위에 있는 모든 row의 index를 변경해 주어야 한다.
			// 그래서  siblingPattern으로 동등한 형제레벨을 찾고 index의 마지막 값보다 큰 것들의 값을 바꿔주기 위해 설정하는 부분. 
			if(siblingPattern.test(dataIndex) && lastNum < indexLastNumber(dataIndex)){
				changeIndexPattern = new RegExp("^"+(dataIndex) );
				lastNum = indexLastNumber(dataIndex);
				changeIndex = dataIndex.split(".").setLast((Number(dataIndex.split(".").getLast())+1)+"").join(".");
			}			
			
			// 실제 index 를 바꾸는 부분.
			if(changeIndexPattern.test(dataIndex)){
				datas[i].index = dataIndex.split(changeIndexPattern).join(changeIndex);
			}
			
			// indexPattern과 맞는 i값 저장 
			if(indexPattern.test(dataIndex) ){ 				
				if(firstCheck){
					dataIdx = i;
					firstCheck = false;
				}
				lastCheck = false;
			}
		}
		
		if(lastCheck){
			var prevIndex = index.split(".").setLast(lastNum-1).join(".");			
			indexPattern = new RegExp("^"+(prevIndex)+"$" );
			isChangePattern = false;
			for(var i=0,n=datas.length; i<n; i++){
				tempData = datas[i];
				dataIndex = tempData.index;
				
				if(indexPattern.test(dataIndex)){ // indexPattern과 맞는지 그리고 index의 마지막 숫자(1.2.3이 index이면 3)보다 크거나 같은 값일 때
					if(isChangePattern){
						dataIdx = i + 1;	
					}else{
						if(tempData.hasChild){
							indexPattern = new RegExp("^"+(prevIndex));
							isChangePattern = true;
						}else{
							dataIdx = i + 1;	
						}	
					}
				}
			}
		}
		
		returnObj.idx = dataIdx || i;
		returnObj.datas = datas;
		
		return returnObj;
	}
	
	table.updateInsertTr = function(tableInfos, addData){
		var rowData = tableInfos.rowData,
			addIdx = addData.index,
			datas,
			updateObj;
		
		updateObj = updateIndex(addIdx, rowData);
		datas = updateObj.datas;
		
		datas.splice(updateObj.idx, 0, addData);
		
		tableInfos.rowData = datas;
		makeTr(tableInfos);
	}
	return table;
}(window.table || {}, jQuery));
