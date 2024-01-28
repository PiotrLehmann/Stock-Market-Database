-- TRIGGER to simulate stock price changes by completed transactions

CREATE OR REPLACE FUNCTION update_stock_price_after_buy()
RETURNS TRIGGER AS
$$
DECLARE
    random_percentage DECIMAL(5, 2);
    random_direction INT;
BEGIN
    random_percentage := (random() * 5) + 1;

    random_direction := CASE WHEN random() > 0.5 THEN 1 ELSE -1 END;

    -- Update stock price with random percent values
    UPDATE stocks
    SET price = price * (1 + (random_percentage / 100) * random_direction)
    WHERE sid = NEW.sid;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_buy_order_trigger
AFTER INSERT OR UPDATE ON orders
FOR EACH ROW
WHEN (NEW.status = 'Completed')
EXECUTE FUNCTION update_stock_price_after_buy();
