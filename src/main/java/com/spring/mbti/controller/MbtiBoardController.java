package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.service.MbtiBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mbti/board")
public class MbtiBoardController {

    private final MbtiBoardService mbtiBoardService;

    @GetMapping("/{mbtiId}")
    public String list(@PathVariable int mbtiId, Model model) {
        List<MbtiBoardDTO> boardList = mbtiBoardService.findAllByMbtiId(mbtiId);
        model.addAttribute("boardList", boardList);
        return "MbtiBoardViews/boardList";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "MbtiBoardViews/write";
    }

    @PostMapping("/write")
    public String write(@ModelAttribute MbtiBoardDTO dto) {
        mbtiBoardService.save(dto);
        return "redirect:/mbti/board/" + dto.getMbtiId();
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable int id, Model model) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        model.addAttribute("board", board);
        return "MbtiBoardViews/detail";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable int id, Model model) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        model.addAttribute("board", board);
        return "MbtiBoardViews/edit";
    }

    @PostMapping("/edit")
    public String edit(@ModelAttribute MbtiBoardDTO dto) {
        mbtiBoardService.update(dto);
        return "redirect:/mbti/board/detail/" + dto.getId();
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable int id) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        mbtiBoardService.delete(id);
        return "redirect:/mbti/board/" + board.getMbtiId();
    }
}
