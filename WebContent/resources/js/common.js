var ajax = (function(ajax, $, undefined){
	
	var ajaxObj = {
		datas : {},
		before : {}, 
		methodMap : {"DELETE":"delete", "INSERT":"post", "UPDATE":"put"},
		setUrl : function(url){
			this.datas.url = location.pathname + url; // url은 member/41 이렇게 와야 함. 
		},
		setMethod : function(method){
			this.datas.method = this.methodMap[(method||"").toUpperCase()] || "get";			
		},
		setBeforeSend : function(){
			this.datas.beforeSend = function(xhr) {
                xhr.setRequestHeader("Accept", "application/json");
                xhr.setRequestHeader("Content-Type", "application/json");
            }
		},
		setDataType : function(type){
			this.datas.dataType = type; 
		},
		setTimeout : function(time){
			this.datas.timeout = time;
		},
		isCU : function(){ // CRUD의 CU 임.
			var flag = false;
			if(_.indexOf(["put", "post", "delete"], this.datas.method) > -1){
				flag = true;
			}
			return flag;
		},
		setData : function(data, dataType){
			if(this.isCU()){
				this.datas.data = JSON.stringify(data);	
			}else{
				this.datas.data = data;
			}
			this.before = data;
		},
		makeDatas : function(params){
			var dataType = "json";
			this.setUrl(params.url);
			this.setMethod(params.method);
			if(this.isCU()){
				this.setBeforeSend();
			}
			this.setData(params.data);
			
			if(params.timeout){
				this.setTimeout(params.timeout);
			}
			return this;
		},		
		run : function(callback){
			$.when(this.ajaxRun()).then(callback);	
		},
		
		ajaxRun : function(){
			var deferred = $.Deferred(),
				returnValue = $.ajax(this.datas),
				before = this.before;
			
			returnValue.done(function(data){				
				deferred.resolve(data, before);
			}).fail(function(jqXHR, textStatus){
				console.log(arguments);
				if(textStatus){
					msg.alert("통신 과정에서 timeout으로 실패하였습니다. 관리자에게 문의하세요.");
				}else{
					msg.alert("통신 과정에서 실패하였습니다. 관리자에게 문의하세요.");
				}
				deferred.reject();
			});
			
			return deferred.promise();
		}		
	};
	
	
	ajax.getAjaxObj = function(){
		return $.extend({}, ajaxObj);		
	};
	
	ajax.run = function(data, callback){
		ajax.getAjaxObj().makeDatas(data).run(callback);
	};
	
	ajax.down = function(params){
		var iframe = document.createElement('iframe');
    	
		iframe.id = "download_iframe";
		iframe.style.display = 'none';
		document.body.appendChild(iframe);
		iframe.src = 'download?'+ $.param(params);
		iframe.addEventListener("load", function () {
			//log.info("FILE LOAD DONE.. Download should start now");
			//다운로드가 되긴하나 제대로 완료되지 않는 듯 싶다.
			//나중에 확인
			console.log(arguments);
			iframe.remove();
		});
	}
	
	return ajax;
}(window.ajax || {}, jQuery));
		 
/*		
window.topMenu = (function(){
	var getUrl = function(menuText){
		var url = "";
		if(menuText === "게시판"){
			//msg.alert("삽질 좀 더 하고 오픈할께요. ^^");
			//return false; 
			url ="page/bbs/bbs.jsp";
			
		}else if(menuText === "성가대원"){
			url = "page/member/member.jsp";
		}
		return location.pathname + url;
	}
	var load = function(url){
		$(".content").load(url);
	}
	var changeMenu = function(text){
		clearUsers();
		load(getUrl(text));
	}
	
	var test = function(url){
		load(url);
	}
	return {
		changeMenu	: changeMenu,
		test 		: test
	}
}());*/

var clearUsers = function(){
	window.userVars = {};
	window.userFns = {};
}

var _WEEKNAMES = {
		sun:"일요일",
		mon:"월요일",
		tue:"화요일",
		wed:"수요일",
		thu:"목요일",
		fri:"금요일",
		sat:"토요일",
		am:"오전",
		pm:"오후"
	};

/*************************************************************************************
 * Date format function 추가
 * @return date String
 * @author LEE YOON KI
 * @date 2015.07. 02
 * @update 
 *************************************************************************************/
Date.prototype.format = function(f) {
	if (!this.valueOf()) return " ";
 
    var weekName = [_WEEKNAMES.sun, _WEEKNAMES.mon, _WEEKNAMES.tue, _WEEKNAMES.wed, _WEEKNAMES.thu, _WEEKNAMES.fri, _WEEKNAMES.sat];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|ms|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "ms": return d.getMilliseconds().zf(3);	
            case "a/p": return d.getHours() < 12 ? _WEEKNAMES.am : _WEEKNAMES.pm;
            default: return $1;
        }
    });
};

Date.prototype.getWeek = function() {    
    var onejan = new Date(this.getFullYear(),0,1);
    var today = new Date(this.getFullYear(),this.getMonth(),this.getDate());
    var dayOfYear = ((today - onejan + 86400000)/86400000);
    return Math.ceil(dayOfYear/7)
}

Date.prototype.minus = function(type, minus) {
    var dat = new Date(this.valueOf());
    
    if(type === "year"){
    	dat.setFullYear(dat.getFullYear() - minus);
    }else if(type === "month"){
    	dat.setMonth(dat.getMonth() - minus);
    }else if(type === "date"){
    	dat.setDate(dat.getDate() - minus);
    }else if(type === "hour"){
    	dat.setHours(dat.getHours() - minus);
    }else if(type === "minute"){
    	dat.setMinutes(dat.getMinutes() - minus);
    }else if(type === "second"){
    	dat.setSeconds(dat.getSeconds() - minus);
    }else{
    	console.log("형식이 잘못 입력되었습니다.");
    }
    return dat;
};

Date.prototype.plus = function(type, plus) {
    var dat = new Date(this.valueOf());
    
    if(type === "year"){
    	dat.setFullYear(dat.getFullYear() + plus);
    }else if(type === "month"){
    	dat.setMonth(dat.getMonth() + plus);
    }else if(type === "date"){
    	dat.setDate(dat.getDate() + plus);
    }else if(type === "hour"){
    	dat.setHours(dat.getHours() + plus);
    }else if(type === "minute"){
    	dat.setMinutes(dat.getMinutes() + plus);
    }else if(type === "second"){
    	dat.setSeconds(dat.getSeconds() + plus);
    }else{
    	console.log("형식이 잘못 입력되었습니다.");
    }
    return dat;
};


/*************************************************************************************
 * String 관련처리
 * @return date String
 * @author LEE YOON KI
 * @date 2015.07. 02
 * @update 
 *************************************************************************************/
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};

//replaceAll
String.prototype.replaceAll = function(str1, str2){
    var temp_str = this.trim();
    temp_str = temp_str.replace(eval("/" + str1 + "/gi"), str2);
    return temp_str;
};

String.prototype.toFirstUpper = function(){
	return this.charAt(0).toUpperCase() + this.substring(1);
};

String.prototype.toCamel = function(){
	return this.replace(/(\_[a-z])/g, function($1){return $1.toUpperCase().replace('_','');});
};


String.prototype.toUnderbar = function(){
	return this.replace(/([A-Z])/g, function($1){return "_"+$1.toLowerCase();});
};

String.prototype.yyyymmdd = function(separator){
	return this.substring(0,4) + separator + this.substring(4,6) + separator + this.substring(6);
}

String.prototype.yyyymmddHH = function(dateSeparator){
	return this.substring(0,4) + dateSeparator + this.substring(4,6) + dateSeparator + this.substring(6, 8) + " " + this.substring(8,10);
}

String.prototype.yyyymmddHHmmss = function(dateSeparator, timeSeparator){
	return this.substring(0,4) + dateSeparator + this.substring(4,6) + dateSeparator + this.substring(6, 8) + " " + this.substring(8,10)+timeSeparator+ this.substring(10,12)+ timeSeparator + this.substring(12) ;
}

String.prototype.toFirstUpperCase = function(){
	return this.charAt(0).toUpperCase() + this.substring(1);
}

String.prototype.toNum = function(){
	return Number(this);
}

String.prototype.toPhone = function(){
	var first = this.substring(0, 3),	
		last = this.substring(this.length, this.length - 4),
		second = this.substring(3, this.indexOf(last));
	return first+"-"+second+"-"+last;
}

Number.prototype.zf = function(len){return this.toString().zf(len);};

/*************************************************************************************
 * Array 관련처리
 * @return date Array
 * @author LEE YOON KI
 * @date 2015.07. 02
 * @update 
 *************************************************************************************/
Array.prototype.remove = function(idx) {
    return (idx<0 || idx>this.length) ? this : this.slice(0, idx).concat(this.slice(idx+1, this.length));
};

Array.prototype.removeLast = function() {
    return this.slice(0, this.length - 1); 
}

Array.prototype.first = function() {
	return this[0]; 
}

Array.prototype.last = function() {
    return this[this.length - 1]; 
}

Array.prototype.setLast = function(value) {
    this[this.length - 1] = value;
    return this;
}

/*************************************************************************************
 * Object 에서  object[name] 방식으로 값을 가져옵니다.
 * @return Object
 * @author LEE YOON KI
 * @date 2015.09. 17
 * @update 
 *************************************************************************************/
/*
 // 이것만 있으면 에러남.
  Object.prototype.getValue = function(name){ 
	return this[name]; 
}*/

/*************************************************************************************
 * Array 문자열의 바이트수 리턴
 * @return Number
 * @author LEE YOON KI
 * @date 2015.07. 02
 * @update 
 *************************************************************************************/
String.prototype.byteLength = function() {
    var l= 0;
     
    for(var idx=0; idx < this.length; idx++) {
        var c = escape(this.charAt(idx));
         
        if( c.length==1 ) l ++;
        else if( c.indexOf("%u")!=-1 ) l += 2;
        else if( c.indexOf("%")!=-1 ) l += c.length/3;
    }
     
    return l;
};

String.prototype.byteLength2 = function(){
	var c;
    for(var b=i=0;c=this.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
    return b;
}


/*************************************************************************************
 * byte크기 가져오기
 * @return bytes크기(int)
 * @author LEE YOON KI
 * @date 2015.07. 02
 * @update 
 *************************************************************************************/
function getBytes(str) {
    var i, tmp = escape(str);
    var bytes = 0;
    for (i = 0; i < tmp.length; i++) {
        if (tmp.charAt(i) == "%") {
            if (tmp.charAt(i + 1) == "u") {
                bytes += 2;
                i += 5;
            } else {
                bytes += 1;
                i += 2;
            }
        } else {
            bytes += 1;
        }
    }

    return bytes;
}

/*************************************************************************************
 * cookie를 set(추가),get(가져오기), del(삭제) 한다.
 * @return null
 * @author LEE YOON KI
 * @date 2015.07. 02
 * @update 
 *************************************************************************************/
var cookie = {
	set : function(name, value, expires){
		var curCookie = name + "=" + escape(value)+"; path=/";
		if(expires) {
			 curCookie += "; expires=" + (new Date()).plus("second", expires * 60).toGMTString()+"; ";
		 }
		document.cookie = curCookie;
	},
	get : function(cName){
		cName = cName + '=';
        var cookieData = document.cookie, 
        	start = cookieData.indexOf(cName), 
        	end ,
        	cValue = '';
        
        if(start !== -1){
            start += cName.length;
            end = cookieData.indexOf(';', start);
            if(end === -1){
            	end = cookieData.length;
            }
            cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
	},
	
	del : function(name){
		cookie.set(name, undefined, -1);
	},
	getMylord : function(name){
		var returnValue;
		if(cookie.get("mylord") === ""){
			returnValue = "";
		}else{
			returnValue = JSON.parse(cookie.get("mylord"))[name];
		}
		return returnValue;
	}

};


var makeWrapCalendar = function(params){		
	var target = params.target,
		wrapHtml = '';
	
	target.css({"border":"none"});
	
	wrapHtml += '<div class="divTable divWrap" >';
	wrapHtml += '<div class="divTr">';
	wrapHtml += '<div class="divTd">';
	wrapHtml += target[0].outerHTML; 
	wrapHtml += '</div>';
	wrapHtml += '<div class="divTd">'; 
	wrapHtml += '</div></div></div>';
	
	target.replaceWith(wrapHtml);
	
	if(params.init){
		var newTarget = $(params.target.selector).parents(".divWrap");
		newTarget.find(".divTd:last").css("width", "40px");
		newTarget.find(".divTd:last").append('<i class="fa fa-times" aria-hidden="true" title="초기화" style="color:#e85b5b;"></i>');
		
		newTarget.find(".fa-times").on("click", function(){
			newTarget.find(":text").val("");
		});
	}
}


var onlyNum = function(event){
	var key = event.keyCode || event.which;
	if(event.altKey || event.ctrlKey || event.shiftKey){ // 세 키중 하나라도 눌렸으면 keyCode를 0으로 바꿈.
		key = 0;
	}
	
    if( !(( key >= 48 && key <= 57 ) || ( key >= 96 && key <= 105 ) ||  key === 37 ||  key === 39 || key === 9 || key === 8 || key === 46 || key === 35 || key === 36  || key === 13 ) ){
        return false;
    }
}


var initAdd = function(target){
	target.find("input:text, textarea, select").not(".nonInit").each(function(){
		$(this).val("");
	});
}

var initMod = function(targetDom, datas){
	var keys = Object.keys(datas), 
		key;
	
	for(let i=0, n=keys.length; i<n; i++){
		key = keys[i];
		targetDom.find("[name="+key+"]").val(datas[key]||"");
	}
}


/*************************************************************************************
 * select box 들어갈 정보를 조회하고 option으로 추가해줌.
 * @return promise()를 리턴함. 
 * @param object 며 필요한 것을 입력하면 됨.
 * 	- url 		: url
 *  - addData	: data를 추가할 경우.
 *  - selected 	: 선택된 값(field명)
 *  - defaultName: <option value="">선택</option> 의 '선택'을 입력한 값으로 변경. 
 *  - name		: option의 name이 될 필드
 *  - value		: option의 value가 될 필드.
 *  - noDefault : <option value="">선택</option> 이거 없게. (true/false)
 *  - target	: 대상 select

 * @author LEE YOON KI
 * @date 2015.07. 27
 * @update 
 *************************************************************************************/
var setSelectBox = function(paramObj){
	var defer = $.Deferred();
	
	var datas = {
		url : paramObj.url
	}
		
	if(paramObj.addData){
		datas.data = paramObj.addData;
	}
	
	ajax.run(datas, function(after, before){
		var	optionHtml = '<option value="">' + ((paramObj.defaultName)?paramObj.defaultName:'선택') + '</option>',
			list = after;
			
		if(paramObj.noDefault){
			optionHtml = '';
		}
			
		list.forEach(function(item){
			optionHtml += '<option value="'+item[paramObj.value]+'">'+item[paramObj.name]+'</option>';
		});
		
		if(paramObj.selected || paramObj.selected === ""){
			optionHtml = optionHtml.split('value="'+paramObj.selected+'"').join('value="'+paramObj.selected+'" selected="selected"');
		}
	
		paramObj.target.html(optionHtml);
		defer.resolve(optionHtml);
	});
	return defer.promise();
}

var validate = function(targets){
	var checkTypes = ":text,textarea,select",
		checkTargets = targets.find(checkTypes).not(".noValid"),
		tempTarget,
		tempValue,
		result = false,
		datas = {};
	
	for(var i=0, n=checkTargets.length; i<n; i++){
		tempTarget = $(checkTargets[i]);
		tempValue = tempTarget.val() || "";
		
		if(tempValue === ""){
			msg.alert((tempTarget.parent().prev().text() || tempTarget.prev().text().trim())+" 값이 없습니다.");
			result = true;
			break;
		}else{
			datas[tempTarget.attr("name")] = tempValue;
		}
	}
	
	if(!result){
		result = datas;
	}
	return result;
}

var byteCalculation = function(bytes) { 
    var bytes = parseInt(bytes);
    var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
    var e = Math.floor(Math.log(bytes)/Math.log(1024));
   
    if(e == "-Infinity") return "0 "+s[0]; 
    else 
    	return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
}

var compare = (function(){
	var birthday = function(property, desc) {
		var sortOrder = desc?1:-1;
	    
	    return function (a, b) {
    		var aa = a[property],    		
				bb = b[property],
				tempAa = Number(aa.substring(4)),
				tempBb = Number(bb.substring(4)),
				returnValue = 0;
    		 
    		if(tempAa > tempBb){
    			returnValue = -1;
    		}else if(tempAa < tempBb){
    			returnValue = 1    			
    		}else{
    			var tempProperty = "name";    			
    			tempAa = a[tempProperty];
    			tempBb = b[tempProperty];
    			returnValue = (tempAa > tempBb) ? -1 : (tempAa < tempBb) ? 1 : 0 ;
    		}
    		
            return (returnValue) * sortOrder;
        } 
	}
	
	var part = function(property, desc) {
		var sortOrder = desc?1:-1,
			part = {"소프라노":1, "알토":2, "테너":3, "베이스":4};
	    
	    return function (a, b) {
    		var aa = a[property],
				bb = b[property],
				tempAa = part[aa] || 5,
				tempBb = part[bb] || 5,
				returnValue = 0;
    		 
    		if(tempAa > tempBb){
    			returnValue = -1;
    		}else if(tempAa < tempBb){
    			returnValue = 1    			
    		}else{
    			var tempProperty = "name";    			
    			tempAa = a[tempProperty];
    			tempBb = b[tempProperty];
    			returnValue = (tempAa > tempBb) ? -1 : (tempAa < tempBb) ? 1 : 0 ;
    		}
    		
            return (returnValue) * sortOrder;
        } 
	}
	
	return {
		birthday	: birthday,
		part		: part
	}
}());


var makeFormDatas = function(fields){
	var datas = {};
	fields.serializeArray().forEach(function(field){
		datas[field.name] = field.value;
	});
	return datas;
}

var deepCopy = function(obj) {
	return JSON.parse(JSON.stringify(obj));
}

var query = {			
	setDatas : function(header, datas){
		this.header = header;
		this.datas = datas;
	},
	setHtml : function(){
		var html = '<table class="width100" border="1">',
			header = this.header;
		
		html += '<thead><tr>';
		header.forEach(function(item){
			html += '<th class="center">'+item+'</th>';
		});
		html += '</tr></thead>';
		html += '<tbody>';
		this.datas.forEach(function(dataItem){
			html += '<tr>';
			header.forEach(function(item){
				html += '<td>'+dataItem[item]+'</td>';	
			});
			
			html += '</tr>';
		});
		html += '</tbody>';
		html += '</html>';
		return html;
	},
	noData : function(){
		var html = '<table class="width100">';
		html += '<tr><td class="center">데이터가 없습니다.</td></tr>'
		html += '</table>';
		return html;
	}
};