# 🏥 Hospital Management System — SQL Project

**Domain:** Healthcare Analytics  
**Level:** Intermediate  
**Tools:** MySQL  
**Completed at:** Innomatics Research Labs (Sep 2026 – Present)

---

## Project Overview

This project involves designing a complete hospital database and writing analytical SQL queries to extract meaningful insights from patient, doctor, appointment, billing, and prescription data. The goal is to support hospital management decision-making through structured data analysis.

---

## Database Schema

| Table | Description |
|---|---|
| `departments` | Hospital departments and head doctors |
| `doctors` | Doctor profiles with specialization and department |
| `patients` | Patient demographics and registration info |
| `appointments` | Scheduled, completed, and cancelled appointments |
| `medical_records` | Diagnosis, treatment, and notes per appointment |
| `medicines` | Medicine catalog with stock and pricing |
| `prescriptions` | Medicines prescribed per patient |
| `billing` | Invoice and payment records per patient |

---

## Key SQL Analyses Performed

- Department-wise patient load and admission trends
- Most common diagnoses and peak appointment periods
- Doctor performance metrics and patient volumes
- Average patient stay duration by department
- Billing summaries and outstanding payment analysis
- Patient segmentation by age group, gender, and blood group
- Medicine stock levels and prescription frequency
- Appointment status breakdown (scheduled / completed / cancelled)

---

## Concepts Used

- Multi-table `JOIN` operations (INNER, LEFT, multiple joins)
- `GROUP BY`, `HAVING`, `ORDER BY`
- `CASE` statements for conditional logic
- Common Table Expressions (CTEs)
- Subqueries and nested queries
- Aggregate functions (`COUNT`, `AVG`, `SUM`, `MAX`)
- `ENUM` data types and date functions
- Foreign key constraints and referential integrity

---

## How to Run

1. Open MySQL Workbench or any MySQL client
2. Run `hospital_management_system.sql`
3. The script creates the database, all tables, inserts sample data, and executes analytical queries

---

## Skills Demonstrated

- Real-world healthcare database design
- Writing complex multi-join queries for business reporting
- Data segmentation and demographic analysis using SQL
- Using CTEs for readable, modular query structure

