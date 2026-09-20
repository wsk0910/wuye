package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Inspection;
import com.property.service.InspectionService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;

@RestController
@RequestMapping("/api/inspection")
@CrossOrigin
public class InspectionController {

    @Resource
    private InspectionService inspectionService;

    @GetMapping("/page")
    public Result<Page<Inspection>> page(@RequestParam(defaultValue = "1") Integer page,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         @RequestParam(required = false) String keyword,
                                         @RequestParam(required = false) Integer status) {
        return Result.success(inspectionService.pageList(page, size, keyword, status));
    }

    @GetMapping("/{id}")
    public Result<Inspection> getById(@PathVariable Long id) {
        return Result.success(inspectionService.getById(id));
    }

    @PostMapping
    public Result<String> save(@RequestBody Inspection inspection) {
        inspectionService.saveOrUpdate(inspection);
        return Result.success("操作成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        inspectionService.removeById(id);
        return Result.success("删除成功");
    }
}
