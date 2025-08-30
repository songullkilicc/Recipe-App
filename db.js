
const mysql = require('mysql2');
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',       // kullanıcı adınızı yazın
    password: '',       // şifrenizi yazın
    database: 'recipe_db'
});

db.connect((err) => {
    if (err) {
        console.error('MySQL bağlantı hatası:', err);
    } else {
        console.log('MySQL veritabanına bağlanıldı.');
    }
});

module.exports = db;
