import pandas as pd
import numpy as np
import streamlit as st
from connector import connect_to
import plotly.express as px

with connect_to('postgres') as conn:
    df = pd.read_sql("""
        select 
            billing_country as country
            , count(invoice_id) as cnt
            , sum(total) as total
            , extract(year from invoice_date) as year
        from invoice i
        group by billing_country, year;    
    """, conn)

with st.sidebar:
    total = st.slider("Total", min_value=df['total'].min(), max_value=df['total'].max())
    years = st.multiselect("Years", df['year'].unique()) 

st.header('Chinook Sales Report')

col1, col2 = st.columns(2, gap='large')

df2 = df[
    (df['total'] <= float(total))
    & (df['year'].isin(years))
]

with col1:
    if st.checkbox("Show the first chart"):
        fig = px.bar(
            data_frame=df2,
            x='country',
            y='cnt'
        )
        st.plotly_chart(fig, key='chart1')
with col2:
    if st.checkbox("Show the second chart"):
        fig2 = px.bar(
            data_frame=df2,
            x='country',
            y='total'
        )
        st.plotly_chart(fig2, key='chart2')

