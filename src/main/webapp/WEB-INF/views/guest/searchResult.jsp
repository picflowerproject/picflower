<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>검색 결과</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/searchResult.css">
</head>
<body>

<jsp:include page="../common/header.jsp" />

<div class="sr-wrap">

  <div class="sr-title">
    <h2>검색 결과</h2>
    <div class="sr-keyword">"<c:out value="${searchKeyword}"/>"</div>
  </div>

  <!-- ================= 상품 결과 ================= -->
  <section class="sr-section">
    <div class="sr-section-head">
      <h3>상품 (<c:out value="${pTotal}"/>)</h3>
    </div>

    <c:choose>
      <c:when test="${empty productList}">
        <div class="sr-empty">상품 검색 결과가 없습니다.</div>
      </c:when>
      <c:otherwise>
        <div class="sr-grid">
          <c:forEach var="p" items="${productList}">
            <a class="sr-card" href="${pageContext.request.contextPath}/guest/productDetail?p_no=${p.p_no}">
              <div class="sr-thumb">
                <c:choose>
                  <c:when test="${empty p.p_image}">
                    <div class="sr-noimg">NO IMAGE</div>
                  </c:when>
                  <c:otherwise>
                    <img src="<c:out value='${p.p_image}'/>" alt="img">
                  </c:otherwise>
                </c:choose>
              </div>
              <div class="sr-card-body">
                <div class="sr-card-title"><c:out value="${p.p_title}"/></div>
                <div class="sr-card-sub"><c:out value="${p.p_subtitle}"/></div>
                <div class="sr-card-foot">
                  <span class="sr-price"><c:out value="${p.p_price}"/>원</span>
                  <span class="sr-chip"><c:out value="${p.p_category}"/></span>
                </div>
              </div>
            </a>
          </c:forEach>
        </div>

        <!-- 상품 페이지 -->
        <div class="sr-paging">
          <c:if test="${pStartPage > 1}">
            <c:url var="pPrev" value="/guest/productSearch">
              <c:param name="searchKeyword" value="${searchKeyword}"/>
              <c:param name="pPage" value="${pStartPage - 1}"/>
              <c:param name="bPage" value="${bPage}"/>
            </c:url>
            <a class="pg-btn" href="${pPrev}">이전</a>
          </c:if>

          <c:forEach var="i" begin="${pStartPage}" end="${pEndPage}">
            <c:url var="pLink" value="/guest/productSearch">
              <c:param name="searchKeyword" value="${searchKeyword}"/>
              <c:param name="pPage" value="${i}"/>
              <c:param name="bPage" value="${bPage}"/>
            </c:url>
            <a class="pg-num ${i==pPage ? 'on' : ''}" href="${pLink}">${i}</a>
          </c:forEach>

          <c:if test="${pEndPage < pTotalPages}">
            <c:url var="pNext" value="/guest/productSearch">
              <c:param name="searchKeyword" value="${searchKeyword}"/>
              <c:param name="pPage" value="${pEndPage + 1}"/>
              <c:param name="bPage" value="${bPage}"/>
            </c:url>
            <a class="pg-btn" href="${pNext}">다음</a>
          </c:if>
        </div>
      </c:otherwise>
    </c:choose>
  </section>

  <!-- ================= 후기 결과 ================= -->
  <section class="sr-section">
    <div class="sr-section-head">
      <h3>후기 (<c:out value="${bTotal}"/>)</h3>
    </div>

    <c:choose>
      <c:when test="${empty boardList}">
        <div class="sr-empty">후기 검색 결과가 없습니다.</div>
      </c:when>
      <c:otherwise>
        <div class="sr-review-list">
          <c:forEach var="b" items="${boardList}">
            <div class="rv-item">
              <div class="rv-top">
                <div class="rv-product">상품: <b><c:out value="${b.p_title}"/></b></div>
                <div class="rv-meta">
                  <span class="rv-user"><c:out value="${b.m_id}"/></span>
                  <span class="rv-date"><c:out value="${b.b_date}"/></span>
                  <span class="rv-star">★ <c:out value="${b.b_rating}"/></span>
                </div>
              </div>

              <div class="rv-body">
                <c:if test="${not empty b.b_image}">
                  <img class="rv-img" src="<c:out value='${b.b_image}'/>" alt="review">
                </c:if>
                <div class="rv-text"><c:out value="${b.b_text}"/></div>
              </div>
            </div>
          </c:forEach>
        </div>

        <!-- 후기 페이지 -->
        <div class="sr-paging">
          <c:if test="${bStartPage > 1}">
            <c:url var="bPrev" value="/guest/productSearch">
              <c:param name="searchKeyword" value="${searchKeyword}"/>
              <c:param name="pPage" value="${pPage}"/>
              <c:param name="bPage" value="${bStartPage - 1}"/>
            </c:url>
            <a class="pg-btn" href="${bPrev}">이전</a>
          </c:if>

          <c:forEach var="i" begin="${bStartPage}" end="${bEndPage}">
            <c:url var="bLink" value="/guest/productSearch">
              <c:param name="searchKeyword" value="${searchKeyword}"/>
              <c:param name="pPage" value="${pPage}"/>
              <c:param name="bPage" value="${i}"/>
            </c:url>
            <a class="pg-num ${i==bPage ? 'on' : ''}" href="${bLink}">${i}</a>
          </c:forEach>

          <c:if test="${bEndPage < bTotalPages}">
            <c:url var="bNext" value="/guest/productSearch">
              <c:param name="searchKeyword" value="${searchKeyword}"/>
              <c:param name="pPage" value="${pPage}"/>
              <c:param name="bPage" value="${bEndPage + 1}"/>
            </c:url>
            <a class="pg-btn" href="${bNext}">다음</a>
          </c:if>
        </div>
      </c:otherwise>
    </c:choose>
  </section>

</div>

<jsp:include page="../common/footer.jsp" />
</body>
</html>
