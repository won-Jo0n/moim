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

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ResponseBody;

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
                       @RequestParam(value = "mbtiBoardFile", required = false) MultipartFile mbtiBoardFile) throws IOException {

        // 파일 저장 (⚠️ 딱 한 번만)
        if (mbtiBoardFile != null && !mbtiBoardFile.isEmpty()) {
            int fileId = fileUtil.fileSave(mbtiBoardFile);
            boardDTO.setFileId(fileId);
        } else {
            boardDTO.setFileId(null);
        }

        Object uidObj = session.getAttribute("userId");
        if (uidObj == null) return "redirect:/user/login";
        int userId = Integer.parseInt(uidObj.toString());

        UserDTO loginUser = userService.getUserById(userId);
        if (loginUser == null) return "redirect:/user/login";

        boardDTO.setAuthor(loginUser.getId());
        mbtiBoardService.save(boardDTO);
        return "redirect:/home";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        mbtiBoardService.increaseHitsIfFirstView(session, id);

        MbtiBoardDTO board = mbtiBoardService.findById(id);
        if (board == null) return "redirect:/mbti/board";

        List<MbtiBoardCommentDTO> commentList = commentService.findAllByBoardId(id);

        Object sessionUserIdObj = session.getAttribute("userId");
        boolean isAuthor = false;
        if (sessionUserIdObj != null) {
            int sessionUserId = Integer.parseInt(sessionUserIdObj.toString());
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
            return "redirect:/mbti/board/detail/" + board.getId();
        }

        model.addAttribute("board", board);
        return "MbtiBoardViews/edit";
    }

    // ✨ 파일 교체 반영 (MultipartFile 수신 + fileId 조건부 갱신)
    @PostMapping("/edit")
    public String update(@ModelAttribute MbtiBoardDTO boardDTO,
                         HttpSession session,
                         @RequestParam(value = "mbtiBoardFile", required = false) MultipartFile mbtiBoardFile) throws IOException {

        MbtiBoardDTO origin = mbtiBoardService.findById((long) boardDTO.getId());
        if (origin == null) return "redirect:/mbti/board";

        Object sessionUserIdObj = session.getAttribute("userId");
        if (sessionUserIdObj == null) return "redirect:/user/login";

        int sessionUserId = Integer.parseInt(sessionUserIdObj.toString());
        if (origin.getAuthor() != sessionUserId) {
            return "redirect:/mbti/board/detail/" + origin.getId();
        }

        // 제목/내용 교체
        origin.setTitle(boardDTO.getTitle());
        origin.setContent(boardDTO.getContent());

        // 새 파일이 올라오면 fileId 교체 (없으면 null 그대로 두어 Mapper에서 스킵)
        if (mbtiBoardFile != null && !mbtiBoardFile.isEmpty()) {
            int newFileId = fileUtil.fileSave(mbtiBoardFile);
            origin.setFileId(newFileId);
        } else {
            origin.setFileId(null); // null이면 Mapper에서 fileId 갱신 안 함
        }

        mbtiBoardService.update(origin);
        return "redirect:/mbti/board/detail/" + origin.getId();
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

    @PostMapping(value = "/{id}/file", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseBody
    public java.util.Map<String, Object> replaceFileAjax(@PathVariable Long id,
                                                         @RequestParam("mbtiBoardFile") MultipartFile file,
                                                         HttpSession session) throws IOException {
        MbtiBoardDTO origin = mbtiBoardService.findById(id);
        if (origin == null) {
            return java.util.Map.of("ok", false, "message", "NOT_FOUND");
        }

        Object uid = session.getAttribute("userId");
        Integer userId = (uid instanceof Integer) ? (Integer) uid : null;
        if (userId == null || origin.getAuthor() != userId) {
            return java.util.Map.of("ok", false, "message", "FORBIDDEN");
        }

        if (file == null || file.isEmpty()) {
            return java.util.Map.of("ok", false, "message", "EMPTY_FILE");
        }

        int newFileId = fileUtil.fileSave(file);     // 파일 저장 → PK 반환
        origin.setFileId(newFileId);
        mbtiBoardService.updateFileId(origin);       // fileId만 업데이트

        String previewUrl = "/file/preview?fileId=" + newFileId;
        return java.util.Map.of("ok", true, "fileId", newFileId, "previewUrl", previewUrl);
    }
}
