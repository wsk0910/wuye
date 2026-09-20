package com.property.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("repair")
public class Repair {
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 报修业主ID */
    private Long ownerId;
    /** 报修标题 */
    private String title;
    /** 报修内容 */
    private String content;
    /** 报修图片 */
    private String images;
    /** 状态: 0-待处理 1-已派单 2-维修中 3-已完成 4-已评价 */
    private Integer status;
    /** 指派的维修工ID */
    private Long workerId;
    /** 维修费用 */
    private BigDecimal cost;
    /** 维修记录 */
    private String repairRecord;
    /** 评分 */
    private Integer rating;
    /** 评价内容 */
    private String comment;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
