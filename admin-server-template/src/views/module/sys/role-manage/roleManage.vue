<style lang="less">
    @import "./roleManage.less";
</style>
<template>
    <div class="search">
        <Row>
            <Col>
                <Card>
                    <Row class="operation">
                        <Button @click="addRole" v-if="permTypes.length > 0" v-has="'add'" type="primary" icon="md-add">添加角色</Button>
                        <Button @click="delAll" v-if="permTypes.length > 0" v-has="'delete'" icon="md-trash">批量删除</Button>
                        <Button @click="init" icon="md-refresh">刷新</Button>
                    </Row>
                    <Row>
                        <Alert show-icon>
                            已选择 <span class="select-count">{{selectCount}}</span> 项
                            <a class="select-clear" @click="clearSelectAll">清空</a>
                        </Alert>
                    </Row>
                    <Row>
                        <Table :loading="loading" border :columns="columns" :data="data" ref="table" sortable="custom"
                               @on-sort-change="changeSort" @on-selection-change="changeSelect"></Table>
                    </Row>
                    <Row type="flex" justify="end" class="page">
                        <Page :current="pageNumber" :total="total" :page-size="pageSize" @on-change="changePage"
                              @on-page-size-change="changePageSize" :page-size-opts="[10,20,50]" size="small" show-total
                              show-elevator show-sizer></Page>
                    </Row>
                </Card>
            </Col>
        </Row>
        <Modal :title="modalTitle" v-model="roleModalVisible" :mask-closable='false' :width="500">
            <Form ref="roleForm" :model="roleForm" :label-width="80" :rules="roleFormValidate">
                <FormItem label="角色名称" prop="name">
                    <Input v-model="roleForm.name" placeholder="按照Spring Security约定建议以‘ROLE_’开头"/>
                </FormItem>
                <FormItem label="备注" prop="description">
                    <Input v-model="roleForm.description"/>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelRole">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="submitRole">提交</Button>
            </div>
        </Modal>
        <Modal title="分配权限(点击选择)" v-model="permModalVisible" :mask-closable='false' :fullscreen="fullscreen" :width="500">

            <div slot="header">
                <div style="float: left;height: 30px; line-height: 30px;">
                    <h3>分配权限(点击选择)</h3>
                </div>
                <div style="float:right;margin-right: 30px;">
                    <span @click="fullscreenChange">
                        <i class="ivu-icon ivu-icon-ios-expand" v-if="!fullscreen" style="font-size: 20px;"></i>
                        <i class="ivu-icon ivu-icon-ios-contract" v-else style="font-size: 20px;"></i>
                    </span>
                </div>
                <div style="clear: both;"></div>
            </div>
            <!--<div slot="close"></div>-->

            <Tree ref="tree" :data="permData" multiple></Tree>
            <Spin size="large" v-if="treeLoading"></Spin>
            <div slot="footer">
                <Button type="text" @click="cancelPermEdit">取消</Button>
                <Button @click="selectTreeAll">全选/反选</Button>
                <Button type="primary" :loading="submitPermLoading" @click="submitPermEdit">提交</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
    import {
        getRoleList,
        getAllPermissionList,
        addRole,
        editRole,
        deleteRole,
        setDefaultRole,
        editRolePerm
    } from "@/api/index";
    import moment from 'moment';

    export default {
        name: "role-manage",
        data() {
            return {
                loading: true,
                treeLoading: true,
                submitPermLoading: false,
                sortColumn: "createdAt",
                sortType: "desc",
                modalType: 0,
                roleModalVisible: false,
                permModalVisible: false,
                modalTitle: "",
                fullscreen: false,
                permTypes: [],
                roleForm: {
                    description: "",
                    name: "",
                },
                roleFormValidate: {
                    name: [{required: true, message: "角色名称不能为空", trigger: "blur"}]
                },
                submitLoading: false,
                selectList: [],
                selectCount: 0,
                columns: [
                    {
                        type: "selection",
                        width: 60,
                        align: "center",
                        fixed: "left",
                    },
                    {
                        title: "角色名称",
                        key: "name",
                        minWidth: 150,
                    },
                    {
                        title: "备注",
                        key: "description",
                        minWidth: 200,
                    },
                    {
                        title: "创建时间",
                        key: "createdAt",
                        minWidth: 150,
                        sortable: true,
                        sortType: "desc",
                        render: (h, params) => {
                            return h("div", moment(params.row.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss'));
                        }
                    },
                    {
                        title: "更新时间",
                        key: "updatedAt",
                        minWidth: 150,
                        sortable: true,
                        sortType: "desc",
                        render: (h, params) => {
                            return h("div", moment(params.row.updatedAt * 1000).format('YYYY-MM-DD HH:mm:ss'));
                        }
                    },
                    {
                        title: "是否设置为注册用户默认角色",
                        key: "defaultRole",
                        align: "center",
                        minWidth: 200,
                        render: (h, params) => {
                            if (this.permTypes.includes("setDefault")) {
                                if (params.row.defaultRole) {
                                    return h("div", [
                                        h(
                                            "Button",
                                            {
                                                props: {
                                                    type: "success",
                                                    size: "small"
                                                },
                                                style: {
                                                    marginRight: "5px"
                                                },
                                                on: {
                                                    click: () => {
                                                        this.cancelDefault(params.row);
                                                    }
                                                }
                                            },
                                            "取消默认"
                                        )
                                    ]);
                                } else {
                                    return h("div", [
                                        h(
                                            "Button",
                                            {
                                                props: {
                                                    type: "info",
                                                    size: "small"
                                                },
                                                style: {
                                                    marginRight: "5px"
                                                },
                                                on: {
                                                    click: () => {
                                                        this.setDefault(params.row);
                                                    }
                                                }
                                            },
                                            "设为默认"
                                        )
                                    ]);
                                }
                            }
                        }
                    },
                    {
                        title: "操作",
                        key: "action",
                        align: "center",
                        fixed: "right",
                        width: 220,
                        render: (h, params) => {

                            let editBtn; let editPermBtn; let deleteBtn;
                            if (this.permTypes.includes("edit")) {
                                editBtn = h(
                                    "Button",
                                    {
                                        props: {
                                            type: "primary",
                                            size: "small"
                                        },
                                        style: {
                                            marginRight: "5px"
                                        },
                                        on: {
                                            click: () => {
                                                this.edit(params.row);
                                            }
                                        }
                                    },
                                    "编辑"
                                );
                            }

                            if (this.permTypes.includes("editPerm")) {
                                editPermBtn = h(
                                    "Button",
                                    {
                                        props: {
                                            type: "warning",
                                            size: "small"
                                        },
                                        style: {
                                            marginRight: "5px"
                                        },
                                        on: {
                                            click: () => {
                                                this.editPerm(params.row);
                                            }
                                        }
                                    },
                                    "分配权限"
                                );
                            }

                            if (this.permTypes.includes("delete")) {
                                deleteBtn = h(
                                    "Button",
                                    {
                                        props: {
                                            type: "error",
                                            size: "small"
                                        },
                                        on: {
                                            click: () => {
                                                this.remove(params.row);
                                            }
                                        }
                                    },
                                    "删除"
                                );
                            }

                            return h("div", [
                                editPermBtn,
                                editBtn,
                                deleteBtn,
                            ]);
                        }
                    }
                ],
                data: [],
                pageNumber: 1,
                pageSize: 10,
                total: 0,
                permData: [],
                editRolePermId: "",
                selectPermList: [],
                selectAllFlag: false
            };
        },
        methods: {
            init() {
                this.getRoleList();
                // 获取所有菜单权限树
                this.getPermList();
                this.initMeta();
            },
            changePage(v) {
                this.pageNumber = v;
                this.getRoleList();
                this.clearSelectAll();
            },
            changePageSize(v) {
                this.pageSize = v;
                this.getRoleList();
            },
            changeSort(e) {
                this.sortColumn = e.key;
                this.sortType = e.order;
                if (e.order === "normal") {
                    this.sortType = "";
                }
                this.getRoleList();
            },
            getRoleList() {
                this.loading = true;
                let params = {
                    pageNumber: this.pageNumber,
                    pageSize: this.pageSize,
                    sort: this.sortColumn,
                    order: this.sort
                };
                getRoleList(params).then(res => {
                    this.loading = false;
                    if (res.success === true) {
                        this.data = res.result.records;
                        this.total = res.result.total;
                    }
                });
            },
            getPermList() {
                this.treeLoading = true;
                getAllPermissionList().then(res => {
                    this.treeLoading = false;
                    if (res.success === true) {
                        this.deleteDisableNode(res.result);
                        this.permData = res.result;
                    }
                });
            },
            // 递归标记禁用节点
            deleteDisableNode(permData) {
                let that = this;
                permData.forEach(function (e) {
                    if (e.status === 0) {
                        e.title = "[已禁用] " + e.title;
                        e.disabled = true;
                    }
                    if (e.children && e.children.length > 0) {
                        that.deleteDisableNode(e.children);
                    }
                });
            },
            cancelRole() {
                this.roleModalVisible = false;
            },
            submitRole() {
                this.$refs.roleForm.validate(valid => {
                    if (valid) {
                        if (this.modalType === 0) {
                            // 添加
                            this.submitLoading = true;
                            addRole(this.roleForm).then(res => {
                                this.submitLoading = false;
                                if (res.success === true) {
                                    this.$Message.success("操作成功");
                                    this.getRoleList();
                                    this.roleModalVisible = false;
                                }
                            });
                        } else {
                            this.submitLoading = true;
                            editRole(this.roleForm).then(res => {
                                this.submitLoading = false;
                                if (res.success === true) {
                                    this.$Message.success("操作成功");
                                    this.getRoleList();
                                    this.roleModalVisible = false;
                                }
                            });
                        }
                    }
                });
            },
            addRole() {
                this.modalType = 0;
                this.modalTitle = "添加角色";
                this.$refs.roleForm.resetFields();
                delete this.roleForm.id;
                this.roleModalVisible = true;
            },
            edit(v) {
                this.modalType = 1;
                this.modalTitle = "编辑角色";
                // 转换null为""
                for (let attr in v) {
                    if (v[attr] === null) {
                        v[attr] = "";
                    }
                }
                let str = JSON.stringify(v);
                let roleInfo = JSON.parse(str);
                this.roleForm = roleInfo;
                this.roleModalVisible = true;
            },
            remove(v) {
                this.$Modal.confirm({
                    title: "确认删除",
                    content: "您确认要删除角色 " + v.name + " ?",
                    onOk: () => {
                        deleteRole(v.id).then(res => {
                            if (res.success === true) {
                                this.$Message.success("删除成功");
                                this.getRoleList();
                            }
                        });
                    }
                });
            },
            setDefault(v) {
                this.$Modal.confirm({
                    title: "确认设置",
                    content: "您确认要设置所选的 " + v.name + " 为注册用户默认角色?",
                    onOk: () => {
                        let params = {
                            id: v.id,
                            isDefault: true
                        };
                        setDefaultRole(params).then(res => {
                            if (res.success === true) {
                                this.$Message.success("操作成功");
                                this.getRoleList();
                            }
                        });
                    }
                });
            },
            cancelDefault(v) {
                this.$Modal.confirm({
                    title: "确认取消",
                    content: "您确认要取消所选的 " + v.name + " 角色为默认?",
                    onOk: () => {
                        let params = {
                            id: v.id,
                            isDefault: false
                        };
                        setDefaultRole(params).then(res => {
                            if (res.success === true) {
                                this.$Message.success("操作成功");
                                this.getRoleList();
                            }
                        });
                    }
                });
            },
            clearSelectAll() {
                this.$refs.table.selectAll(false);
            },
            changeSelect(e) {
                this.selectList = e;
                this.selectCount = e.length;
            },
            delAll() {
                if (this.selectCount <= 0) {
                    this.$Message.warning("您还未选择要删除的数据");
                    return;
                }
                this.$Modal.confirm({
                    title: "确认删除",
                    content: "您确认要删除所选的 " + this.selectCount + " 条数据?",
                    onOk: () => {
                        let ids = "";
                        this.selectList.forEach(function (e) {
                            ids += e.id + ",";
                        });
                        ids = ids.substring(0, ids.length - 1);
                        deleteRole(ids).then(res => {
                            if (res.success === true) {
                                this.$Message.success("删除成功");
                                this.clearSelectAll();
                                this.getRoleList();
                            }
                        });
                    }
                });
            },
            editPerm(v) {
                this.editRolePermId = v.id;
                // 匹配勾选
                let rolePerms = v.permissions;
                // 递归判断子节点
                this.checkPermTree(this.permData, rolePerms);
                this.permModalVisible = true;
            },
            // 递归判断子节点
            checkPermTree(permData, rolePerms) {
                let that = this;
                permData.forEach(function (p) {
                    if (that.hasPerm(p, rolePerms)) {
                        p.selected = true;
                    } else {
                        p.selected = false;
                    }
                    if (p.children && p.children.length > 0) {
                        that.checkPermTree(p.children, rolePerms);
                    }
                });
            },
            // 判断角色拥有的权限节点勾选
            hasPerm(p, rolePerms) {

                if (!rolePerms) {
                    return false;
                }

                let flag = false;
                for (let i = 0; i < rolePerms.length; i++) {
                    if (p.id === rolePerms[i].id) {
                        flag = true;
                        break;
                    }
                }
                if (flag) {
                    return true;
                }
                return false;
            },
            // 全选反选
            selectTreeAll() {
                this.selectAllFlag = !this.selectAllFlag;
                let select = this.selectAllFlag;
                this.selectedTreeAll(this.permData, select);
            },
            // 递归全选节点
            selectedTreeAll(permData, select) {
                let that = this;
                permData.forEach(function (e) {
                    e.selected = select;
                    if (e.children && e.children.length > 0) {
                        that.selectedTreeAll(e.children, select);
                    }
                });
            },
            submitPermEdit() {
                this.submitPermLoading = true;
                let permIds = "";
                let selectedNodes = this.$refs.tree.getSelectedNodes();
                selectedNodes.forEach(function (e) {
                    permIds += e.id + ",";
                });
                permIds = permIds.substring(0, permIds.length - 1);
                editRolePerm(this.editRolePermId, {
                    permIds: permIds
                }).then(res => {
                    this.submitPermLoading = false;
                    if (res.success === true) {
                        this.$Message.success("操作成功");
                        this.getRoleList();
                        this.permModalVisible = false;
                    }
                });
            },
            cancelPermEdit() {
                this.permModalVisible = false;
            },
            initMeta() {
                let permTypes = this.$route.meta.permTypes;
                if (permTypes !== null && permTypes !== undefined) {
                    this.permTypes = permTypes;
                }
            },
            fullscreenChange() {
                this.fullscreen = !this.fullscreen;
            },
        },
        mounted() {
            this.init();
        }
    };
</script>
