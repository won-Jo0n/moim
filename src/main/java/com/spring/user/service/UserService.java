package com.spring.user.service;

import com.spring.user.dto.UserDTO;
import com.spring.user.dto.UserScheduleDTO;
import com.spring.user.repository.UserRepository;
import com.spring.utils.CheckedUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public int join(UserDTO userDTO) {
        boolean result = CheckedUtil.isValidPhone(userDTO.getMobile());
        if(result){
            return userRepository.join(userDTO);
        }else{
            throw new IllegalArgumentException("잘못된 전화번호 형식입니다.");
        }
    }

    public UserDTO login(UserDTO userDTO) {
        return userRepository.login(userDTO);
    }

    public UserDTO getUserById(int userId) {
        return userRepository.getUserById(userId);
    }

    public int modify(UserDTO userDTO) {
        return userRepository.modify(userDTO);
    }

    public void delete(int userId) {
        userRepository.delete(userId);
    }

    public int nickNameCheck(String nickName) {
        return userRepository.nickNameCheck(nickName);
    }

    public void createUserSchedule(UserScheduleDTO userScheduleDTO) {
        userRepository.createUserSchedule(userScheduleDTO);
    }

    public UserScheduleDTO isJoin(UserScheduleDTO userScheduleDTO) {
        return userRepository.isJoin(userScheduleDTO);
    }

    public void cancelUserSchedule(UserScheduleDTO result) {
        userRepository.cancelUserSchedule(result);
    }

    public void updateUserStatus(UserDTO loginUser) {
        userRepository.updateUserStatus(loginUser);
    }

    public int loginIdCheck(String loginId) {
        return userRepository.loginIdCheck(loginId);
    }


    public void updateLastLogin(UserDTO loginUser) {
        userRepository.updateLastLogin(loginUser);
    }

    @Transactional
    public void applySchedule(UserScheduleDTO dto) {
        // 이미 대기/수락 상태인지 확인
        Integer status = userRepository.getMyScheduleStatus(dto);
        if (status != null) {
            if (status == 0 || status == 1) {
                return; // 이미 신청 중/수락 상태면 아무 것도 안 함
            }
            if (status == -1) {
                // 과거 취소 이력이면 재신청으로 복구
                userRepository.reapplyUserSchedule(dto);
                return;
            }
        }
        // 완전 신규 신청
        userRepository.createUserSchedule(dto);
    }

    @Transactional
    public void cancelSchedule(UserScheduleDTO dto) {
        userRepository.cancelUserSchedule(dto); // 0 또는 1 -> -1
    }

    // null, -1, 0, 1 반환
    public Integer getMyScheduleStatus(int userId, int groupScheduleId) {
        UserScheduleDTO dto = new UserScheduleDTO();
        dto.setUserId(userId);
        dto.setGroupScheduleId(groupScheduleId);
        return userRepository.getMyScheduleStatus(dto);
    }
}
