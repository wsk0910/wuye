package com.property.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("fee")
public class Fee {
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 业主ID */
    private Long ownerId;
    /** 费用类型: 1-物业费 2-水费 3-电费 4-停车费 5-其他 */
    private Integer type;
    /** 费用金额 */
    private BigDecimal amount;
    /** 费用周期 如: 2024-01 */
    private String period;
    /** 状态: 0-未缴 1-已缴 */
    private Integer status;
    /** 缴费时间 */
    private LocalDateTime payTime;
    /** 备注 */
    private String remark;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
