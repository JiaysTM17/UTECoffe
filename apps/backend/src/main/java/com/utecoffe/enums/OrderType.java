package com.utecoffe.enums;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum OrderType {
    DINE_IN,
    TAKE_AWAY,
    DELIVERY;

    @JsonCreator
    public static OrderType fromString(String value) {
        if (value == null) return TAKE_AWAY;
        String normalized = value.trim().toUpperCase().replace("-", "_").replace(" ", "_");
        if (normalized.equals("TAKEAWAY")) {
            return TAKE_AWAY;
        }
        for (OrderType type : values()) {
            if (type.name().equals(normalized)) {
                return type;
            }
        }
        return TAKE_AWAY;
    }
}

