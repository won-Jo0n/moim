<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <c:if test="${sessionScope.userId eq groupScheduleDTO.scheduleLeader}">
        <p>참여 신청 목록보기</p>
        <c:forEach var="schedule" items="${scheduleList}">
            <div>
                <p>닉네임: ${schedule.nickName}</p>
                <p>별점: ${schedule.rating}</p>
                <p>사용자 지역: ${schedule.region}</p>
                <p>사용자 mbti: ${schedule.mbti}</p>
            </div>
            <c:if test="${schedule.status eq 0}">
                <button onclick="acceptHandler(${schedule.userId}, ${schedule.groupScheduleId})">참여수락</button>
                <button onclick="refuseHandler()">참여거절</button>
            </c:if>
            <c:if test="${schedule.status eq 1}">
                수락된 사용자
            </c:if>
        </c:forEach>
        <c:if test="${groupScheduleDTO.status eq 0}">
            <button onclick="endRecruit(${groupScheduleDTO.id})">모집종료</button>
        </c:if>
    </c:if>

    <c:choose>
        <c:when test="${groupScheduleDTO.status eq 0}">
            모집중
            <c:if test="${sessionScope.userId ne groupScheduleDTO.scheduleLeader}">
                <button onclick="clickJoinSchedule(${sessionScope.userId}, ${groupScheduleDTO.id})">참여신청</button>
            </c:if>
        </c:when>
        <c:when test="${groupScheduleDTO.status eq 1}">
            모집 완료
        </c:when>
    </c:choose>


    <c:if test="${isDone}">
        <c:forEach var= "schedule" items="${scheduleList}">
            <c:if test="${sessionScope.userId eq schedule.userId && schedule.status eq 1}">
                <a href="/review/review?id=${groupScheduleDTO.id}">리뷰하러 가기</a>
            </c:if>
        </c:forEach>
    </c:if>

    <script>
        const clickJoinSchedule = (joinUser, scheduleId)=>{
            if(confirm("참여 신청하시겠습니까?")){
                location.href="/group/scheduleJoin?joinUserId=" + joinUser + "&scheduleId=" + scheduleId;
            }
        }

        const acceptHandler = (userId, groupScheduleId)=>{
            if(confirm("수락 하시겠습니까?")){
                location.href = "/group/accept?userId="+userId+"&groupScheduleId="+groupScheduleId;
            }
        }

        const endRecruit = (groupScheduleId)=>{
            if(confirm("모집을 종료하시겠습니까?")){
                location.href = "/group/endRecruit?groupScheduleId="+groupScheduleId;
            }
        }
    </script>
</body>
</html>