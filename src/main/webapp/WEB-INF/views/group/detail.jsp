<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>모임 상세 페이지</title>
    <link rel="stylesheet" href="../resources/css/groupDetail.css" >
</head>
<body>
    <div class="group-info-container">
        <!-- 그룹 헤더 레이아웃 (이미지 좌측, 정보 테이블 우측) -->
        <div class="group-hero">
          <div class="group-hero__media">
            <img class="group-hero__img"
                 src="/file/preview?fileId=${group.fileId}"
                 alt="${group.title} 대표 이미지">
          </div>

          <div class="group-hero__body">
            <h2 class="group-hero__title">${group.title}</h2>

            <table class="info-table">
              <tbody>
                <tr>
                  <th>모임 소개</th>
                  <td>${group.description}</td>
                </tr>
                <tr>
                  <th>모임 지역</th>
                  <td>${group.location}</td>
                </tr>
                <tr>
                  <th>최대 인원</th>
                  <td>${group.maxUserNum}</td>
                </tr>
                <tr>
                  <th>생성일</th>
                  <td><fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd" /></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div style="margin-top: 1.5rem;">
            <c:if test="${sessionScope.userId == group.leader}">
                <form action="/group/update" method="get">
                    <input type="hidden" name="id" value="${group.id}"/>
                    <<button type="button"
                                 class="btn btn-primary"
                                 onclick="location.href='/group/update?groupId=${group.id}'">
                             수정
                         </button>
                </form>
                <form action="/group/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <button type="submit" class="btn-danger">삭제</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </form>
            </c:if>

            <c:if test="${sessionScope.userId != group.leader and not isApprovedMember}">
              <c:choose>
                <c:when test="${isAppliedMember}">
                  <form action="/groupjoin/cancel" method="post">
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <button type="submit" class="btn-secondary">참여 신청 취소</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  </form>
                </c:when>
                <c:otherwise>
                  <form action="/groupjoin/apply" method="post">
                    <input type="hidden" name="userId" value="${sessionScope.userId}"/>
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <button type="submit" class="btn-primary">모임 참여 신청</button>
                  </form>
                </c:otherwise>
              </c:choose>
            </c:if>

            <c:if test="${isApprovedMember}">
                <form action="/groupjoin/leave" method="post" onsubmit="return confirm('정말 모임을 탈퇴하시겠습니까?');">
                    <input type="hidden" name="groupId" value="${group.id}"/>
                    <button type="submit" class="btn-secondary">모임 탈퇴</button>
                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </form>
            </c:if>

            <c:if test="${sessionScope.userId eq group.leader}">
                <form action="/groupjoin/requests" method="get">
                    <input type="hidden" name="groupId" value="${group.id}"/>
                    <button type="submit" class="btn-secondary">참여 신청 목록 보기</button>
                </form>
            </c:if>

            <c:if test="${isApprovedMember or isLeader}">
                <form action="/groupboard/create" method="get">
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <button type="submit">글 작성</button>
                </form>
            </c:if>

            <c:if test="${canCreateSchedule}">
                <button type="button"
                        class="btn btn-secondary"
                        onclick="location.href='/group/createSchedule?scheduleLeader=${sessionScope.userId}&groupId=${group.id}'">
                    그룹 일정 생성
                </button>
            </c:if>
        </div>
    </div>

    <c:if test="${sessionScope.userId eq group.leader}">
      <h3>매니저 관리</h3>
      <c:choose>
        <c:when test="${empty approvedMembers}">
          <p>승인된 멤버가 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="m" items="${approvedMembers}">
            <div class="manager-item">
              <strong>${m.userName}</strong>
              <div>
                  <c:choose>
                    <c:when test="${m.role eq 'manager'}">
                      <span class="manager-status">[매니저]</span>
                      <form action="/group/manager/revoke" method="post" style="display:inline;">
                        <input type="hidden" name="groupId" value="${group.id}" />
                        <input type="hidden" name="userId" value="${m.userId}" />
                        <button type="submit" class="btn-secondary">매니저 해제</button>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      </form>
                    </c:when>
                    <c:otherwise>
                      <form action="/group/manager/assign" method="post" style="display:inline;">
                        <input type="hidden" name="groupId" value="${group.id}" />
                        <input type="hidden" name="userId" value="${m.userId}" />
                        <button type="submit" class="btn-primary">매니저 지정</button>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      </form>
                    </c:otherwise>
                  </c:choose>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </c:if>


    <c:if test="${isLeader || isApprovedMember}">
        <h3>게시판</h3>
        <c:forEach var="board" items="${boardList}">
             <div class="post-card" onclick="location.href='/groupboard/detail?id=${board.id}'">
                <img src="/file/preview?fileId=${board.fileId}" alt="게시글 이미지"/>
                <div>
                    <h4>${board.title}</h4>
                    <p>${board.content}</p>
                    <small>작성자: ${board.authorNickName}  작성일: ${board.createdAt}</small>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <h3 style="margin-top: 3rem;">그룹 스케줄</h3>
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
    <a href="/group/list" class="back-link">목록으로 돌아가기</a>

    <script>
        const clickGroupScheduleDetail = (id)=>{
            location.href="/group/groupScheduleDetail?id=" + id;
        }
    </script>
</body>
</html>