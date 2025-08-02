package com.spring.userjoingroup.dto;


import lombok.Data;
import java.sql.Timestamp;

@Data
public class UserJoinGroupDTO {
    private int userId;
    private int groupId;
    private Timestamp joinedAt;
    private String role;
}
