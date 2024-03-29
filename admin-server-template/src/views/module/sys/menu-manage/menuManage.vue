<style lang="less">
    @import "./menuManage.less";
</style>
<template>
    <div class="search">
        <Card>
            <Row class="operation">
                <Button @click="addMenu" type="primary" icon="md-add" v-if="permTypes.length > 0" v-has="'add'">添加子节点</Button>
                <Button @click="addRootMenu" icon="md-add" v-if="permTypes.length > 0" v-has="'add'">添加一级菜单</Button>
                <Button @click="delAll" icon="md-trash" v-if="permTypes.length > 0" v-has="'delete'">批量删除</Button>
                <Dropdown @on-click="handleDropdown">
                    <Button>
                        更多操作
                        <Icon type="md-arrow-dropdown"></Icon>
                    </Button>
                    <DropdownMenu slot="list">
                        <DropdownItem name="refresh">刷新</DropdownItem>
                        <DropdownItem name="expandOne">仅展开一级</DropdownItem>
                        <DropdownItem name="expandTwo">仅展开两级</DropdownItem>
                        <DropdownItem name="expandAll">展开所有</DropdownItem>
                    </DropdownMenu>
                </Dropdown>
            </Row>
            <Row type="flex" justify="start" class="code-row-bg">
                <Col span="6">
                    <Alert show-icon>
                        当前选择编辑：
                        <span class="select-count">{{editTitle}}</span>
                        <a class="select-clear" v-if="menuForm.id" @click="canelEdit">取消选择</a>
                    </Alert>
                    <Tree :data="data" show-checkbox @on-check-change="changeSelect"
                          @on-select-change="selectTree"></Tree>
                    <Spin size="large" fix v-if="loading"></Spin>
                </Col>
                <Col span="9">
                    <Form ref="menuForm" :model="menuForm" :label-width="85" :rules="menuFormValidate">
                        <FormItem label="类型" prop="type">
                            <RadioGroup v-model="menuForm.type">
                                <Radio :label="0" :disabled="isButton">
                                    <Icon type="ios-list-outline"></Icon>
                                    <span>页面菜单</span>
                                </Radio>
                                <Radio :label="1" :disabled="isMenu">
                                    <Icon type="log-in"></Icon>
                                    <span>操作按钮</span>
                                </Radio>
                            </RadioGroup>
                        </FormItem>
                        <FormItem label="名称" prop="title" v-if="menuForm.type===0">
                            <Input v-model="menuForm.title"/>
                        </FormItem>
                        <FormItem label="名称" prop="title" v-if="menuForm.type===1">
                            <Poptip trigger="focus" placement="right" width="230" word-wrap title="提示"
                                    content="操作按钮名称不得重复">
                                <Input v-model="menuForm.title"/>
                            </Poptip>
                        </FormItem>
                        <FormItem label="路径" prop="path" v-if="menuForm.type===0">
                            <Input v-model="menuForm.path"/>
                        </FormItem>
                        <FormItem label="请求路径" prop="path" v-if="menuForm.type===1">
                            <Poptip trigger="focus" placement="right" width="230" word-wrap title="提示"
                                    content="填写后台请求URL，后台将作权限拦截，若无可填写'无'或其他">
                                <Input v-model="menuForm.path"/>
                            </Poptip>
                        </FormItem>
                        <FormItem label="按钮权限类型" prop="buttonType" v-if="menuForm.type===1">
                            <Select v-model="menuForm.buttonType" placeholder="请选择" clearable>
                                <Option v-for="(item, i) in optionData" :key="i" :value="item.value">{{item.title}}
                                </Option>
                            </Select>
                        </FormItem>
                        <div v-if="menuForm.type===0">
                            <FormItem label="英文名" prop="name">
                                <Input v-model="menuForm.name"/>
                            </FormItem>
                            <FormItem label="图标" prop="icon" style="margin-bottom: 5px;">
                                <Input v-model="menuForm.icon"/>
                                <span>
                                    图标请参考
                                    <a target="_blank" href="https://www.iviewui.com/components/icon">
                                        <Icon type="ionic"></Icon>
                                        ionicons
                                    </a>
                                </span>
                            </FormItem>
                            <FormItem label="前端组件" prop="component">
                                <Input v-model="menuForm.component"/>
                            </FormItem>
                            <FormItem label="跳转网页链接" prop="url">
                                <Poptip trigger="focus" placement="right" width="230" word-wrap title="提示"
                                        content="前端组件需为 sys/monitor/monitor 时生效">
                                    <Input v-model="menuForm.url" placeholder="http://"/>
                                </Poptip>
                            </FormItem>
                        </div>
                        <FormItem label="排序值" prop="sortOrder">
                            <InputNumber :max="1000" :min="0" v-model="menuForm.sortOrder"></InputNumber>
                            <span style="margin-left:5px">值越小越靠前，支持小数</span>
                        </FormItem>
                        <FormItem label="是否启用" prop="status">
                            <i-switch size="large" v-model="editStatus" @on-change="changeEditSwitch">
                                <span slot="open">启用</span>
                                <span slot="close">禁用</span>
                            </i-switch>
                        </FormItem>
                        <Form-item>
                            <Button @click="submitEdit" :loading="submitLoading" type="primary"
                                    icon="ios-create-outline" v-if="permTypes.length > 0" v-has="'edit'">修改并保存
                            </Button>
                            <Button @click="handleReset">重置</Button>
                        </Form-item>
                    </Form>
                </Col>
            </Row>
        </Card>

        <Modal draggable :title="modalTitle" v-model="menuModalVisible" :mask-closable='false' :width="500"
               :styles="{top: '30px'}">
            <Form ref="menuFormAdd" :model="menuFormAdd" :label-width="85" :rules="menuFormValidate">
                <div v-if="showParent">
                    <FormItem label="上级节点：">
                        {{parentTitle}}
                    </FormItem>
                </div>
                <FormItem label="类型" prop="type">
                    <RadioGroup v-model="menuFormAdd.type">
                        <Radio :label="0" :disabled="isButtonAdd">
                            <Icon type="ios-list-outline"></Icon>
                            <span>页面菜单</span>
                        </Radio>
                        <Radio :label="1" :disabled="isMenuAdd">
                            <Icon type="log-in"></Icon>
                            <span>操作按钮</span>
                        </Radio>
                    </RadioGroup>
                </FormItem>
                <FormItem label="名称" prop="title" v-if="menuFormAdd.type===0">
                    <Input v-model="menuFormAdd.title"/>
                </FormItem>
                <FormItem label="名称" prop="title" v-if="menuFormAdd.type===1">
                    <Poptip trigger="focus" placement="right" width="230" word-wrap title="提示" content="操作按钮名称不得重复">
                        <Input v-model="menuFormAdd.title"/>
                    </Poptip>
                </FormItem>
                <FormItem label="路径" prop="path" v-if="menuFormAdd.type===0">
                    <Input v-model="menuFormAdd.path"/>
                </FormItem>
                <FormItem label="请求路径" prop="path" v-if="menuFormAdd.type===1">
                    <Poptip trigger="focus" placement="right" width="230" word-wrap title="提示"
                            content="填写后台请求URL，后台将作权限拦截，若无可填写'无'或其他">
                        <Input v-model="menuFormAdd.path"/>
                    </Poptip>
                </FormItem>
                <FormItem label="按钮权限类型" prop="buttonType" v-if="menuFormAdd.type===1">
                    <Select v-model="menuFormAdd.buttonType" placeholder="请选择" clearable>
                        <Option v-for="(item, i) in optionData" :key="i" :value="item.value">{{item.title}}</Option>
                    </Select>
                </FormItem>
                <div v-if="menuFormAdd.type===0">
                    <FormItem label="英文名" prop="name">
                        <Input v-model="menuFormAdd.name"/>
                    </FormItem>
                    <FormItem label="图标" prop="icon" style="margin-bottom: 5px;">
                        <Input v-model="menuFormAdd.icon"/>
                        <span>
                            图标请参考
                            <a target="_blank" href="https://www.iviewui.com/components/icon">
                                <Icon type="ionic"></Icon>
                                ionicons
                            </a>
                        </span>
                    </FormItem>
                    <FormItem label="前端组件" prop="component">
                        <Input v-model="menuFormAdd.component"/>
                    </FormItem>
                    <FormItem label="跳转网页链接" prop="url">
                        <Poptip trigger="focus" placement="right" width="230" word-wrap title="提示"
                                content="前端组件需为 sys/monitor/monitor 时生效">
                            <Input v-model="menuFormAdd.url" placeholder="http://"/>
                        </Poptip>
                    </FormItem>
                </div>
                <FormItem label="排序值" prop="sortOrder">
                    <InputNumber :max="1000" :min="0" v-model="menuFormAdd.sortOrder"></InputNumber>
                    <span style="margin-left:5px">值越小越靠前，支持小数</span>
                </FormItem>
                <FormItem label="是否启用" prop="status">
                    <i-switch size="large" v-model="addStatus" @on-change="changeAddSwitch">
                        <span slot="open">启用</span>
                        <span slot="close">禁用</span>
                    </i-switch>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelAdd">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="submitAdd">提交</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
    import {addPermission, deletePermission, editPermission, getAllPermissionList} from "@/api/index";

    export default {
        name: "menu-manage",
        data() {
            return {
                loading: true,
                expandLevel: 1,
                menuModalVisible: false,
                selectList: [],
                selectCount: 0,
                showParent: false,
                parentTitle: "",
                isButtonAdd: false,
                isMenuAdd: false,
                isMenu: false,
                isButton: false,
                editStatus: true,
                addStatus: true,
                editTitle: "",
                modalTitle: "",
                permTypes: [],
                menuForm: {
                    id: "",
                    parentId: "",
                    buttonType: "",
                    type: 0,
                    sortOrder: null,
                    level: null,
                    status: 1,
                    url: ""
                },
                menuFormAdd: {
                    buttonType: ""
                },
                menuFormValidate: {
                    title: [{required: true, message: "名称不能为空", trigger: "blur"}],
                    name: [{required: true, message: "英文名不能为空", trigger: "blur"}],
                    icon: [{required: true, message: "图标不能为空", trigger: "blur"}],
                    path: [{required: true, message: "路径不能为空", trigger: "blur"}],
                    component: [
                        {required: true, message: "前端组件不能为空", trigger: "blur"}
                    ]
                },
                submitLoading: false,
                data: [],
                optionData: [
                    {title: "查看操作", value: "view"},
                    {title: "添加操作", value: "add"},
                    {title: "编辑操作", value: "edit"},
                    {title: "删除操作", value: "delete"},
                    {title: "清空操作", value: "clear"},
                    {title: "启用操作", value: "enable"},
                    {title: "禁用操作", value: "disable"},
                    {title: "搜索操作", value: "search"},
                    {title: "上传文件", value: "upload"},
                    {title: "导出操作", value: "output"},
                    {title: "导入操作", value: "input"},
                    {title: "分配权限", value: "editPerm"},
                    {title: "设为默认", value: "setDefault"},
                    {title: "修改密码", value: "updatePassword"},
                    {title: "充值", value: "recharge"},
                    {title: "其他操作", value: "other"}
                ]
            };
        },
        methods: {
            init() {
                this.getAllList();
            },
            handleDropdown(name) {
                if (name === "expandOne") {
                    this.expandLevel = 1;
                    this.getAllList();
                } else if (name === "expandTwo") {
                    this.expandLevel = 2;
                    this.getAllList();
                } else if (name === "expandAll") {
                    this.expandLevel = 3;
                    this.getAllList();
                } else if (name === "refresh") {
                    this.getAllList();
                }
            },
            getAllList() {
                this.loading = true;
                this.getRequest("/permission/getAllList").then(res => {
                    this.loading = false;
                    if (res.success === true) {
                        // 仅展开指定级数 默认所有展开
                        let expandLevel = this.expandLevel;
                        res.result.forEach(function (e) {
                            if (expandLevel === 1) {
                                if (e.level === 1) {
                                    e.expand = false;
                                }
                                if (e.children && e.children.length > 0) {
                                    e.children.forEach(function (c) {
                                        if (c.level === 2) {
                                            c.expand = false;
                                        }
                                    });
                                }
                            } else {
                                if (e.children && e.children.length > 0) {
                                    e.children.forEach(function (c) {
                                        if (expandLevel === 2) {
                                            if (c.level === 2) {
                                                c.expand = false;
                                            }
                                        }
                                    });
                                }
                            }
                        });
                        this.data = res.result;
                    }
                });
            },
            selectTree(v) {
                if (v.length > 0) {
                    if (Number(v[0].level) === 1 || Number(v[0].level) === 2) {
                        this.isButton = false;
                        this.isMenu = true;
                    } else {
                        this.isButton = true;
                        this.isMenu = false;
                    }
                    if (Number(v[0].status) === 1) {
                        this.editStatus = true;
                    } else {
                        this.editStatus = false;
                    }
                    // 转换null为""
                    for (let attr in v[0]) {
                        if (v[0][attr] === null) {
                            v[0][attr] = "";
                        }
                    }
                    let str = JSON.stringify(v[0]);
                    let menu = JSON.parse(str);
                    this.menuForm = menu;
                    this.editTitle = menu.title;
                }
            },
            canelEdit() {
                this.isMenu = false;
                this.isButton = false;
                this.$refs.menuForm.resetFields();
                delete this.menuForm.id;
                this.editTitle = "";
            },
            cancelAdd() {
                this.menuModalVisible = false;
            },
            handleReset() {
                this.$refs.menuForm.resetFields();
                this.editStatus = true;
                this.menuForm.status = 1;
            },
            changeEditSwitch(v) {
                if (v) {
                    this.menuForm.status = 1;
                } else {
                    this.menuForm.status = 0;
                }
            },
            submitEdit() {
                this.$refs.menuForm.validate(valid => {
                    if (valid) {
                        if (!this.menuForm.id) {
                            this.$Message.warning("请先点击选择要修改的菜单节点");
                            return;
                        }
                        this.submitLoading = true;
                        if (this.menuForm.sortOrder === null) {
                            this.menuForm.sortOrder = "";
                        }
                        if (this.menuForm.buttonType === null) {
                            this.menuForm.buttonType = "";
                        }
                        if (this.menuForm.type == 1) {
                            this.menuForm.name = "";
                            this.menuForm.icon = "";
                            this.menuForm.component = "";
                        }
                        editPermission(this.menuForm).then(res => {
                            this.submitLoading = false;
                            if (res.success === true) {
                                this.$Message.success("编辑成功");
                                this.init();
                                this.menuModalVisible = false;
                            }
                        });
                    }
                });
            },
            changeAddSwitch(v) {
                if (v) {
                    this.menuFormAdd.status = 1;
                } else {
                    this.menuFormAdd.status = 0;
                }
            },
            submitAdd() {
                this.$refs.menuFormAdd.validate(valid => {
                    if (valid) {
                        this.submitLoading = true;
                        if (this.menuFormAdd.sortOrder === null) {
                            this.menuFormAdd.sortOrder = "";
                        }
                        if (this.menuFormAdd.buttonType === null) {
                            this.menuFormAdd.buttonType = "";
                        }
                        if (this.menuFormAdd.type == 1) {
                            this.menuFormAdd.name = "";
                            this.menuFormAdd.icon = "";
                            this.menuFormAdd.component = "";
                        }
                        addPermission(this.menuFormAdd).then(res => {
                            this.submitLoading = false;
                            if (res.success === true) {
                                this.$Message.success("添加成功");
                                this.init();
                                this.menuModalVisible = false;
                            }
                        });
                    }
                });
            },
            addMenu() {
                if (this.menuForm.id == "" || this.menuForm.id == null) {
                    this.$Message.warning("请先点击选择一个菜单权限节点");
                    return;
                }
                this.parentTitle = this.menuForm.title;
                this.modalTitle = "添加菜单权限(可拖动)";
                this.showParent = true;
                let type = 0;
                if (this.menuForm.level === 1) {
                    type = 0;
                    this.isMenuAdd = true;
                    this.isButtonAdd = false;
                } else if (this.menuForm.level === 2) {
                    type = 1;
                    this.isMenuAdd = false;
                    this.isButtonAdd = true;
                } else if (this.menuForm.level === 3) {
                    this.$Modal.error({
                        title: "抱歉，不能添加啦",
                        content: "仅支持2级菜单目录"
                    });
                    return;
                } else {
                    type = 0;
                    this.isMenuAdd = false;
                    this.isButtonAdd = false;
                }
                this.menuFormAdd = {
                    type: type,
                    parentId: this.menuForm.id,
                    level: Number(this.menuForm.level) + 1,
                    sortOrder: 1,
                    buttonType: "",
                    status: 1
                };
                this.menuModalVisible = true;
            },
            addRootMenu() {
                this.modalTitle = "添加一级菜单(可拖动)";
                this.isMenuAdd = true;
                this.isButtonAdd = false;
                this.showParent = false;
                this.menuFormAdd = {
                    type: 0,
                    level: 1,
                    sortOrder: 1,
                    status: 1
                };
                this.menuModalVisible = true;
            },
            changeSelect(v) {
                this.selectCount = v.length;
                this.selectList = v;
            },
            delAll() {
                if (this.selectCount <= 0) {
                    this.$Message.warning("您还未勾选要删除的数据");
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
                        deletePermission(ids).then(res => {
                            if (res.success === true) {
                                this.$Message.success("删除成功");
                                this.selectList = [];
                                this.selectCount = 0;
                                this.canelEdit();
                                this.init();
                            }
                        });
                    }
                });
            },
            initMeta() {
                let permTypes = this.$route.meta.permTypes;
                if (permTypes !== null && permTypes !== undefined) {
                    this.permTypes = permTypes;
                }
            },
        },
        mounted() {
            this.init();
            this.initMeta();
        }
    };
</script>