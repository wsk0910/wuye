package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Visitor;
import com.property.mapper.VisitorMapper;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

@Service
public class VisitorService extends ServiceImpl<VisitorMapper, Visitor> {

    public Page<Visitor> pageList(Integer page, Integer size, String keyword, Integer status, Long ownerId) {
        QueryWrapper<Visitor> wrapper = new QueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like("visitor_name", keyword).or().like("visitor_phone", keyword));
        }
        if (status != null) {
            wrapper.eq("status", status);
        }
        if (ownerId != null) {
            wrapper.eq("owner_id", ownerId);
        }
        wrapper.orderByDesc("create_time");
        return page(new Page<>(page, size), wrapper);
    }
}
