package com.spring.file.dto;

import lombok.Data;

@Data
public class FileDTO {
    private int id, status;
    private String originalFileName, fileName;

}
