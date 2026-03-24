# 👟 Amazon Nike Shoes Reviews — Web Scraping & EDA

**Domain:** E-Commerce / Customer Analytics  
**Level:** Intermediate  
**Tools:** Python, BeautifulSoup, Requests, Pandas, NumPy, Matplotlib, Seaborn  
**Completed at:** Innomatics Research Labs (Sep 2026 – Present)

---

## Project Overview

This project scrapes customer review data for Nike shoes from Amazon and performs Exploratory Data Analysis (EDA) to uncover patterns in customer sentiment, ratings, and product feedback. The goal is to understand what customers love or dislike about Nike products using real-world scraped data.

---

## Project Workflow

```
Web Scraping → Data Cleaning → EDA → Visualization → Insights
```

### 1. Web Scraping
- Scraped review data from Amazon using **BeautifulSoup** and **Requests**
- Collected: star ratings, review titles, review text, verified purchase status, review dates

### 2. Data Cleaning
- Handled missing values and null entries
- Removed duplicate reviews
- Standardized rating formats and date fields
- Cleaned review text for analysis

### 3. Exploratory Data Analysis (EDA)
- Rating distribution — how many 1★ to 5★ reviews
- Verified vs unverified purchase review comparison
- Most reviewed Nike models
- Sentiment trends over time (monthly/yearly)
- Word frequency in positive vs negative reviews

### 4. Visualizations
- Bar charts — rating distribution
- Histograms — review length distribution
- Heatmaps — correlation between features
- Line charts — rating trends over time
- Count plots — verified purchase breakdown

---

## Key Insights

- Majority of reviews fall in the **4★ and 5★** range
- Verified purchase reviews tend to be more critical than unverified
- Most negative reviews cite **sizing issues** and **sole durability**
- Peak review activity observed during **sale seasons**

---

## Libraries Used

| Library | Purpose |
|---|---|
| `requests` | HTTP requests to fetch Amazon pages |
| `BeautifulSoup` | HTML parsing and data extraction |
| `pandas` | Data manipulation and cleaning |
| `numpy` | Numerical operations |
| `matplotlib` | Base visualizations |
| `seaborn` | Statistical visualizations |

---

## How to Run

1. Clone this repository
2. Install dependencies: `pip install requests beautifulsoup4 pandas numpy matplotlib seaborn`
3. Open `Amazon_Nike_Shoes_Reviews_Analysis_v2.ipynb` in Jupyter Notebook
4. Run all cells from top to bottom

---

## Note

Web scraping results may vary based on Amazon's page structure. The notebook includes the scraped dataset embedded within it for reproducibility.

