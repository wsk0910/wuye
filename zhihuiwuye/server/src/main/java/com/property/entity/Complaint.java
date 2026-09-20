package com.property.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("complaint")
public class Complaint {
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 投诉人ID */
    private Long ownerId;
    /** 类型: 1-投诉 2-建议 */
    private Integer type;
    /** 标题 */
    private String title;
    /** 内容 */
    private String content;
    /** 状态: 0-待处理 1-处理中 2-已处理 */
    private Integer status;
    /** 回复内容 */
    private String reply;
    /** 处理人ID */
    private Long handlerId;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
