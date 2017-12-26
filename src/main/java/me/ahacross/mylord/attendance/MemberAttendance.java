package me.ahacross.mylord.attendance;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor 
public class MemberAttendance {
	private Integer member_id;
	private String attendance_date;
	private String before_check;
	private String after_check;
	private String part;
	private String status;
}
