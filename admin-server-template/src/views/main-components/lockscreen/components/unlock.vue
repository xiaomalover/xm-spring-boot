<style lang="less">
@import "../styles/unlock.less";
</style>

<template>
    <transition name="show-unlock">
        <div class="unlock-body-con" v-if="showUnlock" @keydown.enter="handleUnlock">
            <div @click="handleClickAvator" class="unlock-avator-con" :style="{marginLeft: avatorLeft}">
                <img class="unlock-avator-img" :src="avatar">
                <div class="unlock-avator-cover">
                    <span><Icon type="md-unlock" :size="30"></Icon></span>
                    <p>解锁</p>
                </div>
            </div>
            <div class="unlock-avator-under-back" :style="{marginLeft: avatorLeft}"></div>
            <div class="unlock-input-con">
                <div class="unlock-input-overflow-con">
                    <div class="unlock-overflow-body" :style="{right: inputLeft}">
                        <input ref="inputEle" v-model="password" class="unlock-input" type="password" placeholder="密码同登录密码" />
                        <button ref="unlockBtn" @mousedown="unlockMousedown" @mouseup="unlockMouseup" @click="handleUnlock" class="unlock-btn"><Icon color="white" type="ios-key"></Icon></button>
                    </div>
                </div>
            </div>
            <div class="unlock-locking-tip-con">已锁定</div>
        </div>
    </transition>
</template>

<script>
import { unlock } from "@/api/index";
import Cookies from "js-cookie";
import {
    getUploadDomain
} from "@/api/index";

export default {
  name: "Unlock",
  data() {
    return {
      avatorLeft: "0px",
      inputLeft: "400px",
      password: "",
      check: null,
      avatar: "",
      imageDomain: "",
    };
  },
  props: {
    showUnlock: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    avatarPath() {
      return localStorage.avatorImgPath;
    }
  },
  mounted() {
    this.init();
  },
  methods: {
    init() {
        let userInfo = JSON.parse(Cookies.get("userInfo"));
        this.username = userInfo.username;
        this.userId = userInfo.id;

        if (userInfo.avatar === "") {
            this.avatar = require('../../../../assets/avatar.png');
        } else {
            this.getImageBase();
            if (userInfo.avatar.indexOf(this.imageDomain) !== -1) {
                this.avatar = userInfo.avatar;
            } else {
                if (userInfo.avatar.indexOf("avatar") === -1) {
                    this.avatar = this.imageDomain + "/" + userInfo.avatar;
                } else {
                    this.avatar = userInfo.avatar;
                }
            }
        }
    },

    getImageBase() {
      if(Cookies.get("imageDomain")) {
          this.imageDomain = Cookies.get("imageDomain");
      } else {
        // 多条件搜索配置列表
        this.loading = true;
        getUploadDomain().then(res => {
          this.loading = false;
          if (res.success === true) {
              this.imageDomain = res.result;
              Cookies.set("imageDomain", this.imageDomain);
          }
        });
      }
    },

    unlock() {
      this.avatorLeft = "0px";
      this.inputLeft = "400px";
      this.password = "";
      Cookies.set("locking", "0");
      this.$emit("on-unlock");
    },
    handleClickAvator() {
      this.avatorLeft = "-180px";
      this.inputLeft = "0px";
      this.$refs.inputEle.focus();
    },
    handleUnlock() {
      if (this.password === "") {
        this.$Message.error("请输入密码");
        return;
      }
      // 将用户输入的密码this.password与数据库用户密码对比
      let flag = false;
      unlock({ password: this.password }).then(
        res => {
          if (res.success === true) {
            this.unlock();
          }
        }
      );
    },
    unlockMousedown() {
      this.$refs.unlockBtn.className = "unlock-btn click-unlock-btn";
    },
    unlockMouseup() {
      this.$refs.unlockBtn.className = "unlock-btn";
    }
  }
};
</script>
