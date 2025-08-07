package com.spring.user.repository;

import com.spring.user.dto.UserDTO;
import com.spring.user.dto.UserScheduleDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class UserRepository {
    private final SqlSessionTemplate sql;
    public int join(UserDTO userDTO) {
        return sql.insert("User.join",userDTO);
    }

    public UserDTO login(UserDTO userDTO) {
        return sql.selectOne("User.login",userDTO);
    }

    public UserDTO getUserById(int userId) {
        return sql.selectOne("User.getUserById", userId);
    }

    public int modify(UserDTO userDTO) {
        return sql.update("User.modify", userDTO);
    }

    public void delete(int userId) {
        sql.update("User.delete", userId);
    }

    public UserDTO getUserByLoginId(String loginId) {
        return sql.selectOne("User.getUserByLoginId", loginId);
    }

    public void updateUserStatus(UserDTO user) {
        sql.update("User.updateUserStatus", user);
    }

    public int nickNameCheck(String nickName) {
        return sql.selectOne("User.nickNameCheck", nickName);
    }

    public void createUserSchedule(UserScheduleDTO userScheduleDTO) {
        sql.insert("User.createUserSchedule",userScheduleDTO);
    }

    public UserScheduleDTO isJoin(UserScheduleDTO userScheduleDTO) {
        return sql.selectOne("User.isJoin", userScheduleDTO);
    }

    public void cancleUserSchedule(UserScheduleDTO result) {
        sql.update("User.cancleUserSchedule", result);
    }
}
