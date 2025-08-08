package com.spring.scheduler;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MySchedulerService {
    private final MySchedulerRepository mySchedulerRepository;

    public void deleteOldUserData() {
        mySchedulerRepository.deleteOldUserData();
    }


    public void unblockUser() {
        mySchedulerRepository.unblockUser();
    }

    public void deleteOldChatData() {
        mySchedulerRepository.deleteOldChatData();
    }
}
