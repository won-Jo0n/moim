package com.spring.userdetails;


import com.spring.user.dto.UserDTO;
import com.spring.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class CustomerUserDetailService implements UserDetailsService {
    private final UserRepository userRepository;


    @Override
    public UserDetails loadUserByUsername(String loginId) throws UsernameNotFoundException {
        System.out.println("[DEBUG] loginId: " + loginId);
        UserDTO user = userRepository.getUserByLoginId(loginId);  // 아이디로 사용자 검색
        System.out.println("[DEBUG] user found: " + user);
        if (user == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + loginId);
        }
        // 1. status가 0이고, ban_end_time이 현재 시간보다 미래라면
        if (user.getStatus() == 0 && user.getBanEndTime() != null && user.getBanEndTime().isAfter(LocalDateTime.now())) {
            // 사용자에게 보낼 메시지 (예외 메시지)
            String message = String.format("정지된 계정입니다. 제재 해제 시간: %s", user.getBanEndTime());
            throw new DisabledException(message); // 로그인 거부
        }

        // 2. status가 0이지만, ban_end_time이 현재 시간보다 과거라면
        //    (즉, 제재 기간이 만료되었을 경우)
        if (user.getStatus() == 0 && user.getBanEndTime() != null && user.getBanEndTime().isBefore(LocalDateTime.now())) {
            // 사용자 상태를 정상으로 되돌리는 로직
            user.setStatus(1);
            user.setBanEndTime(null);
            userRepository.updateUserStatus(user); // DB에 업데이트
        }

        return new CustomerUserDetails(user);
    }
}
