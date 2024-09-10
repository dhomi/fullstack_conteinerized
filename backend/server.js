const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(bodyParser.raw());

app.use(express.json())
app.use(cors());

const port = process.env.PORT || 8000;

// Import the users routes
const usersRoutes = require('./items');

// Use the users routes
app.use('/', usersRoutes);

app.listen(port, () => {
	console.log(`Server is running on port ${port}`);
});
