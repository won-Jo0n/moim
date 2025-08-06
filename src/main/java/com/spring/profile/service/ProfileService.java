package com.spring.profile.service;

import com.spring.profile.dto.ProfileDTO;
import com.spring.profile.repository.ProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProfileService {

    private final ProfileRepository profileRepository;

    public ProfileDTO findByUserId(Long userId) {
        return profileRepository.findByUserId(userId);
    }

    public void updateProfile(ProfileDTO profileDTO) {
        profileRepository.updateProfile(profileDTO);
    }

    public List<ProfileDTO> findAcceptedFriends(Long userId) {
        return profileRepository.findAcceptedFriends(userId);
    }
}
