
package com.trafficiq.dao;

import com.trafficiq.model.User;
import com.trafficiq.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User login(String username, String password) {
        if (username == null || password == null) {
            return null;
        }

        String sql = """
                SELECT user_id, username, password, role
                FROM users WHERE username = ?
                """;

        try (Connection con = DBConnection.getConnection()) {
            int id;
            String dbUsername;
            String storedPassword;
            String role;

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username.trim());

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return null;
                    }

                    id = rs.getInt("user_id");
                    dbUsername = rs.getString("username");
                    storedPassword = rs.getString("password");
                    role = rs.getString("role");
                }
            }

            if (!verifyPassword(password, storedPassword)) {
                return null;
            }

            // Migrate legacy plaintext passwords after successful login.
            if (!isBCryptHash(storedPassword)) {
                updatePasswordHash(con, id, password);
            }

            User user = new User();
            user.setUserId(id);
            user.setUsername(dbUsername);
            user.setRole(role);
            user.setPassword(null);
            return user;

        } catch (Exception e) {
            System.err.println("Login database operation failed.");
            e.printStackTrace();
            return null;
        }
    }

    private boolean verifyPassword(String submitted, String stored) {
        if (stored == null) {
            return false;
        }

        if (isBCryptHash(stored)) {
            try {
                return BCrypt.checkpw(submitted, stored);
            } catch (IllegalArgumentException e) {
                return false;
            }
        }

        // Temporary backward compatibility for existing accounts.
        return stored.equals(submitted);
    }

    private boolean isBCryptHash(String value) {
        return value != null &&
                (value.startsWith("$2a$") ||
                        value.startsWith("$2b$") ||
                        value.startsWith("$2y$"));
    }

    private void updatePasswordHash(
            Connection con, int userId, String password)
            throws SQLException {

        String sql = """
                UPDATE users SET password = ?
                WHERE user_id = ?
                """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(password, BCrypt.gensalt(12)));
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();

        String sql = """
                SELECT user_id, username, role
                FROM users ORDER BY user_id
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }
        }

        return users;
    }

    public boolean createUser(
            String username, String password, String role)
            throws SQLException {

        if (username == null || username.isBlank()
                || password == null || password.length() < 8
                || role == null || !role.equals("OPERATOR")) {
            return false;
        }

        String sql = """
                INSERT INTO users (username, password, role)
                VALUES (?, ?, ?)
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(
                    2, BCrypt.hashpw(password, BCrypt.gensalt(12)));
            ps.setString(3, "OPERATOR");

            return ps.executeUpdate() == 1;
        }
    }

    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
