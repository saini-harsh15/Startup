package org.example.startupecosystem.service;

import org.example.startupecosystem.dto.InvestmentRequestNotificationDTO;
import org.example.startupecosystem.entity.*;
import org.example.startupecosystem.repository.InvestmentRequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InvestmentRequestService {

    @Autowired
    private InvestmentRequestRepository repository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    @Transactional
    public void createRequest(
            Investor investor,
            Startup startup,
            Double amount,
            String fundingStage,
            Double expectedRoi,
            Integer horizon,
            String message
    ) {
        InvestmentRequest req = new InvestmentRequest();
        req.setInvestor(investor);
        req.setStartup(startup);
        req.setAmount(amount);
        req.setFundingStage(fundingStage);
        req.setExpectedRoi(expectedRoi);
        req.setHorizon(horizon);
        req.setMessage(message);
        req.setStatus(InvestmentRequestStatus.PENDING);

        repository.saveAndFlush(req);

        InvestmentRequest full = repository.findFullById(req.getId());

        InvestmentRequestNotificationDTO dto =
                new InvestmentRequestNotificationDTO(
                        full.getId(),
                        full.getInvestor().getInvestorName(),
                        full.getAmount(),
                        full.getFundingStage(),
                        full.getStatus().name(),
                        full.getInvestor().getId()
                );

        messagingTemplate.convertAndSend(
                "/topic/startup/investment/" + startup.getId(),
                dto
        );
    }
}

