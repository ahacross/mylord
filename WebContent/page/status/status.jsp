<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
canvas {
    -moz-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
}
</style>
<div class="panel">
	<table id="statusTable" style="width:100%;">
		<tr>
			<td style="width:40%;text-align: center;vertical-align: middle">
				4주간 출석률(전)
				<div id="before4week"></div>				
			</td>
			<td style="width:40%;text-align: center;vertical-align: middle">
				4주간 출석률(후)
				<div id="after4week"></div>
			</td>
			<td style="width:20%;text-align: center;" rowspan="3">
				회비
				<div id="duesBar"></div>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;vertical-align: middle">
				12주간 출석률(전)			
				<div id="before12week"></div>
			</td>
			<td style="text-align: center;vertical-align: middle">
				12주간 출석률(후)
				<div id="after12week"></div>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;vertical-align: middle">
				<span id="yearB">2017</span>년 출석률(전)
				<div id="beforeThisyear"></div>
			</td>
			<td style="text-align: center;vertical-align: middle">
				<span id="yearA">2017</span>년 출석률(후)
				<div id="afterThisyear"></div>
			</td>
		</tr>
	</table>
	연습 -> 왼쪽 상단 메뉴에서 "했던 곡들" -> 오른쪽 끝에 연습 누르면 페이지 이동함.<br/>
	기타 정보들 메뉴에 주를 경배하라, 8성부 아멘 올려놨습니다~ (반주자님 ㄳㄳ)
</div>
<script>

if(Responsive.device === "desktop"){
	$("#statusTable").css("width","40%");
}else{
	$("#statusTable > tbody > tr").css("height", "170px");
}

function getToday() {
    return new Promise(function(resolve, reject) {
    	ajax.run({url:"query", method:"insert", data:{query:"select DATE_FORMAT(now(), '%Y-%m-%d') as toDay"}}, function(after){
    		resolve(after[0].toDay);
    	});
    });
}

function getMemberInfo() {
    return new Promise(function(resolve, reject) {
    	ajax.run({url:"member/"+cookie.get("mylordId")}, function(member){
    		resolve(member);
    	});
    });
}

var setGaugeChart = function(bind, columns){
	c3.generate({
		bindto : bind,
	    data: {
	        columns: columns,
	        type : 'gauge'
	    },
	    gauge: {
		    min: 0, // 0 is default, //can handle negative min e.g. vacuum / voltage / current flow / rate of change
		    max: 100 // 100 is default
	    },
	    color: {
	        pattern: ['#FF0000', '#F97600', '#F6C600', '#60B044'], // the three color levels for the percentage values.
	        threshold: {
	            values: [25, 50, 75, 100]
	        }
	    },
	    size: {
	        height: (Responsive.device === "desktop")?180:100
	    }
	});
}

var setBarChart = function(bind, columns) {
	c3.generate({
		bindto : bind,
	    data: {
	        columns: columns,
	        type: 'bar',
	        groups: [["납부", "미납"]]
	    },
	    grid: {
	        y: {
	            lines: [{value:0}]
	        }
	    }
	});
}

var rateToNum = function(rate){
	return rate.split("%").join("").toNum();
}
 
var setChartData = function(datas){
	ajax.run(datas, function(after, before){
		const beforeRate = rateToNum(after.first().before_rate);
		const afterRate = rateToNum(after.first().after_rate);
		
		setGaugeChart(before.targetId, [['출석', beforeRate]]);
		setGaugeChart(before.targetId.split("before").join("after"),[['출석', afterRate]]);
	});
}
 
//Promise.resolve()
//    .then(getToday)
//    .then(today, member => {
Promise.all([getToday(), getMemberInfo()])	
	 .then(value => {
    	const toDay = new Date(value[0]);
    	const member = value[1];
    	const endDate = toDay.format("yyyyMMdd");
    	const memberId = cookie.get("mylordId");
    	let ajaxData = {
    		url:"stats",
    		data:{
    			type:"one",   				 
   				endDate:endDate,
   				member_id: memberId   				
    		}
    	};
    	
    	let regiDate = Number(member.regi_date || "20160101");
    	
    	ajaxData.data.startDate = (toDay.minus("date", toDay.getDay() + 3 * 7)).format("yyyyMMdd");
    	ajaxData.data.targetId = "#before4week";
    	if(regiDate > Number(ajaxData.data.startDate)) {
    		ajaxData.data.startDate = regiDate+"";
    	}
    	setChartData(deepCopy(ajaxData));
    	
    	ajaxData.data.startDate = (toDay.minus("date", toDay.getDay() + 11 * 7)).format("yyyyMMdd");
    	ajaxData.data.targetId = "#before12week";
    	if(regiDate > Number(ajaxData.data.startDate)) {
    		ajaxData.data.startDate = regiDate+"";
    	}
    	setChartData(deepCopy(ajaxData));
    	
    	ajaxData.data.startDate = (toDay.minus("date", (toDay.getWeek() - 1) * 7 + toDay.getDay())).format("yyyyMMdd");
    	ajaxData.data.targetId = "#beforeThisyear";
    	if(regiDate > Number(ajaxData.data.startDate)) {
    		ajaxData.data.startDate = regiDate+"";
    	}
    	setChartData(deepCopy(ajaxData));
    	
    	// 회비
		let maxDues = Math.floor((toDay.getTime() - new Date((regiDate+"").yyyymmdd("-")).getTime()) / (1000*60*60*24*30));
    	if(maxDues > 12) {
    		maxDues = 12;
    	}
    	setBarChart("#duesBar", [["납부", member.dues], ["미납", (maxDues-member.dues < 0)?0:maxDues-member.dues]]);
    	$("#userName").html(member.name + " 님 ^^");
    });

	
</script>