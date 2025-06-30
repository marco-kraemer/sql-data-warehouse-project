# Data Catalog – Sales Data Mart (Star Schema)

Este catálogo descreve o modelo dimensional do Data Warehouse com base no esquema estrela. Cada tabela está documentada com seu propósito e os detalhes das colunas.

---

## `gold.dim_customers`

- **Purpose**: Stores customer details enriched with demographic and geographic data.
- **Columns**:

| Column Name     | Data Type       | Description                                                                 |
|-----------------|-----------------|-----------------------------------------------------------------------------|
| customer_key    | INT             | Surrogate key uniquely identifying each customer record in the dimension table. |
| customer_id     | INT             | Unique numerical identifier assigned to each customer.                     |
| customer_number | NVARCHAR(50)    | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| first_name      | NVARCHAR(50)    | The customer’s first name, as recorded in the system.                      |
| last_name       | NVARCHAR(50)    | The customer’s last name or family name.                                   |
| country         | NVARCHAR(50)    | The country of residence for the customer (e.g., 'Australia').             |
| marital_status  | NVARCHAR(50)    | The marital status of the customer (e.g., 'Married', 'Single').            |
| gender          | NVARCHAR(50)    | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                |
| birthdate       | DATE            | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06). |
| create_date     | DATE            | The date and time when the customer record was created in the system.      |

---

## `gold.dim_products`

- **Purpose**: Stores detailed information about products, including category and maintenance data.
- **Columns**:

| Column Name     | Data Type       | Description                                                                 |
|-----------------|-----------------|-----------------------------------------------------------------------------|
| product_key     | INT             | Surrogate key uniquely identifying each product record in the dimension table. |
| product_id      | INT             | Unique identifier from source system.                                       |
| product_number  | NVARCHAR(50)    | Alphanumeric product code.                                                  |
| product_name    | NVARCHAR(50)    | The name or description of the product.                                     |
| category_id     | NVARCHAR(50)    | Identifier for the product category.                                        |
| country         | NVARCHAR(50)    | Country of manufacture or sale (e.g., 'Germany').                           |
| subcategory     | NVARCHAR(50)    | Subdivision of the product category.                                        |
| maintenance     | NVARCHAR(50)    | Maintenance description or status for the product.                          |
| cost            | DECIMAL         | Cost of the product.                                                        |
| product_line    | NVARCHAR(50)    | Line of product (e.g., 'Mountain', 'Road', 'Touring', 'Other Sales').       |
| start_date      | DATE            | Date when the product became active.                                        |

---

## `gold.fact_sales`

- **Purpose**: Stores detailed sales transaction data, linking products and customers.
- **Columns**:

| Column Name     | Data Type       | Description                                                                 |
|-----------------|-----------------|-----------------------------------------------------------------------------|
| order_number    | INT             | Unique identifier for the sales order.                                      |
| product_key     | INT             | Foreign key referencing `gold.dim_products.product_key`.                    |
| customer_key    | INT             | Foreign key referencing `gold.dim_customers.customer_key`.                  |
| order_date      | DATE            | The date the order was placed.                                              |
| shipping_date   | DATE            | The date the order was shipped.                                             |
| due_date        | DATE            | The date the order is due.                                                  |
| sales_amount    | DECIMAL         | Total sales value.                                                          |
| quantity        | INT             | Quantity of items sold.                                                     |
| price           | DECIMAL         | Unit price of the product.                                                  |

---
