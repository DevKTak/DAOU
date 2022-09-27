package daou.department;

import daou.department.dto.DepartmentDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface DepartmentMapper {

    List<Map<String, Object>> findDepartment();

    int departmentCreate(Department department);

    int departmentUpdate(DepartmentDTO departmentDTO);
}
