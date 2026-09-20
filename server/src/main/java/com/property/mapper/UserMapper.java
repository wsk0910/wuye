package com.property.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.property.entity.User;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface UserMapper extends BaseMapper<User> {
    
    @Select("SELECT u.* FROM user u WHERE u.role = 3 AND u.id NOT IN (SELECT user_id FROM owner WHERE user_id IS NOT NULL)")
    List<User> selectUnboundUsers();
}
