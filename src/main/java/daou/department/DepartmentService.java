package daou.department;

import daou.department.dto.DepartmentDTO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class DepartmentService {

    private final DepartmentMapper departmentMapper;
    private final ModelMapper modelMapper;

    public int departmentCreate(DepartmentDTO departmentDTO) {
        Department department = modelMapper.map(departmentDTO, Department.class);
        department.generateDepartmentId();

        return departmentMapper.departmentCreate(department);
    }

    public int departmentUpdate(DepartmentDTO departmentDTO) {
        return departmentMapper.departmentUpdate(departmentDTO);
    }

    public int departmentDelete(String departmentId) {
        return departmentMapper.departmentDelete(departmentId);
    }

    public int departmentDragAndDrop(DepartmentDTO departmentDTO) {
        return departmentMapper.departmentDragAndDrop(departmentDTO);
    }
}
