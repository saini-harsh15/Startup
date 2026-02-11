//package org.example.startupecosystem.controller;
//
//import jakarta.servlet.http.HttpSession;
//import org.example.startupecosystem.entity.Investor;
//import org.example.startupecosystem.entity.Startup;
//import org.example.startupecosystem.repository.InvestorRepository;
//import org.example.startupecosystem.repository.StartupRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.Map;
//
//@RestController
//@RequestMapping("/api/security")
//public class UserSecurityController {
//
//    @Autowired
//    private StartupRepository startupRepository;
//
//    @Autowired
//    private InvestorRepository investorRepository;
//
//    @PostMapping("/public-key")
//    public ResponseEntity<?> savePublicKey(
//            @RequestBody Map<String, String> body,
//            HttpSession session) {
//
//        Long userId = Long.parseLong(
//                session.getAttribute("loggedInUserId").toString());
//
//        String role = session.getAttribute("loggedInRole").toString();
//        String publicKey = body.get("publicKey");
//
//        if ("Startup".equals(role)) {
//            Startup s = startupRepository.findById(userId).orElseThrow();
//            s.setPublicKey(publicKey);
//            startupRepository.save(s);
//        } else {
//            Investor i = investorRepository.findById(userId).orElseThrow();
//            i.setPublicKey(publicKey);
//            investorRepository.save(i);
//        }
//
//        return ResponseEntity.ok().build();
//    }
//
//    @GetMapping("/public-key/{userId}/{role}")
//    public ResponseEntity<String> getPublicKey(
//            @PathVariable Long userId,
//            @PathVariable String role) {
//
//        if ("Startup".equalsIgnoreCase(role)) {
//            return ResponseEntity.ok(
//                    startupRepository.findById(userId)
//                            .orElseThrow()
//                            .getPublicKey()
//            );
//        } else {
//            return ResponseEntity.ok(
//                    investorRepository.findById(userId)
//                            .orElseThrow()
//                            .getPublicKey()
//            );
//        }
//    }
//
//}
