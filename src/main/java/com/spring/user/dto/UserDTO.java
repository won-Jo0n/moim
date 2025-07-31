package com.spring.user.dto;

import lombok.Data;

@Data
public class UserDTO {
    private String loginId,password,nickName,gender,birthDate,region,changeMbtiAt,createdAt,lastLogin;
    private int mbtiId,rating,point,status;
}
