package com.picflower.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import org.springframework.util.StreamUtils;

@Service
public class ChatService {

    @Value("${gemini.api.key}")
    private String apiKey;

    private final ResourceLoader resourceLoader;

    public ChatService(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    private final String URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";;

    private String loadProductJson() {
        try {
            Resource resource = resourceLoader.getResource("classpath:static/products-edit.json");
            return StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
        } catch (Exception e) {
            System.err.println("JSON 로드 실패: " + e.getMessage());
            return "[]";
        }	
    }

    public String getAiResponse(String userMessage) {
        RestTemplate restTemplate = new RestTemplate();
        String productJson = loadProductJson();

        String systemInstruction = 
            "2026년 1월 현재 활동 중인 전문 플로리스트입니다. 고객의 질문에 대해 아래 [상품데이터]와 [추천 가이드라인]을 엄격히 준수하여 답변합니다.\n\n" +
            "[추천 가이드라인]\n" +
            "1. 대상: 관계에 따른 격식과 꽃말을 고려합니다.\n" +
            "2. 상황: 생일/기념일은 화려하게, 조문은 흰색 위주로 추천합니다.\n" +
            "3. 장소/이동: 대중교통 이동 시 '쇼핑백 제공', 식사 자리면 '워터팩 처리'를 반드시 제안합니다.\n" +
            "4. 계절감: 현재는 겨울(1월)입니다. 데이터에 설명이 부족해도 겨울 제철 꽃(튤립, 라넌큘러스 등)의 특징을 설명에 덧붙입니다.\n\n" +
            "[상품데이터]\n" + productJson + "\n\n" +
            "고객 질문: " + userMessage;

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String finalUrl = URL + "?key=" + apiKey;

        Map<String, Object> textPart = Map.of("text", systemInstruction);
        Map<String, Object> contents = Map.of("parts", List.of(textPart));
        Map<String, Object> requestBody = Map.of("contents", List.of(contents));

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        try {
            Map<String, Object> response = restTemplate.postForObject(finalUrl, entity, Map.class);
            
            List candidates = (List) response.get("candidates");
            Map firstCandidate = (Map) candidates.get(0);
            Map content = (Map) firstCandidate.get("content");
            List parts = (List) content.get("parts");
            Map firstPart = (Map) parts.get(0);
            
            return (String) firstPart.get("text");
        } catch (Exception e) {
            e.printStackTrace();
            return "상담원이 잠시 자리를 비웠습니다. 잠시 후 다시 이용해주세요.";
        }
    }
}