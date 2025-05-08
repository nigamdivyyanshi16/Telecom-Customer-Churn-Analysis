create database customer_churn;
use customer_churn;
drop table churn;
CREATE TABLE churn (
    customer_id VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    married VARCHAR(15),
    state VARCHAR(50),
    number_of_referrals INT,
    tenure_in_months INT,
    value_deal VARCHAR(50),
    phone_service VARCHAR(30),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(100),
    internet_type VARCHAR(200),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection_plan VARCHAR(30),
    premium_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    streaming_music VARCHAR(30),
    unlimited_data VARCHAR(30),
    contract VARCHAR(20),
    paperless_billing VARCHAR(30),
    payment_method VARCHAR(50),
    monthly_charge FLOAT,
    total_charges FLOAT,
    total_refunds FLOAT,
    total_extra_data_charges FLOAT,
    total_long_distance_charges FLOAT,
    total_revenue FLOAT,
    customer_status VARCHAR(20),
    churn_category VARCHAR(50),
    churn_reason TEXT
);
select * from churn;

/*Data Exploration*/
select gender,count(gender) as TotalCount, round(count(gender)*100.00/(select count(*) from churn),2)  as percentage
from churn
group by gender;

select contract, count(contract) as totalcount, round(count(contract)*100.00/(select count(*) from churn),2) as percentage
from churn
group by contract
order by totalcount desc;

select customer_status, count(customer_status) as totalcount, round(count(customer_status)*100.00/(select count(*) from churn),2) as percentage
from churn
group by customer_status
order by totalcount desc;

select distinct internet_type
from churn;

/*Which services (internet, streaming) correlate with churn?*/
select * from churn;
SELECT 
    internet_service,
    streaming_tv,
    streaming_movies,
    streaming_music,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END) AS churned_customers,
    ROUND(
        COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS churned_percentage
FROM churn
GROUP BY internet_service, streaming_tv, streaming_movies, streaming_music
ORDER BY churned_percentage DESC;

/*Revenue lost due to churn*/



/*State-wise or tenure-wise churn rates*/ 
SELECT 
    state,
    COUNT(*) AS churned_customers,
    ROUND(COUNT(state) * 100.0 / (SELECT COUNT(*) FROM churn), 2) AS state_churn_rate
FROM churn
WHERE customer_status = 'Churned'
GROUP BY state
ORDER BY state_churn_rate DESC;

SELECT 
    tenure_in_months,
    COUNT(*) AS churned_customers,
    ROUND(COUNT(tenure_in_months) * 100.0 / (SELECT COUNT(*) FROM churn), 2) AS tenure_churn_rate
FROM churn
WHERE customer_status = 'Churned'
GROUP BY tenure_in_months
ORDER BY tenure_churn_rate DESC;

/*How many customers have churned?*/
select distinct count(customer_id)
from churn
where customer_status="Churned";

select count(*)
from churn;
/*What is the average tenure of churned vs. active customers?*/
select customer_status,avg(tenure_in_months)
from churn
where customer_status in ("Stayed","Joined", "Churned")
group by customer_status;

/*Which state has the highest churn rate?*/
select distinct state, count(*) as "Churned_customers", round(count(state)*100.00/(select count(*) from churn),2) as "Churn_rates"
from churn
group by state
order by Churn_rates desc
limit 1;
/*Is there any gender bias in churn?*/
select gender, count(gender) as "Gender_churn_count"
from churn
where customer_status="Churned"
group by gender;
/*if females more then is married people have churned more*/
select distinct married, count(married) as "Married_churn_count"
from churn
where customer_status="Churned"
group by married ;

/*married: yes then male and female, no then male and female*/
select distinct married, gender, count(gender) as "Gender_churn"
from churn
where customer_status="Churned"
group by married,gender;

/*What's the average monthly charge for churned users?*/
select round(avg(monthly_charge),2)
from churn
where customer_status="Churned";
/*Which contract type has the most churn?*/
select contract, count(contract) as "Contract_churn_count"
from churn
where customer_status="Churned"
group by contract;
/*What is the total revenue lost due to churn?*/
select sum(total_revenue)
from churn 
where customer_status="Churned";


/*creating views*/
create view churned_stayed_cus as 
select * from churn
where customer_status in ("Stayed","Churned");

create view joined_cus as 
select * from churn
where customer_status="Joined";
