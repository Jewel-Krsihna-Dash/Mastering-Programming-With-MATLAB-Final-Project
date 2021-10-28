classdef Country
    properties
        covidData
        CountryName 
        CountryRows
    end
    methods
        function obj = Country(in,filename)     
            load(filename,'covid_data');
            obj.covidData = covid_data;
            obj.CountryName = covid_data(:,1);
            obj.CountryName{1} = 'Global';
            [~,n] = ismember(obj.CountryName,in);
            obj.CountryRows = find(n == 1);
        end
    end
end