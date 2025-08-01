package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiSubmissionDTO;
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

    // MBTI 검사 페이지 요청
    @GetMapping("/test")
    public String mbtiTestPage(Model model) {
        List<MbtiTestDTO> questionList = mbtiTestService.findAllQuestions();
        model.addAttribute("questions", questionList);
        return "MbtiFormViews/mbtiTest";
    }

    // 검사 결과 처리
    @PostMapping("/submit")
    public String mbtiTestSubmit(@RequestParam Map<String, String> map,
                                 HttpSession session, Model model) {
        List<MbtiTestDTO> questionList = mbtiTestService.findAllQuestions();
        String[] answers = new String[questionList.size()];

        for (int ind = 0; ind < answers.length; ind++) {
            answers[ind] = map.get("answers" + ind);
        }

        // 점수 누적용 Map 초기화
        int e = 0, i = 0, s = 0, n = 0, t = 0, f = 0, j = 0, p = 0;

        for (int idx = 0; idx < answers.length; idx++) {
            String raw = answers[idx];
            int score = 0; // 기본값

            if (raw != null && !raw.equals("")) {
                try {
                    score = Integer.parseInt(raw);
                } catch (NumberFormatException ex) {
                    System.out.println("숫자 변환 실패: answers" + idx + " = " + raw);
                }
            } else {
                System.out.println("값 없음: answers" + idx);
            }

            String type = questionList.get(idx).getType().toLowerCase();

            switch (type) {
                case "ei":
                case "ie":
                    if (type.equals("ei")) e += score;
                    else i += score;
                    break;
                case "sn":
                case "ns":
                    if (type.equals("sn")) s += score;
                    else n += score;
                    break;
                case "tf":
                case "ft":
                    if (type.equals("tf")) t += score;
                    else f += score;
                    break;
                case "jp":
                case "pj":
                    if (type.equals("jp")) j += score;
                    else p += score;
                    break;
            }
        }

        // MBTI 결정
        StringBuilder result = new StringBuilder();
        result.append(i > e ? "I" : "E");
        result.append(n > s ? "N" : "S");
        result.append(f > t ? "F" : "T");
        result.append(p > j ? "P" : "J");

        String mbtiResult = result.toString();
        System.out.println("최종 MBTI 결과: " + mbtiResult);

        model.addAttribute("mbtiResult", mbtiResult);
        return "MbtiFormViews/mbtiFormHome";
    }
}