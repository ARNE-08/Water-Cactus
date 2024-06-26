const mysql = require("mysql");
const jwt = require("jsonwebtoken");

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

        // Assuming `new_email` is passed in the request body
        const { new_email } = req.body;

        if (!new_email) {
            return res.status(400).json({
                success: false,
                message: 'New email is required',
            });
        }

        // Update cactus_user table with the new email
        const id = decodedToken.id; // Assuming id is stored in decoded token
        const updateUserSql = `
            UPDATE cactus_user
            SET email = ?
            WHERE id = ?
        `;

        connection.query(updateUserSql, [new_email, id], (err, results) => {
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
};
