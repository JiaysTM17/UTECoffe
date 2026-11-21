package com.utecoffe.controller.api;

import com.utecoffe.dto.response.ApiResponse;
import com.utecoffe.service.CloudinaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/uploads")
public class FileUploadController {

    @Autowired
    private CloudinaryService cloudinaryService;

    @PostMapping("/image")
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "folder", defaultValue = "products") String folder) {
        try {
            String imageUrl = cloudinaryService.uploadFile(file, folder);
            Map<String, String> data = new HashMap<>();
            data.put("url", imageUrl);
            data.put("fileName", file.getOriginalFilename());
            return ResponseEntity.ok(ApiResponse.success(data, "Tai len hinh anh thanh cong"));
        } catch (IOException ex) {
            return ResponseEntity.status(500).body(ApiResponse.error("Loi tai len anh: " + ex.getMessage()));
        }
    }
}
