package daou.department;

import daou.department.dto.DepartmentDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@Validated
@Slf4j
@RequestMapping("/api")
public class DepartmentController {

    private final DepartmentService departmentService;

    @PostMapping("/department")
    public int departmentCreate(@Valid @RequestBody DepartmentDTO departmentDTO) {
        return departmentService.departmentCreate(departmentDTO);
    }

    @PutMapping("/department")
    public int departmentUpdate(@Valid @RequestBody DepartmentDTO departmentDTO) {
        return departmentService.departmentUpdate(departmentDTO);
    }

    @DeleteMapping("/department/{departmentId}")
    public int departmentDelete(@PathVariable String departmentId) {
        return departmentService.departmentDelete(departmentId);
    }
}
