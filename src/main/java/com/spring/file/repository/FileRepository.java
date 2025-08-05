package com.spring.file.repository;

import com.spring.file.dto.FileDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class FileRepository {
    private final SqlSessionTemplate sql;
    public void saveFile(FileDTO fileDTO) {
        int log = sql.insert("File.save", fileDTO);
        System.out.println(log);
    }

    public int getIdByFileName(String fileName) {
        return sql.selectOne("File.getIdByFileName", fileName);
    }

    public FileDTO getFileByFileId(int id) {
        return sql.selectOne("File.getFileByFileId", id);
    }
}
