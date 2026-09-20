package com.property.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("config")
public class Config {
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 配置键 */
    private String configKey;
    /** 配置值 */
    private String configValue;
    /** 配置名称 */
    private String configName;
    /** 备注 */
    private String remark;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
