package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.User;
import com.property.service.UserService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/user")
@CrossOrigin
public class UserController {

    @Resource
    private UserService userService;

    @PostMapping("/login")
    public Result<User> login(@RequestBody User user) {
        User loginUser = userService.login(user.getUsername(), user.getPassword());
        if (loginUser == null) {
            return Result.error("用户名或密码错误");
        }
        return Result.success(loginUser);
    }

    @GetMapping("/page")
    public Result<Page<User>> page(@RequestParam(defaultValue = "1") Integer page,
                                   @RequestParam(defaultValue = "10") Integer size,
                                   @RequestParam(required = false) String keyword,
                                   @RequestParam(required = false) Integer role) {
        return Result.success(userService.pageList(page, size, keyword, role));
    }

    @GetMapping("/{id}")
    public Result<User> getById(@PathVariable Long id) {
        return Result.success(userService.getById(id));
    }

    @GetMapping("/unbound")
    public Result<List<User>> getUnboundUsers() {
        return Result.success(userService.getUnboundUsers());
    }

    @PostMapping
    public Result<String> save(@RequestBody User user) {
        if (userService.existsByUsername(user.getUsername(), user.getId())) {
            return Result.error("用户名已存在");
        }
        userService.saveOrUpdate(user);
        return Result.success("操作成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        userService.removeById(id);
        return Result.success("删除成功");
    }

    @PutMapping("/status/{id}")
    public Result<String> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        User user = new User();
        user.setId(id);
        user.setStatus(status);
        userService.updateById(user);
        return Result.success("操作成功");
    }
}
