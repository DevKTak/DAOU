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
    </style>
</head>
<body>
<div style="display: flex; width: 100%; height: 100%;">
    <div style="width: 50%; border: 3px #cfcfcf outset; overflow: auto; margin-top: 5px;">
        <div id="daouTreePopup"></div>
    </div>
    <div style="width: 50%; overflow: auto;">
        <div class="w2ui-group">
            <div class="w2ui-group-fields">
                <div class="w2ui-field">
                    <label for="parentDeptName">상위 부서</label>
                    <input type="text" id="parentDeptName" disabled>
                </div>
            </div>
            <div class="w2ui-group-fields">
                <div class="w2ui-field">
                    <label for="name">부서명</label>
                    <input type="text" id="name">
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var departmentPopup = {

        pageId: 'departmentPopup',

        parent: daouTree,
        parentId: '',
        sort: 0,

        initTree: function () {
            const self = this;

            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '${pageContext.request.contextPath}/common/tree',
                success: function (result) {
                    console.log('[%s] initTree - result: ', self.pageId, result);

                    const department = [];
                    let maxSort = -Infinity;

                    $.each(result?.department, (i, v) => {
                        department.push({
                            id: v.department_id,
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

                    const $daouTreePopup = $('#daouTreePopup');

                    $daouTreePopup.jstree({
                        core: {
                            multiple: false, // 다중 선택
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
                        plugins: ['types', 'sort']
                    }).on('loaded.jstree', function () {
                        $daouTreePopup.jstree('open_all');

                        $('#parentDeptName').val('${deptName}');
                        self.parentId =  '${deptId}';
                    }).on('changed.jstree', function (event, data) {
                        const node = data.node;

                        $('#parentDeptName').val(node.text);
                        self.parentId = node.id;

                    }).on('move_node.jstree', function () {

                    }).on('select_node', function (event, data) {
                        console.log('event2: ', event);
                        console.log('data2: ', data);
                    }).on('refresh.jstree', function () {
                        console.log('refresh.jstree');
                    });
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        },

        save: function () {
            const self = this;

            const param = {
                parentId: self.parentId,
                name: $('#name').val(),
                sort: self.sort
            }

            $.ajax({
                type: 'POST',
                dataType: 'text',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(param),
                url: '${pageContext.request.contextPath}/api/department',
                success: function (result) {
                    console.log('[%s] save - result: ', self.pageId, result);

                    if (result > 0) {
                        w2alert('부서가 생성되었습니다.').ok(() => {
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

    $(function () {
        departmentPopup.initTree();
    });
</script>
</body>
</html>
