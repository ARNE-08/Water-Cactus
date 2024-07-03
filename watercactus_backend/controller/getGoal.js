const mysql = require("mysql");
var jwt = require("jsonwebtoken");

module.exports = (req, res) => {
  const { startDate, endDate } = req.body;

  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: "Authorization header is missing",
    });
  }
  const token = authHeader.split(" ")[1];
  if (!token) {
    return res.status(401).json({
      success: false,
      message: "Token is missing",
    });
  }

  jwt.verify(token, process.env.SECRET_KEY, (err, decodedToken) => {
    if (err) {
      return res.status(401).json({
        success: false,
        message: "Invalid token",
      });
    }
    // Extract user id from decoded token
    const { id } = decodedToken;

    // Validate parameters
    if (!startDate || !endDate) {
      return res.status(400).json({
        success: false,
        message: "Missing startDate or endDate in request body",
      });
    }

    const query = `
		SELECT goal_date, goal
			FROM water_goal
			WHERE goal_date BETWEEN ? AND ? AND user_id = ?
			ORDER BY goal_date;
		`;

    connection.query(query, [startDate, endDate, id], (err, results) => {
      if (err) {
        console.error("Error fetching water goals from database: " + err.stack);
        res.status(500).json({ success: false, message: "Internal server error" });
        return;
      }

      if (results.length === 0) {
        res.status(204).json({
          success: true,
          message: "No goals found for the specified time interval",
        });
      } else {
        res.status(200).json({ success: true, data: results });
      }
    });
  });
};
