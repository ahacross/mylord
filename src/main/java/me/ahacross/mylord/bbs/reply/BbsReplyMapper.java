package me.ahacross.mylord.bbs.reply;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import me.ahacross.mylord.bbs.vo.BbsReply;

@Repository(value="bbsReplyMapper")
public interface BbsReplyMapper {
	public List<Map<String, Object>> getList(BbsReply bbsReply);
	public int insert(BbsReply bbsReply);
	public int update(BbsReply bbsReply); 
	public int delete(BbsReply bbsReply);
	public int deleteByBbsId(BbsReply bbsReply);
}
