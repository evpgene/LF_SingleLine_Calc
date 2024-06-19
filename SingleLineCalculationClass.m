classdef SingleLineCalculationClass < handle
    %SingleLineCalculationClass Однолинейный расчёт
    %   однолинейный расчёт электрического контура печи
    properties

        Rarc_max = 100; % проверить
        Npoints = 1000;
        NetworkTransformer
        Reactor
        FurnaceTransformer
        ShortCircuit
        ParallelLoad

        Ntap

    end

    methods
        function obj = SingleLineCalculationClass(NetworkTransformerData,ReactorData,FurnaceTransformerData,ParallelLoadData,SC_A, SC_B)
            %SingleLineCalculationClass Конструирует экземпляр этого класса
            %   Из заданных параметров - Создает экземпляры классов, представляющих импеданс и
            %   коэффициенты трансформации различных компонентов
            %   электрического контура печи.
            obj.NetworkTransformer = NetworkTransformerClass(NetworkTransformerData);
            obj.Reactor = ReactorClass(ReactorData);
            obj.FurnaceTransformer = FurnaceTransformerClass(FurnaceTransformerData);
            obj.ShortCircuit = ShortCircuitClass(SC_A, SC_B);
            obj.ParallelLoad = ParalellLoadClass(ParallelLoadData);
            obj.Ntap = size(FurnaceTransformerData,1);
        end

        function r = computeOneTap(obj, Uhv,Ntr, Nre,Nntr,Npos,parallelOn, THD)
            % вычисление для одной ступени печного трансформатора

            K = obj.FurnaceTransformer.getK(Ntr);

            Z2uptoMV_mean = obj.FurnaceTransformer.getZ(Ntr) + obj.Reactor.getZ(Nre,K) + ...
                obj.ShortCircuit.getZmean(Npos);  % импеданс пересчитанный ...
            % на вторичную сторону печного трансформатора исключая сетевой
            % трансформатор (до среднего напряжения)

            Z2uptoHV_mean = Z2uptoMV_mean + ...
                obj.NetworkTransformer.getZ(Nntr,K); % импеданс...
            % пересчитанный на вторичную сторону печного трансформатора включая сетевой ...
            % трансформатор (до высокого напряжения)

            if parallelOn
                Z2parallel = obj.ParallelLoad.getZ(obj.FurnaceTransformer.getK(Ntr));
            else
                Z2parallel = 999999999+999999999i;
            end
            Rarc =linspace(0, obj.Rarc_max,obj.Npoints); % заполняет массив с заданным шагом
            r.Zarc = complex(Rarc,Rarc.*THD);

            r.Z2_LV_tot = r.Zarc + obj.ShortCircuit.getZmean(Npos);
            r.Z2_MV_tot = r.Zarc + Z2uptoMV_mean;
            r.Z2_MV_tot_parallel = r.Z2_MV_tot * Z2parallel/(r.Z2_MV_tot + Z2parallel);


            r.Z2_HV_tot = r.Zarc + Z2uptoHV_mean;
            r.Z2_HV_tot_parallel =  r.Z2_MV_tot_parallel + obj.NetworkTransformer.getZ(Nntr,K);

            r.E2_ph = obj.FurnaceTransformer.getE2(obj.NetworkTransformer.getE2(Uhv,Nntr),Ntr)/sqrt(3);

            r.I2parallel = r.E2_ph./r.Z2_MV_tot_parallel;

            r.UMV = r.E2_ph - r.I2parallel*obj.NetworkTransformer.getZ(Nntr,K);


            r.I2 =r.UMV./r.Z2_MV_tot;

            r.Parc = abs(r.I2).^2.*real(r.Zarc)./1000.0*3.0;
            r.Sarc = r.I2.^2.*r.Zarc./1000.0*3.0;
            r.Uarc = r.I2.*real(r.Zarc);
            r.Larc =  r.Uarc-40.0;
            r.Ploss_MV = real(Z2uptoMV_mean)*abs(r.I2).^2.*3/1000;
            r.absI2 = abs(r.I2);
        end

        function r = compute(obj, Uhv, Nre,Nntr,Npos,parallelOn,THD)
            % вычисление для всех ступеней печного трансформатора
            r.Z2_LV_tot = zeros(obj.Npoints,obj.Ntap);
            r.Z2_MV_tot = zeros(obj.Npoints,obj.Ntap);
            r.Z2_HV_tot = zeros(obj.Npoints,obj.Ntap);
            r.U2_ph = zeros(1,obj.Ntap);
            r.I2  = zeros(obj.Npoints,obj.Ntap);
            r.Parc  = zeros(obj.Npoints,obj.Ntap);
            r.Sarc  = zeros(obj.Npoints,obj.Ntap);
            r.Uarc  = zeros(obj.Npoints,obj.Ntap);
            r.Larc  = zeros(obj.Npoints,obj.Ntap);
            r.Ploss_MV  = zeros(obj.Npoints,obj.Ntap);

            for i = 1:obj.Ntap
                tmp = computeOneTap(obj, Uhv,i, Nre,Nntr,Npos,parallelOn,THD);

                r.Z2_LV_tot(:,i) = transpose(tmp.Z2_LV_tot);
                r.Z2_MV_tot(:,i) = transpose(tmp.Z2_MV_tot);
                r.Z2_HV_tot(:,i) = transpose(tmp.Z2_HV_tot);
                %r.U2_ph(1,i) = transpose(tmp.U2_ph);
                r.UMV  = transpose(tmp.UMV);
                r.I2(:,i)  = transpose(tmp.I2);
                r.I2parallel(:,i)  = transpose(tmp.I2parallel);
                r.Z2_MV_tot_parallel = transpose(tmp.Z2_MV_tot_parallel);
                r.Zarc(:,i)  = transpose(tmp.Zarc);
                r.Parc(:,i)  = transpose(tmp.Parc);
                r.Sarc(:,i)  = transpose(tmp.Sarc);
                r.Uarc(:,i)  = transpose(tmp.Uarc);
                r.Larc(:,i)  = transpose(tmp.Larc);
                r.Ploss_MV(:,i)  = transpose(tmp.Ploss_MV);
            end
        end
    end
end

