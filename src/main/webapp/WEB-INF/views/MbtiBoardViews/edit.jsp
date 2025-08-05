<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게시글 수정</title>
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
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>게시글 수정</h1>
    <form action="/mbti/board/edit" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="id" value="${board.id}" /> <!-- ✨ 이거 추가 -->

        <label>제목: <input type="text" name="title" value="${board.title}" required/></label>
        <label>내용: <textarea name="content" required>${board.content}</textarea></label>

        <input type="submit" value="수정 완료"/>
    </form>
</div>
</body>
</html>