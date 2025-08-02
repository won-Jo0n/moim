package com.spring.group.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class GroupDTO {
    private int id;
    private String leader;
    private String title;
    private String description;
    private String location;
    private int maxUserNum;
    private Timestamp createdAt;
    private int status;


}
