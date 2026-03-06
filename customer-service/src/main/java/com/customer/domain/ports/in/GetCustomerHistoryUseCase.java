package com.customer.domain.ports.in;

import com.customer.domain.model.CustomerHistory;
import java.util.List;

public interface GetCustomerHistoryUseCase {
    List<CustomerHistory> getHistory(Long customerId);

    void logEvent(Long customerId, String eventType, String description);
}
