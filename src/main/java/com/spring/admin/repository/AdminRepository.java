package com.spring.admin.repository;

import com.spring.admin.dto.PenaltiDTO;
import com.spring.report.dto.ReportDTO;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class AdminRepository {
    private final SqlSessionTemplate sql;

    public List<ReportDTO> getReportList() {
        return sql.selectList("Admin.getReportList");
    }

    public List<UserDTO> getPenaltiesUser() {
        return sql.selectList("Admin.getPenaltiesUser");
    }


    public void getPenalti(PenaltiDTO penaltiDTO) {
        sql.update("Admin.getPenalti", penaltiDTO);
    }

    public UserDTO getUserByNickName(String nickName) {
        return sql.selectOne("Admin.getUserByNickName", nickName);
    }

    public void clearPenalti(int id) {
        sql.update("Admin.clearPenalti", id);
    }
}
