package com.customer.domain.ports.in;

import com.customer.domain.model.CustomerNote;
import java.util.List;

public interface ManageCustomerNotesUseCase {
    CustomerNote addNote(Long customerId, String note);

    List<CustomerNote> getNotes(Long customerId);
}
