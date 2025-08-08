package com.spring.scheduler;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class MySchedulerRepository {
    private final SqlSessionTemplate sql;

    public void deleteOldUserData() {
        sql.delete("Scheduler.deleteOldUserData");
    }


    public void unblockUser() {
        sql.update("Scheduler.unblockUser");
    }

    public void deleteOldChatData() {
        sql.delete("Scheduler.deleteOldChatData");
    }
}

