package daou.member;

import lombok.*;

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

    private LocalDateTime regDatetime;

    private LocalDateTime uptDatetime;

    private char delYn;

    public void generateRegDatetime() {
        this.regDatetime = LocalDateTime.now();
    }
}
