package com.spring.report.repository;

import com.spring.report.dto.ReportDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ReportRepository {
    private final SqlSessionTemplate sql;

    public void report(ReportDTO reportDTO) {
        sql.insert("Report.report",reportDTO);
    }

    public void reportComment(ReportDTO reportDTO) {
        sql.insert("Report.reportComment", reportDTO);
    }

    public ReportDTO getReportById(int reportId) {
        return sql.selectOne("Report.getReportById", reportId);
    }
}
