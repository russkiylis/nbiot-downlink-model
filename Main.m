clear;

grid = NBIoTResourceGrid;
grid.Config.totalFrames = 2;
grid.Config.NCellID = 0;
grid.Config.StartFrame = 0;

grid.GridGen;

grid.resourceGrid(1,1,2) = 2;
grid.resourceGrid(1,2,2) = 3;
grid.resourceGrid(1,3,2) = 4;
grid.resourceGrid(1,4,2) = 5;
grid.resourceGrid(1,5,2) = 6;
grid.resourceGrid(1,6,2) = 7;
grid.resourceGrid(1,7,2) = 8;

grid.showResourceGrid;
