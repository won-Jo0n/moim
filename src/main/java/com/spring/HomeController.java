package com.spring;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.service.MbtiBoardService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import com.spring.userdetails.CustomerUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class HomeController {
    private final MbtiBoardService mbtiBoardService;
    private final UserService userService;
    @GetMapping("/")
    public String index(){
        return "index";
    }

    @GetMapping("/home")
    public String home(Model model, HttpSession session){
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomerUserDetails userDetails = (CustomerUserDetails) auth.getPrincipal();
        UserDTO loginUser = userDetails.getUserDTO();

        // OAuth 로그인을 위한 예외처리
        if(loginUser.getStatus() == -1) return "redirect:/";

        if (loginUser.getStatus() == 0 && loginUser.getBanEndTime() != null && loginUser.getBanEndTime().isAfter(LocalDateTime.now())) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String formattedDate = loginUser.getBanEndTime().format(formatter);
            String message = String.format("정지된 계정입니다. 제재 해제 날짜: %s", formattedDate);
            throw new DisabledException(message); // 로그인 거부
        }
        if (loginUser.getStatus() == 0 && loginUser.getBanEndTime() != null && loginUser.getBanEndTime().isBefore(LocalDateTime.now())) {
            // 사용자 상태를 정상으로 되돌리는 로직
            loginUser.setStatus(1);
            loginUser.setBanEndTime(null);
            userService.updateUserStatus(loginUser); // DB에 업데이트
        }

        session.setAttribute("userId", loginUser.getId());

        model.addAttribute("loginUser", loginUser);


        //List<MbtiBoardDTO> boardList = mbtiBoardService.findAll();
        //model.addAttribute("boardList", boardList);

        return "home";
    }



}
