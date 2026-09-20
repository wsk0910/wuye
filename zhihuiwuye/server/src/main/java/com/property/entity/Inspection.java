package com.property.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("inspection")
public class Inspection {
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 巡检人ID */
    private Long inspectorId;
    /** 巡检区域 */
    private String area;
    /** 巡检内容 */
    private String content;
    /** 巡检结果 */
    private String result;
    /** 问题描述 */
    private String problem;
    /** 图片 */
    private String images;
    /** 状态: 0-正常 1-有问题 */
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
