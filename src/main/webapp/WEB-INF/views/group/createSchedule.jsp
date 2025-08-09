<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>모임 일정 만들기</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
<h2>모임 일정 만들기</h2>

<form id="scheduleForm" action="/group/createSchedule" method="post" novalidate>
    <input type="hidden" name="scheduleLeader" value="${scheduleLeader}"/>
    <input type="hidden" name="groupId" value="${groupId}"/>
    <input type="hidden" id="groupMaxUserNum" value="${groupMaxUserNum}"/>

    <label>일정 제목
        <input type="text" name="title" placeholder="일정 제목을 입력해주세요" required/>
    </label>

    <label>일정 설명
        <textarea name="description" placeholder="일정 설명을 입력해주세요" rows="4" required></textarea>
    </label>

    <label for="startTime">시작시간</label>
    <input id="startTime" type="datetime-local" name="startTime" required/>
    <div class="hint">현재 시각 이후로 설정 가능합니다.</div>

    <label for="endTime">종료시간</label>
    <input id="endTime" type="datetime-local" name="endTime" required/>
    <div class="hint">모임은 1시간 이상으로 설정 가능합니다</div>

    <label>최대 인원
        <input id="maxUserNum" type="number" name="maxUserNum" placeholder="최대 인원" min="1" max="${groupMaxUserNum}" required/>
    </label>
    <div class="hint">이 모임의 최대 인원은 ${groupMaxUserNum}명 입니다.</div>

    <div id="formError" class="error"></div>

    <div style="margin-top:16px;">
        <input type="submit" value="일정 생성"/>
    </div>

    <!-- CSRF 쓰면 아래 추가 -->
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </c:if>
</form>

<script>
    // 유틸: Date -> 'YYYY-MM-DDTHH:MM' 로 포맷
    function toLocalInputValue(d){
        const pad = n => String(n).padStart(2,'0');
        const yyyy = d.getFullYear();
        const MM = pad(d.getMonth()+1);
        const dd = pad(d.getDate());
        const hh = pad(d.getHours());
        const mm = pad(d.getMinutes());
        return `${yyyy}-${MM}-${dd}T${hh}:${mm}`;
    }

    // 최소 1시간 추가
    function addHours(date, hrs){
        const d = new Date(date.getTime());
        d.setHours(d.getHours() + hrs);
        return d;
    }

    const startEl = document.getElementById('startTime');
    const endEl   = document.getElementById('endTime');
    const maxEl   = document.getElementById('maxUserNum');
    const groupMax = parseInt(document.getElementById('groupMaxUserNum').value, 10);
    const form    = document.getElementById('scheduleForm');
    const errBox  = document.getElementById('formError');

    // 페이지 로드 시: 시작시간 min=지금, 종료시간 min=지금+1h
    (function init(){
        const now = new Date();
        now.setSeconds(0,0); // 초/밀리초 정리
        startEl.min = toLocalInputValue(now);

        const minEnd = addHours(now, 1);
        endEl.min = toLocalInputValue(minEnd);

        // 최대 인원 max 한 번 더 보장
        maxEl.max = groupMax;
    })();

    // 시작시간 변경 시: 종료시간 최소값을 "시작+1h"로 갱신
    startEl.addEventListener('change', function(){
        if(!startEl.value) return;
        const start = new Date(startEl.value);
        const minEnd = addHours(start, 1);
        const minEndStr = toLocalInputValue(minEnd);
        endEl.min = minEndStr;

        // 종료시간이 새 최소값보다 이르면 자동으로 끌어올림(UX)
        if(!endEl.value || new Date(endEl.value) < minEnd){
            endEl.value = minEndStr;
        }
    });

    // 제출 전 클라이언트 검증
    form.addEventListener('submit', function(e){
        errBox.style.display = 'none';
        errBox.textContent = '';

        // 기본 HTML required 체크
        if(!form.checkValidity()){
            e.preventDefault();
            errBox.textContent = '입력값을 확인해주세요.';
            errBox.style.display = 'block';
            return;
        }

        const now = new Date(); now.setSeconds(0,0);
        const start = new Date(startEl.value);
        const end   = new Date(endEl.value);
        const maxVal = parseInt(maxEl.value, 10);

        // 1) 시작시간은 현재 이후
        if(start <= now){
            e.preventDefault();
            errBox.textContent = '시작 시간은 현재 시각보다 이후여야 합니다.';
            errBox.style.display = 'block';
            startEl.focus();
            return;
        }

        // 2) 종료시간 - 시작시간 >= 60분
        const diffMin = (end - start) / 60000;
        if(diffMin < 60){
            e.preventDefault();
            errBox.textContent = '종료 시간은 시작 시간으로부터 최소 1시간 이상이어야 합니다.';
            errBox.style.display = 'block';
            endEl.focus();
            return;
        }

        // 3) 일정 최대 인원 ≤ 모임 최대 인원
        if(maxVal > groupMax){
            e.preventDefault();
            errBox.textContent = `일정 최대 인원은 모임 최대 인원(${groupMax}명) 이하여야 합니다.`;
            errBox.style.display = 'block';
            maxEl.focus();
            return;
        }

    });
</script>
</body>
</html>