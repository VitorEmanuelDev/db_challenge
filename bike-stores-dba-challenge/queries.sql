-- 1. Listar todos os clientes que não tenham realizado uma compra

SELECT 
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  c.phone
FROM 
  customers c
LEFT JOIN
  orders o ON c.customer_id = o.customer_id
WHERE
  o.order_id IS NULL;

-- 2 Listar os produtos que não tenham sido comprados

SELECT
  p.product_id,
  p.product_name,
  b.brand_name,
  c.category_name
FROM
  products p
JOIN 
  brands b ON p.brand_id = b.brand_id
JOIN
  categories c ON p.category_id = c.category_id
LEFT JOIN 
  order_items oi ON p.product_id = oi.product_id
WHERE
  oi.order_id IS NULL;

-- 3. Listar os produtos sem estoque

SELECT
  p.product_id,
  p.product_name,
  b.brand_name,
  s.store_name,
  st.quantity
FROM
  products p
JOIN
  brands b ON p.brand_id = b.brand_id
JOIN
  stocks st ON p.product_id = st.product_id
JOIN 
  stores s ON st.store_id = s.store_id
WHERE
  st.quantity = 0;

-- 4. Agrupar a quantidade de vendas por marca e loja

SELECT 
  s.store_id,
  s.store_name,
  b.brand_id,
  b.brand_name,
  COUNT(oi.item_id) AS total_vendas
FROM
  stores s
CROSS JOIN 
  brands b
LEFT JOIN
  products p ON b.brand_id = p.brand_id
LEFT JOIN
  order_items oi ON p.product_id = oi.product_id
LEFT JOIN
  orders o ON oi.order_id = o.order_id AND o.store_id = s.store_id
GROUP BY
  s.store_id, s.store_name, b.brand_id, b.brand_name
ORDER BY 
  s.store_id, b.brand_id;

-- 5. Listar funcionarios sem pedidos relacionados
SELECT 
  s.staff_id,
  s.first_name,
  s.last_name,
  s.email,
  st.store_name
FROM
  staffs s
JOIN
  stores st ON s.store_id = st.store_id
LEFT JOIN 
  orders o ON s.staff_id = o.staff_id
WHERE
  o.order_id IS NULL;
