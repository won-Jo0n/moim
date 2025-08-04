<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 참여요청 목록</title>

</head>
<body>
    <h2>모임 참여요청 목록</h2>

    <c:choose>
      <c:when test="${empty pendingList}">
        <p>현재 대기 중인 참여 요청이 없습니다.</p>
      </c:when>
      <c:otherwise>
        <c:forEach var="applicant" items="${pendingList}">
          <div>
            <p><strong>${applicant.userName}</strong> 님의 신청</p>

            <form action="/groupjoin/approve" method="post" style="display:inline;">
              <input type="hidden" name="userId" value="${applicant.userId}" />
              <input type="hidden" name="groupId" value="${applicant.groupId}" />
              <button type="submit">승인</button>
            </form>

            <form action="/groupjoin/reject" method="post" style="display:inline;">
              <input type="hidden" name="userId" value="${applicant.userId}" />
              <input type="hidden" name="groupId" value="${applicant.groupId}" />
              <button type="submit">거절</button>
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </form>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>


</body>
</html>