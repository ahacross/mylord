package me.ahacross.mylord.enrollment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemberEnrollment {
	private String	attend_date;
	private String	part;
	private Integer	before_count;
	private Integer	after_count;
}
		