package me.ahacross.mylord.attendance;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("memberAttendanceService")
public class MemberAttendanceServiceImpl implements MemberAttendanceService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(MemberAttendance memberAttendance){
		 MemberAttendanceMapper mapper = session.getMapper(MemberAttendanceMapper.class);
		return mapper.getList(memberAttendance);
	}


	@Override
	public int insert(MemberAttendance memberAttendance) {
		MemberAttendanceMapper mapper = session.getMapper(MemberAttendanceMapper.class);
		return mapper.insert(memberAttendance);
	}

	@Override
	public int delete(MemberAttendance memberAttendance) {
		MemberAttendanceMapper mapper = session.getMapper(MemberAttendanceMapper.class);
		return mapper.delete(memberAttendance);
	}
}
