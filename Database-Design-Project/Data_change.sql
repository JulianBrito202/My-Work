USE [EERDBS-20];
GO

-- Candy
UPDATE Purchase_Table
SET Category = 'Candy'
WHERE Item_Description LIKE '%candy%'
   OR Item_Description LIKE '%gum%'
   OR Item_Description LIKE '%bar%';

-- Household
UPDATE Purchase_Table
SET Category = 'Household'
WHERE Item_Description LIKE '%closet%'
   OR Item_Description LIKE '%bathroom%'
   OR Item_Description LIKE '%soap%'
   OR Item_Description LIKE '%desk%'
   OR Item_Description LIKE '%dish%'
   OR Item_Description LIKE '%brush%'
   OR Item_Description LIKE '%cup%'
   OR Item_Description LIKE '%lighter%'
   OR Item_Description LIKE '%socks%'
   OR Item_Description LIKE '%tissue%';

-- School
UPDATE Purchase_Table
SET Category = 'School'
WHERE Item_Description LIKE '%pens%';

-- Video Games
UPDATE Purchase_Table
SET Category = 'Video Games'
WHERE ReceiptNo BETWEEN 27 AND 75;

-- Entertainment
UPDATE Purchase_Table
SET Category = 'Entertainment'
WHERE Item_Description LIKE '%TV%'
   OR Item_Description LIKE '%ticket%'
   OR Item_Description LIKE '%space lime%'
   OR Item_Description LIKE '%flower%'
   OR Item_Description LIKE '%Honey pack%'
   OR Item_Description LIKE '%swisher%';

-- Parking
UPDATE Purchase_Table
SET Category = 'Parking'
WHERE Item_Description LIKE '%parking%';

-- Recurring
UPDATE Purchase_Table
SET Category = 'Recurring'
WHERE Item_Description LIKE '%membership%';

-- Food
UPDATE Purchase_Table
SET Category = 'Food'
WHERE Item_Description LIKE '%sandwich%'
   OR Item_Description LIKE '%chick%'
   OR Item_Description LIKE '%buffalo%'
   OR Item_Description LIKE '%taco%'
   OR Item_Description LIKE '%pepperoni%'
   OR Item_Description LIKE '%burger%'
   OR Item_Description LIKE '%pounder%'
   OR Item_Description LIKE '%burrito%'
   OR Item_Description LIKE '%fries%'
   OR Item_Description LIKE '%rice%'
   OR Item_Description LIKE '%cheese%'
   OR Item_Description LIKE '%chips%';

-- RideShare
UPDATE Purchase_Table
SET Category = 'RideShare'
WHERE Item_Description LIKE '%ride%';

-- Housing
UPDATE Purchase_Table
SET Category = 'Housing'
WHERE Item_Description LIKE '%apartment%'
   OR Item_Description LIKE '%rent%';

-- Drinks
UPDATE Purchase_Table
SET Category = 'Drinks'
WHERE Item_Description LIKE '%white claw%'
   OR Item_Description LIKE '%oz%';

-- View results
SELECT * FROM Purchase_Table;

SELECT Category, COUNT(*) AS Count
FROM Purchase_Table
GROUP BY Category
ORDER BY Count DESC;