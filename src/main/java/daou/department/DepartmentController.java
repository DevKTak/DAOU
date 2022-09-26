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
    public int save(@Valid @RequestBody DepartmentDTO departmentDTO) {
        log.error(String.valueOf(departmentDTO));
        log.debug(departmentDTO.getParentId());

        return departmentService.save(departmentDTO);
    }

}
