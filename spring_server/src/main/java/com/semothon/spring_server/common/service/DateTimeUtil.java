package com.semothon.spring_server.common.service;

import java.time.LocalDateTime;
import java.time.ZoneId;

public class DateTimeUtil {


    private static final ZoneId UTC = ZoneId.of("UTC");
    private static final ZoneId KST = ZoneId.of("Asia/Seoul");


    /**
     * UTC 기준 LocalDateTime을 KST 기준 LocalDateTime으로 변환
     */
    public static LocalDateTime convertUTCToKST(LocalDateTime utcDateTime) {
        if (utcDateTime == null) {
            return null;
        }
        return utcDateTime.atZone(UTC).withZoneSameInstant(KST).toLocalDateTime();
    }

    /**
     * KST 기준 LocalDateTime을 UTC 기준 LocalDateTime으로 변환
     */
    public static LocalDateTime convertKSTToUTC(LocalDateTime kstDateTime) {
        if (kstDateTime == null) {
            return null;
        }
        return kstDateTime.atZone(KST).withZoneSameInstant(UTC).toLocalDateTime();
    }
}

