package com.spring.admin.service;

import com.spring.admin.dto.PenaltiDTO;
import com.spring.admin.repository.AdminRepository;
import com.spring.report.dto.ReportDTO;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {
    private final AdminRepository adminRepository;

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
}
