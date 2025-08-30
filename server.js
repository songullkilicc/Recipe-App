
const express = require('express');
const db = require('./db');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// Get all recipes
app.get('/recipes', (req, res) => {
    const sql = \`
        SELECT r.recipe_id, r.title, r.instructions, u.username, c.name AS category
        FROM Recipes r
        JOIN Users u ON r.user_id = u.user_id
        JOIN Categories c ON r.category_id = c.category_id
    \`;
    db.query(sql, (err, results) => {
        if (err) {
            res.status(400).json({ error: err.message });
        } else {
            res.json({ data: results });
        }
    });
});

app.listen(port, () => {
    console.log(\`Sunucu çalışıyor: http://localhost:\${port}\`);
});
