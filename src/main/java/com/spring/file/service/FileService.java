package com.spring.file.service;

import com.spring.file.dto.FileDTO;
import com.spring.file.repository.FileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FileService {
    private final FileRepository fileRepository;

    public void saveFile(FileDTO fileDTO) {
        fileRepository.saveFile(fileDTO);
    }

    public int getIdByFileName(String fileName) {
        return fileRepository.getIdByFileName(fileName);
    }

    public FileDTO getFileByFileId(int id){
        return fileRepository.getFileByFileId(id);
    }

}
