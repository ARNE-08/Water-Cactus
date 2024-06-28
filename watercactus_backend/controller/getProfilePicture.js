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

        // // Extract user id from decoded token
        // const { id } = decodedToken;

        // Query to fetch total_intake from water_stat for the current user and specified date interval
        const sql = `
            SELECT profile_picture_id, picture_preset
            FROM profile_picture
        `;

        connection.query(sql, (err, results) => {
			if (err) {
			  console.error('Error retrieving profile picture data: ' + err.stack);
			  return res.status(500).json({
				success: false,
				message: 'Error retrieving profile picture data',
				error: err.message,
			  });
			}

			if (results.length === 0) {
			  return res.status(204).json({
				success: false,
				message: 'No profile pictures found',
			  });
			}

			// Return the fetched profile picture data
			return res.status(200).json({
			  success: true,
			  message: 'Profile pictures retrieved successfully',
			  data: results,
			});
		  });
    });
};

// const mysql = require("mysql");
// const jwt = require("jsonwebtoken");


// connection.connect((err) => {
//   if (err) {
//     console.error("Error connecting to the database: " + err.stack);
//     return;
//   }
//   console.log("Connected to the database.");
// });

// module.exports = (req, res) => {
//     const authHeader = req.headers.authorization;

//     if (!authHeader) {
//       return res.status(401).json({
//         success: false,
//         message: 'Authorization header is missing',
//       });
//     }

//     const token = authHeader.split(' ')[1];
//     if (!token) {
//       return res.status(401).json({
//         success: false,
//         message: 'Token is missing',
//       });
//     }

//     jwt.verify(token, process.env.SECRET_KEY, (err, decodedToken) => {
//       if (err) {
//         return res.status(401).json({
//           success: false,
//           message: 'Invalid token',
//         });
//       }

//       // Query to fetch all profile picture data from the profile_picture table
//       const sql = `
//         SELECT profile_picture_id, picture_preset
//         FROM profile_picture
//       `;

//       connection.query(sql, (err, results) => {
//         if (err) {
//           console.error('Error retrieving profile picture data: ' + err.stack);
//           return res.status(500).json({
//             success: false,
//             message: 'Error retrieving profile picture data',
//             error: err.message,
//           });
//         }

//         if (results.length === 0) {
//           return res.status(204).json({
//             success: false,
//             message: 'No profile pictures found',
//           });
//         }

//         // Return the fetched profile picture data
//         return res.status(200).json({
//           success: true,
//           message: 'Profile pictures retrieved successfully',
//           data: results,
//         });
//       });
//     });
//   };
