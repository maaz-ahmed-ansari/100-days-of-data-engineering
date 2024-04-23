## Partitioning Clause (PARTITION BY)

The partitioning clause divides the rows of the table into separate groups or partitions based on one or more column values. The function is applied independently within each partition. This allows you to perform calculations and aggregations on specific subsets of data.

PARTITION BY works similarly to GROUP BY, but instead of dividing the table into sets, it defines how we partition the table into windows. Let’s take a look at the following visualization:

![image](https://github.com/maaz-ahmed-ansari/100-days-of-data-engineering/assets/70753689/778d2f15-6a7e-45c6-97fd-61d2046d4c1b)


This is the table before PARTITION BY (student_id) is executed.

However, after the partition, the table is divided into windows as defined by the student_id:

![image](https://github.com/maaz-ahmed-ansari/100-days-of-data-engineering/assets/70753689/f6d4086d-2946-4feb-9a01-89a5084ac8a7)

Ref: https://www.interviewquery.com/p/sql-analytic-functions 

## Common Table Expression (CTE)

A Common Table Expression (CTE) is the result set of a query which exists temporarily and for use only within the context of a larger query. Much like a derived table, the result of a CTE is not stored and exists only for the duration of the query. This article will focus on non-recurrsive CTEs.

### How are CTEs helpful?

CTEs, like database views and derived tables, enable users to more easily write and maintain complex queries via increased readability and simplification. This reduction in complexity is achieved by deconstructing ordinarily complex queries into simple blocks to be used, and reused if necessary, in rewriting the query. Example use cases include:

- Needing to reference a derived table multiple times in a single query
- An alternative to creating a view in the database
- Performing the same calculation multiple times over across multiple query components

### How to create a CTE

- Initiate a CTE using “WITH”
- Provide a name for the result soon-to-be defined query
- After assigning a name, follow with “AS”
- Specify column names (optional step)
- Define the query to produce the desired result set
- If multiple CTEs are required, initiate each subsequent expression with a comma and repeat steps 2-4.
- Reference the above-defined CTE(s) in a subsequent query

  ```sql
  WITH
  expression_name_1 AS
  (CTE query definition 1)
  
  [, expression_name_X AS
     (CTE query definition X)
   , etc ]
  
  SELECT expression_A, expression_B, ...
  FROM expression_name_1
  ```

  Ref: https://www.atlassian.com/data/sql/using-common-table-expressions
