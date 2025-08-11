<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모임 목록</title>
    <link rel="stylesheet" href="../resources/css/groupList.css">
</head>
<body>
<div class="group-list-wrap">
    <h2>모임 목록</h2>

    <div class="controls">
        <a href="/group/create" class="btn-create">모임 만들기</a>

        <form action="/group/list" method="get" class="search-form">
            <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${param.keyword}"/>
            <button type="submit">검색</button>
        </form>
    </div>

    <table class="group-table">
        <!-- 컬럼 폭 고정 -->
        <colgroup>
            <col style="width:18%"><!-- 모임명 -->
            <col style="width:12%"><!-- 대표 사진 -->
            <col style="width:10%"><!-- 모임 지역 -->
            <col style="width:37%"><!-- 모임 소개  -->
            <col style="width:8%"><!-- 최대 인원 -->
            <col style="width:15%"><!-- 생성일  -->
          </colgroup>

        <thead>
        <tr>
            <th>모임명</th>
            <th>대표 사진</th>
            <th>모임 지역</th>
            <th>모임 소개</th>
            <th>최대 인원</th>
            <th>생성일</th>
        </tr>
        </thead>

        <tbody>
        <c:choose>
            <c:when test="${not empty groupList}">
                <c:forEach var="group" items="${pageGroupList}">
                    <tr class="clickable-row" data-id="${group.id}">
                        <td class="td-title">${group.title}</td>

                        <td class="td-thumb">
                            <c:choose>
                                <c:when test="${not empty group.fileId}">
                                    <img src="/file/preview?fileId=${group.fileId}" alt="모임 대표 사진"/>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-image">이미지 없음</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="td-loc">${group.location}</td>

                        <!-- 100자까지만 노출 + 말줄임표, 전체 문장은 title로 -->
                        <td class="td-desc" title="${group.description}">
                            <c:choose>
                                <c:when test="${fn:length(group.description) > 100}">
                                    ${fn:substring(group.description, 0, 100)}…
                                </c:when>
                                <c:otherwise>
                                    ${group.description}
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="td-num">${group.maxUserNum}</td>

                        <td class="td-date">
                            <fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd"/>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="6">검색 결과가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <div class="paging-wrap">
        <c:if test="${pageInfo.currentPage > 1}">
            <a href="/group/list?page=${pageInfo.currentPage - 1}&keyword=${param.keyword}">&laquo; 이전</a>
        </c:if>

        <c:set var="startPage" value="${pageInfo.currentPage - 4 > 1 ? pageInfo.currentPage - 4 : 1}"/>
        <c:set var="endPage" value="${pageInfo.currentPage + 4 < pageInfo.totalPage ? pageInfo.currentPage + 4 : pageInfo.totalPage}"/>

        <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
            <a href="/group/list?page=${pageNum}&keyword=${param.keyword}" class="${pageNum == pageInfo.currentPage ? 'active' : ''}">${pageNum}</a>
        </c:forEach>

        <c:if test="${pageInfo.currentPage < pageInfo.totalPage}">
            <a href="/group/list?page=${pageInfo.currentPage + 1}&keyword=${param.keyword}">다음 &raquo;</a>
        </c:if>
    </div>
</div>

<script>
    document.querySelectorAll(".clickable-row").forEach(function(row) {
        row.addEventListener("click", function () {
            const id = this.dataset.id;
            window.location.href = "/group/detail?groupId=" + id;
        });
    });
</script>
</body>
</html>