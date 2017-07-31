package me.ahacross.mylord.attendance;

import java.util.List;
import java.util.Map;

public interface MemberAttendanceService {
	public List<Map<String, Object>> getList(MemberAttendance memberAttendance);
	public int insert(MemberAttendance memberAttendance);
	public int delete(MemberAttendance memberAttendance);
}
