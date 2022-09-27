<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>DAOU</title>

<%--    <%@ include file="/WEB-INF/views/include/style.jsp "%>--%>
<%--    <%@ include file="/WEB-INF/views/include/header.jsp "%>--%>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
    <link rel="stylesheet" type="text/css" href="http://w2ui.com/src/w2ui-1.5.min.css" />
</head>
<body>
<div style="text-align: center; width: 300px; border: solid 1px #e7e7e7; padding: 5px; font-weight: bold; margin-bottom: 15px;">조직도</div>
<div id="daouTree"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/w2ui-1.5.min.js"></script>
<script>
    const daouTree = {

        pageId: 'daouTree',

        initTree: function () {
            const self = this;

            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '${pageContext.request.contextPath}/common/tree',
                success: function (result) {
                    console.log('[%s] initTree - result: ', self.pageId, result);

                    const department = [];

                    $.each(result?.department, (i, v) => {
                        department.push({
                            id: v.department_id,
                            parent: v.department_id === '[DAOU]' ? '#' : v.parent_id,
                            text: v.name,
                            type: '',
                            sort: v.sort
                        });
                    });

                    const member = [];

                    $.each(result?.memberAndPosition, (i, v) => {
                        member.push({
                            id: i,
                            parent: v.department_id,
                            text: v.name,
                            type: 'leaf',
                            level: v.level
                        });
                    });

                    member.push(...department);
                    console.log('member', member);

                    const $daouTree = $('#daouTree');

                    $daouTree.jstree('destroy');
                    $daouTree.jstree({
                        core: {
                            animation: 0,
                            multiple: false, // 다중 선택
                            check_callback: true, // 기본적인 컨텍스트메뉴 사용, true를 안해주면 드래그만 되고 이동은 안됨
                            data: member
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
                            const aLevel = this.get_node(a).original?.level;
                            const bLevel = this.get_node(b).original?.level;
                            const aText = this.get_node(a).text;
                            const bText = this.get_node(b).text;

                            if (aLevel && bLevel) { // 사원간 비교
                                if (aLevel > bLevel) {
                                    return 1;
                                } else if (aLevel === bLevel) { // 직위가 같을 경우
                                    return aText > bText ? 1 : -1; // 이름별 오름차순
                                } else {
                                    return -1;
                                }
                            } else if (aLevel || bLevel) { // 사원과 그룹 비교
                                return this.get_node(a).icon ? 1 : -1;
                            } else { //그룹과 그룹 비교
                                return this.get_node(a).original.sort > this.get_node(b).original.sort ? 1 : -1;
                            }
                        },
                        contextmenu: {
                            items: function (node) {
                                console.log('[%s] initTree - contextmenu.items.node: ', self.pageId, node);

                                const nodeData = node.original;
                                const departmentContextMenu = {
                                    departmentCreate: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '부서 생성',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.departmentCreate.obj: ', self.pageId, obj);

                                            self.departmentCreateForm(nodeData);
                                        }
                                    },
                                    departmentUpdate: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '부서 수정',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.departmentUpdate.obj: ', self.pageId, obj);

                                            self.departmentUpdateForm(nodeData);
                                        }
                                    },
                                    departmentDelete: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '부서 삭제',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.departmentDelete.obj: ', self.pageId, obj);
                                        }
                                    },
                                    memberCreate: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '직원 생성',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.memberCreate.obj: ', self.pageId, obj);
                                        }
                                    },
                                };
                                const memberContextMenu = {
                                    memberUpdate: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '직원 수정',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.memberUpdate.obj: ', self.pageId, obj);
                                        }
                                    },
                                    memberDelete: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '직원 삭제',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.memberDelete.obj: ', self.pageId, obj);
                                        }
                                    },
                                }

                            return node.icon ? departmentContextMenu : memberContextMenu;
                          }
                        },
                        plugins: ['contextmenu', 'types', 'dnd' /*, 'wholerow' */, 'sort']
                    }).on('loaded.jstree', function () {
                        $daouTree.jstree('open_all');
                    }).on('changed.jstree', function (event, data) {
                        console.log('event: ', event);
                        console.log('data: ', data);
                    }).on('move_node.jstree', function () {

                    });
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        },

        departmentCreateForm: function (nodeData) {
            const $body = $('body');

            $.ajax({
                type: 'GET',
                dataType: 'html',
                data: 'departmentId=' + encodeURIComponent(nodeData.id)
                    + '&deptName=' + encodeURIComponent(nodeData.text),
                url: '${pageContext.request.contextPath}/department/createForm',
                beforeSend: function () {
                    w2utils.lock($body, {spinner: true, msg: '화면 로딩중...', opacity: 0.5});
                },
                complete: function () {
                  w2utils.unlock($body);
                },
                success: function (result) {
                    const buttons = [
                        '<button class="w2ui-btn w2ui-icon-check" onclick="departmentCreate.createDepartment()">&nbsp;&nbsp;Save</button>',
                        '<button class="w2ui-btn w2ui-icon-cross" onclick="w2popup.close();">&nbsp;&nbsp;Close</button>'
                    ];

                    w2popup.open({
                        title: '부서 생성',
                        body: result,
                        width: 500,
                        height: 400,
                        modal: true,
                        showClose: false,
                        buttons: buttons.join('')
                    });
                }
            });
        },

        departmentUpdateForm: function (nodeData) {
            const $body = $('body');

            $.ajax({
                type: 'GET',
                dataType: 'html',
                data: 'departmentId=' + encodeURIComponent(nodeData.id)
                    + '&deptName=' + encodeURIComponent(nodeData.text),
                url: '${pageContext.request.contextPath}/department/updateForm',
                beforeSend: function () {
                    w2utils.lock($body, {spinner: true, msg: '화면 로딩중...', opacity: 0.5});
                },
                complete: function () {
                    w2utils.unlock($body);
                },
                success: function (result) {
                    const buttons = [
                        '<button class="w2ui-btn w2ui-icon-check" onclick="departmentUpdate.updateDepartment()">&nbsp;&nbsp;Save</button>',
                        '<button class="w2ui-btn w2ui-icon-cross" onclick="w2popup.close();">&nbsp;&nbsp;Close</button>'
                    ];

                    w2popup.open({
                        title: '부서 수정',
                        body: result,
                        width: 300,
                        height: 144,
                        modal: true,
                        showClose: false,
                        buttons: buttons.join('')
                    });
                }
            });
        }
    };

    $(function () {
        daouTree.initTree();
    });
</script>
</body>
</html>
