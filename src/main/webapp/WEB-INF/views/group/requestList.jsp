<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>모임 참여요청/멤버 관리</title>
</head>
<body>
    <h2>모임 참여요청 목록</h2>

    <table>
        <thead>
            <tr>
                <th>닉네임</th>
                <th>신청상태</th>
                <th>처리</th>
            </tr>
        </thead>
        <tbody>

        <c:forEach var="m" items="${pendingList}">
          <div>${m.userName} | 상태: ${m.status}</div>
        </c:forEach>

        <c:forEach var="m" items="${approvedMembers}">
          <div>${m.userName} | 역할: ${m.role}</div>
        </c:forEach>

        <c:choose>
          <c:when test="${empty pendingList}">
            <p>현재 대기 중인 참여 요청이 없습니다.</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="request" items="${pendingList}">
                <tr>
                    <td>${request.nickName}</td>
                    <td>${request.status}</td>
                     <td>
                        <form action="/groupjoin/approve" method="post">
                            <input type="hidden" name="userId" value="${request.userId}"/>
                            <input type="hidden" name="groupId" value="${groupId}"/>
                            <button type="submit">승인</button>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </form>
                        <form action="/groupjoin/reject" method="post">
                            <input type="hidden" name="userId" value="${request.userId}"/>
                            <input type="hidden" name="groupId" value="${groupId}"/>
                            <button type="submit">거절</button>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </form>
                    </td>
                </tr>
            </c:forEach>
          </c:otherwise>
          </c:choose>
        </tbody>
    </table>

    <h2>승인된 멤버 (매니저 지정/해제)</h2>
      <c:choose>
        <c:when test="${empty approvedMembers}">
          <p>승인된 멤버가 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="m" items="${approvedMembers}">
            <div style="margin-bottom:8px;">
              <strong>${m.userName}</strong>
              <c:choose>
                <c:when test="${m.role eq 'manager'}">
                  <span style="margin-left:8px; color:#666;">[매니저]</span>
                  <form action="/groupjoin/manager/revoke" method="post" style="display:inline; margin-left:6px;">
                    <input type="hidden" name="groupId" value="${groupId}" />
                    <input type="hidden" name="targetUserId" value="${m.userId}" />
                    <button type="submit">매니저 해제</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  </form>
                </c:when>
                <c:otherwise>
                  <form action="/groupjoin/manager/grant" method="post" style="display:inline; margin-left:6px;">
                    <input type="hidden" name="groupId" value="${groupId}" />
                    <input type="hidden" name="targetUserId" value="${m.userId}" />
                    <button type="submit">매니저 지정</button>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  </form>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>

<a href="/group/detail?groupId=${groupId}">← 모임 상세로</a>
</body>
</html>