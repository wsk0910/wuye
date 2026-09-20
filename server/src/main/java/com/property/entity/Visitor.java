package com.property.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("visitor")
public class Visitor {
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 预约业主ID */
    private Long ownerId;
    /** 访客姓名 */
    private String visitorName;
    /** 访客电话 */
    private String visitorPhone;
    /** 访客身份证 */
    private String visitorIdCard;
    /** 来访事由 */
    private String reason;
    /** 预计来访时间 */
    private LocalDateTime visitTime;
    /** 状态: 0-待审核 1-已通过 2-已拒绝 3-已来访 */
    private Integer status;
    /** 备注 */
    private String remark;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
