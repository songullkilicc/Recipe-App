
-- Drop existing tables if any
DROP TABLE IF EXISTS Recipe_Ingredients;
DROP TABLE IF EXISTS Recipes;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;

-- Create Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- Create Categories table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Create Ingredients table
CREATE TABLE Ingredients (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    unit VARCHAR(20)
);

-- Create Recipes table
CREATE TABLE Recipes (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    category_id INT,
    title VARCHAR(100) NOT NULL,
    instructions TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Create Recipe_Ingredients table
CREATE TABLE Recipe_Ingredients (
    recipe_id INT,
    ingredient_id INT,
    quantity FLOAT,
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);

-- Create a view to show recipes with user info
CREATE VIEW UserRecipes AS
SELECT u.username, r.title, r.created_at
FROM Users u
JOIN Recipes r ON u.user_id = r.user_id;

-- Stored procedure to add a new recipe
DELIMITER $$
CREATE PROCEDURE AddRecipe(
    IN u_id INT,
    IN c_id INT,
    IN r_title VARCHAR(100),
    IN r_instructions TEXT
)
BEGIN
    INSERT INTO Recipes (user_id, category_id, title, instructions)
    VALUES (u_id, c_id, r_title, r_instructions);
END$$
DELIMITER ;

-- Trigger to check for NULL title in Recipes
DELIMITER $$
CREATE TRIGGER BeforeInsertRecipe
BEFORE INSERT ON Recipes
FOR EACH ROW
BEGIN
    IF NEW.title IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Recipe title cannot be null.';
    END IF;
END$$
DELIMITER ;
