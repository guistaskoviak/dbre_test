# Database Reliability Engineer Test

## 1. Introduction

This test is intended for candidates applying to Database Reliablity Engineering positions at CloudWalk.

You are welcome to use any programming language that you are comfortable with.

## 2. Tasks

### 2.1. Docker Compose Setup

Write a docker-compose.yml file to set up two PostgreSQL instances named pg_master and pg_replica.

### 2.2. Database Creation and Schema Setup

Create a PostgreSQL database called testDB inside the pg_master. Inside testDB, create a table called orders with the following columns:
- id: Integer, primary key, auto-increment
- product_name: Text
- quantity: Integer
- order_date: Date

Create a small script which will insert some sample rows into the orders table. This will be needed for the next exercises.

### 2.3. Deliverable

Configure the pg_master instance to act as a publisher.
Configure the pg_replica instance to act as a subscriber.
Set up logical replication from pg_master to pg_replica for the orders table.
Validate that changes on pg_master are reflected on pg_replica by using the script from 1.

