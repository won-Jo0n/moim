<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>MBTI 성향 테스트</title>
</head>
<body>
<h2>MBTI 테스트</h2>

<form action="/mbti/submit" method="post">

    <c:forEach var="question" items="${questions}" varStatus="status">
        <div style="margin-bottom: 20px">
            <p><b>Q${status.index + 1}.</b> ${question.question}</p>

            <%--
              name 속성을 "answers[인덱스]" 형태로 변경합니다.
              이렇게 해야 스프링이 DTO의 answers 리스트에 값을 순서대로 넣어줍니다.
            --%>
            <input type="radio" name="answers${status.index}" value="0"> 전혀아님
            <input type="radio" name="answers${status.index}" value="1"> 때때로
            <input type="radio" name="answers${status.index}" value="2"> 가끔
            <input type="radio" name="answers${status.index}" value="3"> 주로그럼
            <input type="radio" name="answers${status.index}" value="4"> 그냥나임
        </div>
    </c:forEach>

    <%-- input type="submit"은 text 속성 대신 value 속성을 사용합니다. --%>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <input type="submit" value="제출">
</form>
</body>

</html>