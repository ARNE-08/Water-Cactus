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
        const { stat_date, quantity } = req.body;

        // Validate parameters
        if (!stat_date || !quantity) {
            return res.status(400).json({
                success: false,
                message: "Missing required parameters in request body",
            });
        }

        // Query to fetch the latest goal_id for the user
        const goalIdQuery = mysql.format(
            "SELECT goal_id FROM water_goal WHERE user_id = ? ORDER BY goal_date DESC LIMIT 1",
            [id]
        );

        // Execute SQL query to fetch goal_id
        global.connection.query(goalIdQuery, (err, results) => {
            if (err) {
                return res.status(500).json({
                    success: false,
                    message: "Error fetching goal_id",
                    error: err.message,
                });
            }

            if (results.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: "No goal found for the user",
                });
            }

            const goal_id = results[0].goal_id;

            // Query to check if stat_date already exists for the user
            const checkStatDateQuery = mysql.format(
                "SELECT stat_id FROM water_stat WHERE user_id = ? AND stat_date = ?",
                [id, stat_date]
            );

            // Execute SQL query to check if stat_date already exists
            global.connection.query(checkStatDateQuery, (err, results) => {
                if (err) {
                    return res.status(500).json({
                        success: false,
                        message: "Error checking existing stat_date",
                        error: err.message,
                    });
                }

                if (results.length > 0) {
                    // stat_date already exists, update total_intake
                    const updateTotalIntakeQuery = mysql.format(
                        "UPDATE water_stat SET total_intake = total_intake + ? WHERE user_id = ? AND stat_date = ?",
                        [quantity, id, stat_date]
                    );

                    // Execute SQL query to update total_intake
                    global.connection.query(updateTotalIntakeQuery, (err, updateResults) => {
                        if (err) {
                            return res.status(500).json({
                                success: false,
                                message: "Error updating total intake",
                                error: err.message,
                            });
                        }

                        // Return success response
                        res.status(200).json({
                            success: true,
                            message: "Updated total intake successfully",
                            data: {
                                stat_date: stat_date,
                                quantity: quantity,
                            },
                        });
                    });
                } else {
                    // stat_date does not exist, insert new row
                    const insertNewRowQuery = mysql.format(
                        "INSERT INTO water_stat (user_id, stat_date, total_intake, goal_id) VALUES (?, ?, ?, ?)",
                        [id, stat_date, quantity, goal_id]
                    );

                    // Execute SQL query to insert new row
                    global.connection.query(insertNewRowQuery, (err, insertResults) => {
                        if (err) {
                            return res.status(500).json({
                                success: false,
                                message: "Error inserting new row",
                                error: err.message,
                            });
                        }

                        // Return success response
                        res.status(200).json({
                            success: true,
                            message: "Inserted new row successfully",
                            data: {
                                stat_date: stat_date,
                                quantity: quantity,
                                goal_id: goal_id,
                            },
                        });
                    });
                }
            });
        });
    });
};
