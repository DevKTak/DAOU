package daou.member.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Builder
@Getter
@Setter
@ToString
public class MemberDTO {

    private String memberId;

    private String departmentId;

    private String positionId;

    @NotBlank(message = "이름을 입력해주세요.")
    private String name;

    private LocalDateTime regDatetime;

    private LocalDateTime uptDatetime;

    private char delYn;
}
