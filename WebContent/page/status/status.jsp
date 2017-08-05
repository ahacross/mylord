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
				2017년 출석률(전)
				<div id="beforeThisyear"></div>
			</td>
			<td style="text-align: center;vertical-align: middle">
				2017년 출석률(후)
				<div id="afterThisyear"></div>
			</td>
		</tr>
	</table>
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
 
Promise.resolve()
    .then(getToday)
    .then(today => {
    	const toDay = new Date(today);
    	const endDate = toDay.format("yyyyMMdd");
    	const memberId = cookie.get("mylordId");
    	
    	// 4week
    	ajax.run({
    			url:"stats", 
    			data:{
    				type:"one",
    				startDate:(toDay.minus("date", toDay.getDay() + 3 * 7)).format("yyyyMMdd"), 
    				endDate:endDate,
    				member_id: memberId
    			}
    		},
    		function(after){
    			const beforeRate = rateToNum(after.first().before_rate);
    			const afterRate = rateToNum(after.first().after_rate);
    			
    			setGaugeChart("#before4week", [['출석', beforeRate]]);
    			setGaugeChart("#after4week",[['출석', afterRate]]);
    		}
    	);
    	// 12week
    	ajax.run({
    			url:"stats", 
    			data:{
    				type:"one",
    				startDate:(toDay.minus("date", toDay.getDay() + 11 * 7)).format("yyyyMMdd"), 
    				endDate:endDate,
    				member_id: memberId
    			}
    		},
    		function(after){
    			const beforeRate = rateToNum(after.first().before_rate);
    			const afterRate = rateToNum(after.first().after_rate);
    			
    			setGaugeChart("#before12week", [['출석', beforeRate]]);
    			setGaugeChart("#after12week",[['출석', afterRate]]);
    		}
    	);
    	
    	// thisyear
    	ajax.run({
    			url:"stats", 
    			data:{
    				type:"one",
    				startDate:(toDay.minus("date", (toDay.getWeek() - 1) * 7 + toDay.getDay())).format("yyyyMMdd"), 
    				endDate:endDate,
    				member_id: memberId
    			}
    		},
    		function(after){
    			const beforeRate = rateToNum(after.first().before_rate);
    			const afterRate = rateToNum(after.first().after_rate);
    			
    			setGaugeChart("#beforeThisyear", [['출석', beforeRate]]);
    			setGaugeChart("#afterThisyear",[['출석', afterRate]]);
    		}
    	);
    	
    	// 회비
    	ajax.run({url:"member/"+memberId}, function(after){
    		setBarChart("#duesBar", [["납부", after.dues], ["미납", 12-after.dues]]);
    	});
    });

	
</script>