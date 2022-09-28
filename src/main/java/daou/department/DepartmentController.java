package daou.department;

import daou.department.dto.DepartmentDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/department")
public class DepartmentController {

    private final DepartmentService departmentService;

    @PostMapping()
    public int departmentCreate(@Valid @RequestBody DepartmentDTO departmentDTO) {
        return departmentService.departmentCreate(departmentDTO);
    }

    @PutMapping()
    public int departmentUpdate(@Valid @RequestBody DepartmentDTO departmentDTO) {
        return departmentService.departmentUpdate(departmentDTO);
    }

    @DeleteMapping("/{departmentId}")
    public int departmentDelete(@PathVariable String departmentId) {
        return departmentService.departmentDelete(departmentId);
    }

    @PutMapping("/drag-and-drop")
    public int departmentDragAndDrop(@RequestBody DepartmentDTO departmentDTO) {
        return departmentService.departmentDragAndDrop(departmentDTO);
    }
}
