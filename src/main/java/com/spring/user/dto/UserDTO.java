package com.spring.user.dto;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
public class UserDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private String loginId,password,nickName,gender,birthDate,region,changeMbtiAt,createdAt,lastLogin,role;
    private int id,mbtiId,rating,point,status,fileId;
    private LocalDateTime banEndTime;
}
