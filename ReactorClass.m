classdef ReactorClass < handle
    %ReactorClass - Импеданс реактора
    % Вычисляет импеданс реактора, приведённый ко вторичной стороне печного
    % трансформатора

    properties
        Z
    end

    methods
        function obj = ReactorClass(ReactorData)
            %ShortCircuitClass - Конструирует экземпляр этого класса
            %   Вычисляет и сохраняет импеданс во внутренних переменных
            R = ReactorData.R;
            X = ReactorData.X;
            obj.Z = complex(R,X);
        end

        function Z = getZ(obj,N,K)
            % импеданс низкого напряжения
            % пересчитывает импеданс для заданной ступени реактора и заданного
            % коэффициента трансформации печного трансформатора
            % N - ступень реактора
            % K - коэффициент трансформации печного трансформатора
            Z = obj.Z(N)/K^2;
        end
    end
end