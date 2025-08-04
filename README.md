# Unsupervised Learning on Atmospheric Gases (Mauna Loa Observatory, 2000–2019)

This repository contains the code and figures for an unsupervised learning project analyzing monthly average atmospheric gas concentrations above the Mauna Loa Observatory from 2000 to 2019.

The goal of this project is to perform **exploratory data analysis**, apply **dimensionality reduction**, and conduct **clustering** to uncover patterns and groupings in the concentration levels of five key gases.

## 📊 Dataset Description

- **Observations:** 183 monthly averages (after cleaning, 178)
- **Features:**
  - CO₂ (ppm)
  - CO (ppb)
  - CH₄ (ppb)
  - N₂O (ppb)
  - CFC-11 (ppt)
  - Date (categorical, excluded from PCA and clustering)

The gases are selected due to their environmental significance in climate change, air quality, and ozone depletion.

## 🔍 Key Tasks

### 1. Exploratory Data Analysis (EDA)
- Visualized pairwise relationships and correlations
- Identified and removed outliers (5 in Jan 2013 due to incomplete data)
- Standardized numerical features for further analysis

### 2. Dimensionality Reduction
- **Technique Used:** Principal Component Analysis (PCA)
- **Results:**
  - PC1 explains **78%**, PC2 explains **19.7%**
  - Together, PC1 and PC2 explain **97.7%** of total variance
  - Strong correlations preserved between CO₂, CH₄, N₂O, and CFC-11 (negative)

### 3. Cluster Analysis
- **Techniques Compared:** K-Means vs. K-Medoids
- **Optimal Clusters:** 3 (determined via Elbow method & Silhouette scores)
- **Best Performing:** K-Means (100% classification accuracy)
- **Cluster Ranges:**
  - Cluster 1: 2008–2012
  - Cluster 2: 2000–2005
  - Cluster 3: 2016–2019

## 📌 Highlights

- Strong negative correlation observed between **CFC-11** and other greenhouse gases
- PCA effectively reduced dimensionality while preserving key variance
- K-Means outperformed K-Medoids for this dataset in clarity and accuracy
- Exploratory findings point toward potentially important environmental shifts or regulatory effects (e.g., CFC-11 ban)
