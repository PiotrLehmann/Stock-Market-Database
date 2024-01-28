-- View of Investors balance sorted by balance

-- DROP VIEW investors_balance_view;
CREATE  OR REPLACE VIEW investors_balance_view AS
SELECT iid, first_name, surname, balance FROM investors;
SELECT * FROM investors_balance_view
ORDER BY balance DESC;