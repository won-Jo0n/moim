package com.spring.schedule.dto;

import lombok.Data;

@Data
public class ScheduleDTO {
    private int userId, groupScheduleId, status;
    private float rating;
    private String nickName, region, mbti;
}
