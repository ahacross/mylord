package me.ahacross.mylord.manager;

import org.springframework.stereotype.Repository;

@Repository(value="memberManagerMapper")
public interface MemberManagerMapper {
	public int insert(MemberManager memberManager) ;
}
