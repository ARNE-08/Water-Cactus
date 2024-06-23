const jwt = require("jsonwebtoken");
const mysql = require("mysql");
const convertWaterUnit = require("../utils/convertWaterUnit");

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

        var sql = mysql.format(
            "SELECT unit, weight, activity_rate FROM cactus_user WHERE id = ?",
            [id]
        );

        connection.query(sql, (err, rows) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error querying",
                    error: err.message,
                });
            }

            let goal = parseFloat(rows[0].weight) * 0.67
            if (rows[0].activity_rate === 'low') {
                goal = goal + parseFloat(convertWaterUnit(350, 'ml'))
            } else if (rows[0].activity_rate === 'moderate') {
                goal = goal + parseFloat(convertWaterUnit(700, 'ml'))
            } else if (rows[0].activity_rate === 'high') {
                goal = goal + parseFloat(convertWaterUnit(1050, 'ml'))
            }

            if (rows[0].unit === 'ml')
                goal = convertWaterUnit(goal, 'oz')

            // Return the fetched results
            return res.status(200).json({
                success: true,
                data: goal,
            });
        });
    })
}
