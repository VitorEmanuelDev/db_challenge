-- 1. Listar todos clientes que não tenham realizado uma compra
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    c.phone
FROM 
    customers c -- Seleciona todos os clientes da tabela 'customers'
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id -- Junta com a tabela 'orders' para encontrar pedidos relacionados a cada cliente.
                                           -- LEFT JOIN garante que todos os clientes sejam listados, mesmo os que não têm pedidos.
WHERE 
    o.order_id IS NULL; -- Filtra os resultados para incluir apenas os clientes onde não há um 'order_id' correspondente na tabela 'orders',
                        -- indicando que eles não realizaram nenhuma compra.

-- 2. Listar os produtos que não tenham sido comprados
SELECT 
    p.product_id, 
    p.product_name, 
    b.brand_name, 
    c.category_name
FROM 
    products p -- Seleciona todos os produtos da tabela 'products'
JOIN 
    brands b ON p.brand_id = b.brand_id -- Junta com 'brands' para obter o nome da marca do produto. (INNER JOIN, pois todo produto tem uma marca)
JOIN 
    categories c ON p.category_id = c.category_id -- Junta com 'categories' para obter o nome da categoria do produto. (INNER JOIN, pois todo produto tem uma categoria)
LEFT JOIN 
    order_items oi ON p.product_id = oi.product_id -- Junta com 'order_items' para verificar se o produto foi incluído em algum pedido.
                                                 -- LEFT JOIN garante que todos os produtos sejam listados, mesmo os não comprados.
WHERE 
    oi.order_id IS NULL; -- Filtra os resultados para incluir apenas os produtos onde não há um 'order_id' correspondente em 'order_items',
                         -- o que significa que o produto nunca foi comprado.

-- 3. Listar os produtos sem estoque
SELECT 
    p.product_id, 
    p.product_name, 
    b.brand_name, 
    s.store_name, 
    st.quantity
FROM 
    products p -- Seleciona os produtos da tabela 'products'
JOIN 
    brands b ON p.brand_id = b.brand_id -- Junta com 'brands' para obter o nome da marca.
JOIN 
    stocks st ON p.product_id = st.product_id -- Junta com 'stocks' para obter as informações de estoque (quantidade) para cada produto.
JOIN 
    stores s ON st.store_id = s.store_id -- Junta com 'stores' para obter o nome da loja onde o estoque está registrado.
WHERE 
    st.quantity = 0; -- Filtra os resultados para incluir apenas os produtos cujo 'quantity' (quantidade em estoque) é zero.

-- 4. Agrupar a quantidade de vendas por marca e loja
SELECT 
    s.store_id,
    s.store_name,
    b.brand_id,
    b.brand_name,
    COUNT(oi.item_id) AS total_vendas -- Conta o número de itens de pedido (vendas) para cada grupo.
                                     -- COUNT(coluna) ignora valores NULL, o que é ideal para LEFT JOINs.
FROM 
    stores s -- Tabela de lojas
CROSS JOIN 
    brands b -- Faz um produto cartesiano entre 'stores' e 'brands' para garantir que TODAS as combinações (loja X marca) sejam consideradas,
             -- mesmo que não haja vendas para elas.
LEFT JOIN 
    products p ON b.brand_id = p.brand_id -- Junta 'products' com 'brands' para obter os produtos de cada marca.
                                          -- LEFT JOIN para incluir marcas que podem não ter produtos ainda ou produtos sem vendas.
LEFT JOIN 
    order_items oi ON p.product_id = oi.product_id -- Junta 'order_items' com 'products' para encontrar os itens vendidos.
                                                  -- LEFT JOIN para incluir produtos que podem não ter sido vendidos.
LEFT JOIN 
    orders o ON oi.order_id = o.order_id AND o.store_id = s.store_id -- Junta 'orders' para vincular os itens de pedido aos pedidos e,
                                                                  -- CRUCIALMENTE, associa o pedido à loja específica da combinação do CROSS JOIN (o.store_id = s.store_id).
GROUP BY 
    s.store_id, s.store_name, b.brand_id, b.brand_name -- Agrupa os resultados por loja e marca para que COUNT() opere em cada grupo.
ORDER BY 
    s.store_id, b.brand_id; -- Ordena os resultados para facilitar a leitura.

-- 5. Listar Funcionários sem pedidos relacionados
SELECT 
    s.staff_id, 
    s.first_name, 
    s.last_name, 
    s.email, 
    st.store_name
FROM 
    staffs s -- Seleciona todos os funcionários da tabela 'staffs'
JOIN 
    stores st ON s.store_id = st.store_id -- Junta com 'stores' para obter o nome da loja onde o funcionário trabalha. (INNER JOIN, pois todo funcionário tem uma loja)
LEFT JOIN 
    orders o ON s.staff_id = o.staff_id -- Junta com 'orders' para encontrar pedidos relacionados a cada funcionário.
                                       -- LEFT JOIN garante que todos os funcionários sejam listados, mesmo os que não têm pedidos associados.
WHERE 
    o.order_id IS NULL; -- Filtra os resultados para incluir apenas os funcionários onde não há um 'order_id' correspondente na tabela 'orders',
                        -- indicando que eles não estão relacionados a nenhum pedido.
