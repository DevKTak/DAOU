package daou.department;

import daou.department.dto.DepartmentDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
@Slf4j
public class DepartmentService {

    private final DepartmentMapper mapper;

    public int save(DepartmentDTO departmentDTO) {
        String parseLocalDateTimeNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        Department department = Department.builder()
                        .departmentId(parseLocalDateTimeNow)
                                .parentId(departmentDTO.getParentId())
                                        .name(departmentDTO.getName())
                                                .sort(departmentDTO.getSort())
                                                        .build();

        log.debug(departmentDTO.toString());

        return mapper.save(department);
    }
}
