package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Fee;
import com.property.service.FeeService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/fee")
@CrossOrigin
public class FeeController {

    @Resource
    private FeeService feeService;

    @GetMapping("/page")
    public Result<Page<Fee>> page(@RequestParam(defaultValue = "1") Integer page,
                                  @RequestParam(defaultValue = "10") Integer size,
                                  @RequestParam(required = false) Long ownerId,
                                  @RequestParam(required = false) Integer type,
                                  @RequestParam(required = false) Integer status,
                                  @RequestParam(required = false) String period) {
        return Result.success(feeService.pageList(page, size, ownerId, type, status, period));
    }

    @GetMapping("/{id}")
    public Result<Fee> getById(@PathVariable Long id) {
        return Result.success(feeService.getById(id));
    }

    @GetMapping("/unpaid")
    public Result<BigDecimal> unpaid(@RequestParam(required = false) Long ownerId) {
        return Result.success(feeService.sumUnpaid(ownerId));
    }

    @PostMapping
    public Result<String> save(@RequestBody Fee fee) {
        if (fee.getId() == null) {
            fee.setStatus(0); // 默认未缴
        }
        feeService.saveOrUpdate(fee);
        return Result.success("操作成功");
    }

    @PutMapping("/pay/{id}")
    public Result<String> pay(@PathVariable Long id) {
        Fee fee = new Fee();
        fee.setId(id);
        fee.setStatus(1);
        fee.setPayTime(LocalDateTime.now());
        feeService.updateById(fee);
        return Result.success("缴费成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        feeService.removeById(id);
        return Result.success("删除成功");
    }
}
