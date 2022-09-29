<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>DAOU</title>

    <style>
        .w2ui-field > label {
            width: 60px;
            margin-right: 20px;
            line-height: 10px;
        }
        .w2ui-popup .w2ui-popup-body {
            overflow: hidden;
        }
    </style>
</head>
<body>
<div class="w2ui-group">
    <div class="w2ui-group-fields">
        <div class="w2ui-field w2ui-span3">
            <label for="name">부서명</label>
            <input type="text" id="name" class="w2ui-input" maxlength="50" value="${deptName}">
        </div>
    </div>
</div>

<script>
    var departmentUpdate = {

        pageId: 'departmentUpdate',

        <%-- 부서 수정 --%>
        updateDepartment: function () {
            const self = this;

            const param = {
                departmentId: '${departmentId}',
                name: $('#name').val(),
            };

            $.ajax({
                type: 'PUT',
                dataType: 'text',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(param),
                url: '${pageContext.request.contextPath}/api/department',
                success: function (result) {
                    console.log('[%s] updateDepartment - result: ', self.pageId, result);

                    if (result > 0) {
                        w2alert('부서가 수정되었습니다.', '부서 수정').ok(() => {
                            const obj = {'key': daouTree};
                            const property = 'key';

                            obj[property].initTree();
                            w2popup.close();
                        });
                    }
                }
            });
        }
    };
</script>
</body>
</html>
