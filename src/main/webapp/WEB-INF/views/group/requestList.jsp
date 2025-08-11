<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>모임 참여요청/멤버 관리</title>
    <link rel="stylesheet" href="../resources/css/groupRequestList.css" >
</head>
<body>
<div class="page">
    <header class="page__header">
        <h1 class="page__title">모임 참여요청 / 멤버 관리</h1>
        <a class="link-back" href="<c:url value='/group/detail?groupId=${groupId}'/>">← 모임 상세로</a>
    </header>

    <!-- 대기중 요청 -->
    <section class="card">
        <div class="card__head">
            <h2 class="card__title">대기 중인 참여요청</h2>
        </div>

        <c:choose>
            <c:when test="${empty pendingList}">
                <div class="empty-state">
                    <p>현재 대기 중인 참여 요청이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>닉네임</th>
                            <th>신청상태</th>
                            <th class="col-actions">처리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="request" items="${pendingList}">
                            <tr>
                                <td>
                                    <span class="user">
                                        <span class="user__avatar" aria-hidden="true">${fn:substring(request.nickName,0,1)}</span>
                                        <span class="user__name">${request.nickName}</span>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${request.status eq 'pending'}">
                                            <span class="badge badge--pending">대기</span>
                                        </c:when>
                                        <c:when test="${request.status eq 'rejected'}">
                                            <span class="badge badge--rejected">거절</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge">상태: ${request.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="actions">
                                    <form action="<c:url value='/groupjoin/approve'/>" method="post" class="inline-form">
                                        <input type="hidden" name="userId" value="${request.userId}"/>
                                        <input type="hidden" name="groupId" value="${groupId}"/>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn--approve">승인</button>
                                    </form>
                                    <form action="<c:url value='/groupjoin/reject'/>" method="post" class="inline-form">
                                        <input type="hidden" name="userId" value="${request.userId}"/>
                                        <input type="hidden" name="groupId" value="${groupId}"/>
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn--reject">거절</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- 승인된 멤버 -->
    <section class="card">
        <div class="card__head">
            <h2 class="card__title">승인된 멤버</h2>
            <p class="card__subtitle">매니저 지정/해제 관리</p>
        </div>

        <c:choose>
            <c:when test="${empty approvedMembers}">
                <div class="empty-state">
                    <p>승인된 멤버가 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="member-list">
                    <c:forEach var="m" items="${approvedMembers}">
                        <li class="member">
                            <div class="member__main">
                                <span class="user">
                                    <span class="user__avatar" aria-hidden="true">${fn:substring(m.userName,0,1)}</span>
                                    <strong class="user__name">${m.userName}</strong>
                                </span>

                                <c:if test="${m.role eq 'manager'}">
                                    <span class="chip chip--manager">매니저</span>
                                </c:if>
                            </div>
                            <div class="member__actions">
                                <c:choose>
                                    <c:when test="${m.role eq 'manager'}">
                                        <form action="<c:url value='/groupjoin/manager/revoke'/>" method="post" class="inline-form">
                                            <input type="hidden" name="groupId" value="${groupId}" />
                                            <input type="hidden" name="targetUserId" value="${m.userId}" />
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn--ghost">매니저 해제</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="<c:url value='/groupjoin/manager/grant'/>" method="post" class="inline-form">
                                            <input type="hidden" name="groupId" value="${groupId}" />
                                            <input type="hidden" name="targetUserId" value="${m.userId}" />
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn--outline">매니저 지정</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </section>
</div>
</body>
</html>