const mysql = require("mysql");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

// Assuming `connection` is already defined and connected as per your original code

module.exports = (req, res) => {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json({
            success: false,
            message: 'Authorization header is missing',
        });
    }

    const token = authHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'Token is missing',
        });
    }

    jwt.verify(token, process.env.SECRET_KEY, (err, decodedToken) => {
        if (err) {
            return res.status(401).json({
                success: false,
                message: 'Invalid token',
            });
        }

        // Assuming `current_password` and `new_email` are passed in the request body
        const { current_password, new_email } = req.body;

        if (!current_password || !new_email) {
            return res.status(400).json({
                success: false,
                message: 'Current password and new email are required',
            });
        }

        // Fetch the user's hashed password from the database
        const id = decodedToken.id; // Assuming id is stored in decoded token
        const fetchUserSql = `
            SELECT hashed_password
            FROM cactus_user
            WHERE id = ?
        `;

        connection.query(fetchUserSql, [id], (err, results) => {
            if (err) {
                console.error('Error fetching user:', err);
                return res.status(500).json({
                    success: false,
                    message: 'Error fetching user',
                    error: err.message,
                });
            }

            if (results.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'User not found',
                });
            }

            const hashedPassword = results[0].hashed_password;

            // Compare current_password (plain text) with hashedPassword
            bcrypt.compare(current_password, hashedPassword, (err, isMatch) => {
                if (err) {
                    console.error('Error comparing passwords:', err);
                    return res.status(500).json({
                        success: false,
                        message: 'Error comparing passwords',
                        error: err.message,
                    });
                }

                if (!isMatch) {
                    return res.status(401).json({
                        success: false,
                        message: 'Current password is incorrect',
                    });
                }

                // Update cactus_user table with the new email
                const updateEmailSql = `
                    UPDATE cactus_user
                    SET email = ?
                    WHERE id = ?
                `;

                connection.query(updateEmailSql, [new_email, id], (err, results) => {
                    if (err) {
                        console.error('Error updating email for user:', err);
                        return res.status(500).json({
                            success: false,
                            message: 'Error updating email',
                            error: err.message,
                        });
                    }
                
                    if (results.affectedRows === 0) {
                        return res.status(404).json({
                            success: false,
                            message: 'User not found or email update failed',
                        });
                    }
                
                    return res.status(200).json({
                        success: true,
                        message: 'Email updated successfully',
                    });
                });
            });
        });
    });
};
