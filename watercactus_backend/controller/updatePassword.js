const mysql = require("mysql");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs"); // Include bcryptjs library

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

        // Assuming `new_password` and `current_password` are passed in the request body
        const { new_password, current_password } = req.body;

        if (!new_password || !current_password) {
            return res.status(400).json({
                success: false,
                message: 'Current password and new password are required',
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

                // Hash the new password before updating in the database
                bcrypt.hash(new_password, 10, (err, hashedNewPassword) => {
                    if (err) {
                        console.error('Error hashing new password:', err);
                        return res.status(500).json({
                            success: false,
                            message: 'Error hashing new password',
                            error: err.message,
                        });
                    }

                    // Update cactus_user table with the new hashed password
                    const updatePasswordSql = `
                        UPDATE cactus_user
                        SET hashed_password = ?
                        WHERE id = ?
                    `;

                    connection.query(updatePasswordSql, [hashedNewPassword, id], (err, results) => {
                        if (err) {
                            console.error('Error updating password for user:', err);
                            return res.status(500).json({
                                success: false,
                                message: 'Error updating password',
                                error: err.message,
                            });
                        }
                    
                        if (results.affectedRows === 0) {
                            return res.status(404).json({
                                success: false,
                                message: 'User not found or password update failed',
                            });
                        }
                    
                        return res.status(200).json({
                            success: true,
                            message: 'Password updated successfully',
                        });
                    });
                });
            });
        });
    });
};
