<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> 
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>공지사항</title>
</head>
<body>
	<h1>공지사항</h1>
		<c:forEach var="dto" items="${list}">
		<details>
			<summary>
    		 	 <strong>${dto.n_title}</strong>
   				  <span><fmt:formatDate value="${dto.n_date}" pattern="yyyy-MM-dd"/></span>
  			</summary>
  			<div>
      			<p>${dto.n_text}</p>
     		 	<c:if test="${not empty dto.n_image_name}">
      		    	<img src="/upload/${dto.n_image_name}">
    		  	</c:if>
    		</div>
    		</details>
		</c:forEach>

	<c:choose>
		<c:when test="${not empty pageContext.request.userPrincipal}">
        	<c:choose>
            	<c:when test="${pageContext.request.userPrincipal.name == 'admin'}">
                	<div class="add">
						 <a href="n_insertForm">공지 입력하기</a>
					</div>
            	</c:when>
            	<c:otherwise>
            
            	</c:otherwise>
        	</c:choose>
    	</c:when>
    	<c:otherwise>

    	</c:otherwise>
	</c:choose>
	
	
</body>
</html>