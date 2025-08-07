<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>review</title>
</head>
<body>

    <form action="/review/review" method="post">
         <!-- 리뷰 대상 정보 -->
        <input type="hidden" name="groupId" value="${sessionScope.groupId}" />
        <input type="hidden" name="groupScheduleId" value="${groupScheduleId}" />
        <input type="hidden" name="reviewer" value="${reviewer}" />
        <input type="hidden" name="userId" value="${userId}" />
        <!-- 평가 내용 입력 -->
        <textarea name="content" placeholder="평가를 남겨주세요!"></textarea>
        <!-- 별점 선택 -->
        <label>별점</label>
        <label><input type="radio" name="score" value="1" required /> 1점</label>
        <label><input type="radio" name="score" value="2" /> 2점</label>
        <label><input type="radio" name="score" value="3" /> 3점</label>
        <label><input type="radio" name="score" value="4" /> 4점</label>
        <label><input type="radio" name="score" value="5" /> 5점</label>
        <input type="submit" value="리뷰 남기기"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

</body>
</html>