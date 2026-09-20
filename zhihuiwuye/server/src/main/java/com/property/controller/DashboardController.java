package com.property.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.property.common.Result;
import com.property.service.*;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin
public class DashboardController {

    @Resource
    private OwnerService ownerService;
    @Resource
    private RepairService repairService;
    @Resource
    private ComplaintService complaintService;
    @Resource
    private FeeService feeService;
    @Resource
    private NoticeService noticeService;

    @GetMapping("/stats")
    public Result<Map<String, Object>> stats() {
        Map<String, Object> data = new HashMap<>();
        data.put("ownerCount", ownerService.count());
        data.put("repairPending", repairService.countByStatus(0));
        data.put("repairProcessing", repairService.countByStatus(1) + repairService.countByStatus(2));
        data.put("repairCompleted", repairService.countByStatus(3) + repairService.countByStatus(4));
        data.put("complaintPending", complaintService.count(new QueryWrapper<com.property.entity.Complaint>().eq("status", 0)));
        data.put("unpaidAmount", feeService.sumUnpaid(null));
        data.put("noticeCount", noticeService.count(new QueryWrapper<com.property.entity.Notice>().eq("status", 1)));
        return Result.success(data);
    }
}
