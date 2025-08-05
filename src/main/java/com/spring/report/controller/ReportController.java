package com.spring.report.controller;

import com.spring.report.dto.ReportDTO;
import com.spring.report.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportController {
    private final ReportService reportService;

    @GetMapping("/")
    public String reportForm(@ModelAttribute ReportDTO reportDTO,Model model){
        model.addAttribute("reportDTO", reportDTO);

        return "/report/reportForm";
    }

    @PostMapping("/")
    public String report(@ModelAttribute ReportDTO reportDTO){
        reportService.report(reportDTO);

        return "redirect:/" + reportDTO.getType()+"?id="+reportDTO.getBoardId();
    }



}
