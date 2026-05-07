const express = require('express');
const router = express.Router();
const db = require('../model/db');
const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET;
const bcrypt = require('bcrypt');

router.use(express.json());

router.post('/login', (req, res) => {
    // Match column names from your database (userid, password)
    const { userid, password } = req.body; 
    const sql = "SELECT * FROM users WHERE userid = ?";

    db.query(sql, [userid], async (err, results) => {
        if (err) return res.status(500).json({ error: err.message });

        if (results.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User ID not found"
            });
        }

        const user = results[0];

        // FIXED: Convert both to String and trim to avoid type mismatch or hidden spaces
        const dbPassword = String(user.password).trim();
        const inputPassword = String(password).trim();
         const isMatch = await bcrypt.compare(inputPassword, dbPassword);
        if (!isMatch) {
            return res.status(401).json({
                success: false,
                message: "Incorrect password"
            });
        }

        const token = jwt.sign(
            { id: user.id, userid: user.userid },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.status(200).json({
            success: true,
            message: "Login successful",
            token: token,
            userid: user.userid,
            id: user.userids,
        });
    });
});

module.exports = router;
