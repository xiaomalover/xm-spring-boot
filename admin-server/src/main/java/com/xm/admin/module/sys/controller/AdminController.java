package com.xm.admin.module.sys.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.xm.admin.common.annotation.SystemLog;
import com.xm.admin.common.constant.CommonConstant;
import com.xm.admin.common.handler.PermissionEditor;
import com.xm.admin.common.handler.RolesEditor;
import com.xm.admin.module.storage.service.IStorage;
import com.xm.admin.module.storage.service.StorageFactory;
import com.xm.admin.module.sys.entity.*;
import com.xm.admin.module.sys.service.IAdminService;
import com.xm.admin.module.sys.service.IDepartmentService;
import com.xm.admin.module.sys.service.IRoleService;
import com.xm.admin.module.sys.service.IUserRoleService;
import com.xm.common.enums.CommonStatus;
import com.xm.common.utils.CommonPageUtil;
import com.xm.common.utils.ResultUtil;
import com.xm.common.vo.ExtraVo;
import com.xm.common.vo.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author xiaomalover <xiaomalover@gmail.com>
 * @since 2019-03-06
 */
@Slf4j
@RestController
@RequestMapping("/user")
@CacheConfig(cacheNames = "admin")
@Transactional
public class AdminController {

    private final IAdminService adminService;

    private final IRoleService roleService;

    private final IDepartmentService departmentService;

    private final IUserRoleService iUserRoleService;

    private final IUserRoleService userRoleService;

    private final StringRedisTemplate redisTemplate;

    private final IStorage storage;

    public AdminController(
            IAdminService adminService,
            IRoleService roleService,
            IDepartmentService departmentService,
            IUserRoleService iUserRoleService,
            IUserRoleService userRoleService,
            StringRedisTemplate redisTemplate,
            StorageFactory storageFactory,
            @Value("${storage.type}") String storageType
    ) {
        this.adminService = adminService;
        this.roleService = roleService;
        this.departmentService = departmentService;
        this.iUserRoleService = iUserRoleService;
        this.userRoleService = userRoleService;
        this.redisTemplate = redisTemplate;
        this.storage = storageFactory.getStorage(storageType + "Impl");
    }

    @PostMapping("/regist")
    public Result<Object> regist(@ModelAttribute Admin u,
                                 @RequestParam String verify,
                                 @RequestParam String captchaId
    ) {

        if (StrUtil.isBlank(verify) || StrUtil.isBlank(u.getUsername())
                || StrUtil.isBlank(u.getPassword())) {
            return new ResultUtil<>().error("缺少必需表单字段");
        }

        //验证码
        String code = redisTemplate.opsForValue().get(captchaId);
        if (StrUtil.isBlank(code)) {
            return new ResultUtil<>().error("验证码已过期，请重新获取");
        }

        if (!verify.toLowerCase().equals(code.toLowerCase())) {
            log.error("注册失败，验证码错误：code:" + verify + ",redisCode:" + code.toLowerCase());
            return new ResultUtil<>().error("验证码输入错误");
        }

        if (!ObjectUtils.isEmpty(adminService.findUserDetailInfo(u.getUsername()))) {
            return new ResultUtil<>().error("该用户名已被注册");
        }
        //删除缓存
        redisTemplate.delete("admin::" + u.getUsername());

        String encryptPass = new BCryptPasswordEncoder().encode(u.getPassword());
        u.setPassword(encryptPass);
        u.setType(CommonConstant.USER_TYPE_NORMAL);
        Boolean suc = adminService.save(u);
        if (!suc) {
            return new ResultUtil<>().error("注册失败");
        }
        // 默认角色
        List<Role> roleList = roleService.list(new QueryWrapper<Role>().eq("default_role", true));
        if (!ObjectUtils.isEmpty(roleList)) {
            for (Role role : roleList) {
                AdminRole ur = new AdminRole();
                ur.setUserId(u.getId());
                ur.setRoleId(role.getId());
                iUserRoleService.save(ur);
            }
        }

        return new ResultUtil<>().success(u);
    }

    @GetMapping("/info")
    public Result<Admin> getUserInfo() {

        UserDetails user = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Admin u = adminService.findUserDetailInfo(user.getUsername());
        // 清除持久上下文环境 避免后面语句导致持久化
        u.setPassword(null);
        return new ResultUtil<Admin>().success(u);
    }

    @PostMapping("/unlock")
    public Result<Object> unLock(@RequestParam String password) {

        UserDetails user = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Admin u = adminService.findUserDetailInfo(user.getUsername());
        if (!new BCryptPasswordEncoder().matches(password, u.getPassword())) {
            return new ResultUtil<>().error("密码不正确");
        }
        return new ResultUtil<>().success(null);
    }

    @PostMapping("/edit")
    @CacheEvict(key = "#u.username")
    public Result<Object> editOwn(@ModelAttribute Admin u) {

        Admin old = adminService.getById(u.getId());
        u.setUsername(old.getUsername());
        u.setPassword(old.getPassword());
        u.setAvatar(u.getAvatar());
        boolean suc = adminService.updateById(u);
        if (!suc) {
            return new ResultUtil<>().error("修改失败");
        }
        return new ResultUtil<>().success("修改成功");
    }

    /**
     * @param u     用户
     * @param roles 角色列表
     * @return 修改结果
     */
    @PostMapping("/admin/edit")
    @CacheEvict(key = "#u.username")
    public Result<Object> edit(@ModelAttribute Admin u,
                               @RequestParam(required = false) String[] roles) {

        Admin old = adminService.getById(u.getId());
        //所修改了用户名
        if (!old.getUsername().equals(u.getUsername())) {
            //若修改用户名删除原用户名缓存
            redisTemplate.delete("admin::" + old.getUsername());
            //判断新用户名是否存在
            if (!ObjectUtils.isEmpty(adminService.findUserDetailInfo(u.getUsername()))) {
                return new ResultUtil<>().error("该用户名已被存在");
            }
            //删除缓存
            redisTemplate.delete("admin::" + u.getUsername());
        }

        u.setPassword(old.getPassword());
        boolean sec = adminService.updateById(u);
        if (!sec) {
            return new ResultUtil<>().error("修改失败");
        }
        //删除该用户角色

        userRoleService.remove(new QueryWrapper<AdminRole>().eq("user_id", u.getId()));
        if (roles != null && roles.length > 0) {
            //新角色
            for (String roleId : roles) {
                AdminRole ur = new AdminRole();
                ur.setRoleId(roleId);
                ur.setUserId(u.getId());
                userRoleService.save(ur);
            }
        }
        //手动删除缓存
        redisTemplate.delete("adminRole::" + u.getId());
        return new ResultUtil<>().success("修改成功");
    }

    /**
     * @param id       主键
     * @param password 密码
     * @param newPass  新密码
     * @return 结果
     */
    @PostMapping("/modifyPass")
    public Result<Object> modifyPass(@RequestParam String id, @RequestParam String password, @RequestParam String newPass) {

        Admin old = adminService.getById(id);

        if (!new BCryptPasswordEncoder().matches(password, old.getPassword())) {
            return new ResultUtil<>().error("旧密码不正确");
        }

        String newEncryptPass = new BCryptPasswordEncoder().encode(newPass);
        old.setPassword(newEncryptPass);
        boolean sec = adminService.updateById(old);
        if (!sec) {
            return new ResultUtil<>().error("修改失败");
        }

        //手动更新缓存
        redisTemplate.delete("admin::" + old.getUsername());

        return new ResultUtil<>().success(old);
    }

    @GetMapping("/getByCondition")
    public Result<IPage<Admin>> getByCondition(@ModelAttribute Admin user, @ModelAttribute ExtraVo extraVo) {

        IPage<Admin> page = new CommonPageUtil<Admin>().initIPage(extraVo);

        QueryWrapper<Admin> adminQueryWrapper = new QueryWrapper<>();

        //模糊搜素
        if (StrUtil.isNotBlank(user.getUsername())) {
            adminQueryWrapper.like("username", user.getUsername());
        }
        if (StrUtil.isNotBlank(user.getMobile())) {
            adminQueryWrapper.like("mobile", user.getMobile());
        }
        if (StrUtil.isNotBlank(user.getEmail())) {
            adminQueryWrapper.like("email", user.getEmail());
        }

        //部门
        if (StrUtil.isNotBlank(user.getDepartmentId())) {
            adminQueryWrapper.eq("department_id", user.getDepartmentId());
        }

        //性别
        if (user.getSex() != null) {
            adminQueryWrapper.eq("sex", user.getSex());
        }
        //类型
        if (user.getType() != null) {
            adminQueryWrapper.eq("type", user.getType());
        }
        //状态
        if (user.getStatus() != null) {
            adminQueryWrapper.eq("status", user.getStatus());
        }

        if (ObjectUtils.isNotNull(extraVo.getStartDate()) && extraVo.getStartDate() > 0) {
            adminQueryWrapper.gt("created_at", extraVo.getStartDate());
        }
        if (ObjectUtils.isNotNull(extraVo.getEndDate()) && extraVo.getEndDate() > 0) {
            adminQueryWrapper.lt("created_at", extraVo.getEndDate());
        }

        boolean isAsc = "asc".equals(extraVo.getOrder());
        if (!StrUtil.isEmpty(extraVo.getSort())) {
            adminQueryWrapper.orderBy(true, isAsc, StringUtils.camelToUnderline(extraVo.getSort()));
        } else {
            adminQueryWrapper.orderByDesc("created_at");
        }

        IPage<Admin> admins = adminService.page(page, adminQueryWrapper);

        List<Admin> newAdmins = new ArrayList<>();
        for (Admin u : admins.getRecords()) {
            // 关联部门
            if (StrUtil.isNotBlank(u.getDepartmentId())) {
                Department department = departmentService.getById(u.getDepartmentId());
                u.setDepartmentTitle(department.getTitle());
            }
            // 关联角色
            List<Role> list = iUserRoleService.findByUserId(u.getId());
            u.setRoles(list);
            // 清除持久上下文环境 避免后面语句导致持久化
            u.setPassword(null);
            newAdmins.add(u);
        }
        page.setRecords(newAdmins);
        return new ResultUtil<IPage<Admin>>().success(page);
    }

    @PostMapping("/admin/add")
    public Result<Object> add(@ModelAttribute Admin u,
                              @RequestParam(required = false) String[] roles) {

        if (StrUtil.isBlank(u.getUsername()) || StrUtil.isBlank(u.getPassword())) {
            return new ResultUtil<>().error("缺少必需表单字段");
        }

        if (!ObjectUtils.isEmpty(adminService.findUserDetailInfo(u.getUsername()))) {
            return new ResultUtil<>().error("该用户名已被注册");
        }
        //删除缓存
        redisTemplate.delete("admin::" + u.getUsername());

        String encryptPass = new BCryptPasswordEncoder().encode(u.getPassword());
        u.setPassword(encryptPass);
        boolean sec = adminService.save(u);
        if (!sec) {
            return new ResultUtil<>().error("添加失败");
        }
        if (!ObjectUtils.isEmpty(roles)) {
            //添加角色
            for (String roleId : roles) {
                AdminRole ur = new AdminRole();
                ur.setUserId(u.getId());
                ur.setRoleId(roleId);
                userRoleService.save(ur);
            }
        }

        return new ResultUtil<>().success(u);
    }

    @PostMapping("/admin/disable/{userId}")
    public Result<Object> disable(@PathVariable String userId) {

        Admin user = adminService.getById(userId);
        if (user == null) {
            return new ResultUtil<>().error("通过userId获取用户失败");
        }
        user.setStatus(CommonStatus.STATUS_DISABLED.getStatus());
        adminService.updateById(user);
        //手动更新缓存
        redisTemplate.delete("admin::" + user.getUsername());
        return new ResultUtil<>().success(null);
    }

    @PostMapping("/admin/enable/{userId}")
    public Result<Object> enable(@PathVariable String userId) {

        Admin user = adminService.getById(userId);
        if (user == null) {
            return new ResultUtil<>().error("通过userId获取用户失败");
        }
        user.setStatus(CommonStatus.STATUS_ENABLED.getStatus());
        adminService.updateById(user);
        //手动更新缓存
        redisTemplate.delete("admin::" + user.getUsername());
        return new ResultUtil<>().success(null);
    }

    @DeleteMapping("/delByIds/{ids}")
    public Result<Object> delAllByIds(@PathVariable String[] ids) {

        for (String id : ids) {
            adminService.removeById(id);
            //删除关联角色
            userRoleService.remove((new QueryWrapper<AdminRole>().eq("user_id", id)));
        }
        return new ResultUtil<>().success("批量通过id删除数据成功");
    }

    @PostMapping("/admin/updatePassword")
    @SystemLog(description = "修改管理员密码")
    public Result<Object> updatePassword(@RequestParam String id, @RequestParam String password, @RequestParam String confirmPassword) {

        Admin old = adminService.getById(id);

        String newEncryptPass = new BCryptPasswordEncoder().encode(password);
        old.setPassword(newEncryptPass);
        boolean sec = adminService.updateById(old);
        if (!sec) {
            return new ResultUtil<>().error("修改失败");
        }

        //手动更新缓存
        redisTemplate.delete("admin::" + old.getUsername());

        return new ResultUtil<>().success(old);
    }

    /**
     * 初始化绑定<br/>
     *
     * @param request http请求实例
     * @param binder  绑定实例
     * @throws Exception 异常
     */
    @InitBinder
    public void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
        binder.registerCustomEditor(Permission.class, new PermissionEditor());
        binder.registerCustomEditor(Role.class, new RolesEditor());
    }
}
