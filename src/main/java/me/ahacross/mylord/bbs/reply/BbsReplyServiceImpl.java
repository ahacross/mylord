package me.ahacross.mylord.bbs.reply;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import me.ahacross.mylord.bbs.vo.BbsReply;

@Service("bbsReplyService")
public class BbsReplyServiceImpl implements BbsReplyService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(BbsReply bbsReply){
		 BbsReplyMapper mapper = session.getMapper(BbsReplyMapper.class);
		 return mapper.getList(bbsReply);
	}

	@Override
	public int insert(BbsReply bbsReply) {
		BbsReplyMapper mapper = session.getMapper(BbsReplyMapper.class);
		return mapper.insert(bbsReply);
	}

	@Override
	public int update(BbsReply bbsReply) {
		BbsReplyMapper mapper = session.getMapper(BbsReplyMapper.class);
		return mapper.update(bbsReply);
	}

	@Override
	public int delete(BbsReply bbsReply) {
		BbsReplyMapper mapper = session.getMapper(BbsReplyMapper.class);
		return mapper.delete(bbsReply);
	}
	
	@Override
	public int deleteByBbsId(BbsReply bbsReply) {
		BbsReplyMapper mapper = session.getMapper(BbsReplyMapper.class);
		return mapper.deleteByBbsId(bbsReply);
	}
}
