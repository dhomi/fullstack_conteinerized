const express = require("express")
const cors = require('cors')
const app = express()
const port = 8000;

app.use(cors())
app.listen(port, () => console.log(`Listening on port ${port}`))

const data = [
	{ id: 1, item: "QA engineer walks into a bar. Orders a beer, then 0 beers, then 99999999999 beers. Orders a lizard, then -1 beers. Orders a ueicbksjdhd" },
	{ id: 2, item: "Why did the QA tester break up with their keyboard? It didn it give enough feedback" },
	{ id: 3, item: "What is a QA engineer is favorite place in town? The Error 404 Cafe" },
	{ id: 4, item: "What is a QA engineer is favorite ice cream flavor? Cookie and Debug.", },
	{ id: 5, item: "That is a Variant on my favourite saying - I do not create the problems, I just find them", },
	{ id: 6, item: "Parallel lines have so much in common. It is a shame they ill never meet", },
	{ id: 7, item: "Why did the scarecrow win an award? Because he was outstanding in his field!", },
	{ id: 8, item: "Why don't oysters donate to charity? Because they are shellfish!", },
	{ id: 9, item: "I am on a whiskey diet. I haveve lost three days already" },
	{ id: 10, item: "I used to play piano by ear, but now I use my hands" },
];

app.use(express.json())

// Read (GET) all items
app.get('/', (req, res) => {
	res.json(data)
	res.status(200)
	console.log(res.json(data))
})

// Read (GET) a specific item by ID
app.get('/:id', (req, res) => {
	const id = parseInt(req.params.id)
	const item = data.find((item) => item.id === id)
	if (!item) {
		res.status(404).json({ error: 'Item not found' })
	} else {
		res.json(item)
	}
})

// Create (POST) a new item
app.post('/', (req, res) => {
	const newItem = req.body;
	data.push(newItem)
	res.status(201).json(newItem)
})

// Update (PUT) an item by ID
app.put('/:id', (req, res) => {
	const id = parseInt(req.params.id)
	const updatedItem = req.body;
	const index = data.findIndex((item) => item.id === id)
	if (index === -1) {
		res.status(404).json({ error: 'Item not found' })
	} else {
		data[index] = { ...data[index], ...updatedItem };
		res.json(data[index])
	}
})

// Delete (DELETE) an item by ID
app.delete('/:id', (req, res) => {
	const id = parseInt(req.params.id)
	const index = data.findIndex((item) => item.id === id)
	if (index === -1) {
		res.status(404).json({ error: 'Item not found' })
	} else {
		const deletedItem = data.splice(index, 1)
		res.json(deletedItem[0])
	}
})