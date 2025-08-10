<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title><decorator:title /></title>
    <decorator:head />
</head>
<body>
    <jsp:include page="/WEB-INF/views/header.jsp" />
    <decorator:body />
</body>
</html>