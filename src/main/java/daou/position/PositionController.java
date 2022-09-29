package daou.position;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/position")
public class PositionController {

    private final PositionService positionService;

    @GetMapping()
    public List<Position> findPosition() {
        return positionService.findPosition();
    }
}
