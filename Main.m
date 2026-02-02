clear;

grid = NBIoTResourceGrid;
grid.Config.totalFrames = 2;
grid.Config.NCellID = 0;
grid.Config.startFrame = 0;

grid.GridGen();

grid.resourceGrid(1,1,2) = 2;
grid.resourceGrid(2,1,2) = 3;
grid.resourceGrid(3,1,2) = 4;
grid.resourceGrid(4,1,2) = 5;
grid.resourceGrid(5,1,2) = 6;
grid.resourceGrid(6,1,2) = 7;
grid.resourceGrid(7,1,2) = 8;

grid.showResourceGrid;
