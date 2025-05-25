# Bike Stores - Análise de Dados

## Descrição
Este projeto contém consultas SQL desenvolvidas para a base de dados da empresa Bike Stores Inc., com o objetivo de obter métricas e insights relevantes para as equipes de Marketing e Comercial.

## Tecnologias Utilizadas
- **PostgreSQL** (Dialeto SQL utilizado para as consultas)
- **Git** (Controle de versão)

## Consultas Implementadas
1.  **Clientes inativos** - Identifica clientes que nunca realizaram compras.
2.  **Produtos não vendidos** - Lista produtos sem histórico de vendas.
3.  **Estoque zerado** - Mostra produtos com quantidade zero em estoque em qualquer loja.
4.  **Vendas por marca/loja** - Fornece métricas agregadas de desempenho comercial por combinação de marca e loja.
5.  **Funcionários sem vendas** - Lista membros da equipe comercial que não têm pedidos associados.

## Como Usar
1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/VitorEmanuelDev/db_challenge.git](https://github.com/VitorEmanuelDev/db_challenge.git)
    ```
2.  **Acesse o arquivo de consultas:**
    Navegue até o diretório clonado e localize o arquivo `queries.sql`.
3.  **Execute as consultas:**
    Para utilizar as consultas, você precisará de uma instância do banco de dados PostgreSQL com o esquema da Bike Stores Inc. populado. Conecte-se ao seu banco de dados usando um cliente SQL (como `psql`, DBeaver, pgAdmin, etc.) e execute as consultas contidas no arquivo `queries.sql`.

## Processo de Desenvolvimento

### Análise Inicial
Antes de escrever qualquer consulta, foi realizada uma análise do diagrama de Entidade-Relacionamento (ER) fornecido. Esta etapa foi fundamental para compreender a estrutura do banco de dados e as relações entre as tabelas.

-   **Entendimento do Esquema:** Estudei cada tabela (`customers`, `orders`, `order_items`, `products`, `stocks`, `brands`, `categories`, `staffs`, `stores`) e seus respectivos campos, prestando atenção às chaves primárias e estrangeiras.
-   **Identificação das Relações Críticas:** As relações mais importantes para as consultas solicitadas foram identificadas:
    -   `Customers` **(1:N)** `Orders`: Um cliente pode ter múltiplos pedidos.
    -   `Products` **(1:N)** `Order_items`: Um produto pode aparecer em múltiplos itens de pedido.
    -   `Staffs` **(1:N)** `Orders`: Um funcionário pode estar associado a múltiplos pedidos.
    -   `Products` **(N:M)** `Stores` (via `Stocks`): Produtos têm estoque em diversas lojas.

### Decisões Técnicas

Durante o desenvolvimento das consultas, algumas decisões técnicas foram tomadas para garantir a precisão dos resultados e a eficiência das consultas.

-   **Otimização de JOINs:**
    -   **`LEFT JOIN`:** Foi a escolha para cenários onde era necessário listar todos os registros de uma tabela (a "esquerda") e, se houver, suas correspondências em outra tabela (a "direita"). Isso é importante para identificar entidades "sem" algo (clientes sem compra, produtos não comprados, funcionários sem pedidos). O `LEFT JOIN` preserva todos os registros da tabela da esquerda e preenche com `NULL` as colunas da tabela da direita quando não há correspondência.
    -   **Evitei `INNER JOIN`:** Utilizado quando a relação entre as tabelas é mandatório e queremos apenas os registros que possuem correspondência em ambas as tabelas (ex: produto com sua marca, funcionário com sua loja), ou quando um `LEFT JOIN` seguido de `IS NULL` seria redundante.
    -   **Evitei `RIGHT JOIN`:** Por uma questão de legibilidade e padronização. Qualquer `RIGHT JOIN` pode ser reescrito como um `LEFT JOIN` invertendo a ordem das tabelas.

-   **Filtragem (`WHERE`):**
    -   As condições `IS NULL` foram aplicadas após os `LEFT JOIN`s para identificar registros que não possuem uma correspondência na tabela juntada, cumprindo os requisitos de "não ter" algo.
    -   A cláusula `WHERE` foi aplicada após todas as operações de `JOIN` para filtrar o conjunto de dados já combinado.

-   **Agregação de Dados (`COUNT`, `GROUP BY`, `ORDER BY`):**
    -   **`COUNT()` com `GROUP BY`:** Utilizado especificamente na consulta de "Vendas por Marca e Loja" para calcular métricas agregadas. `COUNT(coluna)` ignora valores `NULL`, o que é ideal para contar ocorrências reais após `LEFT JOIN`s.
    -   **`ORDER BY`:** Aplicado para garantir que os resultados sejam apresentados de forma organizada e previsível, facilitando a análise.

### Desafios Encontrados e Soluções

Apesar de as consultas serem relativamente diretas, alguns pontos exigiram mais atenção:

-   **Consulta #4 (Agrupar a quantidade de vendas por Marca e Loja):**
    -   **Desafio:** O objetivo era listar *todas* as combinações possíveis de loja e marca, mesmo aquelas que não tiveram vendas. Um encadeamento de `LEFT JOIN`s a partir de `stores` ou `brands` poderia omitir lojas que nunca venderam uma certa marca se não houvesse produtos associados ou itens de pedido.
    -   **Solução:** A solução encontrada foi iniciar com um `CROSS JOIN` entre `stores` e `brands`. Isso gerou um conjunto inicial com todas as combinações "Loja X Marca". A partir daí, `LEFT JOIN`s subsequentes (`products`, `order_items`, `orders`) foram usados para "preencher" as vendas, garantindo que mesmo as combinações sem vendas (onde `COUNT(oi.item_id)` poderia resultar em 0) fossem incluídas. A condição `o.store_id = s.store_id` no último `LEFT JOIN` para `orders` foi fundamental para garantir que as vendas fossem corretamente atribuídas à loja específica da combinação do `CROSS JOIN`, e não apenas a qualquer loja do pedido.

-   **Consulta #3 (Listar os Produtos sem Estoque):**
    -   **Desafio:** Exigiu um "JOIN triplo" (`products` -> `stocks` -> `stores`) para relacionar o produto com sua quantidade em estoque e o nome da loja, além da marca.

## Arquivos no Repositório
-   `queries.sql`: Contém todas as consultas SQL desenvolvidas para o desafio.
-   `.gitignore`: Arquivo para ignorar arquivos e diretórios que não devem ser versionados pelo git.

---

This is a challenge by [Coodesh](https://coodesh.com/)
