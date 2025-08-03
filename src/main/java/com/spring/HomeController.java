package com.spring;

import com.spring.friends.FriendsService;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class HomeController {
    private final FriendsService friendsService;

    @GetMapping("/")
    public String index(){
        return "index";
    }

    @GetMapping("/home")
    public String home(HttpSession httpSession) {
        //int userId = (int)httpSession.getAttribute("userId");
        //List<UserDTO> friends = friendsService.getAllFriends(userId);
        return "home";
    }
}
