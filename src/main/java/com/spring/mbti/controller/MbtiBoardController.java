package com.spring.mbti.controller;

import com.spring.mbti.dto.MbtiBoardDTO;
import com.spring.mbti.dto.MbtiBoardCommentDTO;
import com.spring.mbti.service.MbtiBoardCommentService;
import com.spring.mbti.service.MbtiBoardService;
import com.spring.user.dto.UserDTO;
import com.spring.user.service.UserService;
import com.spring.utils.FileUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;


@Controller
@RequiredArgsConstructor
@RequestMapping("/mbti/board")
public class MbtiBoardController {
    private final UserService userService;
    private final MbtiBoardService mbtiBoardService;
    private final MbtiBoardCommentService commentService;
    private final FileUtil fileUtil;

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

        System.out.println(mbtiBoardFile.getOriginalFilename());
        if (!mbtiBoardFile.isEmpty()) {
            int fileId = fileUtil.fileSave(mbtiBoardFile); // file 테이블 insert 후 PK 반환
            boardDTO.setFileId(fileId);
        } else {
            boardDTO.setFileId(null); // 핵심
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
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        // ✅ 세션당 1회만 조회수 증가 (서비스에 중복 방지 포함)
        mbtiBoardService.increaseHitsIfFirstView(session, id);

        // ✅ 증가 후 재조회
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        if (board == null) return "redirect:/mbti/board";

        List<MbtiBoardCommentDTO> commentList = commentService.findAllByBoardId(id);

        Object sessionUserIdObj = session.getAttribute("userId");
        boolean isAuthor = false;
        if (sessionUserIdObj != null) {
            int sessionUserId = Integer.parseInt(sessionUserIdObj.toString()); // int로 맞춤
            isAuthor = (board.getAuthor() == sessionUserId);
        }

        model.addAttribute("board", board);
        model.addAttribute("commentList", commentList);
         model.addAttribute("isAuthor", isAuthor);
        return "MbtiBoardViews/detail";
    }


    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model, HttpSession session) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);

        if (board == null) {
            return "redirect:/mbti/board";
        }

        Object sessionUserIdObj = session.getAttribute("userId");
        if (sessionUserIdObj == null) {
            return "redirect:/user/login";
        }

        int sessionUserId = Integer.parseInt(sessionUserIdObj.toString());
        if (board.getAuthor() != sessionUserId) {
            // 작성자가 아니면 수정 불가
            return "redirect:/mbti/board/detail/" + board.getId(); // 또는 403.jsp로
        }

        model.addAttribute("board", board);
        return "MbtiBoardViews/edit";
    }

    @PostMapping("/edit")
    public String update(@ModelAttribute MbtiBoardDTO boardDTO, HttpSession session) {
        MbtiBoardDTO origin = mbtiBoardService.findById((long) boardDTO.getId());
        if (origin == null) return "redirect:/mbti/board";

        Object sessionUserIdObj = session.getAttribute("userId");
        if (sessionUserIdObj == null) return "redirect:/user/login";

        int sessionUserId = Integer.parseInt(sessionUserIdObj.toString());
        if (origin.getAuthor() != sessionUserId) {
            return "redirect:/mbti/board/detail/" + origin.getId();
        }

        mbtiBoardService.update(boardDTO);
        return "redirect:/mbti/board/detail/" + boardDTO.getId();
    }


    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id, HttpSession session) {
        MbtiBoardDTO board = mbtiBoardService.findById(id);
        if (board == null) return "redirect:/mbti/board";

        Object sessionUserIdObj = session.getAttribute("userId");
        if (sessionUserIdObj == null) return "redirect:/user/login";

        int sessionUserId = Integer.parseInt(sessionUserIdObj.toString());
        if (board.getAuthor() != sessionUserId) {
            return "redirect:/mbti/board/detail/" + board.getId();
        }

        mbtiBoardService.delete(id);
        return "redirect:/mbti/board";
    }
}
