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
app.post("/updateBeverage", require("./controller/updateBeverage"));
app.post("/addGoal", require("./controller/addGoalLog"));
app.post("/addReminder", require("./controller/addReminder"));
app.post("/deleteReminder", require("./controller/deleteReminder"));

app.get("/getGoalToday", require("./controller/getGoalToday"));
app.get("/getWaterGoal", require("./controller/getWaterGoal"));
app.get("/getUnit", require("./controller/getUnit"));
app.get("/getEmail", require("./controller/getEmail"));
app.get("/getInfo", require("./controller/getInfo"));
app.get("/getUserProfile", require("./controller/getUserProfile"));
app.post("/getProfilePicture", require("./controller/getProfilePicture"));
app.put("/updateProfilePicture", require("./controller/updateProfilePicture"));
app.put("/updateEmail", require("./controller/updateEmail"));
app.put("/updatePassword", require("./controller/updatePassword"));

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
