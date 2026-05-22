const jwt = require('jsonwebtoken');
const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2YTAzMDU5OGNkODlkYzgxMmU0MDRjNmMiLCJyb2xlIjoidXNlciIsImlhdCI6MTc3OTQ0MjEwMywiZXhwIjoxNzc5NDQ1NzAzfQ.ed56V3zlle_h1H71Sjld01BV3r5BdM7GxTv9LL-8nZU";
fetch('http://localhost:10000/api/users/favorites', {
    headers: { 'Authorization': 'Bearer ' + token }
}).then(r => r.text()).then(text => console.log("Response:", text)).catch(e => console.error(e));
