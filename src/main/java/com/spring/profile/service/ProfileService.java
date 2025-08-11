package com.spring.profile.service;

import com.spring.group.dto.GroupDTO;
import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.repository.ProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProfileService {
    private final ProfileRepository profileRepository;

    public ProfileDTO getProfile(Long userId) {
        return profileRepository.findByUserId(userId);
    }

    public List<ProfileDTO> getFriendList(Long userId) {
        return profileRepository.findFriendsByUserId(userId);
    }
    public MbtiBoardDTO findById(Long id) {
        return profileRepository.findById(id);
    }

    public ProfileDTO findByUserId(Long userId) {
        return profileRepository.findByUserId(userId);
    }

    public void updateFileId(Long userId, Integer fileId) {
        profileRepository.updateFileId(userId, fileId);
    }

    public String getPasswordHash(Long userId) {
        return profileRepository.selectPasswordHash(userId);
    }

    @org.springframework.transaction.annotation.Transactional
    public void withdraw(Long userId) {
        profileRepository.deleteUser(userId); // 하드 삭제 (연관 FK 있으면 소프트로 전환)
    }

    public List<GroupDTO> getGroupList(Long userId) {
        return profileRepository.findGroupsByUserId(userId);
    }


}
