package com.spring.friends.controller;

import com.spring.friends.service.FriendsService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("friends")
@RequiredArgsConstructor
public class FriendsController {
    private final FriendsService friendsService;


}
