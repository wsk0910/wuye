package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Visitor;
import com.property.service.VisitorService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;

@RestController
@RequestMapping("/api/visitor")
@CrossOrigin
public class VisitorController {

    @Resource
    private VisitorService visitorService;

    @GetMapping("/page")
    public Result<Page<Visitor>> page(@RequestParam(defaultValue = "1") Integer page,
                                      @RequestParam(defaultValue = "10") Integer size,
                                      @RequestParam(required = false) String keyword,
                                      @RequestParam(required = false) Integer status,
                                      @RequestParam(required = false) Long ownerId) {
        return Result.success(visitorService.pageList(page, size, keyword, status, ownerId));
    }

    @GetMapping("/{id}")
    public Result<Visitor> getById(@PathVariable Long id) {
        return Result.success(visitorService.getById(id));
    }

    @PostMapping
    public Result<String> save(@RequestBody Visitor visitor) {
        if (visitor.getId() == null) {
            visitor.setStatus(0); // 默认待审核
        }
        visitorService.saveOrUpdate(visitor);
        return Result.success("操作成功");
    }

    @PutMapping("/approve/{id}")
    public Result<String> approve(@PathVariable Long id, @RequestParam Integer status) {
        Visitor visitor = new Visitor();
        visitor.setId(id);
        visitor.setStatus(status); // 1-通过 2-拒绝
        visitorService.updateById(visitor);
        return Result.success("操作成功");
    }

    @PutMapping("/visit/{id}")
    public Result<String> visit(@PathVariable Long id) {
        Visitor visitor = new Visitor();
        visitor.setId(id);
        visitor.setStatus(3); // 已来访
        visitorService.updateById(visitor);
        return Result.success("登记成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        visitorService.removeById(id);
        return Result.success("删除成功");
    }
}
