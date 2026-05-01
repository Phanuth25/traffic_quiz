require('dotenv').config({ path: './private/.env' });
const express = require('express');
const app = express();
const cors = require('cors');
const loginRoute = require('./private/controller/login');
const profileRoute = require('./private/controller/profile');
const postitemRoute = require('./private/controller/postitem');
const deleteitemRoute = require('./private/controller/deleteitem');
const registerRoute = require('./private/controller/register');
const register2Route = require('./private/controller/register2');
const khqrRoute = require('./private/controller/khqr');
const getitemRoute = require('./private/controller/getitem');
const postitemqty = require('./private/controller/postitemqty');





app.use(cors());
app.use(express.json());

// Routes
app.use('/api', loginRoute);
app.use('/api', profileRoute);
app.use('/api', postitemRoute);
app.use('/api/deleteitem', deleteitemRoute); // Specific path for delete
app.use('/api', registerRoute);
app.use('/api', register2Route);
app.use('/api', khqrRoute);
app.use('/api', getitemRoute);
app.use('/api', postitemqty);





app.listen(3000, () => console.log('Server started on port 3000'));
