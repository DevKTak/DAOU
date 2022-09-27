package daou.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member")
public class MemberRouter {

    @GetMapping("/createForm")
    public String memberCreateForm() {
        return "daou/member/memberCreate";
    }
}
