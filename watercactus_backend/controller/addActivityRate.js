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
        const { activity } = req.body;

        // Validate parameters
        if (!activity) {
            return res.status(400).json({
                success: false,
                message: "Missing activity in request body",
            });
        }

        var sql = mysql.format(
            "UPDATE cactus_user SET activity_rate = ? WHERE id = ?",
            [activity, id]
        );

        connection.query(sql, (err, results) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error updating",
                    error: err.message,
                });
            }

            // Return the fetched results
            return res.status(200).json({
                success: true,
                message: "Add activity successfully",
                data: activity,
            });
        });
    })
}
