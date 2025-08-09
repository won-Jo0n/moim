<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>모임 상세 페이지</title>
</head>
<body>
    <h2>모임 상세 페이지</h2>
    <p><strong>모임명:</strong> ${group.title}</p>
    <img src="/file/preview?fileId=${group.fileId}" width="150" height="150"></img>
    <p><strong>모임 소개:</strong> ${group.description}</p>
    <p><strong>모임 지역:</strong> ${group.location}</p>
    <p><strong>최대 인원:</strong> ${group.maxUserNum}</p>
    <p><strong>생성일:</strong>
        <fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd" />
    </p>

    <!-- 로그인한 사용자가 모임장일 때만 수정/삭제 버튼 표시 -->
    <c:if test="${sessionScope.userId == group.leader}">
        <form action="/group/update" method="get">
            <input type="hidden" name="id" value="${group.id}"/>
            <button type="submit">수정</button>
        </form>

        <form action="/group/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
            <input type="hidden" name="id" value="${group.id}" />
            <button type="submit">삭제</button>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </c:if>

    <!-- 로그인한 사용자가 모임장이 아니고, 승인된 사용자가 아닐떄 참여 버튼 표시 -->
    <c:if test="${sessionScope.userId != group.leader and not isApprovedMember}">
      <c:choose>
        <c:when test="${isAppliedMember}">
          <form action="/groupjoin/cancel" method="post">
            <input type="hidden" name="groupId" value="${group.id}" />
            <button type="submit">참여 신청 취소</button>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          </form>
        </c:when>
        <c:otherwise>
          <form action="/groupjoin/apply" method="post">
            <input type="hidden" name="userId" value="${sessionScope.userId}"/>
            <input type="hidden" name="groupId" value="${group.id}" />
            <input type="submit" value="모임 참여 신청">
          </form>
        </c:otherwise>
      </c:choose>
    </c:if>

    <!-- 승인된 사람에게만 모임 탈퇴 버튼 표시 -->
    <c:if test="${isApprovedMember}">
        <form action="/groupjoin/leave" method="post" onsubmit="return confirm('정말 모임을 탈퇴하시겠습니까?');">
            <input type="hidden" name="groupId" value="${group.id}"/>
            <button type="submit">모임 탈퇴</button>
             <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </c:if>

    <!-- 로그인한 사용자가 모임장일 경우에만 신청 목록 보기 버튼 표시 -->
    <c:if test="${sessionScope.userId eq group.leader}">
        <form action="/groupjoin/requests" method="get">
            <input type="hidden" name="groupId" value="${group.id}"/>
            <button type="submit">참여 신청 목록 보기</button>
        </form>
    </c:if>

    <!-- 모임장일 경우에만 매니저 지정/해제 보기 버튼 표시 -->
    <c:if test="${sessionScope.userId eq group.leader}">
      <h3>매니저 관리</h3>
      <c:choose>
        <c:when test="${empty approvedMembers}">
          승인된 멤버가 없습니다.
        </c:when>
        <c:otherwise>
          <c:forEach var="m" items="${approvedMembers}">
            <div style="margin-bottom:8px;">
              <strong>${m.userName}</strong>
              <c:choose>
                <c:when test="${m.role eq 'manager'}">
                  <span style="margin-left:8px; color:#666;">[매니저]</span>
                  <form action="/group/manager/revoke" method="post" style="display:inline;">
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <input type="hidden" name="userId" value="${m.userId}" />
                    <button type="submit">매니저 해제</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  </form>
                </c:when>
                <c:otherwise>
                  <form action="/group/manager/assign" method="post" style="display:inline;">
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <input type="hidden" name="userId" value="${m.userId}" />
                    <button type="submit">매니저 지정</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  </form>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </c:if>

    <!-- 승인된 사람이거나 모임장일때만 모임게시판 글 작성 버튼 표시-->
    <c:if test="${isApprovedMember or isLeader}">
        <form action="/groupboard/create" method="get">
            <input type="hidden" name="groupId" value="${group.id}" />
            <button type="submit">글 작성</button>
        </form>
    </c:if>

    <c:if test="${canCreateSchedule}">
        <a href="/group/createSchedule?scheduleLeader=${sessionScope.userId}&groupId=${group.id}">그룹일정 생성</a>
    </c:if>

    <c:if test="${isLeader || isApprovedMember}">
        <h3> 게시판</h3>
        <c:forEach var="board" items="${boardList}">
             <div class="post-card" onclick="location.href='/groupboard/detail?id=${board.id}'">
                <img src="/file/preview?fileId=${board.fileId}"  width="80" height="80"/>
                <h4>${board.title}</h4>
                <p>${board.content}</p>
                <small>작성자: ${board.authorNickName}  작성일: ${board.createdAt}</small>
            </div>
        </c:forEach>
    </c:if>

    <c:choose>
        <c:when test="${not empty groupScheduleList}">
            <table>
                <thead>
                    <tr>
                        <th>리더</th>
                        <th>제목</th>
                        <th>설명</th>
                        <th>시작 시간</th>
                        <th>종료 시간</th>
                        <th>최대 인원</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="schedule" items="${groupScheduleList}">
                        <tr onclick="clickGroupScheduleDetail(${schedule.id});">
                            <td>${groupScheduleLeaderNickName[schedule.id]}</td>
                            <td>${schedule.title}</td>
                            <td>${schedule.description}</td>
                            <td>${schedule.startTime}</td>
                            <td>${schedule.endTime}</td>
                            <td>${schedule.maxUserNum}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${schedule.status eq 0}">
                                        모집중
                                    </c:when>
                                    <c:when test="${schedule.status eq 1}">
                                        모집 완료
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p class="no-schedules">등록된 그룹 스케줄이 없습니다.</p>
        </c:otherwise>
    </c:choose>
    <a href="/group/list">목록으로 돌아가기</a>
    <script>
        const clickGroupScheduleDetail = (id)=>{
            location.href="/group/groupScheduleDetail?id=" + id;
        }
    </script>
</body>
</html>