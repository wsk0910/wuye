package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Notice;
import com.property.service.NoticeService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;

@RestController
@RequestMapping("/api/notice")
@CrossOrigin
public class NoticeController {

    @Resource
    private NoticeService noticeService;

    @GetMapping("/page")
    public Result<Page<Notice>> page(@RequestParam(defaultValue = "1") Integer page,
                                     @RequestParam(defaultValue = "10") Integer size,
                                     @RequestParam(required = false) String keyword,
                                     @RequestParam(required = false) Integer status) {
        return Result.success(noticeService.pageList(page, size, keyword, status));
    }

    @GetMapping("/{id}")
    public Result<Notice> getById(@PathVariable Long id) {
        return Result.success(noticeService.getById(id));
    }

    @PostMapping
    public Result<String> save(@RequestBody Notice notice) {
        noticeService.saveOrUpdate(notice);
        return Result.success("操作成功");
    }

    @PutMapping("/publish/{id}")
    public Result<String> publish(@PathVariable Long id) {
        Notice notice = new Notice();
        notice.setId(id);
        notice.setStatus(1);
        noticeService.updateById(notice);
        return Result.success("发布成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        noticeService.removeById(id);
        return Result.success("删除成功");
    }
}
