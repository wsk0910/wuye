package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Inspection;
import com.property.mapper.InspectionMapper;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

@Service
public class InspectionService extends ServiceImpl<InspectionMapper, Inspection> {

    public Page<Inspection> pageList(Integer page, Integer size, String keyword, Integer status) {
        QueryWrapper<Inspection> wrapper = new QueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like("area", keyword).or().like("content", keyword));
        }
        if (status != null) {
            wrapper.eq("status", status);
        }
        wrapper.orderByDesc("create_time");
        return page(new Page<>(page, size), wrapper);
    }
}
