<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>참여 신청자 목록</title>
</head>
<body>
    <h2>참여 신청자 목록</h2>

    <table>
        <thead>
            <tr>
                <th>닉네임</th>
                <th>신청상태</th>
                <th>처리</th>
            </tr>
        </thead>
        <tbody>

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

<a href="/group/detail?groupId=${groupId}">← 모임 상세로</a>
</body>
</html>