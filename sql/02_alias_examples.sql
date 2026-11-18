-- ============================================================
-- Рабочие примеры из руководства: алиасы таблиц и столбцов
-- ============================================================

USE alias_db;

-- ------------------------------------------------------------
-- 2. Алиасы таблиц
-- ------------------------------------------------------------

-- Пример без алиасов
SELECT customers.name, orders.order_date, orders.amount
FROM customers
JOIN orders ON customers.id = orders.customer_id;

-- Тот же запрос с алиасами
SELECT c.name, o.order_date, o.amount
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Самосоединение: алиасы обязательны
SELECT e.name AS employee, m.name AS manager
FROM employees e
JOIN employees m ON e.manager_id = m.id;

-- Неоднозначный id решается алиасами
SELECT c.id AS customer_id, o.id AS order_id
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Производная таблица: алиас обязателен
SELECT *
FROM (SELECT customer_id, SUM(amount) AS total FROM orders GROUP BY customer_id) AS t;

-- ------------------------------------------------------------
-- 3. Алиасы столбцов
-- ------------------------------------------------------------

SELECT name AS customer_name,
       email AS contact_email
FROM customers;

SELECT customer_id,
       COUNT(*) AS order_count,
       SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id;

-- Алиас в ORDER BY
SELECT id, amount * 2 AS double_amount
FROM orders
ORDER BY double_amount DESC;

-- Алиас в WHERE использовать нельзя (ошибка в 03_errors.sql),
-- поэтому выражение повторяем:
SELECT id, amount * 2 AS double_amount
FROM orders
WHERE amount * 2 > 1000;

-- ------------------------------------------------------------
-- 5. Алиасы в подзапросах
-- ------------------------------------------------------------

-- В FROM (производная таблица)
SELECT c.name, o.total
FROM customers c
JOIN (
    SELECT customer_id, SUM(amount) AS total
    FROM orders
    GROUP BY customer_id
) o ON c.id = o.customer_id
WHERE o.total > 2000;

-- В SELECT (скалярный подзапрос)
SELECT c.name,
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.id) AS order_count
FROM customers c;

-- ------------------------------------------------------------
-- 6. Алиасы и JOIN
-- ------------------------------------------------------------

SELECT c.name AS customer,
       o.order_date,
       o.amount,
       o.amount * 2 AS double_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'paid'
ORDER BY double_amount DESC;

-- ------------------------------------------------------------
-- 9. Полный пример «до и после»
-- ------------------------------------------------------------

-- Без алиасов
SELECT customers.name, COUNT(orders.id) AS order_count, SUM(orders.amount) AS total_amount
FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name
ORDER BY total_amount DESC;

-- С алиасами
SELECT c.name, COUNT(o.id) AS order_count, SUM(o.amount) AS total_amount
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY total_amount DESC;
