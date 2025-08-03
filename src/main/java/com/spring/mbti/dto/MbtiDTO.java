package com.spring.mbti.dto;

import lombok.Data;

@Data
public class MbtiDTO {
    private int id, compatible;
    private String mbti, description;
}
