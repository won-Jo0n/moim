<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

        <form action="/group/list" method="get" class="search-form">
            <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${param.keyword}"/>
            <button type="submit">검색</button>
        </form>

        <table>
            <thead>
                <tr>
                    <th>모임명</th>
                    <th>대표 사진</th>
                    <th>모임 지역</th>
                    <th>모임 소개</th>
                    <th>최대 인원</th>
                    <th>생성일</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty groupList}">
                        <c:forEach var="group" items="${pageGroupList}">
                            <tr class="clickable-row" data-id="${group.id}">
                                <td>${group.title}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty group.fileId}">
                                            <img src="/file/preview?fileId=${group.fileId}" alt="모임 대표 사진" style="width: 50px; height: 50px; object-fit: cover;"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span>이미지 없음</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${group.location}</td>
                                <td>${group.description}</td>
                                <td>${group.maxUserNum}</td>
                                <td>
                                    <fmt:formatDate value="${group.createdAt}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${group.status == 1}">활성</c:when>
                                        <c:when test="${group.status == 0}">비활성</c:when>
                                        <c:otherwise>삭제됨</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7">검색 결과가 없습니다.</td>
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