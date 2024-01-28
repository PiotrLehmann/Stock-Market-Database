-- View of Investors and their stocks with IDs and quantity
-- sorted by Investors names and by quantity of their stocks

-- DROP VIEW orders_for_customers_view;
CREATE  OR REPLACE VIEW investors_stocks_view AS
SELECT i.iid,
       i.first_name,
       i.surname,
       i_s.isid,
       i_s.sid,
       i_s.quantity,
       s.type,
       c.name
FROM investor_stocks i_s LEFT JOIN investors i USING(iid) LEFT JOIN stocks s USING(sid) LEFT JOIN companies c USING(cid);
SELECT * FROM investors_stocks_view
ORDER BY first_name, surname, quantity DESC;


-- Function for restricting VIEW of Investors stocks, by setting name of specific Investor
CREATE OR REPLACE FUNCTION get_investor_stocks_by_name(
  in_first_name VARCHAR(50),
  in_surname VARCHAR(50)
)
RETURNS SETOF investors_stocks_view AS $$
BEGIN
  RETURN QUERY
  SELECT *
  FROM investors_stocks_view
  WHERE first_name = in_first_name AND surname = in_surname
  ORDER BY quantity DESC;
END;
$$ LANGUAGE plpgsql;

-- Example
SELECT * FROM get_investor_stocks_by_name('John', 'Doe');

