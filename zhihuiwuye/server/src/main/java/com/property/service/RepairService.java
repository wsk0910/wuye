package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Repair;
import com.property.mapper.RepairMapper;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

@Service
public class RepairService extends ServiceImpl<RepairMapper, Repair> {

    public Page<Repair> pageList(Integer page, Integer size, String keyword, Integer status, Long ownerId, Long workerId) {
        QueryWrapper<Repair> wrapper = new QueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like("title", keyword).or().like("content", keyword));
        }
        if (status != null) {
            wrapper.eq("status", status);
        }
        if (ownerId != null) {
            wrapper.eq("owner_id", ownerId);
        }
        if (workerId != null) {
            wrapper.eq("worker_id", workerId);
        }
        wrapper.orderByDesc("create_time");
        return page(new Page<>(page, size), wrapper);
    }

    public long countByStatus(Integer status) {
        return count(new QueryWrapper<Repair>().eq("status", status));
    }
}
