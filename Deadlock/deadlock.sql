-- DBMS DEADLOCK PRACTICE
-- Learning Purpose
-- Topic: Deadlock


-- Create database

CREATE DATABASE dbms_deadlock;

USE dbms_deadlock;


-- Create table

CREATE TABLE Accounts (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    balance INT
);


-- Insert sample data

INSERT INTO Accounts (id, name, balance)
VALUES
(1, 'Aman', 10000),
(2, 'Raj', 10000);


-- Check data

SELECT * FROM Accounts;


-- DEADLOCK EXAMPLE

-- We need two SQL sessions.

-- Session 1:
-- T1 locks Account 1
-- T1 then wants Account 2

-- Session 2:
-- T2 locks Account 2
-- T2 then wants Account 1


-- SESSION 1

START TRANSACTION;

-- T1 locks Account 1

UPDATE Accounts
SET balance = balance - 1000
WHERE id = 1;

-- Do not COMMIT yet.


-- SESSION 2

START TRANSACTION;

-- T2 locks Account 2

UPDATE Accounts
SET balance = balance - 500
WHERE id = 2;

-- Do not COMMIT yet.


-- Now go back to Session 1

-- T1 wants Account 2

UPDATE Accounts
SET balance = balance + 1000
WHERE id = 2;

-- T1 is waiting for Account 2.


-- Now go to Session 2

-- T2 wants Account 1

UPDATE Accounts
SET balance = balance + 500
WHERE id = 1;

-- T2 is waiting for Account 1.


-- DEADLOCK

-- T1:
-- Account 1 is locked
-- Waiting for Account 2

-- T2:
-- Account 2 is locked
-- Waiting for Account 1

-- T1 → Account 1 → Account 2
-- T2 → Account 2 → Account 1

-- Both transactions are waiting for each other.
-- This is a DEADLOCK.


-- DEADLOCK PREVENTION

-- Use a fixed order.

-- Always access:
-- Account 1 → Account 2

-- Do not use:
-- T1 → Account 1 → Account 2
-- T2 → Account 2 → Account 1

-- Use:
-- T1 → Account 1 → Account 2
-- T2 → Account 1 → Account 2

-- This prevents Circular Wait.


-- SAFE TRANSACTION 1

START TRANSACTION;

-- First access Account 1

UPDATE Accounts
SET balance = balance - 1000
WHERE id = 1;

-- Then access Account 2

UPDATE Accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT;


-- SAFE TRANSACTION 2

START TRANSACTION;

-- First access Account 1

UPDATE Accounts
SET balance = balance - 500
WHERE id = 1;

-- Then access Account 2

UPDATE Accounts
SET balance = balance + 500
WHERE id = 2;

COMMIT;


-- Check final data

SELECT * FROM Accounts;


-- FOUR CONDITIONS OF DEADLOCK

-- 1. Mutual Exclusion
-- One resource can be used by one transaction at a time.

-- 2. Hold and Wait
-- Transaction holds one resource and waits for another.

-- 3. No Preemption
-- Resource cannot be forcibly taken away.

-- 4. Circular Wait
-- Transactions wait for each other in a cycle.


-- Easy Trick

-- M = Mutual Exclusion
-- H = Hold and Wait
-- N = No Preemption
-- C = Circular Wait


-- DEADLOCK PREVENTION APPROACHES

-- 1. Break Mutual Exclusion
-- Make the resource sharable when possible.

-- 2. Break Hold and Wait
-- Request all required resources together.

-- 3. Break No Preemption
-- Release or preempt the resource when possible.

-- 4. Break Circular Wait
-- Use a fixed order for resources.


-- DEADLOCK DETECTION

-- Database can detect waiting cycles.

-- Example:
-- T1 → T2
-- T2 → T1

-- A cycle can indicate a deadlock.


-- DEADLOCK RECOVERY

-- 1. Rollback one transaction.
-- 2. Release its locks.
-- 3. Let the other transaction continue.
-- 4. Retry the failed transaction if required.


-- DEADLOCK VS STARVATION

-- Deadlock:
-- Transactions wait for each other.

-- Starvation:
-- One transaction keeps waiting
-- while other transactions keep getting the resource.