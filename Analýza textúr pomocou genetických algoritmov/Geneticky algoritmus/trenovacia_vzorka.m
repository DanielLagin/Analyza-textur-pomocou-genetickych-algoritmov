%TRENOVACIE_VZORKY zabezpeèujú vytvorenie a ohodnotenie trénovacích vstupov

classdef trenovacia_vzorka < handle    
    properties
        %Parametre trénovacej vzorky
        vzorka
        pravda
    end
    
    methods
    %-----Metódy----
        function obj = trenovacia_vzorka(image, jetextura)
            obj.vzorka = imread(image);
            obj.pravda = jetextura;
        end
    %-----Metódy---- 
    end
end

