
load('Calculation_LF2_US.mat')

Calculation = SingleLineCalculationClass(NetworkTransformerData, ReactorData, FurnaceTransformerData, ParallelLoadData, SC_A, SC_B);

Npos = 1; % позиция обработки 1
Nre = 1; % ступень реактора (реактор отсутствует)

for EAF_On = 0:1
    switch EAF_On
        case 1
            ParallelLoadData.R1 = 9.48;
            ParallelLoadData.X1 = 9.48;
            EAF_On_txt = ', ДСП в работе';
        otherwise
            ParallelLoadData.R1 = 9999;
            ParallelLoadData.X1 = 9999;
            EAF_On_txt = ', ДСП не в работе';
    end

    for Nntr = 1:17
        Nntr_txt = strcat(', ступень сетевого трансформатора = ',string(Nntr));
        figsuffix_txt = strcat(Nntr_txt,EAF_On_txt);
        r = Calculation.compute(220000,Nre,Nntr,Npos,EAF_On,0.06);
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        figname_txt = 'Длина дуги ';
        fignamefull_txt = strcat(figname_txt,figsuffix_txt);

        % конструктор окна диаграммы
        f = figure("Name",figname_txt);
        % отключить строку меню
        f.MenuBar = "none";
        f.ToolBar = "none";
        %   отключить 'figure n' в ярлыке окна
        f.NumberTitle = "off";
        f.Position(3:4) = [1280 960];

        % построить график
        h = plot(abs(r.I2), real(r.Larc));
        % толщина линий
        set(h,LineWidth=1.25);

        % Размер шрифта
        fontsize(f,12,"points")
        % Заголовок и название осей
        title(fignamefull_txt,'FontSize',14)
        xlabel('Ток, [кА]')
        ylabel('Длина дуги, [мм]')
        % пределы отображения по осям
        xlim([0 100])
        ylim([0 200])
        % сетка
        grid on
        grid minor
        % легенда
        label = {'1' '2' '3' '4' '5' '6' '7' '8' '9'};
        legend(label,'Location','best');
        % сохранение результатов
        %saveas(f,'diagramtst.pdf')
        orient(f,'landscape')

        if (exist('Diagrams', 'dir')) ~= 7
            mkdir 'Diagrams';
        end
        printpath_txt = strcat('Diagrams\', fignamefull_txt);
        print(printpath_txt,'-dpdf','-fillpage');
        % деструктор окна диаграммы
        delete(f);
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        figname_txt = 'Мощность дуги';
        fignamefull_txt = strcat(figname_txt,figsuffix_txt);

        % конструктор окна диаграммы
        f = figure("Name",figname_txt);
        % отключить строку меню
        f.MenuBar = "none";
        f.ToolBar = "none";
        %   отключить 'figure n' в ярлыке окна
        f.NumberTitle = "off";
        f.Position(3:4) = [1280 960];

        % построить график
        h = plot(abs(r.I2), r.Parc);
        % толщина линий
        set(h,LineWidth=1.25);

        % Размер шрифта
        fontsize(f,12,"points")
        % Заголовок и название осей
        title(fignamefull_txt,'FontSize',14)
        xlabel('Ток, [кА]')
        ylabel('Мощность дуги, [МВт]')
        % пределы отображения по осям
        xlim([0 100])
        ylim([0 25])
        % сетка
        grid on
        grid minor
        % легенда
        label = {'1' '2' '3' '4' '5' '6' '7' '8' '9'};
        legend(label,'Location','best');
        % сохранение результатов
        %saveas(f,'diagramtst.pdf')
        orient(f,'landscape')

        if (exist('Diagrams', 'dir')) ~= 7
            mkdir 'Diagrams';
        end
        printpath_txt = strcat('Diagrams\', fignamefull_txt);
        print(printpath_txt,'-dpdf','-fillpage');
        % деструктор окна диаграммы
        delete(f);
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        figname_txt = 'Ток ';
        fignamefull_txt = strcat(figname_txt,figsuffix_txt);

        % конструктор окна диаграммы
        f = figure("Name",figname_txt);
        % отключить строку меню
        f.MenuBar = "none";
        f.ToolBar = "none";
        %   отключить 'figure n' в ярлыке окна
        f.NumberTitle = "off";
        f.Position(3:4) = [1280 960];

        % построить график
        h = plot(real(r.Z2_LV_tot), abs(r.I2));
        % толщина линий
        set(h,LineWidth=1.25);

        % Размер шрифта
        fontsize(f,12,"points")
        % Заголовок и название осей
        title(fignamefull_txt,'FontSize',14)
        xlabel('Импеданс, [Ом]')
        ylabel('Ток, [кА]')
        % пределы отображения по осям
        xlim([1 12])
        ylim([20 35])
        % сетка
        grid on
        grid minor
        % легенда
        label = {'1' '2' '3' '4' '5' '6' '7' '8' '9'};
        legend(label,'Location','best');
        % сохранение результатов
        %saveas(f,'diagramtst.pdf')
        orient(f,'landscape')

        if (exist('Diagrams', 'dir')) ~= 7
            mkdir 'Diagrams';
        end
        printpath_txt = strcat('Diagrams\', fignamefull_txt);
        print(printpath_txt,'-dpdf','-fillpage');
        % деструктор окна диаграммы
        delete(f);
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    end
end

