package daou.position;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PositionService {

    private final PositionMapper positionMapper;

    public List<Position> findPosition() {
        return positionMapper.findPosition();
    }
}
