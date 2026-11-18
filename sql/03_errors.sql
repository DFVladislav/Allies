-- ============================================================
-- 7. Распространённые ошибки (выполняется с флагом -f,
--    чтобы клиент продолжил работу после ожидаемых ошибок)
-- ============================================================

USE alias_db;

-- 7.1. Ссылка на старое имя таблицы после объявления алиаса
-- Ожидаемая ошибка: Unknown column 'customers.name' in 'field list'
SELECT customers.name
FROM customers c;

-- 7.2. Пропущен AS для производной таблицы
-- Ожидаемая ошибка: Every derived table must have its own alias
SELECT * FROM (SELECT id FROM customers);

-- 7.3. Алиас в WHERE
-- Ожидаемая ошибка: Unknown column 'double_amount' in 'where clause'
SELECT amount * 2 AS double_amount FROM orders WHERE double_amount > 1000;

-- 7.4. Неоднозначный id без алиаса
-- Ожидаемая ошибка: Column 'id' in field list is ambiguous
SELECT id FROM customers JOIN orders ON customers.id = orders.customer_id;

-- 7.5. Забытый алиас в самосоединении
-- Ожидаемая ошибка: Not unique table/alias: 'employees'
SELECT * FROM employees JOIN employees ON employees.manager_id = employees.id;

-- А теперь правильные варианты из раздела 7:

SELECT c.name
FROM customers c;

SELECT * FROM (SELECT id FROM customers) AS t;

SELECT amount * 2 AS double_amount FROM orders WHERE amount * 2 > 1000;

SELECT c.id, o.id FROM customers c JOIN orders o ON c.id = o.customer_id;

SELECT e.name, m.name FROM employees e JOIN employees m ON e.manager_id = m.id;
