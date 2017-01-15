%CHROMOZOM 
%zabezpeèuje vytvorenie a ohodnotenie jedinca, selekciu, dedenie a mutáciu

classdef chromozom < handle
    properties
        %Parametre jedinca, toto¾né zo vstupom funkcie "hrany"
        sigma = 0;
        minimum = 0;
        klasifikator = 0;
        %Sila jedinca
        fitness = 0;
    end
    
    methods
    %-----Metódy-----    
        %Nastavenie poèiatocnych náhodných parametrov jedinca
        %vstupy funkcie urèujú maximálnu mo¾nú hranicu parametra
        function obj = chromozom(sigma_max, minimum_max, klasifikator_max)
            N = 1; %Poèet generácií náhodných èísel

            %Rozsahy generovaných hodnôt
            rozsah_sigma = [1.4 sigma_max];
            rozsah_minimum = [0 minimum_max];
            rozsah_klasifikator = [0 klasifikator_max];
            
            %Chromozómu priradím náhodné hodnoty z nastaveného intervalu
            %Minimum a klasifikator zaokrúhµujem
            obj.sigma = rand(N, 1) * range(rozsah_sigma) + min(rozsah_sigma);
            obj.minimum = round(rand(N, 1) * range(rozsah_minimum ) + min(rozsah_minimum));
            obj.klasifikator = round(rand(N, 1) * range(rozsah_klasifikator) + min(rozsah_klasifikator));
        end
        
        %Turnament dostane na vstupe dvohc jedincov
        %Silnej¹í, teda ten s väè¹ou fitness vyhráva
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
        
        %Dedenie na vstupe otca a matku nového jedinca
        %Hodnoty nového jedinca sú vypoèítané podµa vzorca
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
        %s rozdielom, ¾e parameter rozsah je pre ka¾dú èas» dedenia generovaný samostatne
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
        
        %Metóda mutácie jednotlivých èastí chormozómu, parameter urèuje
        %aká veµká bude zmena chromozómu po mutácií
        function mutacia(obj, parameter_mutacie)
            N = 1; %Poèet generácií náhodných èísel

            %Rozsahy generovaných hodnôt
            mutacia_sigma_min = (obj.sigma - (obj.sigma / parameter_mutacie));
            mutacia_sigma_max = (obj.sigma + (obj.sigma / parameter_mutacie));
            mutacia_sigma = [mutacia_sigma_min mutacia_sigma_max];
            
            mutacia_minimum_min = (obj.minimum - (obj.minimum / parameter_mutacie));
            mutacia_minimum_max = (obj.minimum + (obj.minimum / parameter_mutacie));
            mutacia_minimum = [mutacia_minimum_min mutacia_minimum_max];
            
            mutacia_klasifikator_min = (obj.klasifikator - (obj.klasifikator / parameter_mutacie));
            mutacia_klasifikator_max = (obj.klasifikator + (obj.klasifikator / parameter_mutacie));
            mutacia_klasifikator = [mutacia_klasifikator_min mutacia_klasifikator_max];
            
            %Chromozómu priradím náhodné hodnoty z nastaveného intervalu
            obj.sigma = rand(N, 1) * range(mutacia_sigma) + min(mutacia_sigma);
            obj.minimum = rand(N, 1) * range(mutacia_minimum) + min(mutacia_minimum);
            obj.minimum = round(obj.minimum);
            obj.klasifikator = round(rand(N, 1) * range(mutacia_klasifikator) + min(mutacia_klasifikator));
        end
        
        %Funkcia hrany, ktorá porovnáva trénovacie vzorky
        %Do funkcie vstupuje parameter vzorka a jedinec
        %Pokiaµ jedinec správne ohodnotí vzorku, zvý¹im jeho silu a naopak
        function hrany(obj, vzorka)
            %Vstupné parametre tried
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
            
            BW = edge(vz_image,'log', 0.0007, sigma); %hranová reprezentácia LOG
            BW = bwareaopen(BW, minimum); %odstránenie hrán men¹ích ako minimal
            
            nWhite = sum(BW(:)); %poèet pixelov hrán
            
            if nWhite > klasifikator %premenná urèuje, èi je analyzovaný výsek textúra alebo nie
               jetextura = 1; %obsahuje textúru
            else
               jetextura = 0; %neobsahuje textúru   
            end
            
            if jetextura == vz_pravda %ohodnotím chromozóm na základe trénovacích vzoriek
               obj.fitness = obj.fitness + 1;
            else
               obj.fitness = obj.fitness - 1;
            end 
        end
    %-----Metódy-----    
    end
end

