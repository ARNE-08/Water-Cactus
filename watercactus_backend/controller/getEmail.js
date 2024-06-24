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

        var sql = mysql.format(
            "SELECT email FROM cactus_user WHERE id = ?",
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

            // Return the fetched results
            return res.status(200).json({
                success: true,
                data: rows[0].email,
            });
        });
    })
}
