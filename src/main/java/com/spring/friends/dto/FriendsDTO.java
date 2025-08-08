package com.spring.friends.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class FriendsDTO {
    int id, requestUserId, responseUserId, status;
    Timestamp requestedAt, responsedAt;
}
