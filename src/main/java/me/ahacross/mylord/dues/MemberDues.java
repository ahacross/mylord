package me.ahacross.mylord.dues;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@AllArgsConstructor
@NoArgsConstructor
public class MemberDues {
	private Integer member_id;
	private String year;
	private Integer dues_cnt;
	private String name;
	private String part;
	private String status;
}
