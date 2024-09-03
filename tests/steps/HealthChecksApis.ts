import { createBdd } from 'playwright-bdd';
const { Given, When, Then } = createBdd()
import { expect } from '@playwright/test';


let endpoint: string;
let response: any = {}
let body: any = {}
let accestoken: string


const API_KEY = 'dummy'

const headers = {
	'x-api-key': API_KEY,
};

Given('dat ik het endpoint {string} heb', async ({ }, url: string) => {
	endpoint = url;
});

When('ik een GET-request naar de API stuur', async ({ request }) => {
	try {
		response = await request.get(endpoint, { headers })
		body = response.json()
	} catch (error) {
		if (error.response) {
			response = error.response; // als de API een fout geeft, sla het antwoord op
			console.log('Error Response:', response); // Log the error response
		} else {
			console.error('Error:', error.message); // Log the error message
			throw new Error(`Er is een fout opgetreden bij het versturen van de GET-aanvraag: ${error.message}`);
		}
	}
})

Then('zou de responsestatuscode 200 moeten zijn', async () => {
	expect(response.status()).toBe(200)
})