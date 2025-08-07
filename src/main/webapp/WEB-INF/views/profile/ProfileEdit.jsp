<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>프로필 수정</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f8f8;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 20px;
        }
        input[type="text"],
        select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        input[type="file"] {
            margin-top: 10px;
        }
        .profile-preview {
            display: block;
            margin: 10px auto;
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #ccc;
        }
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        .button-group button {
            padding: 10px 20px;
            margin: 0 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .button-group button.cancel {
            background-color: #f44336;
        }
        .button-group button:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>프로필 수정</h2>
    <form action="/profile/update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <label for="nickname">닉네임</label>
        <input type="text" id="nickname" name="nickname" value="${profile.nickname}" required/>

        <label for="profileImage">프로필 사진</label>
        <img id="preview" src="<c:url value='/resources/images/default-profile.jpg' />" alt="미리보기" class="profile-preview"/>
        <input type="file" id="profileImage" name="profileImage" accept="image/*" onchange="previewImage(this)"/>

        <div class="button-group">
            <button type="submit">저장</button>
            <button type="button" class="cancel" onclick="location.href='/profile'">취소</button>
        </div>
    </form>
</div>

<script>
    function previewImage(input) {
        const preview = document.getElementById('preview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>
