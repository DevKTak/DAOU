package daou.member.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.constraints.NotBlank;
import java.util.List;

@Getter
@Setter
@ToString
public class MemberDTO {

    private String memberId;

    @NotBlank(message = "이름을 입력해주세요.")
    private String name;

    private String position;

    private MultipartFile profile;

    private List<String> departmentIdList;

    private String profilePath;
}
