package daou.member;

import daou.member.dto.DragAndDropDTO;
import daou.member.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/member")
public class MemberController {

    private final MemberService memberService;

    @DeleteMapping("/{departmentId}/{memberId}")
    public int memberDelete(@PathVariable String departmentId, @PathVariable String memberId) {
        return memberService.memberDelete(departmentId, memberId);
    }

    @PutMapping("/drag-and-drop")
    public int memberDragAndDrop(@RequestBody DragAndDropDTO DragAndDropDTO) {
        return memberService.memberDragAndDrop(DragAndDropDTO);
    }
}
