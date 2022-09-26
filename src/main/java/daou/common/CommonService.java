package daou.common;

import daou.department.DepartmentMapper;
import daou.member.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CommonService {

    private final MemberMapper memberMapper;
    private final DepartmentMapper departmentMapper;

    public Map<String, List<Map<String, Object>>> findTreeData() {
        Map<String, List<Map<String, Object>>> map = new HashMap<>();
        map.put("memberAndPosition", memberMapper.findMemberAndPosition());
        map.put("department", departmentMapper.findDepartment());

        return map;
    }
}
