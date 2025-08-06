<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 일정 만들기</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <h2>모임 일정 만들기</h2>
    <form action="/group/createSchedule" method="post">
        <input type="hidden" name="scheduleLeader" value="${scheduleLeader}"/>
        <input type="hidden" name="groupId" value="${groupId}"/>
        <input type="text" name="title" placeholder="일정 제목을 입력해주세요"/>
        <textArea name="description" placeholder="일정 설명을 입력해주세요"></textArea>
        <label for="startTime">시작시간</label>
        <input id="startTime" type="datetime-local" name="startTime"/>
        <label for="endTime">종료시간</label>
        <input id="endTime" type="datetime-local" name="endTime"/>
        <input type="number" name="maxUserNum" placeholder="최대 인원"/>
        <input type="submit" value="일정 생성"/>
    </form>
</body>
</html>