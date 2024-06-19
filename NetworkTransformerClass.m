classdef NetworkTransformerClass < handle
    % Импеданс сетевого трансформатора
    %  Вычисляет импеданс сетевого трансформатора, приведённый ко вторичной стороне печного
    % трансформатора

    properties
        Z
        K
    end
    methods
        function obj = NetworkTransformerClass(NetworkTransformerData)
            obj.K = NetworkTransformerData.K;
            R = NetworkTransformerData.R1./obj.K.^2;
            X = NetworkTransformerData.X1./obj.K.^2;
            obj.Z = complex(R, X);
        end

        function Z = getZ(obj, N, K)
            % импеданс
            % вычисляет импеданс для заданной ступени и заданного
            % коэффициента трансформации печного трансформатора
            % N - ступень сетевого трансформатора
            % K - коэффициент трансформации печного трансформатора
            Z = obj.Z(N)/K^2;
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

        function U2 = getU2(obj,E1,N,I,K)
            % напряжение
            % Вычисляет напряжение на вторичной стороне при заданной ЭДС на
            % первичной стороне, заданной ступени и заданном коэффициенте
            % трансформации печного трансформатора
            U2 = getE2(E1,N) + I*obj.Z(N)/K^2;
        end

    end
end

