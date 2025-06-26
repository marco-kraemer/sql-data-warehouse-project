# Modern Data Warehouse Project – Sales Data Analytics with SQL Server

This project presents the complete development of a **Modern Data Warehouse** using **SQL Server**, designed to consolidate sales data from multiple sources and enable advanced analytics, business reporting, and informed decision-making.

---

## 📌 Project Overview

- **Architecture**: Modern Data Warehouse following best practices.
- **Technology**: SQL Server Express, SSMS, GitHub, Draw.io, Notion.
- **ETL/ELT Process**: End-to-end pipeline for data extraction, transformation, and loading.
- **Data Modeling**: Star schema and layered architecture (Bronze, Silver, Gold).
- **Use Case**: Integration of ERP and CRM CSV files to generate clean, reliable sales reports.

---

## 🚀 Key Stages

### 1. Project Planning & Architecture
- Project planning structured in Notion with Epics and Tasks.
- Architecture designed using [Draw.io](https://app.diagrams.net), based on the **Medallion Architecture** (Bronze, Silver, Gold layers).
- Naming conventions defined using `snake_case` and English language.

### 2. Requirement Analysis
- Source data from ERP and CRM (CSV format).
- Data required cleaning, standardization, and integration.
- Focused on **current state analysis** (no historical versioning).
- Documentation and lineage included.

---

## 🧱 Architecture Layers

### 🔹 **Bronze Layer**
- Raw data storage with full traceability.
- Data loaded using `BULK INSERT` from CSV files.
- Stored procedure `load_bronze` handles full load with `TRUNCATE & INSERT`.

### 🔸 **Silver Layer**
- Cleaned and standardized data.
- New metadata columns added (e.g., `dw_create_date`).
- Data issues handled:
  - Duplicates: Removed with `ROW_NUMBER()`.
  - Unwanted spaces: Cleaned using `TRIM()`.
  - Nulls & blanks: Replaced with "Not Available".
  - Normalization: Standardized values via `CASE WHEN`.
  - Derived columns: Extracted new attributes from raw fields.
  - Type casting and enrichment included.
- Stored procedure `load_silver` created to automate transformations.

### 🟡 **Gold Layer**
- Optimized for business consumption and BI tools.
- Star Schema implemented using **Views**:
  - Dimensions: Customers, Products, etc.
  - Fact table: `Fact_Sales`
- Techniques used:
  - Surrogate keys via `ROW_NUMBER()`
  - Column renaming and standardization
  - Data integration from multiple sources

---

## 🛠️ Technologies Used

- **SQL Server Express**
- **SQL Server Management Studio (SSMS)**
- **GitHub**
- **Notion** – for project management
- **Draw.io** – for architectural diagrams
- **CSV Files** – from ERP and CRM systems

---

## 🧠 Concepts & Techniques

- **ETL vs ELT**
- **Data Modeling**: Star Schema
- **Data Cleansing & Enrichment**
- **Slowly Changing Dimensions (SCDs) – discussed**
- **Batch Load, Full Load**
- **Data Lineage & Documentation**

---

## 📄 Documentation & Versioning

- All SQL scripts (`DDL`, `Stored Procedures`, `Quality Checks`) are versioned in this repository.
- A **data catalog** describes each table and column in the Gold Layer.
- The full **data flow diagram** includes Bronze → Silver → Gold layers.

---

## 🧾 Final Outcome

A fully functional Data Warehouse with:
- Cleaned and integrated sales data
- Documented architecture and lineage
- Automated ETL pipelines
- Star Schema model ready for BI tools and SQL analysis
