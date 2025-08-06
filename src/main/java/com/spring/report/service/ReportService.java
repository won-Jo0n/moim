package com.spring.report.service;

import com.spring.report.dto.ReportDTO;
import com.spring.report.repository.ReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ReportService {
    private final ReportRepository reportRepository;

    public void report(ReportDTO reportDTO) {
        reportRepository.report(reportDTO);
    }

    public void reportComment(ReportDTO reportDTO) {
        reportRepository.reportComment(reportDTO);
    }

    public ReportDTO getReportById(int reportId) {
        return reportRepository.getReportById(reportId);
    }
}
