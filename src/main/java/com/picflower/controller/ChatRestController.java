package com.picflower.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.picflower.service.ChatService;

@RestController
public class ChatRestController {

    @Autowired
    private ChatService chatService;

    @PostMapping("/api/chat/send")
    public String chat(@RequestBody Map<String, String> payload) {
        String userMsg = payload.get("message");
        return chatService.getAiResponse(userMsg);
    }
}