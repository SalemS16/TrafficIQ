
        package com.trafficiq.dao;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordReset {

    public static void main(String[] args) {

        String newPassword = "TrafficIQ@123";

        String hashedPassword = BCrypt.hashpw(
                newPassword,
                BCrypt.gensalt()
        );

        System.out.println(hashedPassword);
    }
}
