-- View of Investors and their stocks with IDs and quantity
-- sorted by Investors names and by quantity of their stocks

-- DROP VIEW orders_for_customers_view;
CREATE  OR REPLACE VIEW investors_stocks_view AS
SELECT i.iid,
       i.first_name,
       i.surname,
       i_s.isid,
       i_s.sid,
       i_s.quantity
FROM investor_stocks i_s LEFT JOIN investors i USING(iid);
SELECT * FROM investors_stocks_view
ORDER BY first_name, surname, quantity DESC;