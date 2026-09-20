package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Fee;
import com.property.mapper.FeeMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class FeeService extends ServiceImpl<FeeMapper, Fee> {

    public Page<Fee> pageList(Integer page, Integer size, Long ownerId, Integer type, Integer status, String period) {
        QueryWrapper<Fee> wrapper = new QueryWrapper<>();
        if (ownerId != null) {
            wrapper.eq("owner_id", ownerId);
        }
        if (type != null) {
            wrapper.eq("type", type);
        }
        if (status != null) {
            wrapper.eq("status", status);
        }
        if (period != null && !period.isEmpty()) {
            wrapper.eq("period", period);
        }
        wrapper.orderByDesc("create_time");
        return page(new Page<>(page, size), wrapper);
    }

    public BigDecimal sumUnpaid(Long ownerId) {
        QueryWrapper<Fee> wrapper = new QueryWrapper<Fee>()
                .eq("status", 0)
                .select("IFNULL(SUM(amount), 0) as amount");
        if (ownerId != null) {
            wrapper.eq("owner_id", ownerId);
        }
        Fee fee = getOne(wrapper);
        return fee != null && fee.getAmount() != null ? fee.getAmount() : BigDecimal.ZERO;
    }
}
