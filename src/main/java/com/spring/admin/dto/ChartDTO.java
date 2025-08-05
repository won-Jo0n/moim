package com.spring.admin.dto;

import lombok.Data;

import java.util.List;

@Data
public class ChartDTO {
    private String title; // 차트 제목 (예: "댓글 수 상위 MBTI")
    private String type; // 차트 종류 (bar, doughnut, pie 등)
    private String label; // 범례 이름
    private List<String> labels; // x축 라벨 (예: "ISTJ", "ENTP")
    private List<Integer> data; // y축 데이터 (예: 120, 95)
    private List<String> backgroundColors; // 차트 배경색
    private List<String> borderColors; // 차트 테두리색
}
