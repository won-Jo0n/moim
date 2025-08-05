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
            <input type="hidden" name="userId" value="${sessionScope.userId}"
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

    <!-- 승인된 사람이거나 모임장일때만 모임게시판 글 작성 버튼 표시-->
    <c:if test="${isApprovedMember or isLeader}">
        <form action="/groupboard/create" method="get">
            <input type="hidden" name="groupId" value="${group.id}" />
            <button type="submit">글 작성</button>
        </form>
    </c:if>

    <c:if test="${isLeader || isApprovedMember}">
        <h3> 게시판</h3>
        <c:forEach var="board" items="${boardList}">
             <div class="post-card" onclick="location.href='/groupboard/detail?id=${board.id}'">
                <h4>${board.title}</h4>
                <p>${board.content}</p>
                <small>작성자: ${board.authorNickName}  작성일: ${board.createdAt}</small>
            </div>
        </c:forEach>
    </c:if>

    <a href="/group/list">← 목록으로 </a>
</body>
</html>