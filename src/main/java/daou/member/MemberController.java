package daou.member;

import daou.member.dto.DragAndDropDTO;
import daou.member.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.IOException;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/member")
public class MemberController {

    private final MemberService memberService;

    @PostMapping()
    public void memberCreate(@Valid @ModelAttribute MemberDTO memberDTO, HttpServletRequest request) throws IOException {
        log.debug(memberDTO.toString());

        memberService.memberCreate(memberDTO, request);
    }

    @DeleteMapping("/{departmentId}/{memberId}")
    public int memberDelete(@PathVariable String departmentId, @PathVariable String memberId) {
        return memberService.memberDelete(departmentId, memberId);
    }

    @PutMapping("/drag-and-drop")
    public int memberDragAndDrop(@RequestBody DragAndDropDTO DragAndDropDTO) {
        return memberService.memberDragAndDrop(DragAndDropDTO);
    }
}
