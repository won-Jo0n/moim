package com.spring.friends;

import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("friends")
@RequiredArgsConstructor
public class FriendsController {
    private final FriendsService friendsService;

    @GetMapping("/chat")
    @ResponseBody
    public List<UserDTO> chatFriends(HttpSession session){
        int userId = (int) session.getAttribute("userId");
        return friendsService.getAllFriends(userId);
    }
}
