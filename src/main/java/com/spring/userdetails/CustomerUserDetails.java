package com.spring.userdetails;

import com.spring.user.dto.UserDTO;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.util.Collection;
import java.util.Collections;

public class CustomerUserDetails implements UserDetails, Serializable {
    private static final long serialVersionUID = 1L;
    private final UserDTO userDTO; // UserDTO 객체를 포함

    public CustomerUserDetails(UserDTO userDTO) {
        this.userDTO = userDTO;
    }

    // 실제 로그인된 사용자 정보를 가져올 때 사용
    public UserDTO getUserDTO() {
        return userDTO;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // UserDTO에 권한 정보가 있다면 여기서 매핑
        // 예: userDTO.getRoles() 등
        return Collections.singletonList(new SimpleGrantedAuthority(userDTO.getRole()));
    }

    @Override
    public String getPassword() {
        return userDTO.getPassword();
    }

    @Override
    public String getUsername() {
        return userDTO.getLoginId(); // UserDetails의 username은 loginId로 사용
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true; // userDTO.getStatus() == 1 등으로 활성 여부 판단
    }
}
