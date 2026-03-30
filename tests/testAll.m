classdef testAll < matlab.unittest.TestCase

    %NB - Федора
    %LTE - Матлаб

    properties
        filepath;
        folderName = "nb_iot_old";
    end

    methods (TestClassSetup)
        function setup(testCase)
            testFolder = fileparts(mfilename('fullpath'));
            projectRoot = fileparts(testFolder);
            addpath(projectRoot);
            testCase.filepath = fullfile(projectRoot, testCase.folderName);
            addpath(genpath(testCase.filepath));
        end
    end

    methods (TestClassTeardown)
        function teardown(testCase)
            rmpath(genpath(testCase.filepath));
        end
    end

    methods(Test)
        function testCrcNB(testCase)
            arr = randi([0, 1], 1, 34);
            obj = NBIoTCRC();
            
            %Тестирование
            res1 = [arr crc_16(arr)];
            res2 = obj.crc16(arr);
            
            testCase.verifyEqual(res1, res2, 'Не совпадают');
            
            %Замер времени
            f1 = @() [arr crc_16(arr)];
            f2 = @() obj.crc16(arr);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testCrcNB ==========\n');
            fprintf('f1 (crc_16):      %.6f сек\n', t1);
            fprintf('f2 (obj.crc16):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end

    methods(Test)
        function testCrcML(testCase)
            arr = randi([0, 1], 1, 34);
            obj = NBIoTCRC();
            
            %Тестирование
            res1 = lteCRCEncode(arr,"16");
            res2 = obj.crc16(arr);
            
            testCase.verifyEqual(res1', int8(res2), 'Не совпадают');
            
            %Замер времени
            f1 = @() lteCRCEncode(arr,"16");
            f2 = @() obj.crc16(arr);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testCrcML ==========\n');
            fprintf('f1 (lteCRCEncode): %.6f сек\n', t1);
            fprintf('f2 (obj.crc16):    %.6f сек\n', t2);
            fprintf('Отношение f1/f2:   %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end

    methods(Test)
        function testEncodingML(testCase)
            arr = randi([0, 1], 1, 50);
            obj = NBIoTEncoding();
            
            %Тестирование
            res1 = lteConvolutionalEncode(arr);
            res2 = obj.tail_coding(arr)';
            testCase.verifyEqual(res1, int8(res2(:)), 'Не совпадают');
            
            %Замер времени
            f1 = @() lteConvolutionalEncode(arr);
            f2 = @() obj.tail_coding(arr);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testEncodingML ==========\n');
            fprintf('f1 (lteConvolutionalEncode): %.6f сек\n', t1);
            fprintf('f2 (obj.tail_coding):        %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end


    methods(Test)
        function testEncodingNB(testCase)
            arr = randi([0, 1], 1, 50);
            obj = NBIoTEncoding();
            p = [133 171 165];
            
            %Тестирование
            res1 = tbcc(arr, p);
            res2 = obj.tail_coding(arr);
            testCase.verifyEqual(res1, res2, 'Не совпадают');
            
            %Замер времени
            f1 = @() tbcc(arr, p);
            f2 = @() obj.tail_coding(arr);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testEncodingNB ==========\n');
            fprintf('f1 (tbcc):      %.6f сек\n', t1);
            fprintf('f2 (obj.tail_coding):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end

    methods(Test)
        function testRatematchingML(testCase)
            arr = randi([0, 1], 3, 50);
            arr2 = arr';
            arr2 = arr2(:);
            obj = NBIoTRateMatcher();
            
            res1 = lteRateMatchConvolutional(arr2, 1600);
            res2 = obj.rate_match(arr, 1600);
            testCase.verifyEqual(res1', res2, 'Не совпадают');
            
            %Замер времени
            f1 = @() lteRateMatchConvolutional(arr2, 1600);
            f2 = @() obj.rate_match(arr, 1600);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testRatematchingML ==========\n');
            fprintf('f1 (selector):      %.6f сек\n', t1);
            fprintf('f2 (obj.rate_match):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end

    methods(Test)
        function testRatematchingNB(testCase)
            arr = randi([0, 1], 3, 50);
            obj = NBIoTRateMatcher();
            res1 = selector([interleaver(arr(1,:)) ...
                interleaver(arr(2,:)) ...
                interleaver(arr(3,:))], 1600);
            res3 = obj.rate_match(arr, 1600);
            testCase.verifyEqual(res1, res3, 'Не совпадают');
            
            %Замер времени
            f1 = @() selector([interleaver(arr(1,:)) ...
                interleaver(arr(2,:)) ...
                interleaver(arr(3,:))], 1600);
            f2 = @() obj.rate_match(arr, 1600);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testRatematchingNB ==========\n');
            fprintf('f1 (selector):      %.6f сек\n', t1);
            fprintf('f2 (obj.rate_match):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testScramblingML(testCase)
            arr = randi([0 1], 1, 1600);
            NNcellID = 489;
            obj = NBIoTScrambler(arr, NNcellID,"NPBCH");
            res1 = obj.scrambledBits;
            gold_seq = ltePRBS(NNcellID, 1600)';
            res2 = mod(arr + gold_seq, 2);
            testCase.verifyEqual(res1, res2, 'Не совпадают');
            
            %Замер времени
            f1 = @() mod(arr + ltePRBS(NNcellID, 1600)', 2);
            f2 = @() NBIoTScrambler(arr, NNcellID,"NPBCH").scrambledBits;
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testScramblingML ==========\n');
            fprintf('f1 (LTE Scrambler):      %.6f сек\n', t1);
            fprintf('f2 (NBIoTScrambler):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testQpskML(testCase)
            arr = randi([0 1], 1, 1600);
            obj = NBIoTQPSK(arr);
            res1 = obj.modulatedBits;
            res2 = lteSymbolModulate(arr,"QPSK");
            testCase.verifyEqual(res1(:), res2(:), 'AbsTol', 1e-10, 'Не совпадают');
            
            %Замер времени
            f1 = @() NBIoTQPSK(arr).modulatedBits;
            f2 = @() lteSymbolModulate(arr,"QPSK");

            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testQpskML ==========\n');
            fprintf('f1 (MATLAB QPSK):      %.6f сек\n', t1);
            fprintf('f2 (NBIoTQPSK):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testNPSSML(testCase)
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
            grid.GridGen();
            frame = NBIoTFrame(grid, 0);
            subframe = NBIoTSubframe(frame, 0);
            res1 = gen_NPSS(subframe);
            res1_npss = res1(1:11, 4:14, 1);
            enb = struct('OperationMode', 'Standalone', 'NSubframe', 5);
            res2 = lteNPSS(enb);
            testCase.verifyEqual(res1_npss(:), res2(res2 ~= 0), 'AbsTol', 1e-10, 'Не совпадают');
            %Замер времени
            f1 = @() gen_NPSS(subframe);
            f2 = @() lteNPSS(enb);

            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testNPSSML ==========\n');
            fprintf('f1 (MATLAB NPSS): %.6f сек\n', t1);
            fprintf('f2 (NBIoT NPSS):  %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testNSSSML(testCase)
            grid = NBIoTResourceGrid;
            grid.Config.Logging = true;
            grid.Config.totalFrames = 3;
            grid.Config.NCellID = 100;
            grid.Config.startFrame = 0;
            grid.Config.Bits.NPDSCH_Codeword{3}.bits = [ones(1,100) zeros(1,100)];
            grid.Config.Bits.NPDSCH_Codeword{3}.Mrep = 1;
            grid.Config.Bits.NPDSCH_Codeword{3}.nSF = 10;
            grid.Config.Bits.NPDCCH_DCI{4}.bits = ones(1,23);
            grid.Config.Bits.NPDCCH_DCI{4}.type = 0;
            grid.Config.Bits.NPDCCH_DCI{4}.Mrep = 1;
            grid.GridGen();
            frame = NBIoTFrame(grid, 0);
            subframe = NBIoTSubframe(frame, 9);
            res1 = gen_NSSS(subframe);
            res1_nsss = res1(:, 4:14, 1);
            enb = struct();
            enb.OperationMode = 'Standalone';
            enb.NSubframe = 9;
            enb.NNCellID = 100;
            res2 = lteNSSS(enb);
            testCase.verifyEqual(conj(res1_nsss(:)), res2, 'AbsTol', 1e-10, 'Не совпадают');
            f1 = @() gen_NSSS(subframe);
            f2 = @() lteNSSS(enb);

            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testNSSSML ==========\n');
            fprintf('f1 (MATLAB NSSS): %.6f сек\n', t1);
            fprintf('f2 (NBIoT NSSS):  %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testNRSML(testCase)
            grid = NBIoTResourceGrid;
            grid.Config.Logging = true;
            grid.Config.totalFrames = 3;
            grid.Config.NCellID = 100;
            grid.Config.startFrame = 0;
            grid.Config.Bits.NPDSCH_Codeword{3}.bits = [ones(1,100) zeros(1,100)];
            grid.Config.Bits.NPDSCH_Codeword{3}.Mrep = 1;
            grid.Config.Bits.NPDSCH_Codeword{3}.nSF = 10;
            grid.Config.Bits.NPDCCH_DCI{4}.bits = ones(1,23);
            grid.Config.Bits.NPDCCH_DCI{4}.type = 0;
            grid.Config.Bits.NPDCCH_DCI{4}.Mrep = 1;
            grid.GridGen();
            frame = NBIoTFrame(grid, 0);
            subframe = NBIoTSubframe(frame, 0);
            res1 = gen_NRS(subframe);
            enb = struct('NNCellID', 100, 'NBRefP', 1, 'NSubframe', 0);
            res2 = lteNRS(enb);
            idx = lteNRSIndices(enb, 'sub');
            toolbox_grid = zeros(12, 14, 2);
            for i = 1:length(res2)
                toolbox_grid(idx(i,1)+1, idx(i,2)+1, idx(i,3)+1) = res2(i);  % ← было sym(i)
            end
            testCase.verifyEqual(res1(:,:,1), toolbox_grid(:,:,1), 'Не совпадают');
            f1 = @() gen_NRS(subframe);
            f2 = @() lteNRS(enb);

            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testNSSSML ==========\n');
            fprintf('f1 (MATLAB NRS): %.6f сек\n', t1);
            fprintf('f2 (NBIoT NRS):  %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
end