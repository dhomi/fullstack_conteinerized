const express = require('express')
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express()
const port = 8000

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

app.use(cors());

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post('/', (req, res) => {
    const joke = req.body;

    // output the joke to the console for debugging
    console.log(joke);
    qaJokes.push(joke);

    res.send('joke is added to the database');
});

app.get('/', (req, res) => {
    res.json(qaJokes);
});

app.get('/:id', (req, res) => {
    // reading id from the URL
    const id = req.params.id;

    // searching qaJokes for the id
    for (let joke of qaJokes) {
        if (joke.id === id) {
            res.json(joke);
            return;
        }
    }

    // sending 404 when not found something is a good practice
    res.status(404).send('joke not found');
});

app.delete('/:id', (req, res) => {
    // reading id from the URL
    const id = req.params.id;

    // remove item from the qaJokes array
    qaJokes = qaJokes.filter(i => {
        if (i.id !== id) {
            return true;
        }

        return false;
    });

    // sending 404 when not found something is a good practice
    res.send('joke is deleted');
});

app.post('/:id', (req, res) => {
    // reading id from the URL
    const id = req.params.id;
    const newjoke = req.body;

    // remove item from the qaJokes array
    for (let i = 0; i < qaJokes.length; i++) {
        let joke = qaJokes[i]

        if (joke.id === id) {
            qaJokes[i] = newjoke;
        }
    }

    // sending 404 when not found something is a good practice
    res.send('joke is edited');
});

app.listen(port, () => console.log(`Hello world app listening on port ${port}!`));