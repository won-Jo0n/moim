package com.spring.homefeed.controller;

import com.spring.file.dto.FileDTO;
import com.spring.file.service.FileService;
import com.spring.homefeed.dto.HomeFeedDTO;
import com.spring.homefeed.service.HomeFeedService;
import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.dto.MbtiDTO;
import com.spring.mbti.service.MbtiService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/homeFeed")
@RequiredArgsConstructor
public class HomeFeedController {
    private final HomeFeedService homeFeedService;
    private final UserService userService;
    private final MbtiService mbtiService;
    private final FileService fileService;

    @GetMapping("/getFeedList")
    public @ResponseBody List<HomeFeedDTO> getFeedList(HttpSession session){
        UserDTO user = userService.getUserById((int) session.getAttribute("userId"));
        List<HomeFeedDTO> homeFeedList = homeFeedService.getFeedList(user.getMbtiId());
        return homeFeedList;
    }
}
