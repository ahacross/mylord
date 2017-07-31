package me.ahacross.mylord.stats;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Stats {
	private String	beforeCheckCond;
	private String	afterCheckCond;
	private String	startDate;
	private String	endDate;
	private String	member_id;
	private String	type;
}
		