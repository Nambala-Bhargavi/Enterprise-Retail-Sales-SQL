# Database Design and Normalization

## Business problem
A retail company stores sales in spreadsheets. Customer names, product prices and region names are repeated on every row, so errors creep in. The solution is a relational database where each fact is stored once.

## Tables (7)
| Table | Rows | Purpose | Key columns |
|---|---|---|---|
| regions | 5 | Sales regions | PK region_id |
| employees | 10 | Sales staff, with manager link | PK employee_id, FK manager_id (self), FK region_id |
| customers | 60 | Customer master data | PK customer_id, FK region_id |
| categories | 5 | Product categories | PK category_id |
| products | 20 | Product catalogue with cost and price | PK product_id, FK category_id |
| orders | 400 | One row per order (header) | PK order_id, FK customer_id, FK employee_id |
| order_items | 986 | One row per product on an order (detail) | PK order_item_id, FK order_id, FK product_id |

## Relationships
* One region has many customers and many employees.
* One employee manages many employees (self relationship).
* One customer places many orders; one employee handles many orders.
* One order has many order items; one product appears in many order items.
* One category has many products.

## Normalization
* **1NF**: every column holds one value; no repeating groups (items are separate rows, not "item1, item2, item3" columns).
* **2NF**: no partial dependency. In `order_items` every non-key column depends on the whole row, and product details live in `products`.
* **3NF**: no transitive dependency. Region name is stored in `regions`, not repeated in customers; category name is in `categories`, not repeated in products.
* `order_items.unit_price` is deliberately stored again so that a later price change does not rewrite history (the price at the time of sale).

## Constraints used
PRIMARY KEY, FOREIGN KEY, UNIQUE (region and category names), NOT NULL, DEFAULT (status = Completed, discount = 0), CHECK (segment values, price > 0, quantity > 0, discount 0 to 50), INDEX on order_date and foreign keys.

## Intentional data-quality cases
* 6 customers have no email and 4 have no phone (NULL handling demos).
* 5 customers never placed an order (LEFT JOIN demo).
* 2 products were never sold: Iron Box and Air Cooler (RIGHT JOIN demo).
* 24 of 400 orders are Cancelled or Returned (excluded from revenue).
