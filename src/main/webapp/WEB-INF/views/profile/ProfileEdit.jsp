<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>프로필 수정</title>
    <style>
        body { font-family:'Noto Sans KR',sans-serif; background:#f8f8f8; margin:0; }
        .container { max-width:600px; margin:50px auto; padding:30px; background:#fff;
            box-shadow:0 4px 8px rgba(0,0,0,.1); border-radius:10px; }
        h2 { text-align:center; margin-bottom:24px; color:#333; }
        .profile-preview { display:block; margin:10px auto; width:120px; height:120px;
            object-fit:cover; border-radius:50%; border:2px solid #ccc; background:#eee; }
        .row { margin-top:16px; }
        input[type="file"], input[type="password"] { width:100%; padding:10px; border:1px solid #ccc; border-radius:6px; }
        .button-group { display:flex; gap:10px; justify-content:center; margin-top:20px; flex-wrap:wrap; }
        .btn { padding:10px 20px; border:0; border-radius:6px; cursor:pointer; color:#fff; }
        .btn.save { background:#4CAF50; }
        .btn.delete { background:#f44336; }
        .btn.cancel { background:#6b7280; }
        .danger-box { margin-top:28px; padding:16px; border:1px solid #fecaca; background:#fff1f2; border-radius:10px; }
        .danger-title { margin:0 0 10px; font-weight:800; color:#b91c1c; }
        .agree { display:flex; align-items:center; gap:8px; margin-top:10px; }
    </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container">
    <h2>프로필 사진 변경</h2>

    <!-- 현재 프로필 이미지 미리보기 (없으면 기본 이미지) -->
    <c:choose>
        <c:when test="${profile.fileId != null && profile.fileId > 0}">
            <img id="preview" class="profile-preview"
                 src="${ctx}/file/preview?fileId=${profile.fileId}" alt="프로필 이미지"
                 onerror="this.onerror=null; this.src='${ctx}/resources/images/default-profile.jpg';">
        </c:when>
        <c:otherwise>
            <img id="preview" class="profile-preview"
                 src="${ctx}/resources/images/default-profile.jpg" alt="기본 프로필 이미지">
        </c:otherwise>
    </c:choose>

    <!-- 업로드/삭제 통합 폼 -->
    <form class="row" action="${ctx}/profile/photo" method="post" enctype="multipart/form-data">
        <input type="file" id="profileImage" name="profileFile" accept="image/*" onchange="previewImage(this)">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <!-- ✅ 삭제 플래그 -->
        <input type="hidden" name="deletePhoto" id="deletePhoto" value="false">

        <div class="button-group">
            <!-- ✅ 파일 선택/삭제 후 활성화 -->
            <button type="submit" class="btn save" id="btnSave" disabled>저장</button>
            <button type="button" class="btn cancel" onclick="location.href='${ctx}/profile'">취소</button>
            <!-- ✅ 제출 아님: 삭제 표시만 -->
            <button type="button" class="btn delete" id="btnDeletePhoto">사진 제거</button>
        </div>
    </form>

    <!-- 회원 탈퇴 (비밀번호 재입력 필수) -->
    <div class="danger-box">
        <p class="danger-title">회원 탈퇴</p>
        <form id="withdrawForm" action="${ctx}/profile/withdraw" method="post" onsubmit="return confirmWithdraw();">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <label for="withdrawPwd" style="font-weight:700;">현재 비밀번호</label>
            <input type="password" id="withdrawPwd" name="password" placeholder="현재 비밀번호를 입력하세요" required />

            <label class="agree">
                <input type="checkbox" id="agreeChk" />
                <span>탈퇴 시 모든 데이터가 삭제되며 복구가 불가능함에 동의합니다.</span>
            </label>

            <div class="button-group">
                <button type="submit" class="btn delete">회원 탈퇴</button>
            </div>
        </form>
    </div>
</div>

<!-- ✅ 서버에서 withdrawError가 오면 alert -->
<c:if test="${not empty withdrawError}">
    <script>
        alert('<c:out value="${withdrawError}"/>');
    </script>
</c:if>

<script>
function previewImage(input){
    const preview = document.getElementById('preview');
    const btnSave = document.getElementById('btnSave');
    const del = document.getElementById('deletePhoto');

    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => { preview.src = e.target.result; };
        reader.readAsDataURL(input.files[0]);
        // 새 파일 선택 시 삭제 플래그 해제
        if (del) del.value = 'false';
        if (btnSave) btnSave.disabled = false;
    } else {
        if (btnSave) btnSave.disabled = true;
    }
}

// ✅ 사진 제거: 미리보기 기본이미지로, deletePhoto=true, 파일 입력 초기화, 저장 버튼 활성화
document.getElementById('btnDeletePhoto')?.addEventListener('click', function(){
    const preview = document.getElementById('preview');
    const btnSave = document.getElementById('btnSave');
    const del = document.getElementById('deletePhoto');
    const file = document.getElementById('profileImage');

    if (preview) preview.src = '${ctx}/resources/images/default-profile.jpg';
    if (del) del.value = 'true';
    if (file) file.value = '';
    if (btnSave) btnSave.disabled = false;
});

// 탈퇴 전 클라이언트 검증(비번 입력 + 동의 체크 + 재확인)
function confirmWithdraw(){
    const pwd = document.getElementById('withdrawPwd').value.trim();
    const agree = document.getElementById('agreeChk').checked;

    if (!pwd) { alert('현재 비밀번호를 입력하세요.'); return false; }
    if (!agree) { alert('탈퇴 안내에 동의해야 진행할 수 있습니다.'); return false; }

    return confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.');
}
</script>
</body>
</html>
