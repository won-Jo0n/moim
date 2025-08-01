package com.spring;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.json.JSONObject;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.UUID;

@Controller
public class OAuthController {
    @GetMapping("/oauthLogin")
    public String naverLogin(HttpSession session) throws UnsupportedEncodingException {
        String clientId = "BLDL0iNoSfM6b2JzShDS";
        String redirectURI = java.net.URLEncoder.encode("http://localhost:8080/naver/callback", "UTF-8");
        String state = UUID.randomUUID().toString();
        session.setAttribute("naver_state", state);

        String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code"
                + "&client_id=" + clientId
                + "&redirect_uri=" + redirectURI
                + "&state=" + state;
        return "redirect:" + apiURL;
    }

    @RequestMapping(value = "/naver/callback", method = RequestMethod.GET)
    public String naverCallback(@RequestParam String code,
                                @RequestParam String state,
                                HttpSession session, Model model) throws Exception {
        String sessionState = (String) session.getAttribute("naver_state");
        if (!state.equals(sessionState)) {
            throw new IllegalStateException("잘못된 state 값입니다.");
        }

        // 1. Access Token 요청
        String clientId = "BLDL0iNoSfM6b2JzShDS";
        String clientSecret = "m8VmOxWdus";
        String redirectURI = URLEncoder.encode("http://localhost:8080/naver/callback", "UTF-8");

        String tokenURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
                + "&client_id=" + clientId
                + "&client_secret=" + clientSecret
                + "&code=" + code
                + "&state=" + state;

        URL url = new URL(tokenURL);
        HttpURLConnection con = (HttpURLConnection)url.openConnection();
        con.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String line, response = "";
        while ((line = br.readLine()) != null) {
            response += line;
        }
        br.close();

        // JSON 파싱
        JSONObject json = new JSONObject(response);
        String accessToken = json.getString("access_token");

        // 2. 사용자 정보 요청
        URL infoUrl = new URL("https://openapi.naver.com/v1/nid/me");
        HttpURLConnection infoCon = (HttpURLConnection) infoUrl.openConnection();
        infoCon.setRequestMethod("GET");
        infoCon.setRequestProperty("Authorization", "Bearer " + accessToken);

        BufferedReader infoBr = new BufferedReader(new InputStreamReader(infoCon.getInputStream()));
        String infoLine, userInfo = "";
        while ((infoLine = infoBr.readLine()) != null) {
            userInfo += infoLine;
        }
        infoBr.close();

        JSONObject userJson = new JSONObject(userInfo);
        JSONObject responseObj = userJson.getJSONObject("response");
        for(String key : responseObj.keySet()){
            System.out.println(key);
            System.out.println(key + ": " + responseObj.get(key));
        }

        return "redirect:/"; // 로그인 성공 후 이동할 페이지
    }
}

