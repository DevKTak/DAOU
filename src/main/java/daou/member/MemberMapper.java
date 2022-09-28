package daou.member;

import daou.member.dto.DragAndDropDTO;
import daou.member.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    List<Map<String, Object>> findMemberAndPosition();

    int memberDelete(@Param("departmentId") String departmentId, @Param("memberId") String memberId);

    int memberDragAndDrop(DragAndDropDTO dragAndDropDTO);
}
