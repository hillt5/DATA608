d3.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module6/d3_lab/ue_industry.csv', data => {

    const xScale = d3.scaleLinear()
        .domain(d3.extent(data, d => +d.index))
        .range([20, 1180]);
            
    const yScale = d3.scaleLinear()
        .domain(d3.extent(data, d => +d.Agriculture))
        .range([580, 20]);

    var line3 = d3.line()
        .x(d => xScale(d.index))
        .y(d => yScale(d.Agriculture));

        
    d3.select('#answer1')
        .append('path')
        .attr('d', line3(data))
        .attr('stroke', '#2e2928');


});