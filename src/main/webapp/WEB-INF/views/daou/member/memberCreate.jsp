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
    </style>
</head>
<body>
<form id="memberForm" style="display: flex; width: 100%; height: 100%;" action="${pageContext.request.contextPath}/api/member" method="POST" enctype="multipart/form-data">
    <input type="hidden" id="departmentIdList" name="departmentIdList" value="departmentIdList">

    <div style="width: 50%; border: 1px #cfcfcf outset; overflow: auto; margin-top: 5px; height: 96%;">
        <div id="daouTreeCreate"></div>
    </div>
    <div style="width: 50%; overflow: auto;">
        <div class="w2ui-group">
            <div class="w2ui-group-fields">
                <div class="w2ui-field" style="display: flex;">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" placeholder="이름을 입력해주세요." required>
                </div>
            </div>
            <div class="w2ui-group-fields">
                <div class="w2ui-field" style="display: flex;">
                    <label for="position">직급</label>
                    <select id="position" name="position"></select>
                </div>
            </div>
            <div class="w2ui-group-fields">
                <div class="w2ui-field" style="display: flex; align-items: center;">
                    <label for="profile" style="width: 74px;">이미지</label>
                    <input type="file" id="profile" name="profile" class="w2ui-btn" required>
                </div>
            </div>
            <div class="w2ui-group-fields">
                <div class="w2ui-field">
                    <label for="deptName">부서명</label>
                    <textarea id="deptName" name="deptName" disabled style="width: 147px; height: 139px; resize: none;" required></textarea>
                    <div style="margin-left: 0; font-weight: bold; padding-top: 7px; text-align: center;">
                        <span style="color: red;">*</span>부서 중복 선택 가능
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    var memberCreate = {

        pageId: 'memberCreate',

        deptName: [],

        initTree: function () {
            const self = this;

            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '${pageContext.request.contextPath}/api/common/tree',
                success: function (result) {
                    console.log('[%s] initTree - result: ', self.pageId, result);

                    const department = [];
                    let maxSort = -Infinity;

                    $.each(result?.department, (i, v) => {
                        department.push({
                            id: v.department_id,
                            departmentId: v.department_id,
                            parent: v.department_id === '[DAOU]' ? '#' : v.parent_id,
                            text: v.name,
                            type: '',
                            sort: v.sort
                        });

                        if (maxSort < v.sort) {
                            maxSort = v.sort;
                        }
                    });
                    self.sort = maxSort + 1;

                    const $daouTreeCreate = $('#daouTreeCreate');

                    $daouTreeCreate.jstree({
                        core: {
                            multiple: true, // 다중 선택
                            check_callback: false,
                            data: department
                        },
                        types: {
                            leaf: {
                                icon : false
                            }
                        },
                        cookie: {
                            save_selected: false // 가끔 이전에 눌렀던 node 자동선택 방지(쿠키 제거)
                        },
                        sort: function(a, b) {
                            return this.get_node(a).original.sort > this.get_node(b).original.sort ? 1 : -1;
                        },
                        plugins: ['types', 'sort', 'unique']
                    }).on('loaded.jstree', function () {
                        $daouTreeCreate.jstree('open_all');

                        self.departmentIdList = '${departmentId}'
                        self.deptName.push('${deptName}');
                        $('#deptName').val('${deptName}');
                    }).on('changed.jstree', function (event, data) {
                        console.log(data)
                        const selectedNodeLen = ( $daouTreeCreate.jstree("get_selected") ).length;
                        let nodeData = data.node.original;

                            if (data.action === 'select_node') {
                                if (selectedNodeLen <= 1) {
                                    self.deptName.length = 0;
                                }
                                // self.departmentId.push(nodeData.departmentId);
                                self.deptName.push(nodeData.text);
                            } else { // deselect_node
                                self.deptName = self.deptName.filter(v => {
                                    return v !== nodeData.text;
                                });
                            }
                            $('#deptName').val(self.deptName.join('\n'));
                            self.departmentIdList = data.selected;
                    });
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
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
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        },

        <%-- 직원 추가 --%>
        createMember: function () {
            const self = this;

            const formData = new FormData();
            formData.append('name', $('#name').val());
            formData.append('position', $('#position option:selected').val());
            formData.append('departmentIdList', self.departmentIdList);
            formData.append('profile', $('#profile')[0].files[0]);

            $.ajax({
                type: 'POST',
                dataType: 'text',
                processData: false, // 데이터 객체를 문자열로 바꿀지 여부
                contentType: false, // true: 일반 text로 구분되어 짐
                data: formData,
                url: '${pageContext.request.contextPath}/api/member',
                success: function (result) {
                    console.log('[%s] createMember - result: ', self.pageId, result);

                    w2alert('직원이 추가되었습니다.', '직원 추가').ok(() => {
                        const obj = {'key': daouTree};
                        const property = 'key';

                        obj[property].initTree();
                        w2popup.close();
                    });

                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        }
    };

    $(function () {
        memberCreate.initPosition();
        memberCreate.initTree();
    });
</script>
</body>
</html>
