const mysql = require("mysql");

module.exports = (req, res) => {
    var sql = mysql.format(
        "SELECT title, detail FROM info_card"
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
            data: rows,
        });
    });
}
