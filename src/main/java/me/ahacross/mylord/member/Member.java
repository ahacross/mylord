package me.ahacross.mylord.member;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@AllArgsConstructor
@NoArgsConstructor
public class Member {
	private Integer member_id;
	private String name;
	private String phone;
	private String part;
	private String birthday;
	private String email; 
	private String comment;
	private String status;
	private String type;
	private String regi_date;
	private String role;
	private Integer dues;
}
