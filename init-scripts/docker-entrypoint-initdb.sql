\x
\timing

-- Create database
CREATE DATABASE application;

-- Connect to application database
\c application;

-- Create user
CREATE USER application WITH PASSWORD 'password';

-- Grant privileges to the user on the application database
GRANT ALL PRIVILEGES ON DATABASE application TO application;

-- Enable uuid-ossp extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create table chats
CREATE TABLE chat_messages (
  message text not null,
  channel_id uuid not null,
  created_at timestamp not null
) PARTITION BY RANGE (created_at);

CREATE INDEX ON chat_messages (channel_id);
CREATE INDEX ON chat_messages (channel_id, created_at);

-- Create starter partitions
CREATE TABLE chat_messages_2023_01
PARTITION OF chat_messages
FOR VALUES FROM ('2023-01-01 00:00:00') TO ('2023-02-01 00:00:00');

CREATE TABLE chat_messages_2023_02
PARTITION OF chat_messages
FOR VALUES FROM ('2023-02-01 00:00:00') TO ('2023-03-01 00:00:00');

CREATE TABLE chat_messages_2023_03
PARTITION OF chat_messages
FOR VALUES FROM ('2023-03-01 00:00:00') TO ('2023-04-01 00:00:00');

CREATE TABLE chat_messages_2023_04
PARTITION OF chat_messages
FOR VALUES FROM ('2023-04-01 00:00:00') TO ('2023-05-01 00:00:00');

CREATE TABLE chat_messages_2023_05
PARTITION OF chat_messages
FOR VALUES FROM ('2023-05-01 00:00:00') TO ('2023-06-01 00:00:00');

CREATE TABLE chat_messages_2023_06
PARTITION OF chat_messages
FOR VALUES FROM ('2023-06-01 00:00:00') TO ('2023-07-01 00:00:00');

CREATE TABLE chat_messages_2023_07
PARTITION OF chat_messages
FOR VALUES FROM ('2023-07-01 00:00:00') TO ('2023-08-01 00:00:00');

CREATE TABLE chat_messages_2023_08
PARTITION OF chat_messages
FOR VALUES FROM ('2023-08-01 00:00:00') TO ('2023-09-01 00:00:00');

CREATE TABLE chat_messages_2023_09
PARTITION OF chat_messages
FOR VALUES FROM ('2023-09-01 00:00:00') TO ('2023-10-01 00:00:00');

CREATE TABLE chat_messages_2023_10
PARTITION OF chat_messages
FOR VALUES FROM ('2023-10-01 00:00:00') TO ('2023-11-01 00:00:00');

CREATE TABLE chat_messages_2023_11
PARTITION OF chat_messages
FOR VALUES FROM ('2023-11-01 00:00:00') TO ('2023-12-01 00:00:00');

CREATE TABLE chat_messages_2023_12
PARTITION OF chat_messages
FOR VALUES FROM ('2023-12-01 00:00:00') TO ('2024-01-01 00:00:00');

-- Insert random data
INSERT INTO chat_messages (message, channel_id, created_at)
SELECT
  SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 20),
  uuid_generate_v4(),
  TIMESTAMP '2023-01-01 00:00:00' + (RANDOM() * INTERVAL '365 DAYS') AS random_timestamp
FROM
  generate_series(1, 1000000);

-- Counts
SELECT COUNT(*) FROM chat_messages;

-- Just January
SELECT COUNT(*) FROM chat_messages_2023_01;

-- Just December
SELECT COUNT(*) FROM chat_messages_2023_12;

-- Inspection
\d+ chat_messages;
\d+ chat_messages_2023_01;

-- Sample data
SELECT * FROM chat_messages ORDER BY created_at DESC LIMIT 5;

-- Sample data in range
EXPLAIN ANALYZE
  SELECT *
  FROM chat_messages
  WHERE created_at BETWEEN '2023-04-02 00:00:00' AND '2023-04-09 00:00:00'
  ORDER BY RANDOM() LIMIT 5;
