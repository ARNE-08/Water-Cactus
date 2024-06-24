const jwt = require("jsonwebtoken");
const mysql = require("mysql");

module.exports = (req, res) => {
    // Check if Authorization header is present
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json({
            success: false,
            message: "Authorization header is missing",
        });
    }

    // Split the Authorization header to extract the token
    const token = authHeader.split(" ")[1]; // Assuming token is sent as 'Bearer <token>'

    if (!token) {
        return res.status(401).json({
            success: false,
            message: "Token is missing",
        });
    }

    // Verify JWT token
    jwt.verify(token, process.env.SECRET_KEY, (err, decodedToken) => {
        if (err) {
            return res.status(401).json({
                success: false,
                message: "Invalid token",
            });
        }

        // Extract user id from decoded token
        const { id } = decodedToken;

        // Parse request body parameters
        const { index, reminder_time, enable, notification_id } = req.body;

        // Validate parameters
        if (!index || !reminder_time || !enable || !notification_id) {
            return res.status(400).json({
                success: false,
                message: "Missing required parameters in request body",
            });
        }

        // Update or insert beverage log in the database
        const sql = mysql.format(
            "INSERT INTO notification (id, user_id, reminder_time, enable, notification_id) VALUES (?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE reminder_time = VALUES(reminder_time), enable = VALUES(enable), notification_id = VALUES(notification_id)",
            [index, id, reminder_time, enable, notification_id]
        );

        // Execute SQL query
        global.connection.query(sql, (err, results) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error adding/updating notification",
                    error: err.message,
                });
            }

            // Return success response
            res.status(200).json({
                success: true,
                message: "Added/Updated notification successfully",
                data: {
                    index,
					reminder_time,
					enable,
					notification_id
                },
            });
        });
    });
};
