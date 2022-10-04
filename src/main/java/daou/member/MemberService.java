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

    private String memberId;
    private  LocalDateTime now;
    private String saveFileName;

    public void memberCreate(MemberDTO memberDTO, HttpServletRequest request) throws IOException {
        MultipartFile profile = memberDTO.getProfile();

        if (!profile.isEmpty()) {
            uploadFile(profile, memberDTO, request);

            for (String departmentId : memberDTO.getDepartmentIdList()) {
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
            }
        }
    }

    private void uploadFile(MultipartFile profile, MemberDTO memberDTO, HttpServletRequest request) throws IOException {
        String originFileName = profile.getOriginalFilename();
        String extension = originFileName.substring(originFileName.lastIndexOf("."));

        now = LocalDateTime.now();
        memberId = getGenerateMemberId(now);

        String projectInnerSavePath = request.getServletContext().getRealPath("/profileImage");

        saveFileName = memberId + "_" + memberDTO.getName() + extension;
        String fullPath = projectInnerSavePath + "/" + saveFileName;
//          String fullPath = path + saveFileName; // 프로젝트 내부 경로에 저장하는 로직을 위해 잠시 주석

        profile.transferTo(new File(fullPath));
    }

    private String getGenerateMemberId(LocalDateTime now) {
        String parseLocalDateTimeNow = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        return "M" + parseLocalDateTimeNow;
    }

    public int memberUpdate(MemberDTO memberDTO, HttpServletRequest request) throws IOException {
        Member member;

        if (memberDTO.getProfilePath() == null) { // 이미지 수정할 경우
            MultipartFile profile = memberDTO.getProfile();
            uploadFile(profile, memberDTO, request);

            member = Member.builder()
                    .memberId(memberDTO.getMemberId())
                    .positionId(memberDTO.getPosition())
                    .name(memberDTO.getName())
                    .profilePath(saveFileName)
                    .build();
        } else {
            member = Member.builder()
                    .memberId(memberDTO.getMemberId())
                    .positionId(memberDTO.getPosition())
                    .name(memberDTO.getName())
                    .profilePath(memberDTO.getProfilePath())
                    .build();
        }

        return memberMapper.memberUpdate(member);
    }

    public int memberDelete(String departmentId, String memberId) {
        return memberMapper.memberDelete(departmentId, memberId);
    }

    public int memberDragAndDrop(DragAndDropDTO dragAndDropDTO) {
        return memberMapper.memberDragAndDrop(dragAndDropDTO);
    }


}
