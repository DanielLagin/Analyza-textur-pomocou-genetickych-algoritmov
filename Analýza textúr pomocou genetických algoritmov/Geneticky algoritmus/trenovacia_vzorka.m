%TRENOVACIE_VZORKY zabezpe�uj� vytvorenie a ohodnotenie tr�novac�ch vstupov

classdef trenovacia_vzorka < handle    
    properties
        %Parametre tr�novacej vzorky
        vzorka
        pravda
    end
    
    methods
    %-----Met�dy----
        function obj = trenovacia_vzorka(image, jetextura)
            obj.vzorka = imread(image);
            obj.pravda = jetextura;
        end
    %-----Met�dy---- 
    end
end

