package daou;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
public class MainController {

    @GetMapping("/")
    public String main() {
        return "daou/tree";
    }
}
