package daou.member.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@ToString
public class MemberDTO {

    @NotBlank(message = "이름을 입력해주세요.")
    private String name;

    private String position;

    private MultipartFile profile;

    @NotNull(message = "부서를 선택해주세요.")
    private List<String> departmentIdList;
}
