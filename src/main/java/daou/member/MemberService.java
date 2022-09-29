package daou.member;

import daou.member.dto.DragAndDropDTO;
import daou.member.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {

    private final MemberMapper memberMapper;

    @Value("${save.path}")
    private String path;

    public void memberCreate(final MemberDTO memberDTO, HttpServletRequest request) throws IOException {
        MultipartFile profile = memberDTO.getProfile();

        if (!profile.isEmpty()) {
            String originFileName = profile.getOriginalFilename();
            String extension = originFileName.substring(originFileName.lastIndexOf("."));

            final LocalDateTime now = LocalDateTime.now();
            String parseLocalDateTimeNow = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            final String memberId = "M" + parseLocalDateTimeNow;

            String projectInnerSavePath = request.getServletContext().getRealPath("/profileImage");
            log.debug(projectInnerSavePath);

            final String saveFileName = memberId + "_" + memberDTO.getName() + extension;
//            final String fullPath = path + saveFileName; // 프로젝트 내부에 저장하기위해 주석
            final String fullPath = projectInnerSavePath + "/" + saveFileName;

            profile.transferTo(new File(fullPath));

            memberDTO.getDepartmentIdList().stream().forEach((departmentId) -> {
                Member member = Member.builder()
                        .memberId(memberId)
                        .departmentId(departmentId)
                        .positionId(memberDTO.getPosition())
                        .name(memberDTO.getName())
                        .regDatetime(now)
                        .uptDatetime(now)
                        .delYn('N')
                        .profilePath(saveFileName)
                        .build();

                memberMapper.memberCreate(member);
            });
        }
    }

    public int memberDelete(String departmentId, String memberId) {
        return memberMapper.memberDelete(departmentId, memberId);
    }

    public int memberDragAndDrop(DragAndDropDTO dragAndDropDTO) {
        return memberMapper.memberDragAndDrop(dragAndDropDTO);
    }
}
