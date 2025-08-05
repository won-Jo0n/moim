package com.spring.file.controller;

import com.spring.file.dto.FileDTO;
import com.spring.file.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.nio.file.Files;

@Controller
@RequestMapping("/file")
@RequiredArgsConstructor
public class FileController {
    private final FileService fileService;

    @GetMapping("/preview")
    public void preview(@RequestParam("fileId") int fileId, HttpServletResponse response) throws IOException {
        FileDTO fileDTO = fileService.getFileByFileId(fileId);
        String filePath = "c:/upload/" + fileDTO.getFileName();
        File file = new File(filePath);

        if(file.exists()){
            String mimeType = Files.probeContentType(file.toPath());
            response.setContentType(mimeType);
            FileInputStream fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, response.getOutputStream());
            fis.close();
        }

    }

    @GetMapping("/download")
    public void download(@RequestParam("fileName") String fileName,
                         @RequestParam("originalFileName") String originalFileName,
                         HttpServletResponse response) throws IOException {
        String filePath = "c:/upload/" + fileName;
        File file = new File(filePath);

        if(file.exists()){
            response.setContentType("application/octet-stream");
            // 파일 이름 인코딩
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + URLEncoder.encode(originalFileName, "UTF-8") + "\"");

            // 파일 크기 설정
            response.setContentLength((int)file.length());

            FileInputStream fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, response.getOutputStream());
            fis.close();
        }
    }

}
