package daou.member;

import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
public class Member {

    private String memberId;

    private String departmentId;

    private String positionId;

    private String name;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime regDatetime;

    private LocalDateTime uptDatetime;

    private char delYn;

    private String profilePath;
}
