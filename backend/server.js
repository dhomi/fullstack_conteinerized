const express = require("express");
const cors = require('cors')
const app = express();
const port = 8000;

app.use(cors())

app.get("/", (req, res) => {
	res.json([
		{
			id: 1,
			joke: "What’s a QA engineer’s favorite ice cream flavor? Cookie and Debug.",
		},
		{ id: 2, joke: "Why did the QA tester break up with their keyboard? It didn’t give enough feedback" },
		{ id: 3, joke: "What’s a QA engineer’s favorite place in town? The Error 404 Café" },
		{
			id: 4,
			joke: " QA engineer walks into a bar. Orders a beer. Orders 0 beers. Orders 99999999999 beers. Orders a lizard. Orders -1 beers. Orders a ueicbksjdhd",
		},
		{
			id: 5,
			joke: "That’s a Variant on my favourite saying - I don’t create the problems, I just find them",
		},
		{
			id: 6,
			joke: "Parallel lines have so much in common. It’s a shame they’ll never meet",
		},
		{
			id: 7,
			joke: "Why did the scarecrow win an award? Because he was outstanding in his field!",
		},
		{
			id: 8,
			joke: "Why don't oysters donate to charity? Because they are shellfish!",
		},
		{ id: 9, joke: "I'm on a whiskey diet. I've lost three days already" },
		{ id: 10, joke: "I used to play piano by ear, but now I use my hands" },
	]);
});

app.listen(port, () => console.log(`Listening on port ${port}`));