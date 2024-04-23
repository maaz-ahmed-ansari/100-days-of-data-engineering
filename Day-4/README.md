## Partitioning Clause (PARTITION BY)

The partitioning clause divides the rows of the table into separate groups or partitions based on one or more column values. The function is applied independently within each partition. This allows you to perform calculations and aggregations on specific subsets of data.

PARTITION BY works similarly to GROUP BY, but instead of dividing the table into sets, it defines how we partition the table into windows. Let’s take a look at the following visualization:

![image](https://github.com/maaz-ahmed-ansari/100-days-of-data-engineering/assets/70753689/778d2f15-6a7e-45c6-97fd-61d2046d4c1b)


This is the table before PARTITION BY (student_id) is executed.

However, after the partition, the table is divided into windows as defined by the student_id:

![image](https://github.com/maaz-ahmed-ansari/100-days-of-data-engineering/assets/70753689/f6d4086d-2946-4feb-9a01-89a5084ac8a7)

Ref: https://www.interviewquery.com/p/sql-analytic-functions 
