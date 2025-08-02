package com.spring.userjoingroup.repository;

import com.spring.userjoingroup.dto.UserJoinGroupDTO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
//MyBatis Mapper 인터페이스
public interface UserJoinGroupRepository {

    void insert(UserJoinGroupDTO dto);

    void deleteByGroupId(int groupId);

}
