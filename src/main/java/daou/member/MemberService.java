package daou.member;

import daou.member.dto.DragAndDropDTO;
import daou.member.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberMapper memberMapper;
    private final ModelMapper modelMapper;

    public int memberDelete(String departmentId, String memberId) {
        return memberMapper.memberDelete(departmentId, memberId);
    }

    public int memberDragAndDrop(DragAndDropDTO dragAndDropDTO) {
        return memberMapper.memberDragAndDrop(dragAndDropDTO);
    }
}
