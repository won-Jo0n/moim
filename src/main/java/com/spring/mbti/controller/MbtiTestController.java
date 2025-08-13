package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiTestDTO;
import com.spring.mbti.service.MbtiTestService;
import com.spring.user.dto.UserDTO;
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

    @GetMapping("/test/{number}")
    public String mbtiTestStep(@PathVariable int number, Model model) {
        List<MbtiTestDTO> questionList = mbtiTestService.findAllQuestions();
        int total = questionList.size();

        // 잘못된 번호 처리
        if (number < 1 || number > total) {
            return "redirect:/mbti/test/1";
        }

        MbtiTestDTO currentQuestion = questionList.get(number - 1);
        model.addAttribute("question", currentQuestion);
        model.addAttribute("currentNumber", number);
        model.addAttribute("totalNumber", total);

        return "MbtiFormViews/mbtiTestStep"; // 한 문항씩 보여줄 JSP
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

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj != null) {
            int userId = (userIdObj instanceof Integer) ? (int) userIdObj : Integer.parseInt(userIdObj.toString());
            mbtiTestService.calculateMbti(userId, scoreList, session);
        }



        model.addAttribute("mbtiResult", mbtiResult);
        return "MbtiFormViews/mbtiFormHome";
    }
}
