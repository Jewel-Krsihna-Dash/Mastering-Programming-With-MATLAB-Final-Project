classdef State < Country
    properties
        StateName
    end
    methods
        function obj = State(in,filename)
            obj@Country(in,filename);
            obj.StateName = obj.covidData(obj.CountryRows,2);
            obj.StateName{1} = 'All';
        end
    end
end