package com.spring.mbti.dto;

import lombok.Data;

@Data
public class MbtiTestDTO {
    private int id;            // 질문 ID
    private String question;  // 질문 내용
    private String type;      // 질문 유형 (예: ie, ei, sn, ns ...)
    private int answer;       // 사용자 응답 점수 (0~4)
}