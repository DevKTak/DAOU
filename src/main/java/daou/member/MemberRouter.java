package daou.member;

import daou.member.dto.MemberDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequestMapping("/member")
public class MemberRouter {

    @GetMapping("/createForm")
    public String memberCreateForm(@RequestParam("departmentId") String departmentId,
                                   @RequestParam("deptName") String deptName, Model model) {
        model.addAttribute("departmentId", departmentId);
        model.addAttribute("deptName", deptName);

        return "daou/member/memberCreate";
    }

    @GetMapping("/updateForm")
    public String memberUpdateForm(@ModelAttribute MemberDTO memberDTO) {
        return "daou/member/memberUpdate";
    }
}
