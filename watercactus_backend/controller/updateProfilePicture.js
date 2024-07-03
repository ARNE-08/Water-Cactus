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

        // Assuming `current_password` and `profile_picture_id` are passed in the request body
        const { current_password, profile_picture_id } = req.body;

        if (!current_password || !profile_picture_id) {
            return res.status(400).json({
                success: false,
                message: 'Current password and profile_picture_id are required',
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

                // Update cactus_user table with the selected profile_picture_id
                const updateUserSql = `
                    UPDATE cactus_user
                    SET profile_pic_id = ?
                    WHERE id = ?
                `;

                connection.query(updateUserSql, [profile_picture_id, id], (err, results) => {
                    if (err) {
                        console.error('Error updating profile picture for user:', err);
                        return res.status(500).json({
                            success: false,
                            message: 'Error updating profile picture',
                            error: err.message,
                        });
                    }
                
                    if (results.affectedRows === 0) {
                        return res.status(404).json({
                            success: false,
                            message: 'User not found or profile_picture_id does not exist',
                        });
                    }
                
                    return res.status(200).json({
                        success: true,
                        message: 'Profile picture updated successfully',
                    });
                });
            });
        });
    });
};
