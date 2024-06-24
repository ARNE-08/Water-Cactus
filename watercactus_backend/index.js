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

app.post("/signup", require("./controller/signup"));
app.post("/login", require("./controller/login"));
app.post("/getWater", require("./controller/getWater"));
app.post("/addUnit", require("./controller/addUnit"));
app.post("/addGender", require("./controller/addGender"));
app.post("/addActivityRate", require("./controller/addActivityRate"));
app.post("/addWeight", require("./controller/addWeight"));
app.post("/addWater", require("./controller/addWater"));
app.post("/addTotalIntake", require("./controller/addTotalIntake"));
app.post("/getBeverage", require("./controller/getBeverage"));
app.post("/addBeverage", require("./controller/addBeverage"));
app.post("/getGoal", require("./controller/getGoal"));
app.post("/getReminder", require("./controller/getReminder"));
app.post("/updateReminder", require("./controller/updateReminder"));
app.post("/getMaxNoti", require("./controller/getMaxNoti"));

app.get("/getWaterGoal", require("./controller/getWaterGoal"));
app.get("/getUnit", require("./controller/getUnit"));


app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
