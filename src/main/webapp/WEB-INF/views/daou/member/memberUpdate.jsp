<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>DAOU</title>

    <style>
        .w2ui-field > label {
            width: 50px;
            margin-right: 20px;
            line-height: 10px;
        }
        select {
            width: 147px;
        }
        .profileImage-box {
            width: 100px;
            height: 100px;
            border: solid #999999 1px;
        }
        .profileImage {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
<div class="w2ui-group">
    <div class="w2ui-group-fields">
        <div class="w2ui-field" style="display: flex;">
            <label for="name">이름</label>
            <input type="text" id="name" name="name" placeholder="이름을 입력해주세요." required value="${param.name}">
        </div>
    </div>
    <div class="w2ui-group-fields">
        <div class="w2ui-field" style="display: flex;">
            <label for="position">직급</label>
            <select id="position" name="position"></select>
        </div>
    </div>
    <div class="w2ui-group-fields">
        <div class="w2ui-field" style="display: flex;">
            <label for="cur_profile">이미지</label>
            <div id="cur_profile" class="profileImage-box" style="margin-left: 0;">
                <img src="${pageContext.request.contextPath}/profileImage/${param.profilePath}" class="profileImage" alt="프로필 이미지">
            </div>
        </div>
    </div>
    <div class="w2ui-group-fields">
        <div class="w2ui-field" style="display: flex; flex-direction: column; align-items: center;">
            <label for="profile" style="width: 100%;">* 이미지를 변경할 경우에만 파일을 선택해주세요.</label>
            <input type="file" id="profile" name="profile" class="w2ui-btn">
        </div>
    </div>
</div>

<script>
    var memberUpdate = {

        pageId: 'memberUpdate',

        <%-- 직원 수정 --%>
        updateMember: function () {
            const self = this;
            const $name = $('#name');

            if (!$name.val()) {
                w2alert('이름을 입력해주세요.').ok(() => {
                    $name.focus();
                });
                return;
            }

            const formData = new FormData();
            formData.append('memberId', '${param.memberId}');
            formData.append('name', $('#name').val());
            formData.append('position', $('#position option:selected').val());

            if ($('#profile')[0].files[0]) {
                formData.append('profile', $('#profile')[0].files[0]);
            } else {
                formData.append('profilePath', '${param.profilePath}');
            }

            $.ajax({
                type: 'PUT',
                dataType: 'text',
                processData: false, // 데이터 객체를 문자열로 바꿀지 여부
                contentType: false, // true: 일반 text로 구분되어 짐
                data: formData,
                url: '${pageContext.request.contextPath}/api/member',
                success: function (result) {
                    console.log('[%s] updateMember - result: ', self.pageId, result);

                    if (result > 0) {
                        w2alert('직원이 수정되었습니다.', '직원 수정').ok(() => {
                            const obj = {'key': daouTree};
                            const property = 'key';

                            obj[property].initTree();
                            w2popup.close();
                        });
                    }
                }
            });
        },

        initPosition: function () {
            const self = this;

            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '${pageContext.request.contextPath}/api/position',
                success: function (result) {
                    console.log('[%s] initPosition - result: ', self.pageId, result);

                    $.each(result, (i, v) => {
                        $('#position').append('<option value="' + v.positionId + '">' + v.name + '</option>');
                    });

                    $('#position').val('${param.position}').prop('selected', true);
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        },
    };

    $(function () {
        memberUpdate.initPosition();
    });
</script>
</body>
</html>
