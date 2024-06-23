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
        const { beverage_id, quantity, consume_at } = req.body;

        // Validate parameters
        if (!beverage_id || !quantity || !consume_at) {
            return res.status(400).json({
                success: false,
                message: "Missing required parameters in request body",
            });
        }

        // Update or insert beverage log in the database
        const sql = mysql.format(
            "INSERT INTO beverage_log (user_id, beverage_id, quantity, consume_at) VALUES (?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)",
            [id, beverage_id, quantity, consume_at]
        );

        // Execute SQL query
        global.connection.query(sql, (err, results) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error adding/updating beverage log",
                    error: err.message,
                });
            }

            // Return success response
            res.status(200).json({
                success: true,
                message: "Added/Updated beverage log successfully",
                data: {
                    beverage_id: beverage_id,
                    quantity: quantity,
                    consume_at: consume_at,
                },
            });
        });
    });
};
