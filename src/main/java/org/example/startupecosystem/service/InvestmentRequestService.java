package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.*;
import org.example.startupecosystem.repository.InvestmentRequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InvestmentRequestService {

    @Autowired
    private InvestmentRequestRepository repository;

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

        repository.save(req);
    }
}

