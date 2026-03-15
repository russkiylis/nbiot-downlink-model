clear; clc;

grid = NBIoTResourceGrid;
grid.Config.Logging = true;
grid.Config.totalFrames = 20;
grid.Config.NCellID = 0;
grid.Config.startFrame = 0;
grid.Config.Bits.NPDSCH_Codeword{3}.bits = [ones(1,100) zeros(1,100)];
grid.Config.Bits.NPDSCH_Codeword{3}.Mrep = 1;
grid.Config.Bits.NPDCCH_DCI{4}.bits = ones(1,23);
grid.Config.Bits.NPDCCH_DCI{4}.type = 0;
grid.Config.Bits.NPDCCH_DCI{4}.Mrep = 1;

grid.GridGen();

grid.resourceGrid(1,1,2) = 2;
grid.resourceGrid(2,1,2) = 3;
grid.resourceGrid(3,1,2) = 4;
grid.resourceGrid(4,1,2) = 5;
grid.resourceGrid(5,1,2) = 6;
grid.resourceGrid(6,1,2) = 7;
grid.resourceGrid(7,1,2) = 8;

grid.showResourceGrid;
