-- DROP FUNCTION place_order_script(_iid INT, _sid INT, _order_type VARCHAR(5), _quantity INT);

CREATE OR REPLACE FUNCTION public.place_order_script(
  _iid INT,
  _sid INT,
  _order_type VARCHAR(5),
  _quantity INT
)
RETURNS VOID AS
    $$
DECLARE
  v_price DECIMAL(10, 2);
  v_balance DECIMAL(10, 2);
BEGIN
  -- Get the stock price
  SELECT price INTO v_price
  FROM Stocks
  WHERE sid = _sid;

  IF _order_type = 'Buy' THEN
    -- Check if investor's balance is sufficient for a buy order
    SELECT balance INTO v_balance
    FROM Investors
    WHERE iid = _iid;

    IF v_balance < v_price * _quantity THEN
      RAISE EXCEPTION 'Insufficient balance for a buy order';
    END IF;

    -- Update investor's balance after placing order
    UPDATE investors
    SET balance = balance - v_price*_quantity
    WHERE iid = _iid;

  ELSIF _order_type = 'Sell' THEN
    -- Check if investor owns enough quantity for a sell order
    IF NOT EXISTS (
      SELECT 1
      FROM Investor_Stocks
      WHERE iid = _iid AND sid = _sid AND quantity >= _quantity
    ) THEN
      RAISE EXCEPTION 'Insufficient quantity for a sell order';
    END IF;

    -- Update investor's stock quantity after placing order
    UPDATE investor_stocks
    SET quantity = quantity - _quantity
    WHERE iid = _iid
    AND sid = _sid;

  ELSE
    RAISE EXCEPTION 'Invalid order type: %', _order_type;
  END IF;

  -- Place the order
  INSERT INTO Orders (iid, sid, order_type, quantity, price)
  VALUES (_iid, _sid, _order_type, _quantity, v_price*_quantity);

END;
$$ LANGUAGE plpgsql;