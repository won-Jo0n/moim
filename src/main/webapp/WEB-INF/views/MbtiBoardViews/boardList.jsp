<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>MBTI 게시판</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #fafafa;
            margin: 0;
            padding: 40px;
        }

        .list-container {
            max-width: 800px;
            margin: 0 auto;
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
        }

        .write-btn {
            display: block;
            width: fit-content;
            background-color: #3897f0;
            color: white;
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            margin: 0 auto 20px auto;
            font-weight: bold;
        }

        .write-btn:hover {
            background-color: #2878c9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 14px 10px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }

        th {
            background-color: #f5f5f5;
            font-weight: bold;
        }

        td.title {
            text-align: left;
        }

        a.post-link {
            color: #262626;
            text-decoration: none;
        }

        a.post-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="list-container">
    <h1>MBTI 게시판</h1>
    <a href="/mbti/board/write" class="write-btn">글쓰기</a>
    <table>
        <thead>
        <tr>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="board" items="${boardList}">
            <tr>
                <td class="title">
                    <a class="post-link" href="/mbti/board/detail/${board.id}">
                        ${board.title}
                    </a>
                </td>
                <td>${board.authorInfo}</td>
                <td>${board.formattedCreatedAt}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
