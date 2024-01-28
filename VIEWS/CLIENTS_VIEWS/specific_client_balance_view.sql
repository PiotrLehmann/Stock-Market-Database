-- View of Investors balance sorted by balance

-- DROP VIEW investors_balance_view;
CREATE  OR REPLACE VIEW investors_balance_view AS
SELECT iid, first_name, surname, balance FROM investors;
SELECT * FROM investors_balance_view
ORDER BY balance DESC;

-- Function for restricting VIEW of Investors balance, by setting name of specific Investor
CREATE OR REPLACE FUNCTION get_investor_balance_by_name(
  in_first_name VARCHAR(50),
  in_surname VARCHAR(50)
)
RETURNS SETOF investors_balance_view AS $$
BEGIN
  RETURN QUERY
  SELECT *
  FROM investors_balance_view
  WHERE first_name = in_first_name AND surname = in_surname
  ORDER BY balance DESC;
END;
$$ LANGUAGE plpgsql;

-- Example
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');