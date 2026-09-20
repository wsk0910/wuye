package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Owner;
import com.property.entity.User;
import com.property.service.OwnerService;
import com.property.service.UserService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;

@RestController
@RequestMapping("/api/owner")
@CrossOrigin
public class OwnerController {

    @Resource
    private OwnerService ownerService;
    @Resource
    private UserService userService;

    @GetMapping("/page")
    public Result<Page<Owner>> page(@RequestParam(defaultValue = "1") Integer page,
                                    @RequestParam(defaultValue = "10") Integer size,
                                    @RequestParam(required = false) String keyword) {
        return Result.success(ownerService.pageList(page, size, keyword));
    }

    @GetMapping("/{id}")
    public Result<Owner> getById(@PathVariable Long id) {
        return Result.success(ownerService.getById(id));
    }

    @GetMapping("/user/{userId}")
    public Result<Owner> getByUserId(@PathVariable Long userId) {
        return Result.success(ownerService.getByUserId(userId));
    }

    @PostMapping
    public Result<String> save(@RequestBody Owner owner) {
        ownerService.saveOrUpdate(owner);
        return Result.success("操作成功");
    }

    @PutMapping("/bind/{id}")
    public Result<String> bind(@PathVariable Long id, @RequestParam Long userId) {
        // 检查用户是否已绑定其他业主
        Owner existOwner = ownerService.getByUserId(userId);
        if (existOwner != null) {
            return Result.error("该用户已绑定其他业主");
        }
        Owner owner = new Owner();
        owner.setId(id);
        owner.setUserId(userId);
        ownerService.updateById(owner);
        // 更新用户角色为业主
        User user = userService.getById(userId);
        if (user != null && user.getRole() != 3) {
            user.setRole(3);
            userService.updateById(user);
        }
        return Result.success("绑定成功");
    }

    @PostMapping("/bindNew/{id}")
    public Result<String> bindNew(@PathVariable Long id, @RequestBody User user) {
        Owner owner = ownerService.getById(id);
        if (owner == null) {
            return Result.error("业主不存在");
        }
        if (userService.existsByUsername(user.getUsername(), null)) {
            return Result.error("用户名已存在");
        }
        // 创建新用户
        user.setRole(3);
        user.setStatus(1);
        user.setRealName(owner.getName());
        user.setPhone(owner.getPhone());
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            user.setPassword("123456");
        }
        userService.save(user);
        // 绑定到业主
        owner.setUserId(user.getId());
        ownerService.updateById(owner);
        return Result.success("绑定成功");
    }

    @PutMapping("/unbind/{id}")
    public Result<String> unbind(@PathVariable Long id) {
        Owner owner = new Owner();
        owner.setId(id);
        owner.setUserId(null);
        ownerService.updateById(owner);
        return Result.success("解绑成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        ownerService.removeById(id);
        return Result.success("删除成功");
    }
}
