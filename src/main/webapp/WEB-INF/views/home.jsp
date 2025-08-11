<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>홈</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" />
    <link rel="stylesheet" href="/resources/css/home.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/resources/js/home.js"></script>
</head>
<body>
    <main id="post-container"></main>
    <div id="loading-indicator">
      <div class="loading-spinner"></div>
    </div>
    <button id="fixed-add-post-button" onclick="window.location.href='/post/create'">
        +
    </button>
</body>
</html>