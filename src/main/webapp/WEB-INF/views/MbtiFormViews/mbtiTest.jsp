<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>MBTI 성향 테스트</title>
    <style>
        .wrap{max-width:900px;margin:40px auto;padding:24px;background:#fff;border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,.06)}
        .title{font-size:24px;font-weight:700;margin:0 0 12px}
        .bar{height:6px;background:#eee;border-radius:6px;overflow:hidden;margin:12px 0 20px}
        .bar > span{display:block;height:100%;background:#2ecc71;width:0;transition:width .2s ease}
        .q-title{font-size:18px;font-weight:600;margin:12px 0 16px}
        ul.opts{list-style:none;padding:0;margin:0}
        ul.opts li{margin:8px 0}
        label.opt{display:block;padding:12px 14px;border:1px solid #ddd;border-radius:8px;cursor:pointer}
        label.opt input{margin-right:8px}
        .nav{display:flex;gap:8px;margin-top:18px}
        .nav button,.nav a{padding:10px 14px;border:1px solid #ddd;border-radius:8px;background:#f6f6f6;text-decoration:none;color:#222}
        .nav button.primary{background:#2ecc71;border-color:#2ecc71;color:#fff}
        .nav button:disabled{opacity:.5;cursor:not-allowed}
    </style>
</head>
<body>
<div class="wrap">
    <h1 class="title">MBTI 성향 테스트</h1>
    <div class="bar"><span id="progress"></span></div>

    <!-- 질문이 교체 렌더링될 영역 -->
    <div id="q-root"></div>

    <!-- 네비게이션 -->
    <div class="nav">
        <button type="button" id="btn-prev">이전</button>
        <button type="button" id="btn-next" class="primary">다음</button>
        <a href="/profile">마이페이지로 돌아가기</a>
    </div>
</div>

<script>
    // CSRF
    var CSRF_PARAM = '${_csrf.parameterName}';
    var CSRF_TOKEN = '${_csrf.token}';

    // 서버에서 전달된 질문 목록을 JS 배열로 구성
    // 각 항목: { id: Number, text: String, type: String }
    var questions = [
        <c:forEach var="q" items="${questions}" varStatus="st">
            { id: ${q.id}, text: '<c:out value="${fn:escapeXml(q.question)}"/>', type: '<c:out value="${fn:escapeXml(q.type)}"/>' }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    // 상태
    var answers = new Array(questions.length).fill(null); // 각 문항 0~4 또는 null
    var idx = 0;

    // 요소
    var root = document.getElementById('q-root');
    var btnPrev = document.getElementById('btn-prev');
    var btnNext = document.getElementById('btn-next');
    var progress = document.getElementById('progress');

    function render() {
        var q = questions[idx] || {text:''};
        var selected = answers[idx];

        // 진행바 업데이트
        var pct = Math.round((idx / Math.max(1, questions.length)) * 100);
        progress.style.width = pct + '%';

        var labels = ['전혀','때때로','그렇다','주로 그렇다','매우 그렇다'];
        var optsHtml = labels.map(function(label, i){
            return '<li>'
                 +   '<label class="opt">'
                 +     '<input type="radio" name="ans" value="'+ i +'" ' + (selected === i ? 'checked' : '') + '>'
                 +     '<span>'+ label +'</span>'
                 +   '</label>'
                 + '</li>';
        }).join('');

        var html = ''
            + '<div class="card">'
            +   '<p class="q-title">Q' + (idx + 1) + '. ' + q.text + '</p>'
            +   '<ul class="opts">' + optsHtml + '</ul>'
            + '</div>';

        // ★ 핵심: 기존 DOM을 지우고 한 개만 다시 그림 (append 금지)
        root.innerHTML = html;

        // 버튼 상태
        btnPrev.disabled = (idx === 0);
        btnNext.textContent = (idx === questions.length - 1) ? '제출' : '다음';
        btnNext.disabled = (answers[idx] === null);

        // 라디오 체인지
        var radios = root.querySelectorAll('input[name="ans"]');
        for (var r=0; r<radios.length; r++) {
            radios[r].addEventListener('change', function(){
                answers[idx] = Number(this.value);
                btnNext.disabled = false;
            });
        }

        // 뷰 상단으로 스크롤 (선택)
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    btnPrev.addEventListener('click', function(){
        if (idx > 0) {
            idx--;
            render(); // 교체 렌더
        }
    });

    btnNext.addEventListener('click', function(){
        if (idx < questions.length - 1) {
            if (answers[idx] === null) return;
            idx++;
            render(); // 교체 렌더
        } else {
            // 제출
            submitAnswers();
        }
    });

    function submitAnswers() {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = '/mbti/submit';

        // CSRF
        var csrf = document.createElement('input');
        csrf.type = 'hidden';
        csrf.name = CSRF_PARAM;
        csrf.value = CSRF_TOKEN;
        form.appendChild(csrf);

        // answers0..n 으로 전송 (컨트롤러가 map.get("answers"+i)로 받음)
        for (var i = 0; i < answers.length; i++) {
            var inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = 'answers' + i;
            inp.value = (answers[i] == null ? '' : String(answers[i]));
            form.appendChild(inp);
        }

        document.body.appendChild(form);
        form.submit();
    }

    // 최초 1회 렌더
    render();
</script>
</body>
</html>
