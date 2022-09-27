package daou.department;

import lombok.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
public class Department {

    private String departmentId;

    private String parentId;

    private String name;

    private int sort;

    public void generateDepartmentId() {
        String parseLocalDateTimeNow = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        this.departmentId = parseLocalDateTimeNow;
    }
}
