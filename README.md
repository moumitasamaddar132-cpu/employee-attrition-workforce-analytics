# Employee Attrition & Workforce Analytics

An end-to-end HR analytics project analyzing employee attrition, workforce characteristics, and factors associated with employee churn using **Python, MySQL, and Power BI**.

---

## 📌 Project Overview

Employee attrition is an important workforce challenge because high employee turnover can affect workforce stability, hiring requirements, productivity, and business continuity.

This project analyzes employee-level HR data to identify patterns associated with employee churn across:

- Departments
- Employee satisfaction
- Evaluation levels
- Workload
- Salary
- Promotion status
- Number of projects
- Employee tenure
- Work accidents

The project follows an end-to-end analytics workflow, starting with data cleaning and exploratory analysis in Python, followed by SQL-based business analysis and interactive visualization in Power BI.

---

## 🎯 Business Problem

HR teams need to understand:

- How significant is employee churn?
- Which departments have higher churn rates?
- Is employee satisfaction associated with churn?
- Does workload level differ between employees who stay and leave?
- How does salary level relate to churn?
- Is promotion status associated with employee retention?
- Are certain project workloads associated with higher churn?
- Does employee tenure show different churn patterns?

The objective is to transform employee-level HR data into actionable workforce insights.

---

## 🎯 Project Objectives

1. Measure the overall employee churn rate.
2. Analyze churn across different departments.
3. Identify workforce characteristics associated with higher churn.
4. Compare churn rates across satisfaction, evaluation, salary, workload, and tenure groups.
5. Analyze the relationship between promotion status and employee churn.
6. Perform business-focused analysis using SQL.
7. Build an interactive Power BI dashboard for HR workforce monitoring.
8. Develop data-driven recommendations for employee retention.

---

## 🗂️ Dataset

The project uses an employee HR dataset containing **14,999 employee records** and **11 attributes**.

### Dataset Columns

| Column | Description |
|---|---|
| `EmpId` | Employee identifier |
| `Satisfaction` | Employee satisfaction score |
| `Evaluation` | Employee evaluation score |
| `number_of_projects` | Number of projects assigned |
| `average_montly_hours` | Average monthly working hours |
| `time_spent_company` | Years spent at the company |
| `work_accident` | Whether the employee experienced a work accident |
| `Promotion` | Whether the employee received a promotion |
| `Department` | Employee department |
| `Salary_INR` | Employee salary |
| `Churn` | Employee churn indicator |

### Dataset Quality Checks

- Total records: **14,999**
- Total columns: **11**
- Missing values: **0**
- Duplicate rows: **0**
- Duplicate employee IDs: **0**

---

## 🛠️ Tools & Technologies

### Python
- Pandas
- NumPy
- Matplotlib

Used for:

- Data cleaning
- Data quality checks
- Exploratory data analysis
- Feature creation
- Employee segmentation
- Churn analysis
- Data visualization

### MySQL

Used for:

- Business-focused SQL analysis
- Aggregations
- Filtering
- Grouping
- Subqueries
- CTEs
- Window functions
- Workforce and attrition metrics

### Power BI

Used for:

- Interactive HR dashboard
- KPI reporting
- Churn analysis
- Workforce segmentation
- Data storytelling
- Executive-level visualization

---

## 🔄 Project Workflow

```text
Raw HR Dataset
      ↓
Data Understanding
      ↓
Data Cleaning & Quality Checks
      ↓
Exploratory Data Analysis
      ↓
Business Questions & Metrics
      ↓
Python Visualizations
      ↓
MySQL Business Analysis
      ↓
Power BI Data Model & DAX
      ↓
Interactive HR Dashboard
      ↓
Insights & Recommendations
