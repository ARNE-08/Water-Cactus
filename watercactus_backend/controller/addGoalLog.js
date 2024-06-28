const jwt = require("jsonwebtoken");
const mysql = require("mysql");
const getCurrentDateTime = require("../utils/getCurrentDateTime");

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
    console.log("token: ", token);

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
        const { goal } = req.body;
        const date = getCurrentDateTime();

        // Validate parameters
        if (!goal) {
            return res.status(400).json({
                success: false,
                message: "Missing goal in request body",
            });
        }

        var sql = mysql.format(
            "INSERT INTO water_goal (user_id, goal_date, goal) VALUES (?, ?, ?)",
            [id, date, goal]
        );

        connection.query(sql, (err, results) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error adding goal",
                    error: err.message,
                });
            }

            // Return the fetched results
            return res.status(200).json({
                success: true,
                message: "Add water goal successfully",
                data: goal,
            });
        });
    }
    )
}
