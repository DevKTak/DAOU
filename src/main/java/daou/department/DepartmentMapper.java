package daou.department;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface DepartmentMapper {

    List<Map<String, Object>> findDepartment();

    int save(Department department);
}
