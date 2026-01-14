<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
</head>
<body>
<header>
<%@ include file="/WEB-INF/views/common/homeHeader.jsp" %>


</header>
<main>
<h1>main</h1>
<section>
<img src="${pageContext.request.contextPath}/assets/home1.jpg" alt="Home Image">
</section>
</main>

<footer>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>
</body>
</html>