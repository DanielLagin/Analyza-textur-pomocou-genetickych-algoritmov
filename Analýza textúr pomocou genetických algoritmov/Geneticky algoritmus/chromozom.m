%CHROMOZOM 
%zabezpe�uje vytvorenie a ohodnotenie jedinca, selekciu, dedenie a mut�ciu

classdef chromozom < handle
    properties
        %Parametre jedinca, toto�n� zo vstupom funkcie "hrany"
        sigma = 0;
        minimum = 0;
        klasifikator = 0;
        %Sila jedinca
        fitness = 0;
    end
    
    methods
    %-----Met�dy-----    
        %Nastavenie po�iatocnych n�hodn�ch parametrov jedinca
        %vstupy funkcie ur�uj� maxim�lnu mo�n� hranicu parametra
        function obj = chromozom(sigma_max, minimum_max, klasifikator_max)
            N = 1; %Po�et gener�ci� n�hodn�ch ��sel

            %Rozsahy generovan�ch hodn�t
            rozsah_sigma = [1.4 sigma_max];
            rozsah_minimum = [0 minimum_max];
            rozsah_klasifikator = [0 klasifikator_max];
            
            %Chromoz�mu prirad�m n�hodn� hodnoty z nastaven�ho intervalu
            %Minimum a klasifikator zaokr�h�ujem
            obj.sigma = rand(N, 1) * range(rozsah_sigma) + min(rozsah_sigma);
            obj.minimum = round(rand(N, 1) * range(rozsah_minimum ) + min(rozsah_minimum));
            obj.klasifikator = round(rand(N, 1) * range(rozsah_klasifikator) + min(rozsah_klasifikator));
        end
        
        %Turnament dostane na vstupe dvohc jedincov
        %Silnej��, teda ten s v��ou fitness vyhr�va
        function turnament(vitaz, super1, super2)
            super1_sila = super1.fitness;
            super2_sila = super2.fitness;
            
            super1_sigma = super1.sigma;
            super1_minimum = super1.minimum;
            super1_klasifikator = super1.klasifikator;
            
            super2_sigma = super2.sigma;
            super2_minimum = super2.minimum;
            super2_klasifikator = super2.klasifikator;
            
            if super1_sila > super2_sila
                vitaz.sigma = super1_sigma;
                vitaz.minimum = super1_minimum;
                vitaz.klasifikator = super1_klasifikator;
            else
                vitaz.sigma = super2_sigma;
                vitaz.minimum = super2_minimum;
                vitaz.klasifikator = super2_klasifikator;
            end
        end
        
        %Dedenie na vstupe otca a matku nov�ho jedinca
        %Hodnoty nov�ho jedinca s� vypo��tan� pod�a vzorca
        function dedenie(dieta, otec, matka)
            N = 1;
            
            otec_sigma = otec.sigma;
            otec_minimum = otec.minimum;
            otec_klasifikator = otec.klasifikator;
            
            matka_sigma = matka.sigma;
            matka_minimum = matka.minimum;
            matka_klasifikator = matka.klasifikator;
            
            rozsah = [0 1];
            rozsah_dedenie = rand(N, 1) * range(rozsah) + min(rozsah);
            
            dieta.sigma = (rozsah_dedenie * otec_sigma) + ((1 - rozsah_dedenie) * matka_sigma);
            dieta.minimum = round((rozsah_dedenie * otec_minimum) + ((1 - rozsah_dedenie) * matka_minimum)); 
            dieta.klasifikator = round((rozsah_dedenie * otec_klasifikator) + ((1 - rozsah_dedenie) * matka_klasifikator)); 
        end
        
        %Obdoba dedenia
        %s rozdielom, �e parameter rozsah je pre ka�d� �as� dedenia generovan� samostatne
        function dedenie1(dieta, otec, matka)
            N = 1;
            
            otec_sigma = otec.sigma;
            otec_minimum = otec.minimum;
            otec_klasifikator = otec.klasifikator;
            
            matka_sigma = matka.sigma;
            matka_minimum = matka.minimum;
            matka_klasifikator = matka.klasifikator;
            
            rozsah = [0 1];
            
            rozsah_dedenie = rand(N, 1) * range(rozsah) + min(rozsah);
            dieta.sigma = (rozsah_dedenie * otec_sigma) + ((1 - rozsah_dedenie) * matka_sigma);
            rozsah_dedenie = rand(N, 1) * range(rozsah) + min(rozsah);
            dieta.minimum = round((rozsah_dedenie * otec_minimum) + ((1 - rozsah_dedenie) * matka_minimum)); 
            rozsah_dedenie = rand(N, 1) * range(rozsah) + min(rozsah);
            dieta.klasifikator = round((rozsah_dedenie * otec_klasifikator) + ((1 - rozsah_dedenie) * matka_klasifikator)); 
        end
        
        %Met�da mut�cie jednotliv�ch �ast� chormoz�mu, parameter ur�uje
        %ak� ve�k� bude zmena chromoz�mu po mut�ci�
        function mutacia(obj, parameter_mutacie)
            N = 1; %Po�et gener�ci� n�hodn�ch ��sel

            %Rozsahy generovan�ch hodn�t
            mutacia_sigma_min = (obj.sigma - (obj.sigma / parameter_mutacie));
            mutacia_sigma_max = (obj.sigma + (obj.sigma / parameter_mutacie));
            mutacia_sigma = [mutacia_sigma_min mutacia_sigma_max];
            
            mutacia_minimum_min = (obj.minimum - (obj.minimum / parameter_mutacie));
            mutacia_minimum_max = (obj.minimum + (obj.minimum / parameter_mutacie));
            mutacia_minimum = [mutacia_minimum_min mutacia_minimum_max];
            
            mutacia_klasifikator_min = (obj.klasifikator - (obj.klasifikator / parameter_mutacie));
            mutacia_klasifikator_max = (obj.klasifikator + (obj.klasifikator / parameter_mutacie));
            mutacia_klasifikator = [mutacia_klasifikator_min mutacia_klasifikator_max];
            
            %Chromoz�mu prirad�m n�hodn� hodnoty z nastaven�ho intervalu
            obj.sigma = rand(N, 1) * range(mutacia_sigma) + min(mutacia_sigma);
            obj.minimum = rand(N, 1) * range(mutacia_minimum) + min(mutacia_minimum);
            obj.minimum = round(obj.minimum);
            obj.klasifikator = round(rand(N, 1) * range(mutacia_klasifikator) + min(mutacia_klasifikator));
        end
        
        %Funkcia hrany, ktor� porovn�va tr�novacie vzorky
        %Do funkcie vstupuje parameter vzorka a jedinec
        %Pokia� jedinec spr�vne ohodnot� vzorku, zv��im jeho silu a naopak
        function hrany(obj, vzorka)
            %Vstupn� parametre tried
            sigma = obj.sigma;
            minimum = obj.minimum;
            klasifikator = obj.klasifikator;
            
            vz_image = vzorka.vzorka;
            vz_pravda = vzorka.pravda;
            
            %Funkcia hrany
            dim = ndims(vz_image);
            if(dim == 3)
                vz_image = rgb2gray(vz_image);
            end
            
            BW = edge(vz_image,'log', 0.0007, sigma); %hranov� reprezent�cia LOG
            BW = bwareaopen(BW, minimum); %odstr�nenie hr�n men��ch ako minimal
            
            nWhite = sum(BW(:)); %po�et pixelov hr�n
            
            if nWhite > klasifikator %premenn� ur�uje, �i je analyzovan� v�sek text�ra alebo nie
               jetextura = 1; %obsahuje text�ru
            else
               jetextura = 0; %neobsahuje text�ru   
            end
            
            if jetextura == vz_pravda %ohodnot�m chromoz�m na z�klade tr�novac�ch vzoriek
               obj.fitness = obj.fitness + 1;
            else
               obj.fitness = obj.fitness - 1;
            end 
        end
    %-----Met�dy-----    
    end
end

