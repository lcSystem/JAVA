package com.appointment.infrastructure.adapters.in.web;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.LocalDateTime;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import com.appointment.application.ports.in.ScheduleAppointmentCommand;
import com.appointment.application.ports.in.ScheduleAppointmentUseCase;
import com.appointment.domain.exception.TimeSlotTakenException;
import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.AppointmentStatus;
import com.appointment.domain.model.AppointmentType;
import com.fasterxml.jackson.databind.ObjectMapper;

@SpringBootTest
@AutoConfigureMockMvc(addFilters = false) // Disable security constraints for unit controller test
class AppointmentControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private ScheduleAppointmentUseCase scheduleUseCase;

    @Test
    void testScheduleAppointment_Success() throws Exception {
        String title = "Revisión General";
        UUID branchId = UUID.randomUUID();
        UUID employeeId = UUID.randomUUID();

        String payload = """
                    {
                        "title": "%s",
                        "employeeId": "%s",
                        "branchId": "%s",
                        "startTime": "%s",
                        "endTime": "%s",
                        "type": "PRESENCIAL"
                    }
                """.formatted(title, employeeId, branchId,
                LocalDateTime.now().plusDays(1).toString(),
                LocalDateTime.now().plusDays(1).plusHours(1).toString());

        Appointment mockResponse = new Appointment();
        mockResponse.setId(UUID.randomUUID());
        mockResponse.setTitle(title);
        mockResponse.setStatus(AppointmentStatus.PENDING);
        mockResponse.setType(AppointmentType.PRESENCIAL);

        when(scheduleUseCase.schedule(any(ScheduleAppointmentCommand.class)))
                .thenReturn(mockResponse);

        mockMvc.perform(post("/api/appointments")
                .contentType(MediaType.APPLICATION_JSON)
                .content(payload))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("PENDING"))
                .andExpect(jsonPath("$.type").value("PRESENCIAL"));
    }

    @Test
    void testScheduleAppointment_TimeSlotTaken() throws Exception {
        String title = "Revisión General";
        UUID branchId = UUID.randomUUID();
        UUID employeeId = UUID.randomUUID();

        String payload = """
                    {
                        "title": "%s",
                        "employeeId": "%s",
                        "branchId": "%s",
                        "startTime": "%s",
                        "endTime": "%s",
                        "type": "PRESENCIAL"
                    }
                """.formatted(title, employeeId, branchId,
                LocalDateTime.now().plusDays(1).toString(),
                LocalDateTime.now().plusDays(1).plusHours(1).toString());

        when(scheduleUseCase.schedule(any(ScheduleAppointmentCommand.class)))
                .thenThrow(new TimeSlotTakenException("Time slot is taken"));

        mockMvc.perform(post("/api/appointments")
                .contentType(MediaType.APPLICATION_JSON)
                .content(payload))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.error").value("Conflict"))
                .andExpect(jsonPath("$.message").value("Time slot is taken"));
    }
}
