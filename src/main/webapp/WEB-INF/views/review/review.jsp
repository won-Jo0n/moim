<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>review</title>
</head>
<body>

    <c:choose>
      <c:when test="${empty joinUser}">
        <p>리뷰 가능한 대상이 없습니다.</p>
        <c:if test="${not empty groupId}">
            <button type="button" onclick="location.href='/group/detail?groupId=${groupId}'">뒤로가기</button>
        </c:if>
      </c:when>
      <c:otherwise>
        <!-- 기존 form 시작 -->
        <form action="/review/review" method="post">
          <input type="hidden" name="groupScheduleId" value="${groupScheduleId}" />
          <label for="userId">리뷰 대상자</label>
          <select id="userId" name="userId" required>
            <option value="" disabled selected>대상을 선택하세요</option>
            <c:forEach var="p" items="${joinUser}">
              <option value="${p.id}">${p.nickName}</option>
            </c:forEach>
          </select>

          <textarea name="content" placeholder="평가를 남겨주세요!"></textarea>

          <div>
            <label>별점</label>
            <label><input type="radio" name="score" value="1" required /> 1점</label>
            <label><input type="radio" name="score" value="2" /> 2점</label>
            <label><input type="radio" name="score" value="3" /> 3점</label>
            <label><input type="radio" name="score" value="4" /> 4점</label>
            <label><input type="radio" name="score" value="5" /> 5점</label>
          </div>

          <input type="submit" value="리뷰 남기기"/>
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        </form>
        <!-- 기존 form 끝 -->
      </c:otherwise>
    </c:choose>

</body>
</html>