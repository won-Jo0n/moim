package com.spring.notification.controller;

import com.spring.notification.dto.NotificationDTO;
import com.spring.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notification")
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping
    @ResponseBody
    public List<NotificationDTO> findAllByUserId(HttpSession session){
        int userId = (int) session.getAttribute("userId");
        return notificationService.findAllByUserId(userId);
    }
}
