package daou.member;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    List<Map<String, Object>> findMemberAndPosition();

}
