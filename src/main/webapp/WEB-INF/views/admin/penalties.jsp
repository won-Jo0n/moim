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
    <%@ include file="adminSidebar.jsp" %>
    <div class="top-button-container">
        <button onclick="window.history.back()" class="back-to-home-button">돌아가기</button>
    </div>

    <div class="user-search-container">
        <h2>유저 검색</h2>
        <form action="/admin/penaltiesSearch" method="post">
            <input type="text" name="nickName" placeholder="유저 닉네임 입력" required />
            <input type="submit" value="검색" />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
    </div>

    <c:choose>
        <c:when test="${not empty resultUser}">
            <div class="user-search-result">
                <h2>검색 결과</h2>
                <div class="user-info-card">
                    <p><strong>아이디:</strong> ${resultUser.loginId}</p>
                    <p><strong>닉네임:</strong> ${resultUser.nickName}</p>
                    <p><strong>생성 날짜:</strong> ${resultUser.createdAt}</p>
                    <p><strong>마지막 접속 날짜:</strong> ${resultUser.lastLogin}</p>

                    <c:if test="${resultUser.status eq 0}">
                        <p class="penaltied-user">정지상태</p>
                        <p><strong>정지 해제 날짜: </strong>${formattedTime}</p>
                        <button onclick="clearPenalti(${resultUser.id})">정지 해제</button>
                    </c:if>
                    <div>
                        <a href="#" class="action-link">사용자 페이지 가기</a>
                    </div>
                </div>

                <div class="penalties-section">
                    <p><strong>정지하기</strong></p>
                    <form id="get-penalti" action="/admin/getPenalties" method="post">
                        <input type="hidden" name="nickName" value="${resultUser.nickName}" />
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <select name="penaltiesTerm" id="penaltiesTerm">
                            <option value="1">1일 정지</option>
                            <option value="7">1주일 정지</option>
                            <option value="30">1개월 정지</option>
                            <option value="365">1년 정지</option>
                            <option value="9999">영구 정지</option>
                        </select>
                        <input type="submit" value="정지"/>
                    </form>
                </div>
            </div>
            <div class="back-button-container">
                <button onclick="location.href='/admin/penalties'" class="back-button">정지 목록 보기</button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="penalties-list-container">
                <h2>정지된 유저 목록</h2>
                <table>
                    <thead>
                        <tr>
                            <th>유저 ID</th>
                            <th>유저 닉네임</th>
                            <th>정지 종료일</th>
                            <th>정지 해제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${penaltiesUserPage}">
                            <tr onclick="penaltiUserClickHandler('${user.nickName}')">
                                <td>${user.id}</td>
                                <td>${user.nickName}</td>
                                <td>${formattedTime[user.id]}</td>
                                <td><button onclick="event.stopPropagation(); clearPenalti(${user.id})">정지 해제</button></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

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
    window.onload = function(){
        <c:if test="${not empty sessionScope.errorMsg}">
            alert("${errorMsg}");
            <c:remove var="errorMsg" scope="session"/>
        </c:if>
    }

    const clearPenalti = (id) => {
        if (confirm("정지를 해제하시겠습니까?")) {
            location.href = "/admin/clearPenalti?id=" + id;
        }
    }

    function penaltiUserClickHandler(nickName) {
        const form = document.createElement('form');
        form.setAttribute('method', 'post');
        form.setAttribute('action', '/admin/penaltiesSearch');

        const nickNameInput = document.createElement('input');
        nickNameInput.setAttribute('type', 'hidden');
        nickNameInput.setAttribute('name', 'nickName');
        nickNameInput.setAttribute('value', nickName);

        const csrfInput = document.createElement('input');
        csrfInput.setAttribute('type', 'hidden');
        csrfInput.setAttribute('name', '${_csrf.parameterName}');
        csrfInput.setAttribute('value', '${_csrf.token}');

        form.appendChild(nickNameInput);
        form.appendChild(csrfInput);

        document.body.appendChild(form);

        form.submit();
    }

    const getPenalti = document.getElementById("get-penalti");
    getPenalti.addEventListener("submit", function(e){
        if(!confirm("사용자를 정지하시겠습니까?")){
            e.preventDefault();
        }
    });
</script>
</html>