do $$ declare
    r record;
begin
    for r in (select tablename from pg_tables where schemaname = 'public') loop
        execute 'drop table if exists ' || quote_ident(r.tablename) || ' cascade';
    end loop;
end $$;

CREATE TABLE Companies (
    cid SERIAL PRIMARY KEY ,
    name VARCHAR(255) UNIQUE NOT NULL,
    location VARCHAR(255) NOT NULL,
    industry VARCHAR(100) DEFAULT 'Not precised'
);

CREATE TABLE Stocks (
    sid SERIAL PRIMARY KEY,
    cid INT REFERENCES Companies(cid) ON UPDATE CASCADE ON DELETE CASCADE,
    price DECIMAL(10,2),
    type VARCHAR(255) NOT NULL
);

CREATE TABLE Investors (
    iid SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(255) UNIQUE NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.0
);

CREATE TABLE Investor_Stocks (
    isid SERIAL PRIMARY KEY,
    iid INT REFERENCES Investors(iid) ON UPDATE CASCADE ON DELETE CASCADE,
    sid INT REFERENCES Stocks(sid),
    quantity INT NOT NULL
);

CREATE TABLE Orders (
    oid SERIAL PRIMARY KEY,
    iid INT REFERENCES Investors(iid) ON UPDATE CASCADE ON DELETE CASCADE,
    sid INT REFERENCES Stocks(sid) ON UPDATE CASCADE ON DELETE CASCADE,
    order_type VARCHAR(4) CHECK (order_type IN ('Buy', 'Sell')) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Completed', 'Cancelled'))
);