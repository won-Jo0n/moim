<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 작성</title>
    <style>
        /* ================== Purple Theme Tokens ================== */
        :root{
            --lavender:#B18FCF;   /* 메인 배경, 큰 버튼 */
            --purple:#7E57C2;     /* 로고/강조 텍스트 */
            --royal:#5E35B1;      /* 헤더/네비게이션 */
            --lilac:#CBAACB;      /* 카드/섹션 배경 */
            --white:#ffffff;
            --text-dark:#333333;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: var(--lavender);
            padding: 40px;
        }
        .form-container {
            background: var(--white);
            max-width: 600px;
            margin: auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.15);
        }
        h1 {
            text-align: center;
            color: var(--purple);
            margin-bottom: 25px;
        }
        input[type="text"],
        textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }
        input[type="file"] {
            display: none; /* 기본 파일 선택 버튼 숨김 */
        }
        .file-label {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--purple);
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            margin-bottom: 16px;
        }
        .file-name {
            margin-left: 10px;
            font-size: 14px;
            color: var(--text-dark);
        }
        input[type="submit"] {
            background-color: var(--royal);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 20px;
            width: 100%;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: var(--purple);
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>게시글 작성</h1>
    <form action="/mbti/board/write" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <label>제목:</label>
        <input type="text" name="title" required/>

        <label>내용:</label>
        <textarea name="content" required></textarea>

        <label for="mbtiBoardFile" class="file-label">파일 선택</label>
        <span id="file-name" class="file-name">선택된 파일 없음</span>
        <input type="file" id="mbtiBoardFile" name="mbtiBoardFile" />

        <input type="submit" value="작성 완료"/>
    </form>
</div>

<script>
function validateForm() {
    const fileInput = document.getElementById("mbtiBoardFile");
    if (!fileInput.value) {
        alert("파일을 첨부해 주세요.");
        return false;
    }
    return true;
}

document.getElementById("mbtiBoardFile").addEventListener("change", function(){
    const fileName = this.files.length ? this.files[0].name : "선택된 파일 없음";
    document.getElementById("file-name").textContent = fileName;
});
</script>
</body>
</html>
