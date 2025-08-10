package com.spring.groupboard.controller;

import com.spring.groupboard.dto.GroupBoardDTO;
import com.spring.groupboard.service.GroupBoardService;
import com.spring.groupboardcomment.dto.GroupBoardCommentDTO;
import com.spring.groupboardcomment.service.GroupBoardCommentService;
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
@RequestMapping("/groupboard")
public class GroupBoardController {

    private final GroupBoardService groupBoardService;
    private final FileUtil fileUtil;
    private final GroupBoardCommentService groupBoardCommentService;

    // 게시글 상세보기
    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id,
                         HttpSession session,
                         Model model){
        // 조회수 증가
        groupBoardService.increaseHits(id);

        GroupBoardDTO boardDTO = groupBoardService.findById(id);
        int loginUserId = (int) session.getAttribute("userId");
        List<GroupBoardCommentDTO> commentList = groupBoardCommentService.findByBoardId(id);

        boolean isAuthor = (loginUserId == boardDTO.getAuthor());
        model.addAttribute("board", boardDTO);
        model.addAttribute("isAuthor", isAuthor);
        model.addAttribute("commentList", commentList);

        return "groupBoard/detail";
    }

    // 게시글 작성 폼
    @GetMapping("/create")
    public String createForm(@RequestParam("groupId") int groupId, Model model)  {
        model.addAttribute("groupId", groupId);
        return "groupBoard/create";
    }


    // 게시글 작성 처리
    @PostMapping("/create")
    public String create(@ModelAttribute GroupBoardDTO groupBoardDTO,
                         HttpSession session,
                         @RequestParam(value = "groupBoardFile", required = false) MultipartFile file) throws IOException {

        if(!file.isEmpty()){
            int fileId = fileUtil.fileSave(file);
            groupBoardDTO.setFileId(fileId);
        }else{
            groupBoardDTO.setFileId(1);
        }
        int loginUserId = (int) session.getAttribute("userId");
        groupBoardDTO.setAuthor(loginUserId); // author: session으로 설정
        groupBoardService.save(groupBoardDTO);
        return "redirect:/group/detail?groupId=" + groupBoardDTO.getGroupId();
    }

    // 게시글 수정 폼
    @GetMapping("/update")
    public String updateForm(@RequestParam("id") int id,
                             HttpSession session,
                             Model model) {
        GroupBoardDTO board = groupBoardService.findById(id);
        int loginUserId = (int) session.getAttribute("userId");

        if (board.getAuthor() != loginUserId) {
            return "redirect:/group/list";
        }

        model.addAttribute("board", board);
        return "groupBoard/update";
    }

    // 수정 처리
    @PostMapping("/update")
    public String update(@ModelAttribute GroupBoardDTO dto) {
        groupBoardService.update(dto);
        return "redirect:/group/detail?groupId=" + dto.getGroupId();
    }

    // 게시글 삭제
    @PostMapping("/delete")
    public String delete(@RequestParam("id") int id, @RequestParam("groupId") int groupId) {
        groupBoardService.delete(id);
        return "redirect:/group/detail?groupId=" + groupId;
    }

}
