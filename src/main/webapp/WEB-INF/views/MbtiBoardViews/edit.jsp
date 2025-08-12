<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>게시글 수정</title>
    <style>
        :root{ --lavender:#B18FCF; --purple:#7E57C2; --royal:#5E35B1; --lilac:#CBAACB; --white:#fff; --text-dark:#333; }
        body{ font-family:'Arial',sans-serif; background:var(--lavender); padding:40px; }
        .form-container{ background:var(--white); max-width:600px; margin:auto; padding:30px; border-radius:12px; box-shadow:0 0 15px rgba(0,0,0,.15); }
        h1{ text-align:center; color:var(--purple); margin-bottom:25px; }
        input[type="text"],textarea{ width:100%; padding:12px; margin-bottom:16px; border:1px solid #ccc; border-radius:8px; font-size:14px; }
        .current-file{ background:#faf7ff; border:1px solid #E0D4F7; border-radius:10px; padding:12px; margin-bottom:14px; }
        .thumb{ width:100%; max-height:180px; object-fit:cover; border-radius:10px; display:block; }
        input[type="file"]{ display:none; }
        .file-row{ display:flex; align-items:center; gap:10px; margin-bottom:16px; }
        .file-label{ display:inline-block; padding:10px 20px; background:var(--purple); color:#fff; border-radius:8px; cursor:pointer; font-size:14px; }
        .file-name{ font-size:14px; color:var(--text-dark); }
        input[type="submit"]{ background:var(--royal); color:#fff; border:none; padding:12px 24px; border-radius:8px; cursor:pointer; width:100%; font-size:16px; }
        input[type="submit"]:hover{ background:var(--purple); }
    </style>
</head>
<body>
<div class="form-container">
    <h1>게시글 수정</h1>
    <form action="/mbti/board/edit" method="post" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="id" value="${board.id}" />

        <label>제목:</label>
        <input type="text" name="title" value="${board.title}" required/>

        <label>내용:</label>
        <!-- ▼ 내용 textarea만 사이즈 확대 -->
        <textarea name="content" required rows="14" style="min-height:260px;">${board.content}</textarea>

        <div class="current-file">
            <c:choose>
                <c:when test="${not empty board.fileId && board.fileId ne 0}">
                    <div style="margin-bottom:8px;color:#5b4aa8;font-weight:600">현재 첨부 파일</div>
                    <img class="thumb" src="/file/preview?fileId=${board.fileId}" alt="현재 첨부 이미지"
                         onerror="this.style.display='none'"/>
                </c:when>
                <c:otherwise>
                    <span style="color:#6b6b6b">현재 첨부 파일: 없음</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="file-row">
            <label for="mbtiBoardFile" class="file-label">📁 파일 변경</label>
            <span id="file-name" class="file-name">선택된 파일 없음</span>
            <input type="file" id="mbtiBoardFile" name="mbtiBoardFile" />
        </div>

        <input type="submit" value="수정 완료"/>
    </form>
</div>

<script>
document.getElementById("mbtiBoardFile").addEventListener("change", function(){
    const fileName = this.files.length ? this.files[0].name : "선택된 파일 없음";
    document.getElementById("file-name").textContent = fileName;
});
</script>
</body>
</html>
