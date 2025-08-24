<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>MBTI 성향 테스트</title>
    <style>
        :root{
            --paper:#ffffff;
            --bg:#f5f6fa;
            --brand:#7E57C2; --brand-2:#5E35B1; --brand-3:#4527A0;
            --text:#333; --muted:#f6f6f9; --line:#e6e3f2; --lavender:#B18FCF;
        }
        @keyframes gradientShift{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
        body{font-family:'Noto Sans KR',sans-serif;margin:0;background:
              linear-gradient(180deg, rgba(203,170,203,.08), rgba(177,143,207,.08)),var(--bg);color:var(--text);}
        .wrap{max-width:900px;margin:40px auto;padding:24px;background:var(--paper);border-radius:12px;box-shadow:0 4px 12px rgba(0,0,0,.06)}
        .title{font-size:24px;font-weight:800;margin:0 0 12px;color:var(--brand)}

        /* 진행 바 + 카운터 행 */
        .progress-row{display:flex;align-items:center;gap:12px;margin:12px 0 20px}
        .bar{flex:1;height:6px;background:#eee;border-radius:6px;overflow:hidden}
        .bar>span{display:block;height:100%;width:0;transition:width .2s ease;
            background-image:linear-gradient(90deg,var(--brand),var(--brand-2),var(--brand-3));
            background-size:200% 200%;animation:gradientShift 8s linear infinite;
            box-shadow:0 2px 8px rgba(94,53,177,.25) inset;}
        .step{min-width:64px;text-align:right;font-weight:700;color:#555}

        .q-title{font-size:18px;font-weight:700;margin:12px 0 16px}
        ul.opts{list-style:none;padding:0;margin:0}
        ul.opts li{margin:8px 0}
        label.opt{display:block;padding:12px 14px;border:1px solid var(--line);border-radius:10px;cursor:pointer;
            background:var(--muted);transition:border-color .15s,box-shadow .15s,background .15s,transform .08s}
        label.opt:hover{border-color:var(--brand);box-shadow:0 6px 18px rgba(94,53,177,.12);background:#faf8ff;transform:translateY(-1px)}
        label.opt input{margin-right:8px}

        .nav{display:flex;gap:8px;margin-top:18px;flex-wrap:wrap}
        .nav button,.nav a{padding:10px 14px;border:1px solid var(--line);border-radius:10px;background:#f6f6f9;
            text-decoration:none;color:#222;font-weight:700;transition:transform .08s, box-shadow .15s, background .15s}
        .nav a:hover,.nav button:hover{transform:translateY(-1px); box-shadow:0 8px 18px rgba(94,53,177,.10); background:#faf8ff}
        .nav button.primary{border:0; color:#fff; font-weight:800;background-image:linear-gradient(90deg,var(--brand),var(--brand-2),var(--brand-3));
            background-size:200% 200%; animation:gradientShift 8s linear infinite; box-shadow:0 8px 22px rgba(94,53,177,.20)}
        .nav button.primary:hover{box-shadow:0 12px 28px rgba(94,53,177,.25)}
        .nav button:disabled{opacity:.5;cursor:not-allowed;box-shadow:none}
    </style>
</head>
<body>
<div class="wrap">
    <h1 class="title">MBTI 성향 테스트</h1>

    <!-- ✅ 진행바 + 1/24 카운터 -->
    <div class="progress-row">
        <div class="bar"><span id="progress"></span></div>
        <div class="step" id="stepText">1/1</div>
    </div>

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

    // 서버에서 전달된 질문 목록
    var questions = [
        <c:forEach var="q" items="${questions}" varStatus="st">
            { id: ${q.id}, text: '<c:out value="${fn:escapeXml(q.question)}"/>', type: '<c:out value="${fn:escapeXml(q.type)}"/>' }
            <c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    var answers = new Array(questions.length).fill(null);
    var idx = 0;

    var root = document.getElementById('q-root');
    var btnPrev = document.getElementById('btn-prev');
    var btnNext = document.getElementById('btn-next');
    var progress = document.getElementById('progress');
    var stepText = document.getElementById('stepText'); // ✅ 1/24 표출 영역

    function render() {
        var q = questions[idx] || {text:''};
        var selected = answers[idx];

        // 진행바(선택 전에는 현재 인덱스 기준으로 0%, 1/24 표시는 아래에서 별도 처리)
        var pct = Math.round((idx / Math.max(1, questions.length)) * 100);
        progress.style.width = pct + '%';

        // ✅ 1/24 포맷 갱신
        stepText.textContent = (idx + 1) + ' / ' + questions.length;

        var labels = ['전혀','별로 그렇지 않음','보통','주로 그렇다','매우 그렇다'];
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

        root.innerHTML = html;

        btnPrev.disabled = (idx === 0);
        btnNext.textContent = (idx === questions.length - 1) ? '제출' : '다음';
        btnNext.disabled = (answers[idx] === null);

        var radios = root.querySelectorAll('input[name="ans"]');
        for (var r=0; r<radios.length; r++) {
            radios[r].addEventListener('change', function(){
                answers[idx] = Number(this.value);
                btnNext.disabled = false;
            });
        }

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    btnPrev.addEventListener('click', function(){
        if (idx > 0) { idx--; render(); }
    });

    btnNext.addEventListener('click', function(){
        if (idx < questions.length - 1) {
            if (answers[idx] === null) return;
            idx++; render();
        } else {
            submitAnswers();
        }
    });

    function submitAnswers() {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = '/mbti/submit';

        var csrf = document.createElement('input');
        csrf.type = 'hidden';
        csrf.name = CSRF_PARAM;
        csrf.value = CSRF_TOKEN;
        form.appendChild(csrf);

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

    render();
</script>
</body>
</html>
