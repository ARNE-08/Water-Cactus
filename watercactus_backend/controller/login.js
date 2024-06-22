const mysql = require("mysql");
const bcrypt = require("bcrypt");
var jwt = require("jsonwebtoken");

module.exports = (req, res) => {
    const { email, password } = req.body;

    var sql = mysql.format("SELECT * FROM cactus_user WHERE email = ?", [email]);
    connection.query(sql, (err, rows) => {
        if (err) {
            return res.json({
                success: false,
                data: null,
                error: err.message,
            });
        }

        numRows = rows.length;
        if (numRows == 0) {
            return res.status(400).json({
                success: false,
                message: "user not found in the system",
            });
        } else {
            bcrypt.compare(password, rows[0].hashed_password, (err, valid) => {
                if (err) {
                    return res.status(400).json({
                        success: false,
                        message: "Error comparing passwords",
                    });
                }

                if (valid) {
                    const token = jwt.sign(
                        {
							id: rows[0].id,
                        },
                        process.env.SECRET_KEY
                    );

                    return res.status(200).json({
                        success: true,
                        message: "Login credential is correct",
                        data: { token },
                    });
                } else {
                    return res.status(400).json({
                        success: true,
                        message: "Login credential is incorrect",
                    });
                }
            });
        }
    });
};
