<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 일정 상세보기</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <h2>모임 일정 상세보기</h2>
    <p>${leaderNickName}</p>
    <p>${groupScheduleDTO.title}</p>
    <p>${groupScheduleDTO.description}</p>
    <p>${groupScheduleDTO.startTime}</p>
    <p>${groupScheduleDTO.endTime}</p>
    <p>${groupScheduleDTO.maxUserNum}</p>
    <p>${groupScheduleDTO.status}</p>
    <button onclick="clickJoinSchedule(${sessionScope.userId}, ${groupScheduleDTO.id})">참여신청</button>

    <script>
        const clickJoinSchedule = (joinUser, scheduleId)=>{
            if(confirm("참여 신청하시겠습니까?")){
                location.href="/group/scheduleJoin?joinUserId=" + joinUser + "&scheduleId=" + scheduleId;
            }
        }
    </script>
</body>
</html>