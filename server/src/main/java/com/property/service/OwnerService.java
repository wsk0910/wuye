package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Owner;
import com.property.mapper.OwnerMapper;
import org.springframework.stereotype.Service;
import cn.hutool.core.util.StrUtil;

@Service
public class OwnerService extends ServiceImpl<OwnerMapper, Owner> {

    public Page<Owner> pageList(Integer page, Integer size, String keyword) {
        QueryWrapper<Owner> wrapper = new QueryWrapper<>();
        if (StrUtil.isNotBlank(keyword)) {
            wrapper.and(w -> w.like("name", keyword)
                    .or().like("phone", keyword)
                    .or().like("building", keyword)
                    .or().like("room", keyword));
        }
        wrapper.orderByDesc("create_time");
        return page(new Page<>(page, size), wrapper);
    }

    public Owner getByUserId(Long userId) {
        return getOne(new QueryWrapper<Owner>().eq("user_id", userId));
    }
}
