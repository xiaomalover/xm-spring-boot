<style lang="less">
    @import "./logManage.less";
</style>
<template>
    <div class="search">
        <Row>
            <Col>
                <Card>
                    <Form inline :label-width="70" class="search-form">
                        <Form-item label="搜索日志">
                            <Input type="text" v-model="searchKey" clearable placeholder="请输入搜索关键词"
                                   style="width: 200px"/>
                        </Form-item>
                        <Form-item label="创建时间">
                            <DatePicker type="daterange" v-model="selectDate" format="yyyy-MM-dd" clearable
                                        @on-change="selectDateRange" placeholder="选择起始时间"
                                        style="width: 200px"></DatePicker>
                        </Form-item>
                        <Form-item style="margin-left:-35px;" class="br">
                            <Button @click="getLogList" type="primary" icon="ios-search">搜索</Button>
                            <Button @click="handleReset">重置</Button>
                        </Form-item>
                    </Form>
                    <Row class="operation">
                        <Button @click="clearAll" type="error" icon="md-trash" v-if="permTypes.length > 0" v-has="'delete'">清空全部</Button>
                        <Button @click="delAll" icon="md-trash" v-if="permTypes.length > 0" v-has="'delete'">批量删除</Button>
                        <Button @click="getLogList" icon="md-refresh">刷新</Button>
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
    </div>
</template>

<script>
    import {
        getLogListData,
        getSearchLogData,
        deleteLog,
        deleteAllLog
    } from "@/api/index";
    import moment from 'moment';

    export default {
        name: "role-manage",
        data() {
            return {
                loading: true,
                selectList: [],
                selectCount: 0,
                selectDate: null,
                searchKey: "",
                sortColumn: "createdAt",
                sortType: "desc",
                permTypes: [],
                columns: [
                    {
                        type: "selection",
                        minWidth: 60,
                        align: "center",
                        fixed: "left"
                    },
                    {
                        title: "操作名称",
                        key: "name",
                        minWidth: 110,
                        sortable: true,
                    },
                    {
                        title: "请求类型",
                        key: "requestType",
                        minWidth: 120,
                        align: "center",
                        sortable: true,
                        filters: [
                            {
                                label: "GET",
                                value: "GET"
                            },
                            {
                                label: "POST",
                                value: "POST"
                            },
                            {
                                label: "PUT",
                                value: "PUT"
                            },
                            {
                                label: "DELETE",
                                value: "DELETE"
                            }
                        ],
                        filterMultiple: false,
                        filterMethod(value, row) {
                            if (value === "GET") {
                                return row.requestType === "GET";
                            } else if (value === "POST") {
                                return row.requestType === "POST";
                            } else if (value === "PUT") {
                                return row.requestType === "PUT";
                            } else if (value === "DELETE") {
                                return row.requestType === "DELETE";
                            }
                        }
                    },
                    {
                        title: "请求路径",
                        minWidth: 150,
                        key: "requestUrl"
                    },
                    {
                        title: "请求参数",
                        minWidth: 200,
                        key: "requestParam",
                        tooltip: true
                    },
                    {
                        title: "登录用户",
                        key: "username",
                        minWidth: 150,
                        sortable: true
                    },
                    {
                        title: "IP",
                        key: "ip",
                        minWidth: 120,
                        sortable: true
                    },
                    {
                        title: "IP信息",
                        key: "ipInfo",
                        minWidth: 100,
                        sortable: true,
                        render: (h, params) => {
                            let re = "";
                            if (params.row.ipInfo) {
                                return h("div", params.row.ipInfo);
                            } else {
                                return h("div", "-");
                            }
                        },
                    },
                    {
                        title: "耗时(毫秒)",
                        key: "costTime",
                        minWidth: 150,
                        sortable: true,
                        align: "center",
                        filters: [
                            {
                                label: "≤1000毫秒",
                                value: 0
                            },
                            {
                                label: ">1000毫秒",
                                value: 1
                            }
                        ],
                        filterMultiple: false,
                        filterMethod(value, row) {
                            if (value === 0) {
                                return row.costTime <= 1000;
                            } else if (value === 1) {
                                return row.costTime > 1000;
                            }
                        }
                    },
                    {
                        title: "创建时间",
                        key: "createdAt",
                        sortable: true,
                        sortType: "desc",
                        minWidth: 150,
                        render: (h, params) => {
                            return h("div", moment(params.row.createdAt * 1000).format('YYYY-MM-DD HH:mm:ss'));
                        }
                    },
                    {
                        title: "操作",
                        key: "action",
                        minWidth: 100,
                        align: "center",
                        fixed: "right",
                        render: (h, params) => {
                            if (this.permTypes.includes("delete")) {
                                return h("div", [
                                    h(
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
                                    )
                                ]);
                            }
                        }
                    }
                ],
                data: [],
                pageNumber: 1,
                pageSize: 10,
                total: 0,
                startDate: "",
                endDate: ""
            };
        },
        methods: {
            init() {
                this.accessToken = {
                    accessToken: this.getStore("accessToken")
                };
                this.getLogList();
            },
            changePage(v) {
                this.pageNumber = v;
                this.getLogList();
                this.clearSelectAll();
            },
            changePageSize(v) {
                this.pageSize = v;
                this.getLogList();
            },
            selectDateRange(v) {
                if (v) {
                    this.startDate = v[0];
                    this.endDate = v[1];
                }
            },
            getLogList() {
                this.loading = true;
                let params = "";
                // 后端可配置使用数据库或Elasticsearch搜索 这里分开了2个请求
                if (this.searchKey === "" && this.startDate === "") {
                    params = {
                        pageNumber: this.pageNumber,
                        pageSize: this.pageSize,
                        sort: this.sortColumn,
                        order: this.sortType
                    };
                    getLogListData(params).then(res => {
                        this.loading = false;
                        if (res.success === true) {
                            this.data = res.result.records;
                            this.total = res.result.total;
                        }
                    });
                } else {
                    params = {
                        key: this.searchKey,
                        pageNumber: this.pageNumber,
                        pageSize: this.pageSize,
                        sort: this.sortColumn,
                        order: this.sortType,
                        startDate: this.startDate,
                        endDate: this.endDate
                    };
                    getSearchLogData(params).then(res => {
                        this.loading = false;
                        if (res.success === true) {
                            this.data = res.result.records;
                            this.total = res.result.total;
                        }
                    });
                }
            },
            handleReset() {
                this.searchKey = "";
                this.selectDate = null;
                this.startDate = "";
                this.endDate = "";
                this.getLogList();
            },
            remove(v) {
                this.$Modal.confirm({
                    title: "确认删除",
                    content: "您确认要删除该条数据?",
                    onOk: () => {
                        deleteLog(v.id).then(res => {
                            if (res.success === true) {
                                this.$Message.success("删除成功");
                                this.init();
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
            changeSort(e) {
                this.sortColumn = e.key;
                this.sortType = e.order;
                if (e.order === "normal") {
                    this.sortType = "";
                }
                this.getLogList();
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
                        deleteLog(ids).then(res => {
                            if (res.success === true) {
                                this.$Message.success("删除成功");
                                this.clearSelectAll();
                                this.init();
                            }
                        });
                    }
                });
            },
            clearAll() {
                this.$Modal.confirm({
                    title: "请谨慎进行此操作！",
                    content: "您确认要彻底清空删除所有数据?",
                    onOk: () => {
                        this.loading = true;
                        let ids = "";
                        this.selectList.forEach(function (e) {
                            ids += e.id + ",";
                        });
                        ids = ids.substring(0, ids.length - 1);
                        deleteAllLog().then(res => {
                            this.loading = false;
                            if (res.success === true) {
                                this.$Message.success("清空日志成功");
                                this.clearSelectAll();
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
