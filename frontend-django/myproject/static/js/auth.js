// // Authentication helper for frontend

// /**
//  * Retrieve the token from cookies
//  * @returns {string|null} The token if available, otherwise null
//  */
// function getToken() {
//     const value = `; ${document.cookie}`;
//     const parts = value.split(`; access_token=`);
//     if (parts.length === 2) return parts.pop().split(';').shift();
//     return null;
// }

// /**
//  * Set the token in cookies
//  * @param {string} token - The token to set
//  */
// function setToken(token) {
//     const expires = new Date();
//     expires.setTime(expires.getTime() + (7 * 24 * 60 * 60 * 1000)); // 7 days
//     document.cookie = `access_token=${token}; expires=${expires.toUTCString()}; path=/; Secure; HttpOnly`;
// }

// /**
//  * Delete the authentication token from cookies
//  */
// function deleteToken() {
//     document.cookie = 'access_token=; Max-Age=-99999999; path=/; Secure; HttpOnly';
// }

// /**
//  * Perform login and store token
//  * @param {string} url - The login endpoint
//  * @param {Object} credentials - The login credentials (username, password, etc.)
//  * @returns {Promise<boolean>} True if login successful, false otherwise
//  */
// async function authenticate(url, credentials) {
//     try {
//         const response = await fetch(url, {
//             method: 'POST',
//             headers: {
//                 'Content-Type': 'application/json',
//             },
//             body: JSON.stringify(credentials),
//         });

//         if (response.ok) {
//             const data = await response.json();
//             setToken(data.access_token);
//             return true;
//         }
//         return false;
//     } catch (error) {
//         console.error('Authentication error:', error);
//         return false;
//     }
// }

// /**
//  * Logout user by clearing token
//  */
// function logout() {
//     deleteToken();
//     window.location.href = '/login';
// }

// /**
//  * Check if the user is authenticated
//  * @returns {boolean} True if authenticated, false otherwise
//  */
// function isAuthenticated() {
//     return getToken() !== null;
// }

// export { getToken, setToken, deleteToken, authenticate, logout, isAuthenticated };
