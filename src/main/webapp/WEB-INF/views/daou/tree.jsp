<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>DAOU</title>

    <%@ include file="/WEB-INF/views/include/style.jsp" %>
    <%@ include file="/WEB-INF/views/include/header.jsp" %>
</head>
<body>
<div style="text-align: center; width: 300px; border: solid 1px #e7e7e7; padding: 5px; font-weight: bold; margin-bottom: 15px;">조직도</div>
<div id="daouTree"></div>

<script>
    const daouTree = {

        pageId: 'daouTree',

        initTree: function () {
            const self = this;

            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '${pageContext.request.contextPath}/api/common/tree',
                success: function (result) {
                    console.log('[%s] initTree - result: ', self.pageId, result);

                    const department = [];

                    $.each(result?.department, (i, v) => {
                        department.push({
                            id: v.department_id,
                            departmentId: v.department_id,
                            parent: v.department_id === '[DAOU]' ? '#' : v.parent_id,
                            text: v.name,
                            type: '',
                            sort: v.sort
                        });
                    });

                    const member = [];

                    $.each(result?.memberAndPosition, (i, v) => {
                        member.push({
                            id: i, // member_id는 슈퍼키라 중복이 있을수 있기 때문에 jstree에서는 id값으로 사용 x
                            memberId: v.member_id,
                            departmentId: v.department_id,
                            memberName: v.member_name,
                            positionName: v.position_name,
                            parent: v.department_id,
                            text: v.member_name + ' ' + v.position_name,
                            type: 'leaf',
                            level: v.level,
                            positionId: v.position_id,
                            profilePath: v.profile_path,
                            icon : '${pageContext.request.contextPath}/profileImage/' + v.profile_path
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
                            data: member,
                            check_callback: true, // 기본적인 컨텍스트메뉴 사용, true를 안해주면 드래그만 되고 이동은 안됨
                            check_callback: (operation, curNode, nextNode, nodePosition, more) => {
                                if (operation === 'move_node' && more.ref === undefined) { // Drop 하는 시점
                                    const curData = curNode.original;
                                    let nextData = nextNode.original;
                                    const msg = confirm('[' + curData.text + '] -> [' + nextData.text + ']  이동 하시겠습니까?');

                                    if (curData.type === '' && nextData.type === '') { // 부서 -> 부서
                                        if (!msg) {
                                            return false;
                                        }
                                        const param = {
                                            departmentId: curData.departmentId,
                                            parentId: nextData.departmentId
                                        };

                                        $.ajax({
                                            type: 'PUT',
                                            dataType: 'text',
                                            contentType: 'application/json; charset=utf-8',
                                            data: JSON.stringify(param),
                                            url: '${pageContext.request.contextPath}/api/department/drag-and-drop',
                                            success: function (result) {
                                                console.log('[%s] check_callback 부서 -> 부서 - result: ', self.pageId, result);
                                            }
                                        });
                                    } else if (curData.type === 'leaf' && nextData.type === '') { // 직원 -> 부서
                                        if (!msg) {
                                            return false;
                                        }
                                        const param = {
                                            memberId: curData.memberId,
                                            departmentId: curData.departmentId,
                                            nextDepartmentId: nextData.departmentId
                                        };

                                        $.ajax({
                                            type: 'PUT',
                                            dataType: 'text',
                                            contentType: 'application/json; charset=utf-8',
                                            data: JSON.stringify(param),
                                            url: '${pageContext.request.contextPath}/api/member/drag-and-drop',
                                            success: function (result) {
                                                console.log('[%s] check_callback 직원 -> 부서 - result: ', self.pageId, result);
                                            }
                                        });
                                    } else if (curData.type === 'leaf' && nextData.type === 'leaf') {
                                        w2alert('[' + curData.text + '] -> [' + nextData.text + '] 이동할 수 없습니다.');
                                        return false;
                                    } else {
                                        w2alert('[' + curData.text + '] -> [' + nextData.text + '] 이동할 수 없습니다.');
                                        return false;
                                    }
                                }
                            }
                        },
                        types: {
                            default: {
                                icon : '${pageContext.request.contextPath}/icon/daou3.png'
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
                                return this.get_node(a).original.type === '' ? 1 : -1;
                            } else { //그룹과 그룹 비교
                                if (this.get_node(a).original.sort > this.get_node(b).original.sort) {
                                    return 1;
                                } else if (this.get_node(a).original.sort === this.get_node(b).original.sort) {
                                    return aText > bText ? 1 : -1;
                                } else {
                                    return -1;
                                }
                            }
                        },
                        contextmenu: {
                            items: function (node) {
                                console.log('[%s] initTree - contextmenu.items.node: ', self.pageId, node);

                                const nodeData = node.original;
                                console.log('[%s] initTree - contextmenu.items.nodeData: ', self.pageId, nodeData);

                                const departmentContextMenu = {
                                    departmentCreate: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '부서 추가',
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
                                        _disabled: node.children.length > 0,
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.departmentDelete.obj: ', self.pageId, obj);

                                            w2confirm('해당 부서를 삭제하시겠습니까?', '부서 삭제').yes(() => {
                                                self.deleteDepartment(nodeData);
                                            });
                                        }
                                    },
                                    memberCreate: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '직원 추가',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.memberCreate.obj: ', self.pageId, obj);

                                            self.memberCreateForm(nodeData);
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

                                            self.memberUpdateForm(nodeData);
                                        }
                                    },
                                    memberDelete: {
                                        separator_before: false,
                                        separator_after: false,
                                        label: '직원 삭제',
                                        action: (obj) => {
                                            console.log('[%s] initTree - contextmenu.items.memberDelete.obj: ', self.pageId, obj);

                                            w2confirm('해당 직원를 삭제하시겠습니까?', '부서 삭제').yes(() => {
                                                self.deleteMember(nodeData);
                                            });
                                        }
                                    }
                                }

                            return nodeData.type === '' ? departmentContextMenu : memberContextMenu;
                          }
                        },
                        plugins: ['contextmenu', 'types', 'dnd' , 'sort', 'unique'/*, 'wholerow'*/]
                    }).on('loaded.jstree', function () {
                        $daouTree.jstree('open_all');
                    }).on('changed.jstree', function (event, data) {
                        console.log('[%s] initTree - changed.jstree - data: ', self.pageId, data);
                    }).on('move_node.jstree', function (event, data) {

                    });
                },
                error: function (request, status, error) {
                    console.error('request: ', request, 'status: ', status, 'error: ', error);
                }
            });
        },

        <%-- 부서 추가 팝업 --%>
        departmentCreateForm: function (nodeData) {
            const $body = $('body');

            $.ajax({
                type: 'GET',
                dataType: 'html',
                data: 'departmentId=' + encodeURIComponent(nodeData.departmentId)
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
                        '<button class="w2ui-btn w2ui-icon-check" onclick="departmentCreate.createDepartment();">&nbsp;&nbsp;Save</button>',
                        '<button class="w2ui-btn w2ui-icon-cross" onclick="w2popup.close();">&nbsp;&nbsp;Close</button>'
                    ];

                    w2popup.open({
                        title: '부서 추가',
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

        <%-- 부서 수정 팝업 --%>
        departmentUpdateForm: function (nodeData) {
            const $body = $('body');

            $.ajax({
                type: 'GET',
                dataType: 'html',
                data: 'departmentId=' + encodeURIComponent(nodeData.departmentId)
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
        },

        <%-- 부서 삭제 --%>
        deleteDepartment: function (nodeData) {
            $.ajax({
                type: 'DELETE',
                dataType: 'text',
                contentType: 'application/json; charset=utf-8',
                url: '${pageContext.request.contextPath}/api/department/' + nodeData.departmentId,
                success: function (result) {
                    console.log('[%s] deleteDepartment - result: ', this.pageId, result);

                    if (result > 0) {
                        w2alert('부서가 삭제되었습니다.', '부서 삭제').ok(() => {
                            daouTree.initTree();
                        });
                    }
                }
            });
        },

        <%-- 직원 추가 팝업 --%>
        memberCreateForm: function (nodeData) {
            const $body = $('body');

            $.ajax({
                type: 'GET',
                dataType: 'html',
                data: 'departmentId=' + encodeURIComponent(nodeData.departmentId)
                    + '&deptName=' + encodeURIComponent(nodeData.text),
                url: '${pageContext.request.contextPath}/member/createForm',
                beforeSend: function () {
                    w2utils.lock($body, {spinner: true, msg: '화면 로딩중...', opacity: 0.5});
                },
                complete: function () {
                    w2utils.unlock($body);
                },
                success: function (result) {
                    const buttons = [
                        '<button class="w2ui-btn w2ui-icon-check" onclick="memberCreate.createMember();">&nbsp;&nbsp;Save</button>',
                        '<button class="w2ui-btn w2ui-icon-cross" onclick="w2popup.close();">&nbsp;&nbsp;Close</button>'
                    ];

                    w2popup.open({
                        title: '직원 추가',
                        body: result,
                        width: 520,
                        height: 489,
                        modal: true,
                        showClose: false,
                        buttons: buttons.join('')
                    });
                }
            });
        },

        <%-- 직원 수정 팝업 --%>
        memberUpdateForm: function (nodeData) {
            const $body = $('body');

            $.ajax({
                type: 'GET',
                dataType: 'html',
                data: 'memberId=' + encodeURIComponent(nodeData.memberId)
                    + '&name=' + encodeURIComponent(nodeData.memberName)
                    + '&position=' + encodeURIComponent(nodeData.positionId)
                    + '&profilePath=' + encodeURIComponent(nodeData.profilePath),
                url: '${pageContext.request.contextPath}/member/updateForm',
                beforeSend: function () {
                    w2utils.lock($body, {spinner: true, msg: '화면 로딩중...', opacity: 0.5});
                },
                complete: function () {
                    w2utils.unlock($body);
                },
                success: function (result) {
                    const buttons = [
                        '<button class="w2ui-btn w2ui-icon-check" onclick="memberUpdate.updateMember()">&nbsp;&nbsp;Save</button>',
                        '<button class="w2ui-btn w2ui-icon-cross" onclick="w2popup.close();">&nbsp;&nbsp;Close</button>'
                    ];

                    w2popup.open({
                        title: '직원 수정',
                        body: result,
                        width: 290,
                        height: 441,
                        modal: true,
                        showClose: false,
                        buttons: buttons.join('')
                    });
                }
            });
        },

        <%-- 직원 삭제 --%>
        deleteMember: function (nodeData) {
            $.ajax({
                type: 'DELETE',
                dataType: 'text',
                contentType: 'application/json; charset=utf-8',
                url: '${pageContext.request.contextPath}/api/member/' + nodeData.parent + '/' + nodeData.memberId,
                success: function (result) {
                    console.log('[%s] deleteMember - result: ', this.pageId, result);

                    if (result > 0) {
                        w2alert('직원이 삭제되었습니다.', '직원 삭제').ok(() => {
                            daouTree.initTree();
                        });
                    }
                }
            });
        }
    };

    $(function () {
        daouTree.initTree();

        $('i[role="presentation"]').css('color', 'red');
        $('.jstree-icon').css('color', 'red');
        $('.jstree-icon:empty').css('color', 'red');
        $('.jstree-default .jstree-icon:empty').css('color', 'red');
    });
</script>
</body>
</html>
