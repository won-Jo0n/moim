package com.spring.friends.controller;

import com.spring.friends.dto.FriendsDTO;
import com.spring.friends.service.FriendsService;
import com.spring.user.dto.UserDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("friends")
@RequiredArgsConstructor
public class FriendsController {
    private final FriendsService friendsService;

    private Integer sessionUserId(HttpSession session){
        Object o = session.getAttribute("userId");
        if (o instanceof Integer) return (Integer) o;
        if (o instanceof Long)    return ((Long) o).intValue();
        if (o instanceof UserDTO) {
            Object id = ((UserDTO) o).getId();
            if (id instanceof Integer) return (Integer) id;
            if (id instanceof Long)    return ((Long) id).intValue();
        }
        return null;
    }

    @PostMapping("/request")
    public ResponseEntity<?> requestFriend(@RequestBody FriendsDTO dto, HttpSession session) {
        Integer me = sessionUserId(session);
        if (me == null) return ResponseEntity.status(401).build();

        // 본인 제외
        if (me.equals(dto.getResponseUserId())) {
            return ResponseEntity.badRequest().body("본인에게는 요청 불가");
        }

        dto.setRequestUserId(me);
        dto.setStatus(0); // PENDING
        friendsService.addFriend(dto); // <-- 필드명 맞춤
        return ResponseEntity.ok("친구 요청을 보냈습니다.");
    }

    @PostMapping("/cancel")
    public ResponseEntity<?> cancel(@RequestBody FriendsDTO dto, HttpSession session){
        Integer me = sessionUserId(session);
        if (me == null) return ResponseEntity.status(401).build();

        dto.setRequestUserId(me);
        friendsService.cancelFriend(dto); // <-- 필드명 맞춤
        return ResponseEntity.ok().build();
    }
}
