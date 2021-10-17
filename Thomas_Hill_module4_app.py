# -*- coding: utf-8 -*-
"""
Created on Sat Oct 16 13:13:06 2021

@author: Thomas Hill
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd

import numpy as np




#133 trees
#2-4 stewardship levels
#3 health levels
#5 boroughs

soql_health = pd.DataFrame()

for i in range(1,6): #iterate through each borough
    soql_url =('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=boroname, spc_common,health, steward,count(tree_id)' +\
        '&$where=steward=\'None\'' +\
        '&$group=boroname,spc_common, health').replace(' ', '%20')
    soql_boro = pd.read_json(soql_url)
    soql_health = soql_health.append(soql_boro)

#soql_health.dropna()
soql_health.reset_index()
    
len(soql_health)

soql_health = pd.DataFrame()

for i in range(1,6): #iterate through each borough
    soql_url =('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=boroname, spc_common,health, count(tree_id)' +\
        '&$where=borocode='+str(i) +\
        '&$group=boroname,spc_common, health').replace(' ', '%20')
    soql_boro = pd.read_json(soql_url)
    soql_health = soql_health.append(soql_boro)

soql_health.dropna()
soql_health.reset_index()
    
len(soql_health)
        

soql_boro = pd.DataFrame()
soql_url1 = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
             '$select=boroname, health, spc_common, count(tree_id)' +\
             '&$where=borocode=\'1\'' +\
             '&$group=boroname, health, spc_common').replace(' ', '%20')

soql_boro = pd.read_json(soql_url1)


soql_boro['spc_common'].nunique()
#soql_boro.dropna()

soql_health.head()
    

soql_health[soql_health['boroname'] == 'Brooklyn']

soql_url_test = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=spc_common, count(tree_id)' +\
        '&$group=spc_common').replace(' ', '%20')
   
soql_test = pd.read_json(soql_url_test)
len(soql_test)   

soql_test.sort_values(by='count_tree_id').reset_index()

soql_url1 = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=boroname, spc_common,health, count(tree_id)' +\
        '&$where=health !=\'Good\'' +\
        '&$group=boroname,spc_common, health').replace(' ', '%20')
   
soql_url2 = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=borough, spc_common, health, steward, count(tree_id)' +\
        '&where=steward != None' +\
        '&$group=borough,spc_common, health, steward').replace(' ', '%20')

    
soql_trees = pd.read_json(soql_url1)
len(soql_trees)

soql_steward = pd.read_json(soql_url2)

soql_trees.append(soql_steward).reset_index()

soql_trees


fig = px.bar(soql_trees, x="spc_common", y="count_tree_id", barmode="group")




app.layout = html.Div(children=[
    html.H1(children='Trees of New York, Health Report and Stewardship Efforts'),

    html.Div(children='''
        Dash: A web application framework for Python.
    '''),

    dcc.Graph(
        id='example-graph',
        figure=fig
    )
])

if __name__ == '__main__':
    app.run_server(debug=True, use_reloader=False)
    
    
    
    #####
    
    
    
    

boro = 'Bronx'
soql_url = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=spc_common,count(tree_id)' +\
        '&$where=boroname=\'Bronx\'' +\
        '&$group=spc_common').replace(' ', '%20')
    
soql_trees = pd.read_json(soql_url)

soql_trees.head()


fig = px.bar(soql_trees, x="spc_common", y="count_tree_id", barmode="group")




app.layout = html.Div(children=[
    html.H1(children='Trees of New York, Health Report and Stewardship Efforts'),

    html.Div(children='''
        Dash: A web application framework for Python.
    '''),

    dcc.Graph(
        id='example-graph',
        figure=fig
    )
])

if __name__ == '__main__':
    app.run_server(debug=True, use_reloader=False)
    
#####


df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/gapminderDataFiveYear.csv')

app = dash.Dash(__name__)

app.layout = html.Div([
    dcc.Graph(id='graph-with-slider'),
    dcc.Slider(
        id='year-slider',
        min=df['year'].min(),
        max=df['year'].max(),
        value=df['year'].min(),
        marks={str(year): str(year) for year in df['year'].unique()},
        step=None
    )
])


@app.callback(
    Output('graph-with-slider', 'figure'),
    Input('year-slider', 'value'))
def update_figure(selected_year):
    filtered_df = df[df.year == selected_year]

    fig = px.scatter(filtered_df, x="gdpPercap", y="lifeExp",
                     size="pop", color="continent", hover_name="country",
                     log_x=True, size_max=55)

    fig.update_layout(transition_duration=500)

    return fig


if __name__ == '__main__':
    app.run_server(debug=True)



soql_health = pd.DataFrame()

for i in range(1,6): #iterate through each borough

    soql_url = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' +\
        '$select=boroname, spc_common,health, count(tree_id)' +\
        '&$where=borocode='+str(i) +\
        '&where=status=\'Alive\'' +\
        '&$group=boroname,spc_common, health').replace(' ', '%20')
    soql_boro = pd.read_json(soql_url)
    soql_health = soql_health.append(soql_boro)

soql_heatlh = soql_health.dropna(inplace= True)
soql_health = soql_health.reset_index()

soql_health = pd.read_csv('trees.csv')


soql_health['spc_common'] = soql_health['spc_common'].str.title()
soql_health = soql_health.sort_values('spc_common')

soql_health.head()

app = dash.Dash()
server = app.server


tree_options = soql_health['spc_common'].unique() #create levels of health
    
app.layout = html.Div(children=[
    html.H1(children='Tree Health of New York City, 2015'),
    
    html.H6('Select the tree you\'re interested in:'),
    
    dcc.Dropdown(id='tree-column', value = 'Type the Tree Here', 
                  options=[{'label' : i, 'value': i} for i in tree_options]),

    dcc.Graph(
        id='health-graph')
    
])


@app.callback(
    Output('health-graph', 'figure'),
    [Input('tree-column', 'value')])


def update_graph(tree_name):
    
    dff = soql_health[soql_health['spc_common'] == tree_name]
    
    fig = px.treemap(dff, path=[px.Constant("New York City"),
                                'boroname', 'spc_common', 'health'],
                     values='count_tree_id', color='health')
    return fig


if __name__ == '__main__':
    app.run_server(debug=True, use_reloader = False)
