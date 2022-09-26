package daou.department;

import lombok.*;

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
}
