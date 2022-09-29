package daou.position;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Builder
@Getter
@ToString
public class Position {

    private String positionId;

    private String name;

    private int level;
}
