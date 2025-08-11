package com.spring.admin.service;

import com.spring.admin.dto.PenaltiDTO;
import com.spring.admin.repository.AdminRepository;
import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.service.NotificationService;
import com.spring.report.dto.ReportDTO;
import com.spring.report.service.ReportService;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminService {
    private final AdminRepository adminRepository;
    private final NotificationService notificationService;
    private final ReportService reportService;

    public List<ReportDTO> getReportList() {
        return adminRepository.getReportList();
    }

    public List<UserDTO> getPenaltiesUser() {
        return adminRepository.getPenaltiesUser();
    }


    public void getPenalties(PenaltiDTO penaltiDTO) {
        adminRepository.getPenalti(penaltiDTO);
    }

    public UserDTO getUserByNickName(String nickName) {
        return adminRepository.getUserByNickName(nickName);
    }

    public void clearPenalti(int id) {
        adminRepository.clearPenalti(id);
    }


    public List<UserDTO> getPaginatedPenalties(Map<String, Object> params) {
        return adminRepository.getPaginatedPenalties(params);
    }

    public List<ReportDTO> getPaginatedReports(Map<String, Object> params) {
        return adminRepository.getPaginatedReports(params);
    }

    public long countAllReports() {
        return adminRepository.countAllReports();
    }

    public void processReport(int id) {
        adminRepository.porcessReport(id);
        ReportDTO reportDTO = reportService.getReportById(id);
        NotificationDTO notificationDTO = new NotificationDTO();
        notificationDTO.setUserId(reportDTO.getReportUser());
        notificationDTO.setRequestUserId(reportDTO.getReportUser());
        notificationDTO.setRelatedId(reportDTO.getReportedUser());
        notificationDTO.setType("REPORT_COMPLETED");
        notificationDTO.setContent(reportDTO.getTitle());
        notificationDTO.setPath(null);
        notificationService.createNotification(notificationDTO);
    }

    public Long countNotprocessReports() {
        return adminRepository.countNotprocessReports();
    }

    public Long countAllUsers() {
        return adminRepository.countAllUsers();
    }



    public List<ReportDTO> getRecentReports() {
        return adminRepository.getRecentReports();
    }
}
