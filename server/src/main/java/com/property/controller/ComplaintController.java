package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Complaint;
import com.property.service.ComplaintService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;

@RestController
@RequestMapping("/api/complaint")
@CrossOrigin
public class ComplaintController {

    @Resource
    private ComplaintService complaintService;

    @GetMapping("/page")
    public Result<Page<Complaint>> page(@RequestParam(defaultValue = "1") Integer page,
                                        @RequestParam(defaultValue = "10") Integer size,
                                        @RequestParam(required = false) String keyword,
                                        @RequestParam(required = false) Integer type,
                                        @RequestParam(required = false) Integer status,
                                        @RequestParam(required = false) Long ownerId) {
        return Result.success(complaintService.pageList(page, size, keyword, type, status, ownerId));
    }

    @GetMapping("/{id}")
    public Result<Complaint> getById(@PathVariable Long id) {
        return Result.success(complaintService.getById(id));
    }

    @PostMapping
    public Result<String> save(@RequestBody Complaint complaint) {
        if (complaint.getId() == null) {
            complaint.setStatus(0); // 默认待处理
        }
        complaintService.saveOrUpdate(complaint);
        return Result.success("操作成功");
    }

    @PutMapping("/handle/{id}")
    public Result<String> handle(@PathVariable Long id, @RequestBody Complaint complaint) {
        complaint.setId(id);
        complaint.setStatus(2); // 已处理
        complaintService.updateById(complaint);
        return Result.success("处理成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        complaintService.removeById(id);
        return Result.success("删除成功");
    }
}
