package com.spring.group.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class GroupScheduleDTO {
    private String title,description;
    private int id,scheduleLeader,groupId,maxUserNum,status;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime startTime,endTime;
}
