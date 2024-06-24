const jwt = require("jsonwebtoken");

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

        // Query to fetch total_intake from water_stat for the current user and specified date interval
        const sql = `
            SELECT *
            FROM notification
            WHERE user_id = ?
        `;

        connection.query(sql, id, (err, results) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error retrieving beverage data",
                    error: err.message,
                });
            }

            if (results.length === 0) {
                return res.status(204).json({
                    success: false,
                    message: "No notification row found",
                });
            }

            // Return the fetched results
            return res.status(200).json({
                success: true,
                message: "Notification data retrieved successfully",
                data: results,
            });
        });
    });
};
