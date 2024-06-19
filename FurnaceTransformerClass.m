classdef FurnaceTransformerClass < handle
    % Импеданс печного трансформатора
    %     %  Вычисляет импеданс печного трансформатора, приведённый ко вторичной стороне печного
    % трансформатора

    properties
        Z
        K
    end

    methods
        function obj = FurnaceTransformerClass(FurnaceTransformerData)
            %FurnaceTransformerClass - Конструирует экземпляр этого класса
            % Расчитывает эквивалентный импеданс печного трансформатора
            %  приведённый ко вторичной стороне на основе заданных данных
            % (FurnaceTransformerData)
            obj.K = FurnaceTransformerData.K;
            R = ...
                FurnaceTransformerData.R2 ...
                + FurnaceTransformerData.R1./obj.K.^2;
            X = ...
                FurnaceTransformerData.X2 ...
                + FurnaceTransformerData.X1./obj.K.^2;
            obj.Z = complex(R,X);

        end

        function Z = getZ(obj,N)
            % импеданс
            % возвращает значение импеданса печного трансформатора для заданного
            % положения переключателя ответвлений, приведенное ко вторичной стороне
            Z = obj.Z(N);
        end
        function K = getK(obj,N)
            % коэффициент трансформации
            % возвращает коэффициент трансформации печного трансформатора для заданного
            % положения переключателя ответвлений
            K = obj.K(N);
        end

        function E2 = getE2(obj,E1,N)
            % ЭДС
            % Вычисляет ЭДС на вторичной стороне при заданной ЭДС на
            % первичной стороне и заданной ступени
            E2 = E1/getK(obj,N);
        end
    end
end