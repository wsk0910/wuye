package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Complaint;
import com.property.mapper.ComplaintMapper;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

@Service
public class ComplaintService extends ServiceImpl<ComplaintMapper, Complaint> {

    public Page<Complaint> pageList(Integer page, Integer size, String keyword, Integer type, Integer status, Long ownerId) {
        QueryWrapper<Complaint> wrapper = new QueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like("title", keyword).or().like("content", keyword));
        }
        if (type != null) {
            wrapper.eq("type", type);
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
