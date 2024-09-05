import { createBdd } from 'playwright-bdd';
const { Given, When, Then } = createBdd()
import { expect } from '@playwright/test';

let id: any
let eersteKlik: any
let tweedeKlik: any
let derdeKlik: any

Given('dat ik de URL {string} open', async ({ page }, url: string) => {
    await page.goto(url)
})

When('ik een op een card klik', async ({ page }) => {
    try {
        id = await page.getByText('😂 id: 1', { exact: true }).textContent()
        await page.getByText('😂 id: 1', { exact: true }).click()

        await page.getByText('"What is a QA engineer is favorite place in town? The Error 404 Cafe"').click()

        await page.getByRole('button', { name: 'Aantal kliks is' }).click()
        eersteKlik = await page.getByRole('button', { name: 'Aantal kliks is' }).textContent()

        await page.getByRole('button', { name: 'Aantal kliks is' }).click()
        tweedeKlik = await page.getByRole('button', { name: 'Aantal kliks is' }).textContent()

        await page.getByRole('button', { name: 'Aantal kliks is' }).click()
        derdeKlik = await page.getByRole('button', { name: 'Aantal kliks is' }).textContent()

    } catch (error) {
        console.error('Error:', error.message); // Log the error message
        throw new Error(`Er is een fout opgetreden bij het versturen van de GET-aanvraag: ${error.message}`);
    }
})

Then('zou de geklikte id {string} moeten zijn', async ({ page }, id: string) => {
    expect(id).toBe(id)
})

Then('zouden de opvolgende kliks met +1 verhoogd worden', async ({ }) => {
    // console.log('type 3eklik is:', typeof(derdeKlik), 'content ervan is: ', derdeKlik)
    expect(eersteKlik).toBe('Aantal kliks is 1')
    expect(tweedeKlik).toBe('Aantal kliks is 2')
    expect(derdeKlik).toBe('Aantal kliks is 3')
})