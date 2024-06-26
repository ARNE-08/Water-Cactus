const mysql = require("mysql");
const jwt = require("jsonwebtoken");

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

        // Assuming `profile_picture_id` is passed in the request body
        const { profile_picture_id } = req.body;

        if (!profile_picture_id) {
            return res.status(400).json({
                success: false,
                message: 'profile_picture_id is required',
            });
        }

        // Update cactus_user table with the selected profile_picture_id
        const id = decodedToken.id; // Assuming id is stored in decoded token
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
};
