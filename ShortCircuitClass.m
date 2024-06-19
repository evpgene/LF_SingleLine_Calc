classdef ShortCircuitClass < handle
    %ShortCircuitClass Импеданс короткой сети
    %  Вычисляет импеданс короткой сети, приведённый ко вторичной стороне печного
    % трансформатора

    properties
        ZA
        ZB
        ZAmean
        ZBmean
    end

    methods
        function obj = ShortCircuitClass(SC_A,SC_B)
            %ShortCircuitClass - Конструирует экземпляр этого класса
            %   Вычисляет и сохраняет импеданс во внутренних переменных
            obj.ZA = transpose(complex(SC_A.R,SC_A.X));
            obj.ZB = transpose(complex(SC_B.R,SC_B.X));
            obj.ZAmean = mean(obj.ZA);
            obj.ZBmean = mean(obj.ZB);
        end

        function Z = getZ(obj,N)
            % Импеданс
            % Если номер позиции 2 - возвращает импеданс для позиции B,
            % иначе для позиции A
            switch N
                case 2
                    Z = obj.ZB;
                otherwise
                    Z = obj.ZA;
            end
        end
        function Z = getZmean(obj,N)
            % Импеданс средний по трем электродам
            % Если номер позиции 2 - возвращает средний по трем электродам импеданс для позиции B,
            % иначе для позиции A
            switch N
                case 2
                    Z = obj.ZBmean;
                otherwise
                    Z = obj.ZAmean;
            end
        end
    end
end
