<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>글 작성</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="stylesheet" href="../resources/css/groupBoardCreate.css" >
</head>
<body>
  <div class="page">
    <header class="page__header">
      <h2 class="page__title">글 작성</h2>
      <a class="link-back" href="javascript:history.back()">뒤로가기</a>
    </header>

    <section class="card">
      <div class="card__head">
        <h3 class="card__title">게시글 정보</h3>
        <p class="card__subtitle">제목, 내용, 이미지 파일을 업로드하세요</p>
      </div>

      <form class="form" action="/groupboard/create" method="post" enctype="multipart/form-data">
        <!-- 그룹 ID (필수 hidden 그대로 유지) -->
        <input type="hidden" name="groupId" value="${groupId}" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div class="form__row">
          <label for="title" class="label">제목</label>
          <input type="text" id="title" name="title" class="input" placeholder="제목을 입력하세요" required>
          <p class="help">  50자 이내 권장</p>
        </div>

        <div class="form__row">
          <label for="content" class="label">내용</label>
          <textarea id="content" name="content" class="textarea" rows="10" placeholder="내용을 입력하세요" required></textarea>

        </div>

        <div class="form__row">
          <label for="groupBoardFile" class="label" >이미지 첨부 (선택)</label>
          <div class="filebox">
            <input type="file" id="groupBoardFile" name="groupBoardFile" class="filebox__input" accept="image/*" required>
            <label for="groupBoardFile" class="filebox__button">파일 선택</label>
            <span class="filebox__name" id="fileName">선택된 파일 없음</span>
          </div>
          <p class="help">JPG/PNG/WebP 권장, 10MB 이하</p>
        </div>

        <div class="actions">
          <button type="submit" class="pill-btn pill-btn--accent">등록</button>
          <button type="button" class="pill-btn" onclick="history.back()">취소</button>
        </div>
      </form>
    </section>
  </div>

  <script>
    // 선택한 파일명 표시
    $('#groupBoardFile').on('change', function(){
      const file = this.files && this.files.length ? this.files[0].name : '선택된 파일 없음';
      $('#fileName').text(file);
    });
  </script>
</body>