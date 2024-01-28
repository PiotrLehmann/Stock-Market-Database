-- FUNCTIONS TESTS

-- ADDING BALANCE TEST
-- add_balance_script.sql should add balance to every
-- existing user. If user does not exist (checked by id or
-- firstname and surname), function informs user with appropriate output
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');
-- without ID
SELECT public.add_balance_script('Filip', 'Korus', NULL, 5000.00);
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');
-- with ID
SELECT public.add_balance_script(NULL, NULL, 1, 5000.00);
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');

-- WITHDRAWING BALANCE TEST
-- withdraw_balance_script.sql should withdraw balance for every
-- existing user. If user does not exist (checked by id or
-- firstname and surname), function informs user with appropriate output
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');
-- without ID
SELECT public.withdraw_balance_script('Filip', 'Korus', NULL, 5000.00);
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');
-- with ID
SELECT public.withdraw_balance_script(NULL, NULL, 1, 5000.00);
SELECT * FROM get_investor_balance_by_name('Filip', 'Korus');

-- PLACING ORDER TEST
-- Client can place order with type 'Sell' or 'Buy',
-- either he/she wants to buy some stocks, or sell them.
-- User can not place order for more stocks than he/she has.
-- User can place order for any number of stocks.
-- Stocks are defined by id, user is also defined by id
-- Every order is placed with different row, so if user wants to
-- sell 5 stocks now and 7 later, he/she can do that with 2 different
-- function runs
SELECT * FROM public.get_investor_stocks_by_name('Filip', 'Korus');
-- order for buying
SELECT public.place_order_script(1, 10, 'Buy', 2);
SELECT * FROM public.get_investor_stocks_by_name('Filip', 'Korus');
-- order for selling
SELECT public.place_order_script(1, 10, 'Sell', 2);
SELECT * FROM public.get_investor_stocks_by_name('Filip', 'Korus');

SELECT * FROM public.clients_all_orders_view;

-- FINALISING ORDERS TEST
-- Users can buy or sell stocks, which are placed in orders table
-- or can be seen in clients_all_orders_view.
-- Client can finalise only an existing order, if order does not exist
-- client will be informed. There are 2 different functions for finalising
-- buy or sell type of order. After finalising an order, status should be changed
-- to 'Completed'. Then u can not finalise order second time.
SELECT * FROM public.clients_all_orders_view;
-- finalise sell order
SELECT public.finalise_sell_order_script(16, 1);
SELECT * FROM public.clients_all_orders_view;
-- finalise buy order
SELECT public.finalise_buy_order_script(17, 1);
SELECT * FROM public.clients_all_orders_view;

-- TRIGGERS TESTS

-- UPDATE STOCK PRICE TRIGGER
-- This trigger is for simulating price changes in stock market
-- while transactions are being completed. It is not accurate,
-- but helps with price fluctuations. After every completed buy, trigger should
-- run and update the price of stock which was bought.
SELECT * FROM stocks;
SELECT public.place_order_script(1, 10, 'Sell', 2);
SELECT public.finalise_sell_order_script(18, 1);
SELECT * FROM stocks;

-- ADMINISTRATORS VIEWS TEST
-- Only administrators have permission to use them. Those views are
-- different from clients views, because of containing specific id
-- and all sensitive information about clients

-- ALL ORDERS VIEW
SELECT * FROM public.orders_for_customers_view;
-- INVESTOR STOCKS VIEW
SELECT * FROM public.investors_stocks_view;
-- INVESTOR BALANCE VIEW
SELECT * FROM public.investors_balance_view;


-- CLIENTS VIEWS TEST
-- Only clients have permission to use them. Those views are
-- different from administrator views, because of NOT containing specific id
-- and all sensitive information about different clients

-- ALL CLIENTS ORDERS VIEW
SELECT * FROM public.clients_all_orders_view;
-- SPECIFIC CLIENT BALANCE VIEW
SELECT * FROM public.get_investor_balance_by_name('Filip', 'Korus');
-- SPECIFIC CLIENT STOCKS VIEW
SELECT * FROM public.get_investor_stocks_by_name('John', 'Doe');


