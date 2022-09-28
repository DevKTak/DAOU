package daou.member;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/member")
public class MemberRouter {

    @GetMapping("/createForm")
    public String memberCreateForm(@RequestParam("departmentId") String departmentId,
                                   @RequestParam("deptName") String deptName, Model model) {
        model.addAttribute("departmentId", departmentId);
        model.addAttribute("deptName", deptName);

        return "daou/member/memberCreate";
    }
}
