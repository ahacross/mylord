package me.ahacross.mylord.manager;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemberManager {
	private Integer	member_id;
	private String	role;
	private String	auth;
	private String	term_range_s;
	private String	term_range_e;
}
		