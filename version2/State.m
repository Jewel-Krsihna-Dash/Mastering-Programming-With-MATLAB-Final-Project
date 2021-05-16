classdef State < Country
    properties
        StateName
    end
    methods
        function obj = State(in)
            obj@Country(in);
            obj.StateName = obj.covidData(obj.CountryRows,2);
            obj.StateName{1} = 'All';
        end
    end
end