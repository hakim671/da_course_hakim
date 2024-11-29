import streamlit as st
import pandas as pd
import plotly.express as px

# Load the dataset
@st.cache
def load_data():
    df = pd.read_csv('vgsales.csv')
    df['Year'] = pd.to_numeric(df['Year'], errors='coerce')  # Handle non-numeric years
    return df

# Main app
def main():
    st.title("Video Game Sales Analysis")
    st.sidebar.header("Filters")
    
    # Load data
    data = load_data()
    
    # Sidebar filters
    years = st.sidebar.slider(
        "Select Year Range", 
        int(data["Year"].min()), 
        int(data["Year"].max()), 
        (2000, 2015)
    )
    platforms = st.sidebar.multiselect(
        "Select Platforms", 
        options=data["Platform"].unique(), 
        default=data["Platform"].unique()
    )
    
    filtered_data = data[
        (data["Year"] >= years[0]) & 
        (data["Year"] <= years[1]) & 
        (data["Platform"].isin(platforms))
    ]
    
    st.subheader("Filtered Data")
    st.write(filtered_data)
    
    # Top games visualization
    st.subheader("Top 10 Games by Global Sales")
    top_games = (
        filtered_data.sort_values("Global_Sales", ascending=False)
        .head(10)
    )
    fig = px.bar(
        top_games, 
        x="Name", 
        y="Global_Sales", 
        color="Platform", 
        title="Top 10 Games by Global Sales"
    )
    st.plotly_chart(fig)
    
    # Regional sales trends
    st.subheader("Sales by Region Over Time")
    sales_trends = (
        filtered_data.groupby("Year")[["NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"]]
        .sum()
        .reset_index()
    )
    fig = px.line(
        sales_trends, 
        x="Year", 
        y=["NA_Sales", "EU_Sales", "JP_Sales", "Other_Sales"], 
        title="Regional Sales Over Time",
        labels={"value": "Sales (millions)", "Year": "Year"}
    )
    st.plotly_chart(fig)
    
    # Platform-wise game count
    st.subheader("Games Released Per Platform")
    platform_counts = (
        filtered_data.groupby("Platform")["Name"]
        .count()
        .reset_index()
        .rename(columns={"Name": "Game Count"})
    )
    fig = px.bar(
        platform_counts, 
        x="Platform", 
        y="Game Count", 
        title="Number of Games Released Per Platform"
    )
    st.plotly_chart(fig)
    
    # Publisher performance
    st.subheader("Publisher Performance")
    publisher_stats = (
        filtered_data.groupby("Publisher")
        .agg({"Name": "count", "Global_Sales": "sum"})
        .reset_index()
        .rename(columns={"Name": "Game Count", "Global_Sales": "Total Sales"})
    )
    fig = px.scatter(
        publisher_stats, 
        x="Game Count", 
        y="Total Sales", 
        size="Total Sales", 
        hover_name="Publisher", 
        title="Publishers by Number of Games and Global Sales"
    )
    st.plotly_chart(fig)
    # Genre distribution
    st.subheader("Genre Distribution")
    genre_distribution = (
        filtered_data["Genre"]
        .value_counts()
        .reset_index()
        .rename(columns={"index": "Genre", "Genre": "Count"})
    )
    st.write("Debugging DataFrame Structure:")
    st.write(genre_distribution.head())  # Show the first few rows for debugging


if __name__ == "__main__":
    main()
