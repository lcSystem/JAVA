package com.appointment.domain.exception;

public class TimeSlotTakenException extends RuntimeException {
    public TimeSlotTakenException(String message) {
        super(message);
    }
}
