package com.spring.friends.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class FriendsDTO {
    private int requestUserId, responseUserId, status;
    private String requestedAt, responsedAt;
}
