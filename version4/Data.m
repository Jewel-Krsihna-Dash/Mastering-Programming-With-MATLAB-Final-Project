classdef Data < State
    properties
        Date
    end
    methods
        function obj = Data(in,filename)
            obj@State(in,filename);
            obj.Date = obj.covidData(1,5:end);
        end
        function out = Cases_Vector(obj,inc)
            Cases = zeros(1,length(obj.Date));
            for ii = 5:length(obj.covidData(1,:))
                Cases(ii - 4) = obj.covidData{inc,ii}(1,1);
            end
            out = Cases;
        end
        function out = Deaths_Vector(obj,inc)
            Deaths = zeros(1,length(obj.Date));
            for ii = 5:length(obj.covidData(1,:))
                Deaths(ii - 4) = obj.covidData{inc,ii}(1,2);
            end
            out = Deaths;
        end
        function out = global_cases_and_deaths(obj)
            states = obj.covidData(:,2);
            global_cases = zeros(length(states),length(obj.Date));
            global_deaths = zeros(length(states),length(obj.Date));
            for ii = 1:length(states)
                if isempty(states{ii})
                    for jj = 5:length(obj.covidData(1,:))
                        global_cases(ii,jj-4) = obj.covidData{ii,jj}(1,1);
                    end
                    for kk = 5:length(obj.covidData(1,:))
                        global_deaths(ii,kk-4) = obj.covidData{ii,kk}(1,2);
                    end
                end
            end
            out = [sum(global_cases);sum(global_deaths)];
        end
    end
end