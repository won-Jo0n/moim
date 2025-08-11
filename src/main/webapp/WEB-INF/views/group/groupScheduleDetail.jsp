<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 일정 상세보기</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="stylesheet" href="../resources/css/groupScheduleDetail.css">
</head>
<body>

<%-- 시작/종료 시간 문자열 처리 --%>
<c:set var="startStr" value=""/>
<c:catch>
  <fmt:formatDate value="${groupScheduleDTO.startTime}" pattern="yyyy.MM.dd HH:mm" var="startStr"/>
</c:catch>
<c:if test="${empty startStr}">
  <c:set var="startStr" value="${fn:replace(groupScheduleDTO.startTime, 'T', ' ')}"/>
</c:if>

<c:set var="endStr" value=""/>
<c:catch>
  <fmt:formatDate value="${groupScheduleDTO.endTime}" pattern="yyyy.MM.dd HH:mm" var="endStr"/>
</c:catch>
<c:if test="${empty endStr}">
  <c:set var="endStr" value="${fn:replace(groupScheduleDTO.endTime, 'T', ' ')}"/>
</c:if>

<%-- 상태 클래스 안전 적용 --%>
<c:set var="statusClass" value=""/>
<c:if test="${groupScheduleDTO.status == 1}">
  <c:set var="statusClass" value="closed"/>
</c:if>

<div class="page">
  <header class="page__header">
    <h2 class="page__title">모임 일정 상세보기</h2>
    <a class="link-back" href="javascript:history.back()">뒤로가기</a>
  </header>

  <!-- 일정 기본 정보 카드 -->
  <section class="card">
    <div class="card__head">
      <h3 class="card__title">기본 정보</h3>
      <p class="card__subtitle">일정의 주정보와 상태</p>
    </div>

    <div class="info-table">
      <div class="info-row">
        <div class="info-th">리더</div>
        <div class="info-td"><span class="badge">${leaderNickName}</span></div>
      </div>

      <div class="info-row">
        <div class="info-th">제목</div>
        <div class="info-td"><p class="info__title">${groupScheduleDTO.title}</p></div>
      </div>

      <div class="info-row info-row--desc">
        <div class="info-th">설명</div>
        <div class="info-td"><p class="info__desc">${groupScheduleDTO.description}</p></div>
      </div>

      <div class="info-row">
        <div class="info-th">시작</div>
        <div class="info-td"><p class="info__time">${startStr}</p></div>
      </div>

      <div class="info-row">
        <div class="info-th">종료</div>
        <div class="info-td"><p class="info__time">${endStr}</p></div>
      </div>

      <div class="info-row">
        <div class="info-th">정원</div>
        <div class="info-td"><p class="info__quota"><strong>${groupScheduleDTO.maxUserNum}</strong> 명</p></div>
      </div>
    </div>

    <!-- 상태/참여 영역 -->
    <div class="info-status ${statusClass}">
      <div class="status-left">
        <c:choose>
          <c:when test="${groupScheduleDTO.status == 0}">
            <div class="c-status c-status--open"><span class="c-status__dot"></span> 모집중</div>
          </c:when>
          <c:when test="${groupScheduleDTO.status == 1}">
            <div class="c-status c-status--closed"><span class="c-status__dot"></span> 모집 완료</div>
          </c:when>
        </c:choose>
      </div>

      <div class="status-right actions">
        <c:if test="${sessionScope.userId ne groupScheduleDTO.scheduleLeader && groupScheduleDTO.status == 0}">
          <c:choose>
            <c:when test="${empty myScheduleStatus or myScheduleStatus == -1}">
              <form action="/group/scheduleJoin" method="post" style="display:inline;">
                <input type="hidden" name="joinUserId" value="${sessionScope.userId}">
                <input type="hidden" name="scheduleId" value="${groupScheduleDTO.id}">
                <button type="submit" class="btn btn--ghost">참여 신청</button>
              </form>
            </c:when>
            <c:when test="${myScheduleStatus == 0}">
              <form action="/group/scheduleCancel" method="post" style="display:inline;">
                <input type="hidden" name="joinUserId" value="${sessionScope.userId}">
                <input type="hidden" name="scheduleId" value="${groupScheduleDTO.id}">
                <button type="submit" class="btn btn--ghost">신청 취소</button>
              </form>
            </c:when>
            <c:when test="${myScheduleStatus == 1}">
              <button class="btn btn--primary" disabled>참가 중</button>
            </c:when>
          </c:choose>
        </c:if>

        <c:if test="${sessionScope.userId eq groupScheduleDTO.scheduleLeader && groupScheduleDTO.status == 0}">
          <button class="btn btn--danger" onclick="endRecruit(${groupScheduleDTO.id})">모집 종료</button>
        </c:if>
      </div>
    </div>
  </section>

  <!-- 참여 신청 목록 (리더 전용) -->
  <c:if test="${sessionScope.userId eq groupScheduleDTO.scheduleLeader}">
    <section class="card">
      <div class="card__head">
        <h3 class="card__title">참여 신청 목록</h3>
        <p class="card__subtitle">대기/수락 상태를 관리하세요</p>
      </div>

      <div class="applicant-table">
        <div class="applicant-thead">
          <div class="applicant-th">신청자</div>
          <div class="applicant-th">정보</div>
          <div class="applicant-th th-actions">처리</div>
        </div>

        <c:forEach var="schedule" items="${scheduleList}">
          <div class="applicant-tr">
            <div class="applicant-td">
              <span class="badge">${schedule.nickName}</span>
            </div>
            <div class="applicant-td">
              <div class="applicant__meta">
                <span class="muted">★ ${schedule.rating}</span>
                <span class="muted">${schedule.region}</span>
                <span class="muted">${schedule.mbti}</span>
              </div>
            </div>
            <div class="applicant-td">
              <c:choose>
                <c:when test="${schedule.status == 0}">
                  <div class="actions">
                    <button class="btn btn--primary"
                            onclick="acceptHandler(${schedule.userId}, ${schedule.groupScheduleId})">
                      수락
                    </button>
                    <button class="btn btn--ghost"
                            onclick="refuseHandler(${schedule.userId}, ${schedule.groupScheduleId})">
                      거절
                    </button>
                  </div>
                </c:when>
                <c:when test="${schedule.status == 1}">
                  <div class="c-tag c-tag--approved">수락됨</div>
                </c:when>
              </c:choose>
            </div>
          </div>
        </c:forEach>
      </div>
    </section>
  </c:if>

  <!-- 리뷰 이동 -->
  <c:if test="${isDone}">
    <section class="card">
      <div class="card__head">
        <h3 class="card__title">리뷰</h3>
        <p class="card__subtitle">일정 종료 후 참가자 평가를 남겨주세요</p>
      </div>
      <form action="/review/review" method="get" class="review-form">
        <input type="hidden" name="groupScheduleId" value="${groupScheduleDTO.id}">
        <button type="submit" class="btn btn--primary">리뷰하러 가기</button>
      </form>
    </section>
  </c:if>
</div>

<script>
  // 리더 수락/거절/모집 종료 (기존 GET 로직 유지)
  const acceptHandler = (userId, groupScheduleId) => {
    if (confirm("수락 하시겠습니까?")) {
      location.href = "/group/accept?userId=" + userId + "&groupScheduleId=" + groupScheduleId;
    }
  };

  const refuseHandler = (userId, groupScheduleId) => {
    if (confirm("거절 하시겠습니까?")) {
      location.href = "/group/refuse?userId=" + userId + "&groupScheduleId=" + groupScheduleId;
    }
  };

  const endRecruit = (groupScheduleId) => {
    if (confirm("모집을 종료하시겠습니까?")) {
      location.href = "/group/endRecruit?groupScheduleId=" + groupScheduleId;
    }
  };
</script>
</body>
</html>
