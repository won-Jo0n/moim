package com.spring.page.dto;

import lombok.Data;

@Data
public class PageInfoDTO {
    private int currentPage,totalPage,pageSize;
    private Long totalItems;
}
