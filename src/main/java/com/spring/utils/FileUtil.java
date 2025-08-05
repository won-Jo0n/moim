package com.spring.utils;

import com.spring.file.dto.FileDTO;
import com.spring.file.service.FileService;
import lombok.RequiredArgsConstructor;
import lombok.experimental.UtilityClass;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class FileUtil {
    private final FileService fileService;

    public int fileSave(MultipartFile file) throws IOException {
        String originalFileName = file.getOriginalFilename();
        String uuid = UUID.randomUUID().toString();
        String storedFileName = uuid + "-" + originalFileName;
        String savePath = "C:/upload/" + storedFileName;


        file.transferTo(new File(savePath));

        FileDTO fileDTO = new FileDTO();
        fileDTO.setOriginalFileName(originalFileName);
        fileDTO.setFileName(storedFileName);

        fileService.saveFile(fileDTO);
        return fileService.getIdByFileName(fileDTO.getFileName());

    }


}
