# Washington State EV and Charging Station Analysis

## Overview
This project examines electric vehicle (EV) adoption and charging station trends in Washington State using SQL for data analysis and Tableau for visualization.

### Objective
- Analyze EV adoption trends and CAFV program eligibility.
- Study the distribution and growth of EV charging stations across the state.
- Derive actionable insights to inform EV policy and infrastructure development.

---

## Datasets
### Electric Vehicle Dataset
Details on EVs in Washington State:
- **Columns**: State, Model Year, Make, EV Type, Electric Range, Base MSRP, Legislative District, CAFV Eligibility.

### Charging Station Dataset
Details of EV charging stations in Washington:
- **Columns**: City, Station Name, Charger Type, Number of Chargers, Installation Year.

---

## Tools and Techniques
- **SQL**:
  - Data cleaning (handling missing values and filtering incomplete data, changing column names, conditional formating, removing unwanted columns).
  - Aggregation, joins, and CTEs for detailed analysis.
  - Window functions for advanced insights.

---

## Key Insights
### Electric Vehicle Analysis
1. **CAFV Program Eligibility**:
   - Only 32.24% of EVs are eligible for the CAFV program.
   - 57.82% have unknown eligibility, emphasizing the need for better data collection.
2. **Manufacturing Trends**:
   - EV manufacturing has shown an upward trend since 1999.
3. **Brand Popularity**:
   - Tesla leads the market with 95,150 vehicles.
4. **EV Type Comparison**:
   - BEVs dominate over PHEVs, but PHEVs have higher CAFV eligibility (52.45% vs. 26.91%).
5. **Eligibility Criteria**:
   - Only EVs with a minimum electric range of 30 miles are CAFV-eligible.
6. **Eligibility Decline (2020-2021)**:
   - Sharp drop in CAFV eligibility from 87.66% to 11.65%, likely due to incomplete data or policy changes.

### Charging Station Analysis
1. **Growth Trends**:
   - Steady increase in charging station installations over the years.
2. **City Coverage**:
   - 223 out of 281 cities have charging stations, but 176 have fewer than 10 stations.
3. **Top Cities**:
   - Seattle leads with 652 stations, followed by Bellevue with 276.



## Contact
Have questions or feedback? Connect with me:
- **Email**: [wils1205@gmail.com]
