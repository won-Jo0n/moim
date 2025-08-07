package com.spring.customAuthenticationFailure;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {
    private String defaultFailureUrl = "/?error=true";

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
        String errorMsg;


        if (exception instanceof InternalAuthenticationServiceException) { // 이 부분을 추가
            errorMsg = exception.getMessage(); // DisabledException의 메시지를 그대로 사용
        }else{
            errorMsg = "로그인에 실패했습니다. 다시 시도해 주세요.";
        }
        request.getSession().setAttribute("loginErrorMsg", errorMsg);
        response.sendRedirect(defaultFailureUrl);
    }
}
