package com.spring.admin.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.admin.dto.*;
import com.spring.admin.service.AdminService;
import com.spring.mbti.service.MbtiService;
import com.spring.page.dto.PageInfoDTO;
import com.spring.report.dto.ReportDTO;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final AdminService adminService;
    private final UserService userService;
    private final MbtiService mbtiService;

    @GetMapping("/")
    public String admin(Model model) throws JsonProcessingException {


        // 대기중인 신고 개수
        Long pendingReportsCount = adminService.countNotprocessReports();
        model.addAttribute("pendingReportsCount", pendingReportsCount);

        // 총 사용자 수
        Long totalUserCount = adminService.countAllUsers();
        model.addAttribute("totalUserCount", totalUserCount);

        // 제재중인 사용자 수
        int penaltiesUser = adminService.getPenaltiesUser().size();
        model.addAttribute("penaltiesUser", penaltiesUser);

        // 최근 신고내역(5개)
        List<ReportDTO> recentReports = adminService.getRecentReports();
        Map<Integer, String> formattedDate = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yy-MM-dd HH:mm");

        model.addAttribute("recentReports", recentReports);
        for(ReportDTO report : recentReports){
            formattedDate.put(report.getId(), report.getReportedAt().format(formatter));
        }
        model.addAttribute("formattedDate", formattedDate);

        // MBTI별 사용자 분포
        List<ChartDTO> statsList = new ArrayList<>();

        List<ChartCountDTO> mbtiCountList = mbtiService.getCountGroupByMbti();
        ChartDTO mbtiStats = new ChartDTO();
        mbtiStats.setTitle("MBTI별 가입자 수");
        mbtiStats.setType("bar");
        mbtiStats.setLabel("가입자 수");

        Random random = new Random();

        // mbtiStats 데이터
        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        List<String> backgroundColors = new ArrayList<>();
        List<String> borderColors = new ArrayList<>();

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

        ObjectMapper objectMapper = new ObjectMapper();
        String statsJson = objectMapper.writeValueAsString(statsList);
        model.addAttribute("statsJson", statsJson);
        model.addAttribute("activeMenu", "admin");


        return "/admin/admin";
    }



    @GetMapping("/report")
    public String report(Model model,
                         @RequestParam(value = "page", defaultValue = "1") int page,
                         @RequestParam(value = "size", defaultValue = "10") int size){

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        Map<Integer, String> reportUserName = new HashMap<>();
        Map<Integer, String> reportedUserName = new HashMap<>();
        Map<Integer, String> formattedDates  = new HashMap<>();

        Map<String, Object> params = new HashMap<>();
        params.put("limit", size);
        params.put("offset", (page - 1) * size);

        List<ReportDTO> reportPage = adminService.getPaginatedReports(params);



        for(ReportDTO reportDTO : reportPage){
            UserDTO reportUser = userService.getUserById(reportDTO.getReportUser());
            UserDTO reportedUser = userService.getUserById(reportDTO.getReportedUser());

            reportUserName.put(reportDTO.getId(),reportUser.getNickName());
            reportedUserName.put(reportDTO.getId(),reportedUser.getNickName());
            formattedDates.put(reportDTO.getId(), reportDTO.getReportedAt().format(formatter));
        }

        long totalReports = adminService.countAllReports();
        int totalPages = (int) Math.ceil((double) totalReports / size);

        PageInfoDTO pageInfo = new PageInfoDTO();
        pageInfo.setCurrentPage(page);
        pageInfo.setTotalPage(totalPages);
        pageInfo.setPageSize(size);
        pageInfo.setTotalItems(totalReports);

        model.addAttribute("reportPage", reportPage);
        model.addAttribute("reportUserMap", reportUserName);
        model.addAttribute("reportedUserMap", reportedUserName);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("formattedDates", formattedDates);

        model.addAttribute("activeMenu", "report");

        return "/admin/report";
    }

    @GetMapping("/penalties")
    public String penalties(Model model,
                            @RequestParam(value = "page", defaultValue = "1")int page,
                            @RequestParam(value = "size", defaultValue = "10") int size){
        Map<String, Object> params = new HashMap<>();
        Map<Integer, String> formattedTime = new HashMap<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");


        params.put("limit", size);
        params.put("offset", (page - 1) * size);

        List<UserDTO> penaltiesUserPage = adminService.getPaginatedPenalties(params);

        for(UserDTO user : penaltiesUserPage){
            formattedTime.put(user.getId(), user.getBanEndTime().format(formatter));
        }

        List<UserDTO> penaltiesUser = adminService.getPenaltiesUser();
        long totalUsers = penaltiesUser.size();
        int totalPages = (int) Math.ceil((double) totalUsers / size);

        PageInfoDTO pageInfo = new PageInfoDTO();

        pageInfo.setCurrentPage(page);
        pageInfo.setTotalPage(totalPages);
        pageInfo.setPageSize(size);
        pageInfo.setTotalItems(totalUsers);

        model.addAttribute("penaltiesUser", penaltiesUser);
        model.addAttribute("penaltiesUserPage", penaltiesUserPage);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("formattedTime", formattedTime);

        model.addAttribute("activeMenu", "penalties");
        return "/admin/penalties";
    }

    @PostMapping("/penaltiesSearch")
    public String penaltiesSearch(@RequestParam("nickName") String nickName, Model model, HttpSession session){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        UserDTO userDTO = adminService.getUserByNickName(nickName);

        if(userDTO == null){
            session.setAttribute("errorMsg", "존재하지 않는 사용자입니다.");
            return "redirect:/admin/penalties";
        }

        if(userDTO.getStatus() == 0){
            String formattedTime = userDTO.getBanEndTime().format(formatter);
            model.addAttribute("formattedTime", formattedTime);
        }

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
    public String chart(Model model) throws JsonProcessingException {
        List<ChartDTO> statsList = new ArrayList<>();

        List<ChartCountDTO> mbtiCountList = mbtiService.getCountGroupByMbti();
        ChartDTO mbtiStats = new ChartDTO();
        mbtiStats.setTitle("MBTI별 가입자 수");
        mbtiStats.setType("bar");
        mbtiStats.setGridArea("A");
        mbtiStats.setLabel("가입자 수");

        List<UserGenderRatioDTO> userGenderRatioDTOS = mbtiService.getCountGroupByGender();
        ChartDTO genderStats = new ChartDTO();
        genderStats.setTitle("유저 성별 비율");
        genderStats.setType("bar");
        genderStats.setGridArea("B");
        genderStats.setLabel("사용자 수");

        List<UserAgeRatioDTO> userAgeRatioDTOS = mbtiService.getCountGroupByAge();
        ChartDTO ageStats = new ChartDTO();
        ageStats.setTitle("나이별 유저 비율");
        ageStats.setType("bar");
        ageStats.setGridArea("C");
        ageStats.setLabel("사용자 수");


        List<MbtiGroupActivityAverageDTO> mbtiGroupActivityAverageDTOS = mbtiService.getMbtiGroupActivity();
        ChartDTO activityStats = new ChartDTO();
        activityStats.setTitle("mbti별 모임 활동량");
        activityStats.setType("bar");
        activityStats.setGridArea("D");
        activityStats.setLabel("활동량");



        Random random = new Random();

        // mbtiStats 데이터
        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        List<String> backgroundColors = new ArrayList<>();
        List<String> borderColors = new ArrayList<>();

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

        // mbti별 모임 활동량
        List<String> activityStatsLabels = new ArrayList<>();
        List<Integer> activityStatsData = new ArrayList<>();
        List<String> activityStatsBackgroundColors = new ArrayList<>();
        List<String> activityStatsBorderColors = new ArrayList<>();

        for (MbtiGroupActivityAverageDTO ma : mbtiGroupActivityAverageDTOS) {
            activityStatsLabels.add(ma.getMbti());
            activityStatsData.add(ma.getValue());
            // 차트 색상을 동적으로 생성
            String backgroundColor = String.format("rgba(%d, %d, %d, 0.5)",
                    random.nextInt(256), random.nextInt(256), random.nextInt(256));
            activityStatsBackgroundColors.add(backgroundColor);
            activityStatsBorderColors.add(backgroundColor.replace("0.5", "1"));
        }

        activityStats.setLabels(activityStatsLabels);
        activityStats.setData(activityStatsData);
        activityStats.setBackgroundColors(activityStatsBackgroundColors);
        activityStats.setBorderColors(activityStatsBorderColors);
        statsList.add(activityStats);


        ObjectMapper mapper = new ObjectMapper();
        String statsJson = mapper.writeValueAsString(statsList);


        model.addAttribute("statsList", statsList);
        model.addAttribute("statsJson", statsJson);
        model.addAttribute("activeMenu", "chart");

        // JSP 페이지로 이동
        return "/admin/chart";
    }

    @GetMapping("/processReport")
    public String processReport(@RequestParam int id){
        adminService.processReport(id);

        return "redirect:/admin/report";
    }


}
