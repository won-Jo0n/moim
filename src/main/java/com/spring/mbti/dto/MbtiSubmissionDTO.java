package com.spring.mbti.dto;

import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
public class MbtiSubmissionDTO {
    private List<String> answers;
}