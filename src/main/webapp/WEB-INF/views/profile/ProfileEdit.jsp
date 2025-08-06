<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>프로필 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/profile.css">
    <style>
        .edit-form-container {
            max-width: 600px;
            margin: 50px auto;
            background: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .edit-form-container h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .form-buttons {
            text-align: center;
            margin-top: 30px;
        }
        .form-buttons button {
            padding: 10px 20px;
            font-size: 14px;
            margin: 0 10px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
        }
        .submit-btn {
            background-color: #4a72ff;
            color: white;
        }
        .cancel-btn {
            background-color: #ddd;
        }
    </style>
</head>
<body>
<div class="edit-form-container">
    <h2>프로필 수정</h2>
    <form action="${pageContext.request.contextPath}/profile/update" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="userId" value="${profile.userId}" />

        <div class="form-group">
            <label for="nickname">닉네임</label>
            <input type="text" name="nickname" id="nickname" value="${profile.nickname}" required />
        </div>

        <div class="form-group">
            <label for="mbti">MBTI</label>
            <select name="mbtiId" id="mbti" required>
                <c:forEach var="mbti" items="${mbtiList}">
                    <option value="${mbti.id}" <c:if test="${mbti.mbti == profile.mbti}">selected</c:if>>
                        ${mbti.mbti}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-buttons">
            <button type="submit" class="submit-btn">수정하기</button>
            <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
        </div>
    </form>
</div>
</body>
</html>
