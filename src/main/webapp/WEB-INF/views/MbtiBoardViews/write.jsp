<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 작성</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #e9ecef;
            padding: 40px;
        }
        .form-container {
            background: white;
            max-width: 600px;
            margin: auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        input[type="text"],
        textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>게시글 작성</h1>
    <form action="/mbti/board/write" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <label>제목: <input type="text" name="title" required/></label>
        <label>내용: <textarea name="content" required></textarea></label>
        <label for="mbtiBoardFile">파일 첨부</label>
        <input type="file" id="mbtiBoardFile" name="mbtiBoardFile" /> <br>
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
</script>
</body>
</html>
