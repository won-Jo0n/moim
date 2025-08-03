<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>수정</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <h2>회원 수정</h2>
    <form action="/user/modify" method="post">
        <input type="hidden" name="id" value="${user.id}" />
        <input type="text" name="loginId" value="${user.loginId}" readOnly/>
        <input type="text" name="gender" value="${user.gender}" readOnly/>
        <input type="text" name="birthDate" value="${user.birthDate}" readOnly/>
        <input type="text" name="nickName" value="${user.nickName}" />
        <label for="city">시/도 선택:</label>
        <select id="city" name="city" required>
          <option value="">-- 시/도 선택 --</option>
          <option value="서울특별시" <c:if test="${city eq '서울특별시'}">selected</c:if>>서울특별시</option>
          <option value="부산광역시" <c:if test="${city eq '부산광역시'}">selected</c:if>>부산광역시</option>
          <option value="대구광역시" <c:if test="${city eq '대구광역시'}">selected</c:if>>대구광역시</option>
          <option value="인천광역시" <c:if test="${city eq '인천광역시'}">selected</c:if>>인천광역시</option>
          <option value="광주광역시" <c:if test="${city eq '광주광역시'}">selected</c:if>>광주광역시</option>
          <option value="대전광역시" <c:if test="${city eq '대전광역시'}">selected</c:if>>대전광역시</option>
          <option value="울산광역시" <c:if test="${city eq '울산광역시'}">selected</c:if>>울산광역시</option>
          <option value="세종특별자치시" <c:if test="${city eq '세종특별자치시'}">selected</c:if>>세종특별자치시</option>
          <option value="경기도" <c:if test="${city eq '경기도'}">selected</c:if>>경기도</option>
          <option value="강원특별자치도" <c:if test="${city eq '강원특별자치도'}">selected</c:if>>강원특별자치도</option>
          <option value="충청북도" <c:if test="${city eq '충청북도'}">selected</c:if>>충청북도</option>
          <option value="충청남도" <c:if test="${city eq '충청남도'}">selected</c:if>>충청남도</option>
          <option value="전라북도" <c:if test="${city eq '전라북도'}">selected</c:if>>전라북도</option>
          <option value="전라남도" <c:if test="${city eq '전라남도'}">selected</c:if>>전라남도</option>
          <option value="경상북도" <c:if test="${city eq '경상북도'}">selected</c:if>>경상북도</option>
          <option value="경상남도" <c:if test="${city eq '경상남도'}">selected</c:if>>경상남도</option>
          <option value="제주특별자치도" <c:if test="${city eq '제주특별자치도'}">selected</c:if>>제주특별자치도</option>
        </select>
        <label for="county">구/군 선택:</label>
        <select id="county" name="county" required>
        <option value="">-- 구/군 선택 --</option>
        <!-- 자바스크립트로 해당 시/도에 맞는 구/군 자동 변경 -->
        </select>
        <input type="submit" value="수정하기"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
</body>
<script>
  const regionData = {
    '서울특별시': ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'],
    '부산광역시': ['강서구', '금정구', '남구', '동구', '동래구', '부산진구', '북구', '사상구', '사하구', '서구', '수영구', '연제구', '영도구', '중구', '해운대구'],
    '대구광역시': ['남구', '달서구', '달성군', '동구', '북구', '서구', '수성구', '중구'],
    '인천광역시': ['강화군', '계양구', '남동구', '동구', '미추홀구', '부평구', '서구', '연수구', '옹진군', '중구'],
    '광주광역시': ['광산구', '남구', '동구', '북구', '서구'],
    '대전광역시': ['대덕구', '동구', '서구', '유성구', '중구'],
    '울산광역시': ['남구', '동구', '북구', '중구', '울주군'],
    '세종특별자치시': ['세종시'],
    '경기도': ['가평군', '고양시', '과천시', '광명시', '광주시', '구리시', '군포시', '김포시', '남양주시', '동두천시', '부천시', '성남시', '수원시', '시흥시', '안산시', '안성시', '안양시', '양주시', '양평군', '여주시', '연천군', '오산시', '용인시', '의왕시', '의정부시', '이천시', '파주시', '평택시', '포천시', '하남시', '화성시'],
    '강원특별자치도': ['강릉시', '고성군', '동해시', '삼척시', '속초시', '양구군', '양양군', '영월군', '원주시', '인제군', '정선군', '철원군', '춘천시', '태백시', '평창군', '홍천군', '화천군', '횡성군'],
    '충청북도': ['괴산군', '단양군', '보은군', '영동군', '옥천군', '음성군', '제천시', '증평군', '진천군', '청주시', '충주시'],
    '충청남도': ['계룡시', '공주시', '금산군', '논산시', '당진시', '보령시', '부여군', '서산시', '서천군', '아산시', '예산군', '천안시', '청양군', '태안군', '홍성군'],
    '전라북도': ['고창군', '군산시', '김제시', '남원시', '무주군', '부안군', '순창군', '완주군', '익산시', '임실군', '장수군', '전주시', '정읍시', '진안군'],
    '전라남도': ['강진군', '고흥군', '곡성군', '광양시', '구례군', '나주시', '담양군', '목포시', '무안군', '보성군', '순천시', '신안군', '여수시', '영광군', '영암군', '완도군', '장성군', '장흥군', '진도군', '함평군', '해남군', '화순군'],
    '경상북도': ['경산시', '경주시', '고령군', '구미시', '군위군', '김천시', '문경시', '봉화군', '상주시', '성주군', '안동시', '영덕군', '영양군', '영주시', '영천시', '예천군', '울릉군', '울진군', '의성군', '청도군', '청송군', '칠곡군', '포항시'],
    '경상남도': ['거제시', '거창군', '고성군', '김해시', '남해군', '밀양시', '사천시', '산청군', '양산시', '의령군', '진주시', '창녕군', '창원시', '통영시', '하동군', '함안군', '함양군', '합천군'],
    '제주특별자치도': ['서귀포시', '제주시']
  };


  const citySelect = document.getElementById('city');
  const countySelect = document.getElementById('county');

  const selectedCity = "${city != null ? city : ''}";
  const selectedCounty = "${county != null ? county : ''}";


  if (selectedCity) {
    citySelect.value = selectedCity; // city select 기본값 설정

    if (regionData[selectedCity]) {
      regionData[selectedCity].forEach(function (county) {
        const option = document.createElement('option');
        option.value = county;
        option.textContent = county;
        if (county === selectedCounty) {
          option.selected = true; // county 기본값 설정
        }
        countySelect.appendChild(option);
      });
    }
  }

  citySelect.addEventListener('change', function () {
    const selectedCity = this.value;
    countySelect.innerHTML = '<option value="">-- 구/군 선택 --</option>';

    if (regionData[selectedCity]) {
      regionData[selectedCity].forEach(function (county) {
        const option = document.createElement('option');
        option.value = county;
        option.textContent = county;
        countySelect.appendChild(option);
      });
    }
  });
</script>
</html>