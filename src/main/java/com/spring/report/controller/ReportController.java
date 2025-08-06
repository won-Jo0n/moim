package com.spring.report.controller;

import com.spring.report.dto.ReportDTO;
import com.spring.report.service.ReportService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportController {
    private final ReportService reportService;
    private final UserService userService;

    @GetMapping("/")
    public String reportForm(@ModelAttribute ReportDTO reportDTO,Model model){
        UserDTO reportUser = userService.getUserById(reportDTO.getReportUser());
        UserDTO reportedUser = userService.getUserById(reportDTO.getReportedUser());
        model.addAttribute("reportDTO", reportDTO);
        model.addAttribute("reportUser", reportUser.getNickName());
        model.addAttribute("reportedUser", reportedUser.getNickName());

        return "/report/reportForm";
    }

    @PostMapping("/")
    public String report(@ModelAttribute ReportDTO reportDTO){
        if(reportDTO.getCommentId() == null){
            reportService.report(reportDTO);
        }else{
            reportService.reportComment(reportDTO);
        }

        return "redirect:/" + reportDTO.getType()+"/detail?id="+reportDTO.getBoardId();
    }

    @GetMapping("/detail")
    public String reportDetail(@RequestParam("id") int reportId, Model model){
        ReportDTO reportDTO = reportService.getReportById(reportId);
        model.addAttribute("report", reportDTO);
        UserDTO reportUser = userService.getUserById(reportDTO.getReportUser());
        UserDTO reportedUser = userService.getUserById(reportDTO.getReportedUser());
        model.addAttribute("reportUser", reportUser);
        model.addAttribute("reportedUser", reportedUser);

        return "/report/detail";
    }



}
