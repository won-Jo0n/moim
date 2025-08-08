package com.spring.friends.controller;

import com.spring.friends.dto.FriendsDTO;
import com.spring.friends.service.FriendsService;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
@RequestMapping("friends")
@RequiredArgsConstructor
public class FriendsController {
    private final FriendsService friendsService;

    @GetMapping("/pending")
    public List<UserDTO> pendingFriends(HttpSession session){
        int userId = (int)session.getAttribute("userId");
        System.out.println(userId);
        return friendsService.pendingFriends(userId);
    }

    @GetMapping("/update")
    public void update(@RequestParam("reqId") int reqId, @RequestParam("status") int status, HttpSession session){
        int userId = (int)session.getAttribute("userId");
        FriendsDTO friendsDTO = new FriendsDTO();
        friendsDTO.setRequestUserId(reqId);
        friendsDTO.setResponseUserId(userId);
        friendsDTO.setStatus(status);
        friendsService.updateFriend(friendsDTO);
    }
}
