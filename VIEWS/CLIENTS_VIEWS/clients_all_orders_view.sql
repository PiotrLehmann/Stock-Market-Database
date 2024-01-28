-- DROP VIEW clients_all_orders_view;

CREATE  OR REPLACE VIEW clients_all_orders_view AS
SELECT
       oid,
       i.first_name,
       i.surname,
       o.order_type,
       o.price AS total_price,
       o.quantity,
       c.name AS company,
       s.type AS name,
       o.status
       FROM orders o, stocks s, companies c, investors i
WHERE  o.sid = s.sid
AND c.cid = s.cid
AND i.iid = o.iid;
SELECT * FROM clients_all_orders_view
ORDER BY oid;
