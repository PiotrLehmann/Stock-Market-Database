CREATE OR REPLACE FUNCTION public.finalise_buy_order_script(_oid INT, _iid INT) RETURNS VOID AS
    $$
DECLARE
    order_row RECORD;
    investor_stock_quantity INT;
BEGIN
    -- Locking the row in the orders table for the specified order
    SELECT * INTO order_row FROM orders WHERE orders.oid = _oid AND order_type = 'Buy' FOR UPDATE;

    -- Retrieving the investor's stock quantity of certain sid (from order)
    SELECT quantity INTO investor_stock_quantity FROM investor_stocks WHERE investor_stocks.iid = _iid AND investor_stocks.sid = order_row.sid;

    -- Checking if the investor has sufficient funds
    IF investor_stock_quantity >= order_row.quantity THEN
        -- Subtracting from the sellers balance
        UPDATE investors SET balance = balance + order_row.price WHERE investors.iid = _iid;

        -- Subtracting stocks from sellers stocks
        UPDATE investor_stocks SET quantity = quantity - order_row.quantity WHERE investor_stocks.iid = _iid AND investor_stocks.sid = order_row.sid;

        -- Checking if the investor already owns this stock from the same seller
        IF EXISTS (SELECT 1 FROM investor_stocks WHERE iid = order_row.iid AND sid = order_row.sid) THEN
            -- Updating the quantity of the stock in the investor_stocks table
            UPDATE investor_stocks SET quantity = quantity + order_row.quantity WHERE iid = order_row.iid AND sid = order_row.sid;
        ELSE
            -- Adding a row to the investor_stocks table
            INSERT INTO investor_stocks (iid, sid, quantity)
            VALUES (order_row.iid, order_row.sid, order_row.quantity);
        END IF;

        -- Changing the status of the order to 'Completed'
        UPDATE orders SET status = 'Completed' WHERE orders.oid = _oid;
    ELSE
        RAISE EXCEPTION 'Insufficient funds in the investor''s account.';
    END IF;
END;
$$ LANGUAGE plpgsql;

