const mysql = require("mysql");
const bcrypt = require("bcrypt");
const jwt = require('jsonwebtoken');
require('dotenv').config();

module.exports = async (req, res) => {
    const { email, password } = req.body;
    const salt1 = await bcrypt.genSalt(10);
    const hash1 = await bcrypt.hash(password, salt1);

    // Check if email already exists
    var checkemailQuery = mysql.format("SELECT * FROM cactus_user WHERE email = ?", [email]);
    connection.query(checkemailQuery, (err, rows) => {
        if (err) {
            return res.json({
                success: false,
                data: null,
                error: err.message,
            });
        }

        if (rows.length > 0) {
            // email already exists
            return res.status(400).json({
                success: false,
                data: null,
                error: "Account already exists",
            });
        }

        // email does not exist, proceed with registration
        var insertQuery = mysql.format(
            "INSERT INTO cactus_user (email, hashed_password) VALUES (?, ?)",
            [email, hash1]
        );

        connection.query(insertQuery, (err, rows) => {
            if (err) {
                return res.status(400).json({
                    success: false,
                    data: null,
                    error: err.message,
                });
            }

            const token = jwt.sign({ id: rows.insertId }, process.env.SECRET_KEY);
            return res.status(200).json({ 
                success: true,
                data: { token },
                error: null
             });
        });
    });
};