package com.semothon.spring_server.common.service;

import com.semothon.spring_server.common.exception.InvalidInputException;

public class ScoreNormalization {
    public static double normalize(double score) {
        if (score < -1.0 || score > 1.0) {
            throw new InvalidInputException("score must be between -1.0 and 1.0");
        }

        return (score + 1.0) * 50.0;
    }


    public static double denormalize(double normalized) {
        if (normalized < 0.0 || normalized > 100.0) {
            throw new InvalidInputException("normalized score must be between 0.0 and 100.0");
        }

        return (normalized / 50.0) - 1.0;
    }
}
