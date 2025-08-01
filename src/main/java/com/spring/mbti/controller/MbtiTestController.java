package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiTestDTO;
import com.spring.mbti.service.MbtiTestService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mbti")
public class MbtiTestController {

    private final MbtiTestService mbtiTestService;

    @GetMapping("/test")
    public String mbtiTestPage(Model model) {
        List<MbtiTestDTO> questionList = mbtiTestService.findAllQuestions();
        model.addAttribute("questions", questionList);
        return "MbtiFormViews/mbtiTest";
    }


    @PostMapping("/submit")
    public String mbtiTestSubmit(@RequestParam Map<String, String> map,
                                 HttpSession session, Model model) {
        List<MbtiTestDTO> questionList = mbtiTestService.findAllQuestions();
        String[] answers = new String[questionList.size()];
        for (int i = 0; i < answers.length; i++) {
            answers[i] = map.get("answers" + i);
        }

        int e = 0, i = 0, s = 0, n = 0, t = 0, f = 0, j = 0, p = 0;
        List<Integer> scoreList = new ArrayList<>();

        for (int idx = 0; idx < answers.length; idx++) {
            int score = 0;
            String raw = answers[idx];

            if (raw != null && !raw.equals("")) {
                try {
                    score = Integer.parseInt(raw);
                } catch (NumberFormatException ignored) {}
            }

            scoreList.add(score);
            String type = questionList.get(idx).getType().toLowerCase();

            switch (type) {
                case "ei": e += score; break;
                case "ie": i += score; break;
                case "sn": s += score; break;
                case "ns": n += score; break;
                case "tf": t += score; break;
                case "ft": f += score; break;
                case "jp": j += score; break;
                case "pj": p += score; break;
            }
        }

        StringBuilder result = new StringBuilder();
        result.append(i > e ? "I" : "E");
        result.append(n > s ? "N" : "S");
        result.append(f > t ? "F" : "T");
        result.append(p > j ? "P" : "J");
        String mbtiResult = result.toString();

        // ✅ 세션에서 loginId 꺼내서 → userId 조회
        Object loginIdObj = session.getAttribute("loginId");
        if (loginIdObj != null) {
            String loginId = loginIdObj.toString(); // ex) "ngchan03"
            int userId = mbtiTestService.findUserIdByLoginId(loginId); // 핵심
            mbtiTestService.calculateMbti(userId, scoreList);
        }

        model.addAttribute("mbtiResult", mbtiResult);
        return "MbtiFormViews/mbtiFormHome";
    }

}
