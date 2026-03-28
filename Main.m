clear; clc;

grid = NBIoTResourceGrid;
grid.Config.Logging = true;
grid.Config.totalFrames = 3;
grid.Config.NCellID = 300;
grid.Config.startFrame = 0;

grid.Config.Bits.NPDSCH_Codeword{3}.bits = [ones(1,100) zeros(1,100)];
grid.Config.Bits.NPDSCH_Codeword{3}.Mrep = 1;
grid.Config.Bits.NPDSCH_Codeword{3}.nSF = 10;
grid.Config.Bits.NPDCCH_DCI{4}.bits = ones(1,23);
grid.Config.Bits.NPDCCH_DCI{4}.type = 0;
grid.Config.Bits.NPDCCH_DCI{4}.Mrep = 1;

% Генерация
grid.GridGen();
grid.SignalGen();

% Вывод
grid.showResourceGrid();
grid.showSignal(1e6);
grid.showSpectr(1e6);
