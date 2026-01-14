package com.picflower.service; 
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class ChatService {

    @Value("${gemini.api.key}")
    private String apiKey;

    // curl에 적힌 주소와 완전히 동일하게 설정합니다.
    private final String URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

    public String getAiResponse(String userMessage) {
        RestTemplate restTemplate = new RestTemplate();

        // 1. 헤더 설정 (-H 부분)
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("X-goog-api-key", apiKey); // 여기에 새 API 키가 들어갑니다.

        // 2. 바디 구성 (-d 부분)
        Map<String, Object> textPart = Map.of("text", "너는 꽃집 주인이야. 친절하게 답해줘: " + userMessage);
        Map<String, Object> contents = Map.of("parts", List.of(textPart));
        Map<String, Object> requestBody = Map.of("contents", List.of(contents));

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        try {
            // 3. POST 요청
            Map<String, Object> response = restTemplate.postForObject(URL, entity, Map.class);
            
            // 4. 응답 파싱
            List candidates = (List) response.get("candidates");
            Map firstCandidate = (Map) candidates.get(0);
            Map content = (Map) firstCandidate.get("content");
            List parts = (List) content.get("parts");
            Map firstPart = (Map) parts.get(0);
            
            return (String) firstPart.get("text");
        } catch (Exception e) {
            System.err.println("에러 발생: " + e.getMessage());
            // 429 에러가 나면 할당량 문제, 404가 나면 주소 문제입니다.
            return "AI 플로리스트가 잠시 응답을 거부했습니다. 조금 뒤에 다시 시도해주세요.";
        }
    }
}