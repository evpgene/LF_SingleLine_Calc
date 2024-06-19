classdef NetworkTransformerClass < handle
    % �������� �������� ��������������
    %  ��������� �������� �������� ��������������, ���������� �� ��������� ������� �������
    % ��������������

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
            % ��������
            % ��������� �������� ��� �������� ������� � ���������
            % ������������ ������������� ������� ��������������
            % N - ������� �������� ��������������
            % K - ����������� ������������� ������� ��������������
            Z = obj.Z(N)/K^2;
        end

        function K = getK(obj,N)
            % ����������� �������������
            % ���������� ����������� ������������� ������� �������������� ��� ���������
            % ��������� ������������� �����������
            K = obj.K(N);
        end

        function E2 = getE2(obj,E1,N)
            % ���
            % ��������� ��� �� ��������� ������� ��� �������� ��� ��
            % ��������� ������� � �������� �������
            E2 = E1/getK(obj,N);
        end

        function U2 = getU2(obj,E1,N,I,K)
            % ����������
            % ��������� ���������� �� ��������� ������� ��� �������� ��� ��
            % ��������� �������, �������� ������� � �������� ������������
            % ������������� ������� ��������������
            U2 = getE2(E1,N) + I*obj.Z(N)/K^2;
        end

    end
end

