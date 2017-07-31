package me.ahacross.mylord.security;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
	private Integer	member_id;
	private String	name;
	private String	phone;
	private String	role;
}
		