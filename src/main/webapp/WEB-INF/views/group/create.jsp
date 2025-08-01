<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 만들기</title>
</head>
<body>
    <h2>모임 만들기</h2>
    <form action="/group/create" method="post">
            <!-- 제목 -->
            <label for="title">모임 이름</label><br>
            <input type="text" id="title" name="title" placeholder="모임 이름을 입력하세요" required><br><br>



            <!-- 모임 소개 -->
            <label for="description">모임 소개</label><br>
            <textarea id="description" name="description" rows="5" cols="40" placeholder="모임을 소개해주세요" required></textarea><br><br>

            <!-- 지역 선택 -->
            <label for="location">지역</label><br>
            <select id="location" name="location" required>
                <option value="">-- 지역 선택 --</option>
                <option value="서울">서울</option>
                <option value="부산">부산</option>
                <option value="대구">대구</option>
                <option value="인천">인천</option>
                <option value="광주">광주</option>
                <option value="대전">대전</option>
                <option value="울산">울산</option>
                <option value="세종">세종</option>
                <option value="경기">경기</option>
                <option value="강원">강원</option>
                <option value="충북">충북</option>
                <option value="충남">충남</option>
                <option value="전북">전북</option>
                <option value="전남">전남</option>
                <option value="경북">경북</option>
                <option value="경남">경남</option>
                <option value="제주">제주</option>
            </select><br><br>

            <!-- 최대 인원 -->
            <label for="maxUserNum">최대 인원</label><br>
            <input type="number" id="maxUserNum" name="maxUserNum" placeholder="예: 10" min="1" required><br><br>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">모임 만들기</button>
    </form>


</body>
</html>