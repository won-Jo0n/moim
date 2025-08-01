package com.spring.user.dto;

import lombok.Data;

@Data
public class UserDTO {
    private String loginId,password,nickName,gender,birthDate,region,changeMbtiAt,createdAt,lastLogin;
    private int id,mbtiId,rating,point,status;
}
