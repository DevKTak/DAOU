package daou.department;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/department")
public class DepartmentRouter {

    @GetMapping("/createForm")
    public String departmentCreateForm(@RequestParam("departmentId") String departmentId,
                                       @RequestParam("deptName") String deptName, Model model) {
        model.addAttribute("departmentId", departmentId);
        model.addAttribute("deptName", deptName);

        return "daou/department/departmentCreate";
    }

    @GetMapping("/updateForm")
    public String departmentUpdateForm(@RequestParam("departmentId") String departmentId,
                                       @RequestParam("deptName") String deptName, Model model) {
        model.addAttribute("departmentId", departmentId);
        model.addAttribute("deptName", deptName);

        return "daou/department/departmentUpdate";
    }
}
