package com.property.controller;

import com.property.common.Result;
import com.property.entity.Config;
import com.property.service.ConfigService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/config")
@CrossOrigin
public class ConfigController {

    @Resource
    private ConfigService configService;

    @GetMapping("/list")
    public Result<List<Config>> list() {
        return Result.success(configService.list());
    }

    @GetMapping("/{key}")
    public Result<String> getByKey(@PathVariable String key) {
        return Result.success(configService.getValue(key));
    }

    @PostMapping
    public Result<String> save(@RequestBody Config config) {
        configService.saveOrUpdate(config);
        return Result.success("操作成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        configService.removeById(id);
        return Result.success("删除成功");
    }
}
