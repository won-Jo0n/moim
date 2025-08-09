package com.spring.scheduler;

import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@EnableScheduling
@RequiredArgsConstructor
public class MyScheduler {
    private final MySchedulerService mySchedulerService;

    @Scheduled(cron = "0 0 4 * * ?")
    public void dailyCheck() {
        // 탈퇴한지 6개월이 지난 사용자 데이터 삭제
        mySchedulerService.deleteOldUserData();

        // 정지 일자가 지난 사용자들 정지 해제
        mySchedulerService.unblockUser();

        // 채팅 데이터 3개월 지나면 삭제
        mySchedulerService.deleteOldChatData();
    }
}
