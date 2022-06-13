classdef Covid_data_analysis_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure  matlab.ui.Figure
        SaveFigureButton           matlab.ui.control.Button
        LoadDataButton             matlab.ui.control.Button
        AboutButton                matlab.ui.control.Button
        DataSourceButton           matlab.ui.control.Button
        TabGroup                   matlab.ui.container.TabGroup
        PlotTab                    matlab.ui.container.Tab
        TextArea_3                 matlab.ui.control.TextArea
        UIAxes                     matlab.ui.control.UIAxes
        StatisticsTab              matlab.ui.container.Tab
        TextArea_7                 matlab.ui.control.TextArea
        TextArea_6                 matlab.ui.control.TextArea
        UIAxes3                    matlab.ui.control.UIAxes
        HistogramsTab              matlab.ui.container.Tab
        TextArea_4                 matlab.ui.control.TextArea
        UIAxes_2                   matlab.ui.control.UIAxes
        PieChartTab                matlab.ui.container.Tab
        UIAxes4                    matlab.ui.control.UIAxes
        HeatMapTab                 matlab.ui.container.Tab
        TextArea_5                 matlab.ui.control.TextArea
        DataTab                    matlab.ui.container.Tab
        UITable                    matlab.ui.control.Table
        GeographicPlotTab          matlab.ui.container.Tab
        Switch                     matlab.ui.control.Switch
        Hyperlink                  matlab.ui.control.Hyperlink
        TextArea_2                 matlab.ui.control.TextArea
        DeveloperInfoTab           matlab.ui.container.Tab
        TextArea                   matlab.ui.control.TextArea
        UIAxes2                    matlab.ui.control.UIAxes
        OptionforcasesButtonGroup  matlab.ui.container.ButtonGroup
        LinechartButton_2          matlab.ui.control.RadioButton
        BarchartButton             matlab.ui.control.RadioButton
        DefaultSettingButton       matlab.ui.control.Button
        EditField_2                matlab.ui.control.EditField
        EditField                  matlab.ui.control.EditField
        OptionButtonGroup          matlab.ui.container.ButtonGroup
        DailyButton                matlab.ui.control.RadioButton
        CumulativeButton           matlab.ui.control.RadioButton
        DatatoplotButtonGroup      matlab.ui.container.ButtonGroup
        BothButton                 matlab.ui.control.RadioButton
        DeathsButton               matlab.ui.control.RadioButton
        CasesButton                matlab.ui.control.RadioButton
        AverageofdaysSlider        matlab.ui.control.Slider
        AverageofdaysSliderLabel   matlab.ui.control.Label
        StateListBox               matlab.ui.control.ListBox
        StateListBoxLabel          matlab.ui.control.Label
        CountryListBox             matlab.ui.control.ListBox
        CountryLabel               matlab.ui.control.Label
    end


    properties (Access = private)
        XData
        Cases_Deaths_Matrix
        CasesVec
        DeathsVec
        AverageCases
        AverageDeaths
        AveragingWindow
        Country_title
        State_title
        tab
        tableData
        filename = []
        prev_file = []
        obj1
        obj2
    end

    methods (Access = private)
    
        function PlotData(app)
            app.UIAxes3.reset; app.TextArea_3.delete; app.UIAxes_2.Visible = "off"; app.Switch.Visible = "off";
            app.UIAxes.Visible = "on"; app.TextArea_4.Visible = "on"; app.TextArea_6.Visible = "off"; app.TextArea_7.Visible = "on"; app.UIAxes3.Visible = "off";
            
            % Plot Tab
            app.UIAxes.reset; 
            ta = 'Cumulative Number of Cases in ';
            tb = 'Cumulative Number of Deaths in ';
            tc = 'Cumulative Number of Cases and Deaths in ';
            td = 'Daily Number of Cases in ';
            te = 'Daily Number of Deaths in ';
            tf = 'Daily Number of Cases and Deaths in ';
            half_window = app.AveragingWindow/2;
            start = floor(half_window) + 1;
            stop = length(app.XData) - (ceil(half_window)-1);
            app.UITable.RowName = {'Date'}; app.UITable.ColumnName = {'Country';'State'};
            if app.CasesButton.Value && app.CumulativeButton.Value && app.BarchartButton.Value
                app.CumulativeVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Cumulative Cases';
                app.UITable.Data = app.currentData;
                bar(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                num_title = [ta app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
                ylabel(app.UIAxes,'Cumulative Cases');
            elseif app.CasesButton.Value && app.CumulativeButton.Value && app.LinechartButton_2.Value
                app.CumulativeVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Cumulative Cases';
                app.UITable.Data = app.currentData;
                plot(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                num_title = [ta app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
                ylabel(app.UIAxes,'Cumulative Cases');
            elseif app.CasesButton.Value && app.DailyButton.Value && app.BarchartButton.Value
                app.DailyVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Daily Cases';
                app.UITable.Data = app.currentData;
                app.TextArea_7.Visible = "off"; app.TextArea_6.Visible = "on"; app.UIAxes3.Visible = "on";
                app.TextArea_6.Value = {'From Jan,2020 To Feb,2021'; ['Total Cases: ' char(string(sum(app.AverageCases(start:stop))))];...
                                                ['Mean: ' char(string(mean(app.AverageCases(start:stop))))];...
                                                ['Median: ' char(string(median(app.AverageCases(start:stop))))];...
                                                ['Mode: ' char(string(mode(app.AverageCases(start:stop))))];...
                                                ['STD: ' char(string(std(app.AverageCases(start:stop))))];...
                                                ['Maximum: ' char(string(max(app.AverageCases(start:stop))))];...
                                                ['Minimum: ' char(string(min(app.AverageCases(start:stop))))]};
                boxplot(app.UIAxes3,app.AverageCases(start:stop));
                title(app.UIAxes3, "BoxPlot for " + string(app.Country_title) + string(app.State_title)); ylabel(app.UIAxes3, "Daily Cases");
                set(app.UIAxes3,'YTickLabel', num2str(get(app.UIAxes3,'YTick').' , '%.f') );
                bar(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                num_title = [td app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
                ylabel(app.UIAxes,'Daily Cases');
            elseif app.CasesButton.Value && app.DailyButton.Value && app.LinechartButton_2.Value
                app.DailyVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Daily Cases';
                app.UITable.Data = app.currentData;
                app.TextArea_7.Visible = "off"; app.TextArea_6.Visible = "on"; app.UIAxes3.Visible = "on";
                app.TextArea_6.Value = {'From Jan,2020 To Feb,2021';['Total Cases: ' char(string(sum(app.AverageCases(start:stop))))];...
                                                ['Mean: ' char(string(mean(app.AverageCases(start:stop))))];...
                                                ['Median: ' char(string(median(app.AverageCases(start:stop))))];...
                                                ['Mode: ' char(string(mode(app.AverageCases(start:stop))))];...
                                                ['STD: ' char(string(std(app.AverageCases(start:stop))))];...
                                                ['Maximum: ' char(string(max(app.AverageCases(start:stop))))];...
                                                ['Minimum: ' char(string(min(app.AverageCases(start:stop))))]};
                boxplot(app.UIAxes3,app.AverageCases(start:stop));
                title(app.UIAxes3, "BoxPlot for " + string(app.Country_title) + string(app.State_title)); ylabel(app.UIAxes3, "Daily Cases");
                set(app.UIAxes3,'YTickLabel', num2str(get(app.UIAxes3,'YTick').' , '%.f') );
                plot(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                num_title = [td app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
                ylabel(app.UIAxes,'Cumulative Cases');
            elseif app.DeathsButton.Value && app.CumulativeButton.Value
                app.CumulativeVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Cumulative Deaths';
                app.UITable.Data = app.currentData;
                plot(app.UIAxes,app.XData(start:stop),app.AverageDeaths(start:stop),'r');
                num_title = [tb app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
                ylabel(app.UIAxes,'Cumulative Deaths');
            elseif app.DeathsButton.Value && app.DailyButton.Value
                app.DailyVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Daily Deaths';
                app.UITable.Data = app.currentData;
                app.TextArea_7.Visible = "off"; app.TextArea_6.Visible = "on"; app.UIAxes3.Visible = "on";
                app.TextArea_6.Value = {'From Jan,2020 To Feb,2021';['Total Deaths: ' char(string(sum(app.AverageDeaths(start:stop))))];...
                                                ['Mean: ' char(string(mean(app.AverageDeaths(start:stop))))];...
                                                ['Median: ' char(string(median(app.AverageDeaths(start:stop))))];...
                                                ['Mode: ' char(string(mode(app.AverageDeaths(start:stop))))];...
                                                ['STD: ' char(string(std(app.AverageDeaths(start:stop))))];...
                                                ['Maximum: ' char(string(max(app.AverageDeaths(start:stop))))];...
                                                ['Minimum: ' char(string(min(app.AverageDeaths(start:stop))))]};
                boxplot(app.UIAxes3,app.AverageDeaths(start:stop));
                title(app.UIAxes3, "BoxPlot for " + string(app.Country_title) + string(app.State_title)); ylabel(app.UIAxes3, "Daily Deaths");
                set(app.UIAxes3,'YTickLabel', num2str(get(app.UIAxes3,'YTick').' , '%.f') );
                plot(app.UIAxes,app.XData(start:stop),app.AverageDeaths(start:stop),'r');
                num_title = [te app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
                ylabel(app.UIAxes,'Daily Deaths');
            elseif app.BothButton.Value && app.CumulativeButton.Value && app.BarchartButton.Value
                app.CumulativeVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Cumulative Cases';
                app.UITable.RowName{3} = 'Cumulative Deaths';
                app.UITable.Data = app.currentData;
                yyaxis(app.UIAxes,'left');
                bar(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                ylabel(app.UIAxes,'Cumulative Cases');
                set(app.UIAxes,'YTickLabel', num2str(get(app.UIAxes,'YTick').' , '%.f') );
                app.UIAxes.YColor = [0.00 0.00 1.00];
                hold(app.UIAxes,'on');
                yyaxis(app.UIAxes,'right');
                plot(app.UIAxes,app.XData(start:stop),app.AverageDeaths(start:stop),'r');
                ylabel(app.UIAxes,'Cumulative Deaths');
                app.UIAxes.YColor = [1.00 0.00 0.00];
                num_title = [tc app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
            elseif app.BothButton.Value && app.CumulativeButton.Value && app.LinechartButton_2.Value
                app.CumulativeVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Cumulative Cases';
                app.UITable.RowName{3} = 'Cumulative Deaths';
                app.UITable.Data = app.currentData;
                yyaxis(app.UIAxes,'left');
                plot(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                ylabel(app.UIAxes,'Cumulative Cases');
                set(app.UIAxes,'YTickLabel', num2str(get(app.UIAxes,'YTick').' , '%.f') );
                app.UIAxes.YColor = [0.00 0.00 1.00];
                hold(app.UIAxes,'on');
                yyaxis(app.UIAxes,'right');
                plot(app.UIAxes,app.XData(start:stop),app.AverageDeaths(start:stop),'r');
                ylabel(app.UIAxes,'Cumulative Deaths');
                app.UIAxes.YColor = [1.00 0.00 0.00];
                num_title = [tc app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
            elseif app.BothButton.Value && app.DailyButton.Value && app.BarchartButton.Value
                app.DailyVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Daily Cases';
                app.UITable.RowName{3} = 'Daily Deaths';
                app.UITable.Data = app.currentData;
                yyaxis(app.UIAxes,'left');
                bar(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                ylabel(app.UIAxes,'Daily Cases');
                set(app.UIAxes,'YTickLabel', num2str(get(app.UIAxes,'YTick').' , '%.f') );
                app.UIAxes.YColor = [0.00 0.00 1.00];
                hold(app.UIAxes,'on');
                yyaxis(app.UIAxes,'right');
                plot(app.UIAxes,app.XData(start:stop),app.AverageDeaths(start:stop),'r');
                ylabel(app.UIAxes,'Daily Deaths');
                app.UIAxes.YColor = [1.00 0.00 0.00];
                num_title = [tf app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
            elseif app.BothButton.Value && app.DailyButton.Value && app.LinechartButton_2.Value
                app.DailyVec;
                app.ComputeAverages;
                app.UITable.RowName{2} = 'Daily Cases';
                app.UITable.RowName{3} = 'Daily Deaths';
                app.UITable.Data = app.currentData;
                yyaxis(app.UIAxes,'left');
                plot(app.UIAxes,app.XData(start:stop),app.AverageCases(start:stop),'b');
                ylabel(app.UIAxes,'Daily Cases');
                set(app.UIAxes,'YTickLabel', num2str(get(app.UIAxes,'YTick').' , '%.f') );
                app.UIAxes.YColor = [0.00 0.00 1.00];
                hold(app.UIAxes,'on');
                yyaxis(app.UIAxes,'right');
                plot(app.UIAxes,app.XData(start:stop),app.AverageDeaths(start:stop),'r');
                ylabel(app.UIAxes,'Daily Deaths');
                app.UIAxes.YColor = [1.00 0.00 0.00];
                num_title = [tf app.Country_title app.State_title app.tab];
                title(app.UIAxes,num_title,'HorizontalAlignment','center');
            end
            xlim(app.UIAxes,[app.XData(1)-21,app.XData(end)+2]); xlim(app.UIAxes,'manual');
            app.UIAxes.YLimMode = 'auto'; app.UIAxes.YTickMode = 'auto';
            xlabel(app.UIAxes,'Date(mm/dd)'); grid(app.UIAxes,'on');
            datetick(app.UIAxes,'x','mm/dd','keeplimits');
            set(app.UIAxes,'YTickLabel', num2str(get(app.UIAxes,'YTick').' , '%.f') );
            hold(app.UIAxes,'off');
            
            % Data By State Tab, Geographic Plot Tab, Heat Map Tab
            app.UIAxes_2.reset;load Global geo_data; 
            Selected_Item = Data(app.CountryListBox.Value,app.filename);
            cases = zeros(1,length(Selected_Item.CountryRows)-1);
            deaths = zeros(1,length(Selected_Item.CountryRows)-1);
            longitude = zeros(1,length(Selected_Item.CountryRows)-1);
            latitude = zeros(1,length(Selected_Item.CountryRows)-1);
            state = cell(length(Selected_Item.CountryRows)-1,1);           
            if app.Country_title == "Global" 
                app.TextArea_4.Visible = "off"; app.UIAxes_2.Visible = "on"; app.TextArea_5.Visible = "off";
                app.obj2 = heatmap(app.HeatMapTab,{'Cases','Deaths'},geo_data.Country,[geo_data.Cases,geo_data.Deaths],"Title",'Heat Map for Global');
                if app.CasesButton.Value
                    app.TextArea_2.Visible = "off"; app.Hyperlink.Visible = "off"; app.Switch.Visible = "on";
                    app.obj1 = geobubble(app.GeographicPlotTab,geo_data.Latitude,geo_data.Longitude,geo_data.Cases,geo_data.Country,"Basemap",'colorterrain');
                    app.obj1.Title = "Global Cases"; if app.Switch.Value == "Max"; app.obj1.MapLayout = 'maximized'; else; app.obj1.MapLayout = 'normal'; end
                    bar(app.UIAxes_2,geo_data.Country,geo_data.Cases);
                    set(app.UIAxes_2,'YTickLabel', num2str(get(app.UIAxes_2,'YTick').' , '%.f') );
                    title(app.UIAxes_2,"Global Cases"); 
                    explode = zeros(1,length(geo_data.Cases)); explode(geo_data.Cases == max(geo_data.Cases)) = 1; explode(geo_data.Cases == min(geo_data.Cases)) = 1;
                    pie(app.UIAxes4,geo_data.Cases,explode,categories(geo_data.Country));
                    title(app.UIAxes4,"Global Cases");
                elseif app.DeathsButton.Value
                    app.TextArea_2.Visible = "off"; app.Hyperlink.Visible = "off"; app.Switch.Visible = "on";
                    app.obj1 = geobubble(app.GeographicPlotTab,geo_data.Latitude,geo_data.Longitude,geo_data.Deaths,geo_data.Country,"Basemap",'colorterrain');
                    app.obj1.Title = "Global Deaths"; if app.Switch.Value == "Max"; app.obj1.MapLayout = 'maximized'; else; app.obj1.MapLayout = 'normal'; end
                    bar(app.UIAxes_2,geo_data.Country,geo_data.Deaths);
                    set(app.UIAxes_2,'YTickLabel', num2str(get(app.UIAxes_2,'YTick').' , '%.f') );
                    title(app.UIAxes_2,"Global Deaths");
                    explode = zeros(1,length(geo_data.Deaths)); explode(geo_data.Deaths == max(geo_data.Deaths)) = 1; explode(geo_data.Deaths == min(geo_data.Deaths)) = 1;
                    pie(app.UIAxes4,geo_data.Deaths,explode,categories(geo_data.Country));
                    title(app.UIAxes4,"Global Deaths");
                end
            elseif length(Selected_Item.CountryRows)>1
                app.TextArea_4.Visible = "off"; app.UIAxes_2.Visible = "on"; app.TextArea_5.Visible = "off";
                for i=2:length(Selected_Item.CountryRows)
                    cases(i-1) = Selected_Item.covidData{Selected_Item.CountryRows(i),end}(1);
                    deaths(i-1) = Selected_Item.covidData{Selected_Item.CountryRows(i),end}(2);
                    latitude(i-1) = Selected_Item.covidData{Selected_Item.CountryRows(i),3};
                    longitude(i-1) = Selected_Item.covidData{Selected_Item.CountryRows(i),4};
                    state{i-1,1} = Selected_Item.covidData{Selected_Item.CountryRows(i),2}(1:end);
                end
                geo_table = table(categorical(state),latitude',longitude',cases',deaths');
                geo_table.Properties.VariableNames = {'state','latitude','longitude','cases','deaths'};
                cdata = [cases; deaths]'; xvalues = {'Cases', 'Deaths'}; 
                app.obj2 = heatmap(app.HeatMapTab,xvalues,Selected_Item.StateName(2:end),cdata,"Title",['Heat Map for ' app.Country_title]);
                if app.CasesButton.Value
                    bar(app.UIAxes_2,categorical(Selected_Item.StateName(2:end)),cases');
                    set(app.UIAxes_2,'YTickLabel', num2str(get(app.UIAxes_2,'YTick').' , '%.f') );
                    title(app.UIAxes_2,['Cases By State for ' app.Country_title]); 
                    app.TextArea_2.Visible = "off";app.Hyperlink.Visible = "off"; app.Switch.Visible = "on";
                    app.obj1 = geobubble(app.GeographicPlotTab,geo_table.latitude,geo_table.longitude,geo_table.cases,geo_table.state,"Basemap",'colorterrain');
                    app.obj1.Title = "Cases for " + string(app.Country_title); if app.Switch.Value == "Max"; app.obj1.MapLayout = 'maximized'; else; app.obj1.MapLayout = 'normal'; end
                    explode = zeros(1,length(cases)); explode(cases == max(cases)) = 1; explode(cases == min(cases)) = 1;
                    pie(app.UIAxes4,cases,explode,Selected_Item.StateName(2:end));
                    title(app.UIAxes4,"Cases for " + string(app.Country_title));
                elseif app.DeathsButton.Value
                    bar(app.UIAxes_2,categorical(Selected_Item.StateName(2:end)),deaths');
                    set(app.UIAxes_2,'YTickLabel', num2str(get(app.UIAxes_2,'YTick').' , '%.f') );
                    title(app.UIAxes_2,['Deaths By State for ' app.Country_title]); 
                    app.TextArea_2.Visible = "off";app.Hyperlink.Visible = "off"; app.Switch.Visible = "on";
                    app.obj1 = geobubble(app.GeographicPlotTab,geo_table.latitude,geo_table.longitude,geo_table.deaths,geo_table.state,"Basemap",'colorterrain');
                    app.obj1.Title = "Deaths for " + string(app.Country_title); if app.Switch.Value == "Max"; app.obj1.MapLayout = 'maximized'; else; app.obj1.MapLayout = 'normal'; end        
                    explode = zeros(1,length(cases)); explode(cases == max(cases)) = 1; explode(cases == min(cases)) = 1;
                    pie(app.UIAxes4,deaths,explode,Selected_Item.StateName(2:end));
                    title(app.UIAxes4,"Deaths for " + string(app.Country_title));
                elseif app.BothButton.Value
                    app.obj1.Visible = "off"; app.TextArea_2.Visible = "on"; app.Hyperlink.Visible = "on";                  
                    app.TextArea_4.Visible = "on"; app.Switch.Visible = "off"; bar(app.UIAxes_2,[],[]);
                    app.UIAxes_2.Visible = "off";
                end
            else
                app.obj1.Visible = "off"; app.TextArea_2.Visible = "on"; app.Hyperlink.Visible = "on";
                bar(app.UIAxes_2,[],[]); app.UIAxes_2.Visible = "off"; app.TextArea_5.Visible = "on"; app.obj2.Visible = "off";
            end
        end
        function ComputeAverages(app)
            app.AverageCases = movmean(app.CasesVec,app.AveragingWindow);
            app.AverageDeaths = movmean(app.DeathsVec,app.AveragingWindow);
        end
        function DailyVec(app)
            app.CumulativeVec;
            x = app.CasesVec - circshift(app.CasesVec,1);
            x(1) = app.CasesVec(1);
            x(x<0) = 0;
            app.CasesVec = x;
            y = app.DeathsVec - circshift(app.DeathsVec,1);
            y(1) = app.DeathsVec(1);
            y(y<0) = 0;
            app.DeathsVec = y;
        end
        function CumulativeVec(app)
            Selected_Item = Data(app.CountryListBox.Value,app.filename);
            [~,in1] = ismember(app.CountryListBox.Value,app.CountryListBox.Items);
            [~,in2] = ismember(app.StateListBox.Value,app.StateListBox.Items);
            if in1 == 1
                app.Cases_Deaths_Matrix = Selected_Item.global_cases_and_deaths;
                app.CasesVec = app.Cases_Deaths_Matrix(1,:);
                app.DeathsVec = app.Cases_Deaths_Matrix(2,:);
            else
                app.CasesVec = Selected_Item.Cases_Vector(Selected_Item.CountryRows(in2));
                app.DeathsVec = Selected_Item.Deaths_Vector(Selected_Item.CountryRows(in2));
            end
        end
        function out = currentData(app)
            if app.BothButton.Value
                app.tableData{2,1} = app.CountryListBox.Value;
                app.tableData{2,2} = app.StateListBox.Value;
                app.tableData{3,1} = app.CountryListBox.Value;
                app.tableData{3,2} = app.StateListBox.Value;
                for i = 1:length(app.CasesVec)
                    app.tableData{2,i+2} = app.CasesVec(i);
                    app.tableData{3,i+2} = app.DeathsVec(i);
                end
                out = app.tableData;
            elseif app.CasesButton.Value
                app.tableData{2,1} = app.CountryListBox.Value;
                app.tableData{2,2} = app.StateListBox.Value;
                for i = 1:length(app.CasesVec)
                    app.tableData{2,i+2} = app.CasesVec(i);
                end
                out = app.tableData(1:2,:);
            elseif app.DeathsButton.Value
                app.tableData{2,1} = app.CountryListBox.Value;
                app.tableData{2,2} = app.StateListBox.Value;
                for i = 1:length(app.DeathsVec)
                    app.tableData{2,i+2} = app.DeathsVec(i);
                end
                out = app.tableData(1:2,:);
            end
        end
        function setDefaults(app)
            try 
                app.UIAxes.reset;
                globalData = Data('Global',app.filename);
                app.CountryListBox.Items = unique(globalData.CountryName,'stable');
                app.StateListBox.Items = unique(globalData.StateName,'stable');
                app.Cases_Deaths_Matrix = globalData.global_cases_and_deaths();
                app.tableData = cell(3,length(globalData.Date));
                app.tableData = globalData.covidData(1,1:end);
                app.tableData{1,1} = ' ';
                app.tableData{1,2} = ' ';
                app.CasesVec = app.Cases_Deaths_Matrix(1,:);
                app.DeathsVec = app.Cases_Deaths_Matrix(2,:);
                startDate = datenum(globalData.Date(1));
                endDate = datenum(globalData.Date(end));
                app.XData = linspace(startDate,endDate,length(globalData.Date));
                app.AveragingWindow = 1;
                app.AverageofdaysSlider.Value = 1;
                
                % set widgets
                app.CountryListBox.Value = 'Global';
                app.StateListBox.Value = 'All';
                app.CasesButton.Value = true;
                app.DeathsButton.Value = false;
                app.BothButton.Value = false;
                app.CumulativeButton.Value = true;
                app.DailyButton.Value = false;
                app.BarchartButton.Value = true;
                app.LinechartButton_2.Value = false;
                app.UITable.RowName = {'Date'};
                
                app.StateListBoxValueChanged;
            catch
                msgbox('Failed to load data!', 'Error','error');
                if ~isempty(app.prev_file)
                    app.filename = app.prev_file;
                    app.CountryListBoxValueChanged;
                end
            end
        end
        function shortName(app,name)
            if ~ischar(name)
                error('Input must be character array');
            end
            first = string(name(1));
            k = find(name == ' ');
            other = "";
            for ii = 1:length(k)
                other = other + string(name(k(ii)+1));
            end
            app.State_title = char(", "+first + other);
        end        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            image(app.UIAxes2,importdata('JKDash.jpg')); axis(app.UIAxes2,'off');
            app.UIAxes.Visible = "off"; app.UIAxes_2.Visible = "off"; app.Switch.Visible = "off";
            app.TextArea_6.Visible = "off"; app.TextArea_7.Visible = "on"; app.UIAxes3.Visible = "off";
        end

        % Value changed function: CountryListBox
        function CountryListBoxValueChanged(app, event)
            app.UITable.RowName = {'Date'};
            app.UITable.ColumnName = {'Country';'State'};
            Selected_Item = Data(app.CountryListBox.Value,app.filename);
            app.StateListBox.Items = unique(Selected_Item.StateName,'stable');
            app.StateListBoxValueChanged;
        end

        % Value changed function: StateListBox
        function StateListBoxValueChanged(app, event)
            app.UITable.ColumnName = {'Country';'State'};
            app.UITable.RowName = {'Date'};
            [~,in2] = ismember(app.StateListBox.Value,app.StateListBox.Items);
            app.Country_title = app.CountryListBox.Value;
            if in2 ~= 1
                if ismember(' ',app.StateListBox.Value)
                    app.shortName(app.StateListBox.Value);
                else
                    app.State_title = char(", " + string(app.StateListBox.Value));
                end
            else
                app.State_title = '';
            end
            app.PlotData;            
        end

        % Value changing function: AverageofdaysSlider
        function AverageofdaysSliderValueChanging(app, event)
            app.AveragingWindow = round(abs(event.Value));
            if app.AveragingWindow > 1
                app.tab = [' (' char(string(round(app.AveragingWindow))) '-day mean)'];
            else
                app.tab = '';
            end
            if ~isempty(app.filename); app.PlotData; end
        end

        % Selection changed function: DatatoplotButtonGroup
        function DatatoplotButtonGroupSelectionChanged(app, event)
            if ~isempty(app.filename); app.PlotData; end
            
        end

        % Selection changed function: OptionButtonGroup
        function OptionButtonGroupSelectionChanged(app, event)
            if ~isempty(app.filename); app.PlotData; end
            
        end

        % Selection changed function: OptionforcasesButtonGroup
        function OptionforcasesButtonGroupSelectionChanged(app, event)
            if ~isempty(app.filename); app.PlotData; end
            
        end

        % Button pushed function: DefaultSettingButton
        function DefaultSettingButtonPushed(app, event)
            if ~isempty(app.filename); app.setDefaults; end
        end

        % Value changed function: EditField
        function EditFieldValueChanged(app, event)
            if ismember(event.Value,app.CountryListBox.Items)
                app.CountryListBox.Value = event.Value;
                app.CountryListBoxValueChanged;
            else
                msgbox('Invalid Country Name!', 'Error','error');
            end
            
        end

        % Value changed function: EditField_2
        function EditField_2ValueChanged(app, event)
            if ismember(event.Value,app.StateListBox.Items)
                app.StateListBox.Value = event.Value;
                app.StateListBoxValueChanged;
            else
                msgbox('Invalid State Name!', 'Error','error');
            end           
        end

        % Button pushed function: DataSourceButton
        function DataSourceButtonPushed(app, event)
            if ~isempty(app.filename)
                load(app.filename,'covid_data');
                if app.CasesButton.Value
                    for i = 1:length(covid_data(2:end,5))
                        if isempty(covid_data{i+1,2})
                            covid_data{i+1,2} = 'All';
                        end
                        for j = 5:length(covid_data(1,:))
                            covid_data{i+1,j} = covid_data{i+1,j}(1,1); 
                        end
                    end
                elseif app.DeathsButton.Value
                    for i = 1:length(covid_data(2:end,5))
                        if isempty(covid_data{i+1,2})
                            covid_data{i+1,2} = 'All';
                        end
                        for j = 5:length(covid_data(1,:))
                            covid_data{i+1,j} = covid_data{i+1,j}(1,2); 
                        end
                    end
                elseif app.BothButton.Value
                    message = fileread('message.txt');
                    msgbox(message,"Error","error");
                    return;
                end
                app.UITable.RowName = {};
                app.UITable.ColumnName = {};
                app.UITable.Data = table(covid_data);
            end
        end

        % Button pushed function: AboutButton
        function AboutButtonPushed(app, event)
            about = fileread('about.txt');
            msgbox(about,"About Info",'custom',imread('index.jpg'));
        end

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            app.prev_file = app.filename;
            [f,p] = uigetfile({'*.mat';'*.txt';'*.csv';'*.slx';'*.m';'*.xlsx';'*.*'},'File Selector');
            if ischar(p)
                app.filename = fullfile(p,f);
                app.setDefaults;
            end
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            app.PlotData;
        end

        % Button pushed function: SaveFigureButton
        function SaveFigureButtonPushed(app, event)
                if app.TabGroup.SelectedTab.Title == "Plot"
                    exportgraphics(app.UIAxes,strcat("Plot-",string(datetime('now','Format','MMMM-dd-yyyy HH-mm-ss')),".png"));
                elseif app.TabGroup.SelectedTab.Title == "Statistics"
                    exportgraphics(app.UIAxes3,strcat("Stat-",string(datetime('now','Format','MMMM-dd-yyyy HH-mm-ss')),".png"));
                elseif app.TabGroup.SelectedTab.Title == "Histograms"
                    exportgraphics(app.UIAxes_2,strcat("Histogram-",string(datetime('now','Format','MMMM-dd-yyyy HH-mm-ss')),".png"));
                elseif app.TabGroup.SelectedTab.Title == "Heat Map"
                    exportgraphics(app.obj2,strcat("Heat_map-",string(datetime('now','Format','MMMM-dd-yyyy HH-mm-ss')),".png"));
                elseif app.TabGroup.SelectedTab.Title == "Geographic Plot"
                    exportgraphics(app.obj1,strcat("Geo_graph-",string(datetime('now','Format','MMMM-dd-yyyy HH-mm-ss')),".png"));
                elseif app.TabGroup.SelectedTab.Title == "Pie Chart"
                    exportgraphics(app.UIAxes4,strcat("Pie Chart-",string(datetime('now','Format','MMMM-dd-yyyy HH-mm-ss')),".png"));
                end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure and hide until all components are created
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure = uifigure('Visible', 'off');
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.IntegerHandle = 'on';
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.NumberTitle = 'on';
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.Color = [0.349 0.549 0.651];
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.Position = [100 100 814 707];
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.Name = 'COVID-19 Data Visualization (Data source: Johns Hopkins University)';
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.WindowStyle = 'modal';

            % Create CountryLabel
            app.CountryLabel = uilabel(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.CountryLabel.FontWeight = 'bold';
            app.CountryLabel.FontColor = [0.902 0.902 0.902];
            app.CountryLabel.Position = [9 240 55 22];
            app.CountryLabel.Text = 'Country:';

            % Create CountryListBox
            app.CountryListBox = uilistbox(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.CountryListBox.Items = {};
            app.CountryListBox.ValueChangedFcn = createCallbackFcn(app, @CountryListBoxValueChanged, true);
            app.CountryListBox.BackgroundColor = [0.902 0.902 0.902];
            app.CountryListBox.Position = [63 28 153 208];
            app.CountryListBox.Value = {};

            % Create StateListBoxLabel
            app.StateListBoxLabel = uilabel(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.StateListBoxLabel.FontWeight = 'bold';
            app.StateListBoxLabel.FontColor = [0.902 0.902 0.902];
            app.StateListBoxLabel.Position = [222 240 39 22];
            app.StateListBoxLabel.Text = 'State:';

            % Create StateListBox
            app.StateListBox = uilistbox(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.StateListBox.Items = {};
            app.StateListBox.ValueChangedFcn = createCallbackFcn(app, @StateListBoxValueChanged, true);
            app.StateListBox.BackgroundColor = [0.902 0.902 0.902];
            app.StateListBox.Position = [258 28 153 208];
            app.StateListBox.Value = {};

            % Create AverageofdaysSliderLabel
            app.AverageofdaysSliderLabel = uilabel(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.AverageofdaysSliderLabel.HorizontalAlignment = 'center';
            app.AverageofdaysSliderLabel.FontSize = 14;
            app.AverageofdaysSliderLabel.FontColor = [0.902 0.902 0.902];
            app.AverageofdaysSliderLabel.Position = [557 236 106 22];
            app.AverageofdaysSliderLabel.Text = 'Average of days';

            % Create AverageofdaysSlider
            app.AverageofdaysSlider = uislider(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.AverageofdaysSlider.Limits = [1 15];
            app.AverageofdaysSlider.MajorTicks = [1 3 5 7 9 11 13 15];
            app.AverageofdaysSlider.ValueChangingFcn = createCallbackFcn(app, @AverageofdaysSliderValueChanging, true);
            app.AverageofdaysSlider.Position = [506 226 208 3];
            app.AverageofdaysSlider.Value = 1;

            % Create DatatoplotButtonGroup
            app.DatatoplotButtonGroup = uibuttongroup(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.DatatoplotButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @DatatoplotButtonGroupSelectionChanged, true);
            app.DatatoplotButtonGroup.Title = 'Data to plot';
            app.DatatoplotButtonGroup.BackgroundColor = [0.7804 0.7608 0.7294];
            app.DatatoplotButtonGroup.Position = [445 66 100 106];

            % Create CasesButton
            app.CasesButton = uiradiobutton(app.DatatoplotButtonGroup);
            app.CasesButton.Text = ' Cases';
            app.CasesButton.Position = [11 60 59 22];
            app.CasesButton.Value = true;

            % Create DeathsButton
            app.DeathsButton = uiradiobutton(app.DatatoplotButtonGroup);
            app.DeathsButton.Text = 'Deaths';
            app.DeathsButton.Position = [11 38 65 22];

            % Create BothButton
            app.BothButton = uiradiobutton(app.DatatoplotButtonGroup);
            app.BothButton.Text = 'Both';
            app.BothButton.Position = [11 16 65 22];

            % Create OptionButtonGroup
            app.OptionButtonGroup = uibuttongroup(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.OptionButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @OptionButtonGroupSelectionChanged, true);
            app.OptionButtonGroup.Title = 'Option';
            app.OptionButtonGroup.BackgroundColor = [0.7804 0.7608 0.7294];
            app.OptionButtonGroup.Position = [563 66 100 106];

            % Create CumulativeButton
            app.CumulativeButton = uiradiobutton(app.OptionButtonGroup);
            app.CumulativeButton.Text = 'Cumulative';
            app.CumulativeButton.Position = [11 60 82 22];
            app.CumulativeButton.Value = true;

            % Create DailyButton
            app.DailyButton = uiradiobutton(app.OptionButtonGroup);
            app.DailyButton.Text = 'Daily';
            app.DailyButton.Position = [11 38 65 22];

            % Create EditField
            app.EditField = uieditfield(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'text');
            app.EditField.ValueChangedFcn = createCallbackFcn(app, @EditFieldValueChanged, true);
            app.EditField.Position = [62 240 153 22];

            % Create EditField_2
            app.EditField_2 = uieditfield(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'text');
            app.EditField_2.ValueChangedFcn = createCallbackFcn(app, @EditField_2ValueChanged, true);
            app.EditField_2.Position = [258 240 153 22];

            % Create DefaultSettingButton
            app.DefaultSettingButton = uibutton(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'push');
            app.DefaultSettingButton.ButtonPushedFcn = createCallbackFcn(app, @DefaultSettingButtonPushed, true);
            app.DefaultSettingButton.BackgroundColor = [0.7804 0.7608 0.7294];
            app.DefaultSettingButton.Position = [422 29 91 22];
            app.DefaultSettingButton.Text = 'Default Setting';

            % Create OptionforcasesButtonGroup
            app.OptionforcasesButtonGroup = uibuttongroup(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.OptionforcasesButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @OptionforcasesButtonGroupSelectionChanged, true);
            app.OptionforcasesButtonGroup.Title = 'Option for cases';
            app.OptionforcasesButtonGroup.BackgroundColor = [0.7804 0.7608 0.7294];
            app.OptionforcasesButtonGroup.Position = [680 66 100 104];

            % Create BarchartButton
            app.BarchartButton = uiradiobutton(app.OptionforcasesButtonGroup);
            app.BarchartButton.Text = 'Bar chart';
            app.BarchartButton.Position = [11 58 71 22];
            app.BarchartButton.Value = true;

            % Create LinechartButton_2
            app.LinechartButton_2 = uiradiobutton(app.OptionforcasesButtonGroup);
            app.LinechartButton_2.Text = 'Line chart';
            app.LinechartButton_2.Position = [11 36 75 22];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure);
            app.TabGroup.Position = [1 284 814 424];

            % Create PlotTab
            app.PlotTab = uitab(app.TabGroup);
            app.PlotTab.Title = 'Plot';
            app.PlotTab.BackgroundColor = [0.6902 0.7686 0.8];

            % Create UIAxes
            app.UIAxes = uiaxes(app.PlotTab);
            title(app.UIAxes, 'Cumulative Number of Cases in Global')
            xlabel(app.UIAxes, 'Date(mm/dd)')
            ylabel(app.UIAxes, 'Cumulative Cases')
            app.UIAxes.PlotBoxAspectRatio = [2.67692307692308 1 1];
            app.UIAxes.XTickLabel = '';
            app.UIAxes.YTickLabel = '';
            app.UIAxes.BoxStyle = 'full';
            app.UIAxes.Clipping = 'off';
            app.UIAxes.Position = [21 1 774 389];

            % Create TextArea_3
            app.TextArea_3 = uitextarea(app.PlotTab);
            app.TextArea_3.FontSize = 14;
            app.TextArea_3.FontColor = [1 0 0];
            app.TextArea_3.Position = [266 155 284 80];
            app.TextArea_3.Value = {'At first click on Load Data Button to load covid_data.mat file and wait some seconds.'; 'You can also load updated covid_data.mat file frequently by clicking load data button.'};

            % Create StatisticsTab
            app.StatisticsTab = uitab(app.TabGroup);
            app.StatisticsTab.Title = 'Statistics';
            app.StatisticsTab.BackgroundColor = [0.6902 0.7686 0.8];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.StatisticsTab);
            title(app.UIAxes3, 'Title')
            ylabel(app.UIAxes3, 'Y')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.Position = [60 11 684 378];

            % Create TextArea_6
            app.TextArea_6 = uitextarea(app.StatisticsTab);
            app.TextArea_6.Position = [620 234 175 121];

            % Create TextArea_7
            app.TextArea_7 = uitextarea(app.StatisticsTab);
            app.TextArea_7.FontSize = 14;
            app.TextArea_7.FontColor = [1 0 0];
            app.TextArea_7.Position = [293 168 229 71];
            app.TextArea_7.Value = {'It works only for Daily Button. Click cases button for case data and deaths button for deaths data.'; ''};

            % Create HistogramsTab
            app.HistogramsTab = uitab(app.TabGroup);
            app.HistogramsTab.Title = 'Histograms';
            app.HistogramsTab.BackgroundColor = [0.6902 0.7686 0.8];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.HistogramsTab);
            app.UIAxes_2.PlotBoxAspectRatio = [2.67692307692308 1 1];
            app.UIAxes_2.XTick = [];
            app.UIAxes_2.XTickLabel = '';
            app.UIAxes_2.YTick = [];
            app.UIAxes_2.YTickLabel = '';
            app.UIAxes_2.BoxStyle = 'full';
            app.UIAxes_2.Position = [8 1 787 389];

            % Create TextArea_4
            app.TextArea_4 = uitextarea(app.HistogramsTab);
            app.TextArea_4.FontSize = 14;
            app.TextArea_4.FontColor = [1 0 0];
            app.TextArea_4.Position = [258 139 314 103];
            app.TextArea_4.Value = {'Here a bar chart is represented for Global and for those country which have states such as China, Canada, United States, United Kingdom.'; 'Click cases button for case data and deaths button for deaths data.'};

            % Create PieChartTab
            app.PieChartTab = uitab(app.TabGroup);
            app.PieChartTab.Title = 'Pie Chart';

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.PieChartTab);
            title(app.UIAxes4, 'Title')
            app.UIAxes4.XColor = [1 1 1];
            app.UIAxes4.XTick = [];
            app.UIAxes4.YColor = [1 1 1];
            app.UIAxes4.YTick = [];
            app.UIAxes4.Position = [21 11 758 378];

            % Create HeatMapTab
            app.HeatMapTab = uitab(app.TabGroup);
            app.HeatMapTab.Title = 'Heat Map';
            app.HeatMapTab.BackgroundColor = [0.6902 0.7686 0.8];

            % Create TextArea_5
            app.TextArea_5 = uitextarea(app.HeatMapTab);
            app.TextArea_5.FontSize = 14;
            app.TextArea_5.FontColor = [1 0 0];
            app.TextArea_5.Position = [288 155 238 93];
            app.TextArea_5.Value = {'Here a heat map is represented for Global and for those country which have states such as China, Canada, United States, United Kingdom.'; 'Maximize the app for better view.'};

            % Create DataTab
            app.DataTab = uitab(app.TabGroup);
            app.DataTab.Title = 'Data';
            app.DataTab.BackgroundColor = [0.502 0.502 0.502];

            % Create UITable
            app.UITable = uitable(app.DataTab);
            app.UITable.ColumnName = {'Country'; 'State'};
            app.UITable.RowName = {'Date'; 'Cumulative cases'};
            app.UITable.FontSize = 14;
            app.UITable.Position = [25 21 765 360];

            % Create GeographicPlotTab
            app.GeographicPlotTab = uitab(app.TabGroup);
            app.GeographicPlotTab.Title = 'Geographic Plot';
            app.GeographicPlotTab.BackgroundColor = [0.6902 0.7686 0.8];

            % Create TextArea_2
            app.TextArea_2 = uitextarea(app.GeographicPlotTab);
            app.TextArea_2.FontColor = [1 0 0];
            app.TextArea_2.Position = [182 149 450 92];
            app.TextArea_2.Value = {'The Geographic Plot is represented for Global & only for those country which have states such as China, Canada, United States, United Kingdom.'; 'Click cases button for case data and deaths button for deaths data.'; 'Here we use geobubble function for geographical plot. To learn more about geobuuble plot click '; 'For map you need internet connection.'};

            % Create Hyperlink
            app.Hyperlink = uihyperlink(app.GeographicPlotTab);
            app.Hyperlink.URL = 'https://www.mathworks.com/help/matlab/ref/geobubble.html';
            app.Hyperlink.Position = [296 165 91 22];
            app.Hyperlink.Text = {'geobubble plot'; ''};

            % Create Switch
            app.Switch = uiswitch(app.GeographicPlotTab, 'slider');
            app.Switch.Items = {'Norm', 'Max'};
            app.Switch.Orientation = 'vertical';
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.FontSize = 9.5;
            app.Switch.Position = [29 321 15 34];
            app.Switch.Value = 'Norm';

            % Create DeveloperInfoTab
            app.DeveloperInfoTab = uitab(app.TabGroup);
            app.DeveloperInfoTab.Title = 'Developer Info';
            app.DeveloperInfoTab.BackgroundColor = [0.6902 0.7686 0.8];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.DeveloperInfoTab);
            app.UIAxes2.XColor = [0 0 0];
            app.UIAxes2.XTick = [];
            app.UIAxes2.YColor = [0 0 0];
            app.UIAxes2.YTick = [];
            app.UIAxes2.Position = [91 69 246 269];

            % Create TextArea
            app.TextArea = uitextarea(app.DeveloperInfoTab);
            app.TextArea.FontSize = 12.5;
            app.TextArea.Position = [378 121 379 173];
            app.TextArea.Value = {'Name: Jewel Krishna Dash'; ''; 'Occupation: Student'; ''; 'University: Noakhali Science & Technology University, Noakhali'; ''; 'Department: Applied Mathematics'; ''; 'Country: Bangladesh'; ''; 'Home Town: Brahmanbaria, Chittagong'; ''; 'Email: jewelkrishnadash@gmail.com'};

            % Create DataSourceButton
            app.DataSourceButton = uibutton(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'push');
            app.DataSourceButton.ButtonPushedFcn = createCallbackFcn(app, @DataSourceButtonPushed, true);
            app.DataSourceButton.BackgroundColor = [0.7804 0.7608 0.7294];
            app.DataSourceButton.Position = [673 29 81 22];
            app.DataSourceButton.Text = 'Data Source';

            % Create AboutButton
            app.AboutButton = uibutton(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'push');
            app.AboutButton.ButtonPushedFcn = createCallbackFcn(app, @AboutButtonPushed, true);
            app.AboutButton.BackgroundColor = [0.7804 0.7608 0.7294];
            app.AboutButton.Position = [756 30 47 22];
            app.AboutButton.Text = 'About';

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.BackgroundColor = [0.7804 0.7608 0.7294];
            app.LoadDataButton.Position = [598 29 73 22];
            app.LoadDataButton.Text = 'Load Data';

            % Create SaveFigureButton
            app.SaveFigureButton = uibutton(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure, 'push');
            app.SaveFigureButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFigureButtonPushed, true);
            app.SaveFigureButton.BackgroundColor = [0.7804 0.7608 0.7294];
            app.SaveFigureButton.Position = [516 29 80 22];
            app.SaveFigureButton.Text = 'Save Figure';

            % Show the figure after all components are created
            app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Covid_data_analysis_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.COVID19DataVisualizationDatasourceJohnHopkinsUniversityUIFigure)
        end
    end
end