package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.dto.MbtiBoardCommentDTO;
import com.spring.mbti.service.MbtiBoardCommentService;
import com.spring.mbti.service.MbtiBoardService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mbti/board")
public class MbtiBoardController {
    private final UserService userService;
    private final MbtiBoardService mbtiBoardService;
    private final MbtiBoardCommentService commentService;

    @GetMapping
    public String boardList(Model model) {
        List<MbtiBoardDTO> boardList = mbtiBoardService.findAll();
        model.addAttribute("boardList", boardList);
        return "MbtiBoardViews/boardList";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "MbtiBoardViews/write";
    }

    @PostMapping("/write")
    public String save(@ModelAttribute MbtiBoardDTO boardDTO,
                       HttpSession session,
                       @RequestParam(value = "mbtiBoardFile", required = false)MultipartFile mbtiBoardFile) throws IOException {
        if(!mbtiBoardFile.isEmpty()){
            String originalFileName = mbtiBoardFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String storedFileName = uuid + "_" + originalFileName;
            String savePath = "C:/upload/" + storedFileName;

            mbtiBoardFile.transferTo(new File(savePath));


        }
        int userId = (int) session.getAttribute("userId");
        System.out.println(userId);
        UserDTO loginUser = userService.getUserById(userId);
        if (loginUser == null) {
            return "redirect:/user/login"; // 로그인 안 됐으면 로그인 페이지로
        }

        boardDTO.setAuthor(loginUser.getId()); // 여기서 작성자 ID 세팅
        mbtiBoardService.save(boardDTO);
        return "redirect:/mbti/board";
    }


    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        List<MbtiBoardCommentDTO> commentList = commentService.findAllByBoardId(id); // ✅ 수정됨
        model.addAttribute("board", board);
        model.addAttribute("commentList", commentList);
        return "MbtiBoardViews/detail";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        model.addAttribute("board", board);
        return "MbtiBoardViews/edit";
    }

    @PostMapping("/edit")
    public String update(@ModelAttribute MbtiBoardDTO boardDTO) {
        mbtiBoardService.update(boardDTO);
        return "redirect:/mbti/board/detail/" + boardDTO.getId();
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        mbtiBoardService.delete(id);
        return "redirect:/mbti/board";
    }
}
