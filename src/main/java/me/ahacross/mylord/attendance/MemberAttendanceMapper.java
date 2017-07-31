package me.ahacross.mylord.attendance;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="memberAttendanceMapper")
public interface MemberAttendanceMapper {
	public List<Map<String, Object>> getList(MemberAttendance member) ;
	public int insert(MemberAttendance member);
	public int delete(MemberAttendance member);
}
