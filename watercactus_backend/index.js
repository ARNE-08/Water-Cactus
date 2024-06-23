const express = require("express");
const mysql = require("mysql");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use(bodyParser.json({ type: "application/json" }));

app.use(
  cors({
    origin: "*",
    credentials: true,
  })
);

require("dotenv").config();

const connection = mysql.createConnection({
  host: process.env.DATABASE_URL,
  port: process.env.PORT,
  user: process.env.DATABASE_USER,
  password: process.env.PASSWORD,
  database: process.env.DATABASE_NAME,
});

connection.connect();
global.connection = connection;
console.log("Database is connected");

app.get("/", (req, res) => {
  res.send("Hello WaterCactus!");
});

function convertWaterUnit(weight, unit) {
  const conversionFactor = 29.5735; // 1 oz = 29.5735 ml

  weight = parseFloat(weight);

  if (unit.toLowerCase() === 'ml') {
    const convertedWeight = weight / conversionFactor;
    return `${convertedWeight.toFixed(2)}`;
  } else if (unit.toLowerCase() === 'oz') {
    const convertedWeight = weight * conversionFactor;
    return `${convertedWeight.toFixed(2)}`;
  } else {
    return 'Invalid unit. Please specify either "ml" or "oz".';
  }
}

// Example usage
// console.log(convertWaterUnit(500, 'ml')); // Output: "16.91 oz"

app.post("/signup", require("./controller/signup"));
app.post("/login", require("./controller/login"));
app.post("/getWater", require("./controller/getWater"));
app.post("/getGoal", require("./controller/getGoal"));
app.post("/addUnit", require("./controller/addUnit"));
app.post("/addGender", require("./controller/addGender"));
app.post("/addActivityRate", require("./controller/addActivityRate"));
app.post("/addWeight", require("./controller/addWeight"));
app.post("/addWater", require("./controller/addWater"));
app.post("/addTotalIntake", require("./controller/addTotalIntake"));
app.post("/getBeverage", require("./controller/getBeverage"));

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
