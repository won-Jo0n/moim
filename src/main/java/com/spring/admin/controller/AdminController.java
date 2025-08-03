package com.spring.admin.controller;

import com.spring.admin.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final AdminService adminService;

    @GetMapping("/")
    public String admin(){
        return "/admin/admin";
    }

    @GetMapping("chart")
    public String chart(){
        return "/admin/chart";
    }

}
