package daou.department;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/department")
public class DepartmentRouter {

    @GetMapping("/popup")
    public String departmentPopupForm(@RequestParam("deptId") String deptId,
                                      @RequestParam("deptName") String deptName, Model model) {
        model.addAttribute("deptId", deptId);
        model.addAttribute("deptName", deptName);

        return "daou/department/departmentPopup";
    }
}
