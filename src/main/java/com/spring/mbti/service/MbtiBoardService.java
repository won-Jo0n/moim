package com.spring.mbti.service;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.repository.MbtiBoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MbtiBoardService {

    private final MbtiBoardRepository mbtiBoardRepository;

    public int save(MbtiBoardDTO dto) {
        return mbtiBoardRepository.save(dto);
    }

    public List<MbtiBoardDTO> findAllByMbtiId(int mbtiId) {
        return mbtiBoardRepository.findAllByMbtiId(mbtiId);
    }

    public MbtiBoardDTO findById(int id) {
        return mbtiBoardRepository.findById(id);
    }

    public int update(MbtiBoardDTO dto) {
        return mbtiBoardRepository.update(dto);
    }

    public int delete(int id) {
        return mbtiBoardRepository.delete(id);
    }
}
