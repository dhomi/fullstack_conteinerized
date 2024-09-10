
const express = require('express');
const router = express.Router();

let qaJokes = [
	{ id: 1, joke: "QA engineer walks into a bar. Orders a beer, then 0 beers, then 99999999999 beers. Orders a lizard, then -1 beers. Orders a ueicbksjdhd" },
	{ id: 2, joke: "Why did the QA tester break up with their keyboard? It didn it give enough feedback" },
	{ id: 3, joke: "What is a QA engineer is favorite place in town? The Error 404 Cafe" },
	{ id: 4, joke: "What is a QA engineer is favorite ice cream flavor? Cookie and Debug.", },
	{ id: 5, joke: "That is a Variant on my favourite saying - I do not create the problems, I just find them", },
	{ id: 6, joke: "Parallel lines have so much in common. It is a shame they ill never meet", },
	{ id: 7, joke: "Why did the scarecrow win an award? Because he was outstanding in his field!", },
	{ id: 8, joke: "Why don't oysters donate to charity? Because they are shellfish!", },
	{ id: 9, joke: "I am on a whiskey diet. I haveve lost three days already" },
	{ id: 10, joke: "I used to play piano by ear, but now I use my hands" },
];

// Get all qaJokes
router.get('/', (req, res) => {
	res.json(qaJokes);
});

// Get a single qaJoke by ID
router.get('/:id', (req, res) => {
	const { id } = req.params;
	const qaJoke = qaJokes.find((qaJoke) => qaJoke.id === parseInt(id));

	if (!qaJoke) {
		return res.status(404).json({ message: 'Kan de QA mop niet vinden... foetsie!?' });
	}

	res.json(qaJoke);
});

// POST a new qaJoke
router.post('/', (req, res) => {
	const joke = JSON.parse(req.rawHeaders[3]).item

	// Eenvoudige validatie
	if (!joke) {
		return res.status(400).json({ message: 'joke is verplicht...pfff, dat kan je toch tenminste WEL meegeven?! lol ;)' });
	}

	const newQaJoke = { id: qaJokes.length + 1, joke };
	qaJokes.push(newQaJoke);
	console.log('Got body:', joke);

	res.status(201).json(newQaJoke);
});

// Update an existing qaJoke by ID
router.put('/:id', (req, res) => {
	const { id } = req.params;
	const { joke } = req.body;

	// Simple validation
	if (!joke) {
		return res.status(400).json({ message: 'joke is verplicht toch?...pfff, WEL meegeven hoor?! lol ;)' });
	}

	const qaJoke = qaJokes.find((qaJoke) => qaJoke.id === parseInt(id));

	if (!qaJoke) {
		return res.status(404).json({ message: 'Niet gevonden... misschien was ie te grappig?' });
	}

	qaJoke.joke = joke;
	qaJoke.age = age;

	res.json(qaJoke);
});

// Delete a qaJoke by ID
router.delete('/:id', (req, res) => {
	const { id } = req.params;
	qaJokes = qaJokes.filter((qaJoke) => qaJoke.id !== parseInt(id));
	res.sendStatus(204);
});

module.exports = router;