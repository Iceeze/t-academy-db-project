CREATE TABLE product_types (
    product_type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
COMMENT ON TABLE product_types IS 'Справочник типов банковских продуктов (вклад, накопительный счет)';


CREATE TABLE account_statuses (
    status_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
COMMENT ON TABLE account_statuses IS 'Справочник статусов счетов';


CREATE TABLE currencies (
    currency_id SERIAL PRIMARY KEY,
    code VARCHAR(3) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL
);
COMMENT ON TABLE currencies IS 'Справочник валют';
COMMENT ON COLUMN currencies.code IS 'Код валюты (например, USD, EUR, RUB)';


CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    birth_date DATE NOT NULL,
    passport_data VARCHAR(11) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,

    CONSTRAINT regex_passport_data CHECK (passport_data ~* '\d{4}\s\d{6}'),
    CONSTRAINT regex_phone_number CHECK (phone_number ~* '^(\+7|8)[0-9]{10}$'),
    CONSTRAINT regex_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),

    CONSTRAINT chk_birth_date CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years')
);
COMMENT ON TABLE customers IS 'Информация о клиентах банка';
COMMENT ON COLUMN customers.passport_data IS 'Паспортные данные (серия и номер с пробелом)';


CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    product_type_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    currency_id INTEGER NOT NULL,
    open_date DATE NOT NULL,
    current_interest_rate DECIMAL(5,2) NOT NULL,
    created_at DATE DEFAULT CURRENT_DATE,
    
    CONSTRAINT fk_accounts_customers FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id) ON DELETE RESTRICT,
    CONSTRAINT fk_accounts_product_types FOREIGN KEY (product_type_id) 
        REFERENCES product_types(product_type_id) ON DELETE RESTRICT,
    CONSTRAINT fk_accounts_statuses FOREIGN KEY (status_id) 
        REFERENCES account_statuses(status_id) ON DELETE RESTRICT,
    CONSTRAINT fk_accounts_currencies FOREIGN KEY (currency_id) 
        REFERENCES currencies(currency_id) ON DELETE RESTRICT,
    
    CONSTRAINT chk_interest_rate CHECK (current_interest_rate >= 0)
);
COMMENT ON TABLE accounts IS 'Банковские счета клиентов';


CREATE TABLE transaction_types (
    transaction_type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
COMMENT ON TABLE transaction_types IS 'Справочник типов операций по счетам';


CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL,
    transaction_type_id INTEGER NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    balance_after DECIMAL(15,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_transactions_accounts FOREIGN KEY (account_id) 
        REFERENCES accounts(account_id) ON DELETE RESTRICT,
    CONSTRAINT fk_transactions_types FOREIGN KEY (transaction_type_id) 
        REFERENCES transaction_types(transaction_type_id) ON DELETE RESTRICT
);
COMMENT ON TABLE transactions IS 'Операции по банковским счетам';


CREATE TABLE interest_rates (
    rate_id SERIAL PRIMARY KEY,
    product_type_id INTEGER NOT NULL,
    interest_rate_value DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    
    CONSTRAINT fk_interest_rates_product_types FOREIGN KEY (product_type_id) 
        REFERENCES product_types(product_type_id) ON DELETE RESTRICT,

    CONSTRAINT chk_interest_rate_range CHECK (interest_rate_value >= 0),
    CONSTRAINT chk_dates CHECK (end_date IS NULL OR end_date > start_date)
);
COMMENT ON TABLE interest_rates IS 'История изменений процентных ставок';


CREATE TABLE status_audit (
    audit_id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL,
    old_status_id INTEGER NOT NULL,
    new_status_id INTEGER NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_status_audit_accounts FOREIGN KEY (account_id) 
        REFERENCES accounts(account_id) ON DELETE RESTRICT,
    CONSTRAINT fk_status_audit_old_status FOREIGN KEY (old_status_id) 
        REFERENCES account_statuses(status_id) ON DELETE RESTRICT,
    CONSTRAINT fk_status_audit_new_status FOREIGN KEY (new_status_id) 
        REFERENCES account_statuses(status_id) ON DELETE RESTRICT
);
COMMENT ON TABLE status_audit IS 'Аудит изменений статусов счетов';