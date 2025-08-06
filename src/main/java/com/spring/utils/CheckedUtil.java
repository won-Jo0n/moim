package com.spring.utils;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
public class CheckedUtil {

    public static String formatPhoneNumber(String phone) {
        String digits = phone.replaceAll("\\D", "");

        if (digits.length() == 11) {
            return digits.replaceFirst("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        } else if (digits.length() == 10) {
            return digits.replaceFirst("(\\d{3})(\\d{3})(\\d{4})", "$1-$2-$3");
        } else {
            return phone;
        }
    }

    public static boolean isValidPhone(String phone) {
        return phone.matches("^01[016789]-\\d{3,4}-\\d{4}$");
    }
}
