for i = 2:size(Global,1)
                    Cases(i-1,1) = Global{i,end}(1);
                    Deaths(i-1,1) = Global{i,end}(2);
                    Latitude(i-1,1) = Global{i,3};
                    Longitude(i-1,1) = Global{i,4};
                    Country(i-1,1) = string(Global{i,1}(1:end));
end
Country = categorical(Country);
geo_data = table(Country,Latitude,Longitude,Cases,Deaths);
geobubble(geo_data.Latitude,geo_data.Longitude,geo_data.Cases,geo_data.Country);