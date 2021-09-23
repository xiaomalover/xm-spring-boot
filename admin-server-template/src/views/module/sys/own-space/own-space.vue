<style lang="less">
    @import "own-space.less";
</style>

<template>
    <div class="own-space">
        <Card>
            <Tabs>
                <TabPane label="基本信息" name="info">
                    <Form
                            ref="userForm"
                            :model="userForm"
                            :label-width="100"
                            label-position="right"
                    >
                        <FormItem label="用户头像：">
                            <span class="ivu-avatar ivu-avatar-circle ivu-avatar-large ivu-avatar-image" style="background: rgb(97, 159, 231); margin-left: 10px;">
                                <img :src="userForm.avatar" @click="changeAvatar">
                            </span>
                        </FormItem>

                        <Modal title="修改头像" v-model="avatarModalVisible" :mask-closable='false' :width="650"
                               :styles="{top: '30px'}" @on-ok="downCustom">
                            <div class="cropper-content">
                                <div class="cropper">
                                    <vueCropper ref="cropper" :img="option.img" :outputSize="option.size"
                                                :outputType="option.outputType" :info="true" :full="option.full"
                                                :canMove="option.canMove" :canMoveBox="option.canMoveBox"
                                                :original="option.original" :autoCrop="option.autoCrop"
                                                :autoCropWidth="option.autoCropWidth"
                                                :autoCropHeight="option.autoCropHeight" :fixedBox="option.fixedBox"
                                                @realTime="realTime" @imgLoad="imgLoad"></vueCropper>
                                </div>
                                <div class="show-preview" :style="{'width': previews.w + 'px', 'height': previews.h + 'px',  'overflow': 'hidden', 'margin': '5px'}">
                                    <div :style="previews.div" class="preview">
                                        <img :src="previews.url" :style="previews.img">
                                    </div>
                                </div>
                            </div>

                            <div class="footer-btn">
                                <div class="scope-btn">
                                    <label class="btn" for="uploads">选择图片</label>
                                    <input type="file" id="uploads" style="position:absolute; clip:rect(0 0 0 0);" accept="image/png, image/jpeg, image/gif, image/jpg" @change="uploadImg($event, 1)">
                                    <Button @click="changeScale(1)" style="font-weight: 600;"><Icon type="md-add" /></Button>
                                    <Button @click="changeScale(-1)" style="font-weight: 600;"><Icon type="md-remove" /></Button>
                                    <Button @click="rotateLeft"><span style="font-weight: 600;">↺</span></Button>
                                    <Button @click="rotateRight"><span style="font-weight: 600;">↻</span></Button>
                                </div>
                                <div class="upload-btn"></div>
                            </div>
                        </Modal>

                        <FormItem label="用户账号：">
                            <span>{{userForm.username}}</span>
                        </FormItem>
                        <FormItem label="性别：">
                            <RadioGroup v-model="userForm.sex">
                                <Radio :label="1">男</Radio>
                                <Radio :label="0">女</Radio>
                            </RadioGroup>
                        </FormItem>
                        <FormItem label="手机号：">
                            <span>{{userForm.mobile}}</span>
                        </FormItem>
                        <FormItem label="邮箱：">
                            <span>{{userForm.email}}</span>
                        </FormItem>
                        <FormItem label="地址：">
                            <al-cascader v-model="userForm.addressArray" @on-change="changeAddress" data-type="code"
                                         level="2" style="width:250px"/>
                        </FormItem>
                        <FormItem label="所属部门：">
                            <span>{{ userForm.departmentTitle }}</span>
                        </FormItem>
                        <FormItem label="用户类型：">
                            <span>{{ userForm.typeTxt }}</span>
                        </FormItem>
                        <FormItem label="创建时间：">
                            <span>{{ userForm.createdAt }}</span>
                        </FormItem>
                        <FormItem>
                            <Button type="primary" style="width: 100px;margin-right:5px" :loading="saveLoading"
                                    @click="saveEdit">保存
                            </Button>
                            <Button @click="cancelEditUserInfo">取消</Button>
                        </FormItem>
                    </Form>
                </TabPane>
            </Tabs>

        </Card>
    </div>
</template>

<script>
    import {
        userInfoEdit,
        uploadCommon,
    } from "@/api/index";
    import Cookies from "js-cookie";
    import { VueCropper }  from 'vue-cropper';

    export default {
        name: "ownspace_index",
        data() {
            return {
                accessToken: {},
                userForm: {
                    id: "",
                    avatar: "",
                    username: "",
                    sex: "",
                    mobile: "",
                    email: "",
                    status: "",
                    type: "",
                    typeTxt: "",
                    address: "",
                    addressArray: []
                },
                codeError: "",
                initPhone: "",
                initEmail: "",
                uid: "", // 登录用户的userId
                saveLoading: false,
                savePassLoading: false,
                oldPassError: "",

                avatarModalVisible: false,
                crap: false,
                previews: {},
                option: {
                    img: '',
                    size: 1,
                    full: false, // 输出原图比例截图 props名full
                    outputType: 'png',
                    canMove: true,
                    original: false,
                    canMoveBox: true,
                    autoCrop: true,
                    autoCropWidth: 200,
                    autoCropHeight: 200,
                    fixedBox: true
                },
                downImg: '#',
            };
        },

        components: {VueCropper},

        methods: {
            init() {
                this.accessToken = {
                    accessToken: this.getStore("accessToken")
                };
                let v = JSON.parse(Cookies.get("userInfo"));
                // 转换null为""
                for (let attr in v) {
                    if (v[attr] === null) {
                        v[attr] = "";
                    }
                }
                let str = JSON.stringify(v);
                let userInfo = JSON.parse(str);
                userInfo.addressArray = [];
                this.userForm = userInfo;
                if (this.userForm.avatar === "") {
                    this.userForm.avatar = require('../../../../assets/avatar.png');
                } else {
                    this.userForm.avatar = userInfo.avatar;
                }
                this.initPhone = userInfo.mobile;
                this.initEmail = userInfo.email;
                if (userInfo.address !== null && userInfo.address !== "") {
                    this.userForm.address = userInfo.address;
                    this.userForm.addressArray = JSON.parse(userInfo.address);
                }
                if (this.userForm.type === 0) {
                    this.userForm.typeTxt = "普通用户";
                } else if (this.userForm.type === 1) {
                    this.userForm.typeTxt = "管理员";
                }
            },
            cancelEditUserInfo() {
                this.$store.commit("removeTag", "ownspace_index");
                localStorage.pageOpenedList = JSON.stringify(
                    this.$store.state.app.pageOpenedList
                );
                let lastPageName = "";
                if (this.$store.state.app.pageOpenedList.length > 1) {
                    lastPageName = this.$store.state.app.pageOpenedList[1].name;
                } else {
                    lastPageName = this.$store.state.app.pageOpenedList[0].name;
                }
                this.$router.push({
                    name: lastPageName
                });
            },
            saveEdit() {
                this.saveLoading = true;
                let params = this.userForm;
                delete params.nickName;
                delete params.description;
                userInfoEdit(params).then(res => {
                    this.saveLoading = false;
                    if (res.success === true) {
                        this.$Message.success("保存成功");
                        // 更新用户信息
                        Cookies.set("userInfo", this.userForm);
                    }
                });
            },
            changeAddress() {
                this.userForm.address = JSON.stringify(this.userForm.addressArray);
            },


            downCustom() {
                this.down('blob');
            },
            changeAvatar() {
                this.avatarModalVisible = true;
            },

            changeScale(num) {
                num = num || 1
                this.$refs.cropper.changeScale(num)
            },

            rotateLeft() {
                this.$refs.cropper.rotateLeft()
            },

            rotateRight() {
                this.$refs.cropper.rotateRight()
            },

            // 实时预览函数
            realTime(data) {
                this.previews = data
            },

            down(type) {
                if (type === 'blob') {
                    this.$refs.cropper.getCropBlob(data => {
                        let mime = require('mime-types');
                        let fileExtension = mime.extension(data.type);
                        let files = new window.File([data], "avatar" + new Date().getTime() + "." + fileExtension, {type: data.type});
                        let formData = new FormData();
                        formData.append("file", files);
                        formData.append("folder", "adminAvatar");
                        uploadCommon(formData).then(res => {
                            if (res.success === true) {
                                this.userForm.avatar = res.result.url;
                            }
                        });
                    })
                } else {
                    this.$refs.cropper.getCropData(data => {
                        this.userForm.avatar = data;
                    })
                }
            },

            uploadImg(e, num) {
                //上传图片
                // this.option.img
                var file = e.target.files[0]
                if (!/\.(gif|jpg|jpeg|png|bmp|GIF|JPG|PNG)$/.test(e.target.value)) {
                    this.$Message.error('图片类型必须是.gif,jpeg,jpg,png,bmp中的一种');
                    return false
                }
                var reader = new FileReader()
                reader.onload = e => {
                    let data
                    if (typeof e.target.result === 'object') {
                        // 把Array Buffer转化为blob 如果是base64不需要
                        data = window.URL.createObjectURL(new Blob([e.target.result]))
                    } else {
                        data = e.target.result
                    }
                    if (num === 1) {
                        this.option.img = data
                    } else if (num === 2) {
                        this.example2.img = data
                    }
                }
                // 转化为base64
                reader.readAsDataURL(file)
            },

            imgLoad(msg) {
            },
        },
        mounted() {
            this.init();
        }
    };
</script>
