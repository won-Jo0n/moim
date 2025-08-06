package com.spring.admin.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.admin.dto.*;
import com.spring.admin.service.AdminService;
import com.spring.mbti.service.MbtiService;
import com.spring.report.dto.ReportDTO;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final AdminService adminService;
    private final UserService userService;
    private final MbtiService mbtiService;

    @GetMapping("/")
    public String admin(){
        return "/admin/admin";
    }



    @GetMapping("/report")
    public String report(Model model){
        List<ReportDTO> reportList =  adminService.getReportList();
        Map<Integer, String> reportUserName = new HashMap<>();
        Map<Integer, String> reportedUserName = new HashMap<>();

        for(ReportDTO reportDTO : reportList){
            UserDTO reportUser = userService.getUserById(reportDTO.getReportUser());
            UserDTO reportedUser = userService.getUserById(reportDTO.getReportedUser());

            reportUserName.put(reportDTO.getId(),reportUser.getNickName());
            reportedUserName.put(reportDTO.getId(),reportedUser.getNickName());
        }

        model.addAttribute("reportList", reportList);
        model.addAttribute("reportUserMap", reportUserName);
        model.addAttribute("reportedUserMap", reportedUserName);

        return "/admin/report";
    }

    @GetMapping("/penalties")
    public String penalties(Model model){
        List<UserDTO> penaltiesUser = adminService.getPenaltiesUser();
        model.addAttribute("penaltiesUser", penaltiesUser);

        return "/admin/penalties";
    }

    @PostMapping("/penaltiesSearch")
    public String penaltiesSearch(@RequestParam("nickName") String nickName, Model model){
        UserDTO userDTO = adminService.getUserByNickName(nickName);
        model.addAttribute("resultUser", userDTO);
        return "/admin/penalties";
    }

    @PostMapping("/getPenalties")
    public String getPenalties(@ModelAttribute PenaltiDTO penaltiDTO){
        adminService.getPenalties(penaltiDTO);

        return "redirect:/admin/penalties";
    }

    @GetMapping("/clearPenalti")
    public String clearPenalti(@RequestParam("id") int id){
        adminService.clearPenalti(id);

        return "redirect:/admin/penalties";
    }

    @GetMapping("/chart")
    public String chart2(Model model) throws JsonProcessingException {
        List<ChartDTO> statsList = new ArrayList<>();

        List<ChartCountDTO> mbtiCountList = mbtiService.getCountGroupByMbti();
        ChartDTO mbtiStats = new ChartDTO();
        mbtiStats.setTitle("MBTI별 가입자 수");
        mbtiStats.setType("bar");
        mbtiStats.setLabel("가입자 수");

        List<UserGenderRatioDTO> userGenderRatioDTOS = mbtiService.getCountGroupByGender();
        ChartDTO genderStats = new ChartDTO();
        genderStats.setTitle("유저 성별 비율");
        genderStats.setType("bar");
        genderStats.setLabel("사용자 수");

        List<UserAgeRatioDTO> userAgeRatioDTOS = mbtiService.getCountGroupByAge();
        ChartDTO ageStats = new ChartDTO();
        ageStats.setTitle("나이별 유저 비율");
        ageStats.setType("bar");
        ageStats.setLabel("사용자 수");

        // mbtiStats 데이터
        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        List<String> backgroundColors = new ArrayList<>();
        List<String> borderColors = new ArrayList<>();

        Random random = new Random();

        for (ChartCountDTO c : mbtiCountList) {
            labels.add(c.getMbti());
            data.add(c.getValue());
            // 차트 색상을 동적으로 생성
            String backgroundColor = String.format("rgba(%d, %d, %d, 0.5)",
                    random.nextInt(256), random.nextInt(256), random.nextInt(256));
            backgroundColors.add(backgroundColor);
            borderColors.add(backgroundColor.replace("0.5", "1"));
        }
        mbtiStats.setLabels(labels);
        mbtiStats.setData(data);
        mbtiStats.setBackgroundColors(backgroundColors);
        mbtiStats.setBorderColors(borderColors);
        statsList.add(mbtiStats);

        // 성별 비율 데이터
        List<String> genderLabels = new ArrayList<>();
        List<Integer> genderData = new ArrayList<>();
        List<String> genderBackgroundColors = new ArrayList<>();
        List<String> genderBorderColors = new ArrayList<>();

        for (UserGenderRatioDTO g : userGenderRatioDTOS) {
            genderLabels.add(g.getGender());
            genderData.add(g.getCount());
            System.out.println("count: " + g.getCount());
            // 차트 색상을 동적으로 생성
            String backgroundColor = String.format("rgba(%d, %d, %d, 0.5)",
                    random.nextInt(256), random.nextInt(256), random.nextInt(256));
            genderBackgroundColors.add(backgroundColor);
            genderBorderColors.add(backgroundColor.replace("0.5", "1"));
        }
        genderStats.setLabels(genderLabels);
        genderStats.setData(genderData);
        genderStats.setBackgroundColors(genderBackgroundColors);
        genderStats.setBorderColors(genderBorderColors);
        statsList.add(genderStats);

        List<String> ageLabels = new ArrayList<>();
        List<Integer> ageData = new ArrayList<>();
        List<String> ageBackgroundColors = new ArrayList<>();
        List<String> ageBorderColors = new ArrayList<>();

        for (UserAgeRatioDTO u : userAgeRatioDTOS) {
            ageLabels.add(u.getAgeRatio());
            ageData.add(u.getValue());
            // 차트 색상을 동적으로 생성
            String backgroundColor = String.format("rgba(%d, %d, %d, 0.5)",
                    random.nextInt(256), random.nextInt(256), random.nextInt(256));
            ageBackgroundColors.add(backgroundColor);
            ageBorderColors.add(backgroundColor.replace("0.5", "1"));
        }

        ageStats.setLabels(ageLabels);
        ageStats.setData(ageData);
        ageStats.setBackgroundColors(ageBackgroundColors);
        ageStats.setBorderColors(ageBorderColors);
        statsList.add(ageStats);


        ObjectMapper mapper = new ObjectMapper();
        String statsJson = mapper.writeValueAsString(statsList);


        model.addAttribute("statsList", statsList);
        model.addAttribute("statsJson", statsJson);


        // JSP 페이지로 이동
        return "/admin/chart";
    }


}
