<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모임 만들기</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- jQuery CDN -->
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <style>
        body {
            background-color: #f0f2f5; /* 차분한 배경색 */
            font-family: 'Arial', sans-serif;
        }
        .container-form {
            max-width: 600px;
        }
        .card {
            border-radius: 1rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            transition: background-color 0.3s, transform 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container container-form my-5">
        <div class="card p-4">
            <h2 class="card-title text-center mb-4">새로운 모임 만들기</h2>
            <form action="/group/create" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                <!-- 제목 -->
                <div class="mb-3">
                    <label for="title" class="form-label">모임 이름</label>
                    <input type="text" class="form-control" id="title" name="title" placeholder="모임 이름을 입력하세요" required>
                    <div class="invalid-feedback">모임 이름을 입력해주세요.</div>
                </div>

                <!-- 모임 대표사진 -->
                <div class="mb-3">
                    <label for="groupFile" class="form-label">모임 대표 사진</label>
                    <input type="file" class="form-control" id="groupFile" name="groupFile">
                </div>

                <!-- 모임 소개 -->
                <div class="mb-3">
                    <label for="description" class="form-label">모임 소개</label>
                    <textarea class="form-control" id="description" name="description" rows="5" placeholder="모임을 소개해주세요" required></textarea>
                    <div class="invalid-feedback">모임 소개를 입력해주세요.</div>
                </div>

                <!-- 시/도 선택 -->
                <div class="mb-3">
                    <label for="city" class="form-label">시/도 선택</label>
                    <select class="form-select" id="city" name="city" required>
                        <option value="">-- 시/도 선택 --</option>
                        <option value="서울특별시">서울특별시</option>
                        <option value="부산광역시">부산광역시</option>
                        <option value="대구광역시">대구광역시</option>
                        <option value="인천광역시">인천광역시</option>
                        <option value="광주광역시">광주광역시</option>
                        <option value="대전광역시">대전광역시</option>
                        <option value="울산광역시">울산광역시</option>
                        <option value="세종특별자치시">세종특별자치시</option>
                        <option value="경기도">경기도</option>
                        <option value="강원특별자치도">강원특별자치도</option>
                        <option value="충청북도">충청북도</option>
                        <option value="충청남도">충청남도</option>
                        <option value="전라북도">전라북도</option>
                        <option value="전라남도">전라남도</option>
                        <option value="경상북도">경상북도</option>
                        <option value="경상남도">경상남도</option>
                        <option value="제주특별자치도">제주특별자치도</option>
                    </select>
                    <div class="invalid-feedback">시/도를 선택해주세요.</div>
                </div>

                <!-- 구/군 선택 -->
                <div class="mb-3">
                    <label for="country" class="form-label">구/군 선택</label>
                    <select class="form-select" id="country" name="country" required>
                        <option value="">-- 구/군 선택 --</option>
                    </select>
                    <div class="invalid-feedback">구/군을 선택해주세요.</div>
                </div>

                <input type="hidden" id="location" name="location" />

                <!-- 최대 인원 -->
                <div class="mb-4">
                    <label for="maxUserNum" class="form-label">최대 인원</label>
                    <input type="number" class="form-control" id="maxUserNum" name="maxUserNum" placeholder="예: 10" min="4" max="99" required>
                    <div class="invalid-feedback">최대 인원은 4명 이상 99명 이하로 입력해주세요.</div>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg">모임 만들기</button>
                </div>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </form>
        </div>
    </div>

    <!-- Bootstrap JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

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
      const countrySelect = document.getElementById('country');

      citySelect.addEventListener('change', function () {
        const selectedCity = this.value;
        countrySelect.innerHTML = '<option value="">-- 구/군 선택 --</option>';

        if (regionData[selectedCity]) {
          regionData[selectedCity].forEach(function (country) {
            const option = document.createElement('option');
            option.value = country;
            option.textContent = country;
            countrySelect.appendChild(option);
          });
        }
      });

      // 부트스트랩 폼 유효성 검사 활성화
      (function () {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
        Array.from(forms)
          .forEach(function (form) {
            form.addEventListener('submit', function (event) {
              if (!form.checkValidity()) {
                event.preventDefault()
                event.stopPropagation()
              }
              form.classList.add('was-validated')
            }, false)
          })
      })()
    </script>
</body>
</html>
