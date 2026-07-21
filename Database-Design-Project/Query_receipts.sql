--WE HAVE ALTERED SOME OF THE QUESTIONS SLIGHTLY TO FIT WORK WITHIN OUR DATABASE

-- 1. For each Owner, find and display total number of receipts together with the month's total and average amount ($) of receipts.

SELECT 
    r.Owner,
    COUNT(DISTINCT r.ReceiptNo) AS TotalReceipts,
    SUM(p.Total) AS TotalAmount,
    AVG(p.Total) AS AvgAmount
FROM Reciepts_Table r
JOIN Purchase_Table p ON r.ReceiptNo = p.ReceiptNo
GROUP BY r.Owner;


-- 2. Highest amount receipt per receipt type

SELECT r.Type, r.ReceiptNo, MAX(p.Total) AS HighestAmount
FROM Reciepts_Table r
JOIN Purchase_Table p ON r.ReceiptNo = p.ReceiptNo
GROUP BY r.Type, r.ReceiptNo
HAVING MAX(p.Total) = (
    SELECT MAX(p2.Total)
    FROM Purchase_Table p2
    JOIN Reciepts_Table r2 ON p2.ReceiptNo = r2.ReceiptNo
    WHERE r2.Type = r.Type
);


-- 3. Find and display the receipt number and amount ($) that is above the average of all receipts.

SELECT r.ReceiptNo, p.Total
FROM Reciepts_Table r
JOIN Purchase_Table p ON r.ReceiptNo = p.ReceiptNo
WHERE p.Total > (SELECT AVG(Total) FROM Purchase_Table);


-- 4. Find and display the receipt number and amount ($) that is most close to the average of all receipts, including receipts whose amount ($) is above and below the average.

SELECT TOP 1 r.ReceiptNo, p.Total
FROM Reciepts_Table r
JOIN Purchase_Table p ON r.ReceiptNo = p.ReceiptNo
ORDER BY ABS(p.Total - (SELECT AVG(Total) FROM Purchase_Table));


-- 5. Find and display the receipt number, type, and amount ($) of receipts with zero tax.

SELECT r.ReceiptNo, r.Type, p.Total
FROM Reciepts_Table r
JOIN Purchase_Table p ON r.ReceiptNo = p.ReceiptNo
WHERE p.Tax = 0;


-- 6. Receipts with three or more items

SELECT r.ReceiptNo, COUNT(p.Item_Description) AS TotalItems
FROM Reciepts_Table r
JOIN Purchase_Table p ON r.ReceiptNo = p.ReceiptNo
GROUP BY r.ReceiptNo
HAVING COUNT(p.Item_Description) >= 3;


-- 7. If a Receipt has an address with a capital E or N in it signifying whether the road travels North and East then display their receipt number and "North" or "East" with the receipt depending on which way the road of the address travels.

SELECT r.ReceiptNo,
       CASE 
            WHEN s.Location_Address LIKE '% N %' OR s.Location_Address LIKE 'N %' OR s.Location_Address LIKE '% N' THEN 'North'
            WHEN s.Location_Address LIKE '% E %' OR s.Location_Address LIKE 'E %' OR s.Location_Address LIKE '% E' THEN 'East'
       END AS Direction
FROM Reciepts_Table r
JOIN Store_Table s ON r.Store_ID = s.Store_ID
WHERE s.Location_Address LIKE '% N %'
   OR s.Location_Address LIKE '% E %'
   OR s.Location_Address LIKE 'N %'
   OR s.Location_Address LIKE 'E %'
   OR s.Location_Address LIKE '% N'
   OR s.Location_Address LIKE '% E';


-- 8. Line items with exactly three words

SELECT p.ReceiptNo, p.Item_Description
FROM Purchase_Table p
WHERE LEN(p.Item_Description) - LEN(REPLACE(p.Item_Description, ' ', '')) = 2;


-- 9. Highest unit price item

SELECT TOP 1 p.Item_Description, p.Subtotal AS UnitPrice, p.ReceiptNo
FROM Purchase_Table p
ORDER BY p.Subtotal DESC;


-- 10. Most popular item (appears in most receipts)

SELECT TOP 1 p.Item_Description,
       COUNT(DISTINCT p.ReceiptNo) AS NumberOfReceipts
FROM Purchase_Table p
GROUP BY p.Item_Description
ORDER BY COUNT(DISTINCT p.ReceiptNo) DESC;
