package daou.department.dto;

import lombok.*;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
@ToString
public class DepartmentDTO {

    private String parentId;

    @NotBlank(message = "부서명을 입력해주세요.")
    private String name;

    private int sort;
}