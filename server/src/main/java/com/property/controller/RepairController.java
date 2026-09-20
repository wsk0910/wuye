package com.property.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.property.common.Result;
import com.property.entity.Fee;
import com.property.entity.Repair;
import com.property.service.FeeService;
import com.property.service.RepairService;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.math.BigDecimal;

@RestController
@RequestMapping("/api/repair")
@CrossOrigin
public class RepairController {

    @Resource
    private RepairService repairService;
    @Resource
    private FeeService feeService;

    @GetMapping("/page")
    public Result<Page<Repair>> page(@RequestParam(defaultValue = "1") Integer page,
                                     @RequestParam(defaultValue = "10") Integer size,
                                     @RequestParam(required = false) String keyword,
                                     @RequestParam(required = false) Integer status,
                                     @RequestParam(required = false) Long ownerId,
                                     @RequestParam(required = false) Long workerId) {
        return Result.success(repairService.pageList(page, size, keyword, status, ownerId, workerId));
    }

    @GetMapping("/{id}")
    public Result<Repair> getById(@PathVariable Long id) {
        return Result.success(repairService.getById(id));
    }

    @PostMapping
    public Result<String> save(@RequestBody Repair repair) {
        if (repair.getId() == null) {
            repair.setStatus(0); // 新报修默认待处理
        }
        repairService.saveOrUpdate(repair);
        return Result.success("操作成功");
    }

    @PutMapping("/assign/{id}")
    public Result<String> assign(@PathVariable Long id, @RequestParam Long workerId) {
        Repair repair = new Repair();
        repair.setId(id);
        repair.setWorkerId(workerId);
        repair.setStatus(1); // 已派单
        repairService.updateById(repair);
        return Result.success("派单成功");
    }

    @PutMapping("/start/{id}")
    public Result<String> start(@PathVariable Long id) {
        Repair repair = new Repair();
        repair.setId(id);
        repair.setStatus(2); // 维修中
        repairService.updateById(repair);
        return Result.success("开始维修");
    }

    @PutMapping("/complete/{id}")
    public Result<String> complete(@PathVariable Long id, @RequestBody Repair repair) {
        Repair existRepair = repairService.getById(id);
        repair.setId(id);
        // 如果有维修费用，状态改为待缴费(3)，否则直接待评价(4)
        if (repair.getCost() != null && repair.getCost().compareTo(BigDecimal.ZERO) > 0) {
            repair.setStatus(3); // 待缴费
        } else {
            repair.setStatus(4); // 待评价
        }
        repairService.updateById(repair);
        return Result.success("维修完成");
    }

    @PutMapping("/pay/{id}")
    public Result<String> pay(@PathVariable Long id) {
        Repair existRepair = repairService.getById(id);
        if (existRepair == null || existRepair.getStatus() != 3) {
            return Result.error("状态错误");
        }
        // 更新报修状态为待评价
        Repair repair = new Repair();
        repair.setId(id);
        repair.setStatus(4); // 待评价
        repairService.updateById(repair);
        
        // 生成已缴费的费用记录
        Fee fee = new Fee();
        fee.setOwnerId(existRepair.getOwnerId());
        fee.setType(5); // 其他费用（维修费）
        fee.setAmount(existRepair.getCost());
        fee.setPeriod("维修费");
        fee.setStatus(1); // 已缴
        fee.setPayTime(java.time.LocalDateTime.now());
        fee.setRemark("报修单号:" + id + " - " + existRepair.getTitle());
        feeService.save(fee);
        
        return Result.success("缴费成功");
    }

    @PutMapping("/evaluate/{id}")
    public Result<String> evaluate(@PathVariable Long id, @RequestBody Repair repair) {
        repair.setId(id);
        repair.setStatus(5); // 已完成
        repairService.updateById(repair);
        return Result.success("评价成功");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        repairService.removeById(id);
        return Result.success("删除成功");
    }
}
