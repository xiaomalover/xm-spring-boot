(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-437767ab"],{"21fa":function(e,t,i){},"2fdd":function(e,t,i){"use strict";i("21fa")},3441:function(e,t,i){"use strict";var s=i("e99b"),l=i("3250"),n=i("8078"),o=i("0926"),r=[].sort,a=[1,2,3];s(s.P+s.F*(o((function(){a.sort(void 0)}))||!o((function(){a.sort(null)}))||!i("95b6")(r)),"Array",{sort:function(e){return void 0===e?r.call(n(this)):r.call(n(this),l(e))}})},"37c5":function(e,t,i){"use strict";i.r(t);var s=function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"search"},[i("Row",[i("Col",[i("Card",[i("Row",{staticClass:"operation"},[e.permTypes.length>0?i("Button",{directives:[{name:"has",rawName:"v-has",value:"add",expression:"'add'"}],attrs:{type:"primary",icon:"md-add"},on:{click:e.addRole}},[e._v("添加角色")]):e._e(),e.permTypes.length>0?i("Button",{directives:[{name:"has",rawName:"v-has",value:"delete",expression:"'delete'"}],attrs:{icon:"md-trash"},on:{click:e.delAll}},[e._v("批量删除")]):e._e(),i("Button",{attrs:{icon:"md-refresh"},on:{click:e.init}},[e._v("刷新")])],1),i("Row",[i("Alert",{attrs:{"show-icon":""}},[e._v("\n                        已选择 "),i("span",{staticClass:"select-count"},[e._v(e._s(e.selectCount))]),e._v(" 项\n                        "),i("a",{staticClass:"select-clear",on:{click:e.clearSelectAll}},[e._v("清空")])])],1),i("Row",[i("Table",{ref:"table",attrs:{loading:e.loading,border:"",columns:e.columns,data:e.data,sortable:"custom"},on:{"on-sort-change":e.changeSort,"on-selection-change":e.changeSelect}})],1),i("Row",{staticClass:"page",attrs:{type:"flex",justify:"end"}},[i("Page",{attrs:{current:e.pageNumber,total:e.total,"page-size":e.pageSize,"page-size-opts":[10,20,50],size:"small","show-total":"","show-elevator":"","show-sizer":""},on:{"on-change":e.changePage,"on-page-size-change":e.changePageSize}})],1)],1)],1)],1),i("Modal",{attrs:{title:e.modalTitle,"mask-closable":!1,width:500},model:{value:e.roleModalVisible,callback:function(t){e.roleModalVisible=t},expression:"roleModalVisible"}},[i("Form",{ref:"roleForm",attrs:{model:e.roleForm,"label-width":80,rules:e.roleFormValidate}},[i("FormItem",{attrs:{label:"角色名称",prop:"name"}},[i("Input",{attrs:{placeholder:"按照Spring Security约定建议以‘ROLE_’开头"},model:{value:e.roleForm.name,callback:function(t){e.$set(e.roleForm,"name",t)},expression:"roleForm.name"}})],1),i("FormItem",{attrs:{label:"备注",prop:"description"}},[i("Input",{model:{value:e.roleForm.description,callback:function(t){e.$set(e.roleForm,"description",t)},expression:"roleForm.description"}})],1)],1),i("div",{attrs:{slot:"footer"},slot:"footer"},[i("Button",{attrs:{type:"text"},on:{click:e.cancelRole}},[e._v("取消")]),i("Button",{attrs:{type:"primary",loading:e.submitLoading},on:{click:e.submitRole}},[e._v("提交")])],1)],1),i("Modal",{attrs:{title:"分配权限(点击选择)","mask-closable":!1,fullscreen:e.fullscreen,width:500},model:{value:e.permModalVisible,callback:function(t){e.permModalVisible=t},expression:"permModalVisible"}},[i("div",{attrs:{slot:"header"},slot:"header"},[i("div",{staticStyle:{float:"left",height:"30px","line-height":"30px"}},[i("h3",[e._v("分配权限(点击选择)")])]),i("div",{staticStyle:{float:"right","margin-right":"30px"}},[i("span",{on:{click:e.fullscreenChange}},[e.fullscreen?i("i",{staticClass:"ivu-icon ivu-icon-ios-contract",staticStyle:{"font-size":"20px"}}):i("i",{staticClass:"ivu-icon ivu-icon-ios-expand",staticStyle:{"font-size":"20px"}})])]),i("div",{staticStyle:{clear:"both"}})]),i("Tree",{ref:"tree",attrs:{data:e.permData,multiple:""}}),e.treeLoading?i("Spin",{attrs:{size:"large"}}):e._e(),i("div",{attrs:{slot:"footer"},slot:"footer"},[i("Button",{attrs:{type:"text"},on:{click:e.cancelPermEdit}},[e._v("取消")]),i("Button",{on:{click:e.selectTreeAll}},[e._v("全选/反选")]),i("Button",{attrs:{type:"primary",loading:e.submitPermLoading},on:{click:e.submitPermEdit}},[e._v("提交")])],1)],1)],1)},l=[],n=(i("a450"),i("1bc7"),i("3441"),i("aa18"),i("982e"),i("365c")),o=i("23d5"),r=i.n(o),a={name:"role-manage",data:function(){var e=this;return{loading:!0,treeLoading:!0,submitPermLoading:!1,sortColumn:"createdAt",sortType:"desc",modalType:0,roleModalVisible:!1,permModalVisible:!1,modalTitle:"",fullscreen:!1,permTypes:[],roleForm:{description:"",name:""},roleFormValidate:{name:[{required:!0,message:"角色名称不能为空",trigger:"blur"}]},submitLoading:!1,selectList:[],selectCount:0,columns:[{type:"selection",width:60,align:"center",fixed:"left"},{title:"角色名称",key:"name",minWidth:150},{title:"备注",key:"description",minWidth:200},{title:"创建时间",key:"createdAt",minWidth:150,sortable:!0,sortType:"desc",render:function(e,t){return e("div",r()(1e3*t.row.createdAt).format("YYYY-MM-DD HH:mm:ss"))}},{title:"更新时间",key:"updatedAt",minWidth:150,sortable:!0,sortType:"desc",render:function(e,t){return e("div",r()(1e3*t.row.updatedAt).format("YYYY-MM-DD HH:mm:ss"))}},{title:"是否设置为注册用户默认角色",key:"defaultRole",align:"center",minWidth:200,render:function(t,i){if(e.permTypes.includes("setDefault"))return i.row.defaultRole?t("div",[t("Button",{props:{type:"success",size:"small"},style:{marginRight:"5px"},on:{click:function(){e.cancelDefault(i.row)}}},"取消默认")]):t("div",[t("Button",{props:{type:"info",size:"small"},style:{marginRight:"5px"},on:{click:function(){e.setDefault(i.row)}}},"设为默认")])}},{title:"操作",key:"action",align:"center",fixed:"right",width:220,render:function(t,i){var s,l,n;return e.permTypes.includes("edit")&&(s=t("Button",{props:{type:"primary",size:"small"},style:{marginRight:"5px"},on:{click:function(){e.edit(i.row)}}},"编辑")),e.permTypes.includes("editPerm")&&(l=t("Button",{props:{type:"warning",size:"small"},style:{marginRight:"5px"},on:{click:function(){e.editPerm(i.row)}}},"分配权限")),e.permTypes.includes("delete")&&(n=t("Button",{props:{type:"error",size:"small"},on:{click:function(){e.remove(i.row)}}},"删除")),t("div",[l,s,n])}}],data:[],pageNumber:1,pageSize:10,total:0,permData:[],editRolePermId:"",selectPermList:[],selectAllFlag:!1}},methods:{init:function(){this.getRoleList(),this.getPermList(),this.initMeta()},changePage:function(e){this.pageNumber=e,this.getRoleList(),this.clearSelectAll()},changePageSize:function(e){this.pageSize=e,this.getRoleList()},changeSort:function(e){this.sortColumn=e.key,this.sortType=e.order,"normal"===e.order&&(this.sortType=""),this.getRoleList()},getRoleList:function(){var e=this;this.loading=!0;var t={pageNumber:this.pageNumber,pageSize:this.pageSize,sort:this.sortColumn,order:this.sort};Object(n["Q"])(t).then((function(t){e.loading=!1,!0===t.success&&(e.data=t.result.records,e.total=t.result.total)}))},getPermList:function(){var e=this;this.treeLoading=!0,Object(n["I"])().then((function(t){e.treeLoading=!1,!0===t.success&&(e.deleteDisableNode(t.result),e.permData=t.result)}))},deleteDisableNode:function(e){var t=this;e.forEach((function(e){0===e.status&&(e.title="[已禁用] "+e.title,e.disabled=!0),e.children&&e.children.length>0&&t.deleteDisableNode(e.children)}))},cancelRole:function(){this.roleModalVisible=!1},submitRole:function(){var e=this;this.$refs.roleForm.validate((function(t){t&&(0===e.modalType?(e.submitLoading=!0,Object(n["f"])(e.roleForm).then((function(t){e.submitLoading=!1,!0===t.success&&(e.$Message.success("操作成功"),e.getRoleList(),e.roleModalVisible=!1)}))):(e.submitLoading=!0,Object(n["B"])(e.roleForm).then((function(t){e.submitLoading=!1,!0===t.success&&(e.$Message.success("操作成功"),e.getRoleList(),e.roleModalVisible=!1)}))))}))},addRole:function(){this.modalType=0,this.modalTitle="添加角色",this.$refs.roleForm.resetFields(),delete this.roleForm.id,this.roleModalVisible=!0},edit:function(e){for(var t in this.modalType=1,this.modalTitle="编辑角色",e)null===e[t]&&(e[t]="");var i=JSON.stringify(e),s=JSON.parse(i);this.roleForm=s,this.roleModalVisible=!0},remove:function(e){var t=this;this.$Modal.confirm({title:"确认删除",content:"您确认要删除角色 "+e.name+" ?",onOk:function(){Object(n["q"])(e.id).then((function(e){!0===e.success&&(t.$Message.success("删除成功"),t.getRoleList())}))}})},setDefault:function(e){var t=this;this.$Modal.confirm({title:"确认设置",content:"您确认要设置所选的 "+e.name+" 为注册用户默认角色?",onOk:function(){var i={id:e.id,isDefault:!0};Object(n["bb"])(i).then((function(e){!0===e.success&&(t.$Message.success("操作成功"),t.getRoleList())}))}})},cancelDefault:function(e){var t=this;this.$Modal.confirm({title:"确认取消",content:"您确认要取消所选的 "+e.name+" 角色为默认?",onOk:function(){var i={id:e.id,isDefault:!1};Object(n["bb"])(i).then((function(e){!0===e.success&&(t.$Message.success("操作成功"),t.getRoleList())}))}})},clearSelectAll:function(){this.$refs.table.selectAll(!1)},changeSelect:function(e){this.selectList=e,this.selectCount=e.length},delAll:function(){var e=this;this.selectCount<=0?this.$Message.warning("您还未选择要删除的数据"):this.$Modal.confirm({title:"确认删除",content:"您确认要删除所选的 "+this.selectCount+" 条数据?",onOk:function(){var t="";e.selectList.forEach((function(e){t+=e.id+","})),t=t.substring(0,t.length-1),Object(n["q"])(t).then((function(t){!0===t.success&&(e.$Message.success("删除成功"),e.clearSelectAll(),e.getRoleList())}))}})},editPerm:function(e){this.editRolePermId=e.id;var t=e.permissions;this.checkPermTree(this.permData,t),this.permModalVisible=!0},checkPermTree:function(e,t){var i=this;e.forEach((function(e){i.hasPerm(e,t)?e.selected=!0:e.selected=!1,e.children&&e.children.length>0&&i.checkPermTree(e.children,t)}))},hasPerm:function(e,t){if(!t)return!1;for(var i=!1,s=0;s<t.length;s++)if(e.id===t[s].id){i=!0;break}return!!i},selectTreeAll:function(){this.selectAllFlag=!this.selectAllFlag;var e=this.selectAllFlag;this.selectedTreeAll(this.permData,e)},selectedTreeAll:function(e,t){var i=this;e.forEach((function(e){e.selected=t,e.children&&e.children.length>0&&i.selectedTreeAll(e.children,t)}))},submitPermEdit:function(){var e=this;this.submitPermLoading=!0;var t="",i=this.$refs.tree.getSelectedNodes();i.forEach((function(e){t+=e.id+","})),t=t.substring(0,t.length-1),Object(n["C"])(this.editRolePermId,{permIds:t}).then((function(t){e.submitPermLoading=!1,!0===t.success&&(e.$Message.success("操作成功"),e.getRoleList(),e.permModalVisible=!1)}))},cancelPermEdit:function(){this.permModalVisible=!1},initMeta:function(){var e=this.$route.meta.permTypes;null!==e&&void 0!==e&&(this.permTypes=e)},fullscreenChange:function(){this.fullscreen=!this.fullscreen}},mounted:function(){this.init()}},c=a,d=(i("2fdd"),i("cba8")),u=Object(d["a"])(c,s,l,!1,null,null,null);t["default"]=u.exports},"95b6":function(e,t,i){"use strict";var s=i("0926");e.exports=function(e,t){return!!e&&s((function(){t?e.call(null,(function(){}),1):e.call(null)}))}}}]);