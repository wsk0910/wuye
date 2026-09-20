package com.property.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.property.entity.Config;
import com.property.mapper.ConfigMapper;
import org.springframework.stereotype.Service;

@Service
public class ConfigService extends ServiceImpl<ConfigMapper, Config> {

    public String getValue(String key) {
        Config config = getOne(new QueryWrapper<Config>().eq("config_key", key));
        return config != null ? config.getConfigValue() : null;
    }
}
