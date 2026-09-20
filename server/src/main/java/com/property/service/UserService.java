package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.User;
import com.property.mapper.UserMapper;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserService extends ServiceImpl<UserMapper, User> {

    @Resource
    private UserMapper userMapper;

    public User login(String username, String password) {
        return getOne(new QueryWrapper<User>()
                .eq("username", username)
                .eq("password", password)
                .eq("status", 1));
    }

    public Page<User> pageList(Integer page, Integer size, String keyword, Integer role) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like("username", keyword)
                    .or().like("real_name", keyword)
                    .or().like("phone", keyword));
        }
        if (role != null) {
            wrapper.eq("role", role);
        }
        wrapper.orderByDesc("create_time");
        return page(new Page<>(page, size), wrapper);
    }

    public boolean existsByUsername(String username, Long excludeId) {
        QueryWrapper<User> wrapper = new QueryWrapper<User>().eq("username", username);
        if (excludeId != null) {
            wrapper.ne("id", excludeId);
        }
        return count(wrapper) > 0;
    }

    public List<User> getUnboundUsers() {
        // 查询角色为业主(3)且未被绑定的用户
        return userMapper.selectUnboundUsers();
    }
}
