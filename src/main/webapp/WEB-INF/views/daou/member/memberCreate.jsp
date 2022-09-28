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
<div style="display: flex; width: 100%; height: 100%;">
    <div style="width: 50%; border: 3px #cfcfcf outset; overflow: auto; margin-top: 5px;">
        <div id="daouTreeCreate"></div>
    </div>
    <div style="width: 50%; overflow: auto;">
        <div class="w2ui-group">
            <div class="w2ui-group-fields">
                <div class="w2ui-field">
                    <label for="name">이름</label>
                    <input type="text" id="name" placeholder="이름을 입력해주세요." required>
                </div>
            </div>
            <div class="w2ui-group-fields">
                <div class="w2ui-field">
                    <label for="position">직급</label>
                    <select id="position"></select>
                </div>
            </div>
            <div class="w2ui-group-fields">
                <div class="w2ui-field">
                    <label for="deptName">부서명</label>
                    <input type="text" id="deptName" disabled>
                    <div style="margin-left: 0; font-weight: bold; padding-top: 7px;">
                        <span style="color: red;">*</span> 부서 중복 선택 가능
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var memberCreate = {

        pageId: 'memberCreate',

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

                        self.parentId =  '${departmentId}';
                    }).on('changed.jstree', function (event, data) {
                        const node = data.node;
                        $('#parentDeptName').val(node.text);
                        self.parentId = node.departmentId;
                    });
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        },
    };

    $(function () {
        memberCreate.initTree();
    });
</script>
</body>
</html>
