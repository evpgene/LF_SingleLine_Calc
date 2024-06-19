classdef ParalellLoadClass < handle
    %ParalellLoadClass Импеданс параллельной нагрузки
    % Вычисляет импеданс параллельной нагрузки, такой, как параллельная печь, приведённый ко вторичной стороне печного
    % трансформатора

    properties
        Z
    end

    methods
        function obj = ParalellLoadClass(ParallelLoadData)
            %ParalellLoadClass - Конструирует экземпляр этого класса
            %   Вычисляет и сохраняет импеданс во внутренних переменных
            obj.Z = complex(ParallelLoadData.R1, ParallelLoadData.X1);
        end

        function Z = getZ(obj,  Ktr)
            % импеданс
            % вычисляет импеданс для заданной ступени и заданного
            % коэффициента трансформации печного трансформатора
            % N - ступень сетевого трансформатора
            % K - коэффициент трансформации печного трансформатора
            K= Ktr;
            Z = obj.Z/K^2;
        end
    end
end

