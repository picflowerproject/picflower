<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 승인키 (2026년 현재 발급받은 키 입력)
    String confmKey = "devU01TX0FVVEgyMDI2MDExMzExNTk0MDExNzQzNDE="; 
    String resultType = "4"; // 결과 유형 (JSP 호출 시 필수)
%>
<!DOCTYPE html>
<html>
<head>
<script language="javascript">
function init(){
    var url = location.href;
    var confmKey = "<%=confmKey%>";
    var resultType = "<%=resultType%>";
    var inputYn= "<%=request.getParameter("inputYn")%>";

    if(inputYn != "Y"){
        document.form.confmKey.value = confmKey;
        document.form.returnUrl.value = url;
        document.form.resultType.value = resultType;
        document.form.action="https://business.juso.go.kr/addrlink/addrLinkUrl.do";
        document.form.submit();
    } else {
        opener.jusoCallBack("<%=request.getParameter("roadFullAddr")%>","<%=request.getParameter("roadAddrPart1")%>","<%=request.getParameter("addrDetail")%>","<%=request.getParameter("roadAddrPart2")%>","<%=request.getParameter("engAddr")%>","<%=request.getParameter("jibunAddr")%>","<%=request.getParameter("zipNo")%>");
        window.close();
    }
}
</script>
</head>
<body onload="init();">
    <form id="form" name="form" method="post">
        <input type="hidden" id="confmKey" name="confmKey" value=""/>
        <input type="hidden" id="returnUrl" name="returnUrl" value=""/>
        <input type="hidden" id="resultType" name="resultType" value=""/>
    </form>
</body>
</html>