package daou.member.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
public class DragAndDropDTO {

    private String memberId;

    private String departmentId;

    private String nextDepartmentId;
}
