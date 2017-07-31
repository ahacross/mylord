package me.ahacross.mylord.enrollment;

import org.springframework.stereotype.Repository;

@Repository(value="memberEnrollmentMapper")
public interface MemberEnrollmentMapper {
	public int insert(MemberEnrollment memberEnrollment) ;
}
