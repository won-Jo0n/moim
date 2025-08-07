<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 유저 제재</title>
    <link rel="stylesheet" href="../resources/css/penalties.css">
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <h2>유저 검색</h2>

        <form action="/admin/penaltiesSearch" method="post">
            <input type="text" name="nickName" placeholder="유저 닉네임 입력" required />
            <input type="submit" value="검색" />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>

        <c:choose>
            <c:when test="${not empty resultUser}">
                <h2>검색 결과</h2>
                <p>아이디: ${resultUser.loginId}</p>
                <p>닉네임: ${resultUser.nickName}</p>
                <p>생성 날짜: ${resultUser.createdAt}</p>
                <p>마지막 접속 날짜: ${resultUser.lastLogin}</p>
                <a href="#">사용자 페이지 가기</a>
                <p>정지하기</p>
                <form action="/admin/getPenalties" method="post">
                    <select name="penaltiesTerm" id="penaltiesTerm">
                        <option value="1">1일 정지</option>
                        <option value="7">1주일 정지</option>
                        <option value="30">1개월 정지</option>
                        <option value="365">1년 정지</option>
                        <option value="9999">영구 정지</option>
                    </select>
                    <input type="hidden" name="nickName" value="${resultUser.nickName}" />
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="submit" value="정지"/>
                </form>
            </c:when>
            <c:otherwise>
                <h2>정지된 유저 목록</h2>
                <table>
                    <thead>
                        <tr>
                            <th>유저 ID</th>
                            <th>정지 종료일</th>
                            <th>정지 해제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${penaltiesUserPage}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.banEndTime}</td>
                                <td><button onclick="clearPenalti(${user.id})">정지 해제</button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="pagination">
                    <c:if test="${pageInfo.currentPage > 1}">
                        <a href="/admin/penalties?page=${pageInfo.currentPage - 1}">이전</a>
                    </c:if>

                    <c:forEach begin="1" end="${pageInfo.totalPage}" var="pageNumber">
                        <a href="/admin/penalties?page=${pageNumber}"
                           class="${pageNumber eq pageInfo.currentPage ? 'active' : ''}">
                           ${pageNumber}
                        </a>
                    </c:forEach>

                    <c:if test="${pageInfo.currentPage < pageInfo.totalPage}">
                        <a href="/admin/penalties?page=${pageInfo.currentPage + 1}">다음</a>
                    </c:if>
                </div>
                </c:otherwise>
        </c:choose>
</body>

<script>
    const clearPenalti = (id)=>{
        console.log(id);
        location.href="/admin/clearPenalti?id=" + id;
    }
</script>
</html>
