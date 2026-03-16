classdef testAll < matlab.unittest.TestCase

    properties
        filepath;
        folderName = "nb_iot";
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
        function testCrcCompare(testCase)
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
    
            fprintf('\n========== testCrcCompare ==========\n');
            fprintf('f1 (crc_16):      %.6f сек\n', t1);
            fprintf('f2 (obj.crc16):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end

    methods(Test)
        function testEncodingCompare(testCase)
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
    
            fprintf('\n========== testEncodingCompare ==========\n');
            fprintf('f1 (tbcc):      %.6f сек\n', t1);
            fprintf('f2 (obj.tail_coding):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end

    methods(Test)
        function testRatematchingCompare(testCase)
            arr = randi([0, 1], 3, 50);
            obj = NBIoTRateMatcher();
            res1 = selector([interleaver(arr(1,:)) ...
                interleaver(arr(2,:)) ...
                interleaver(arr(3,:))], 1600);
            res3 = obj.rate_match(arr);
            testCase.verifyEqual(res1, res3, 'Не совпадают');
            
            %Замер времени
            f1 = @() selector([interleaver(arr(1,:)) ...
                interleaver(arr(2,:)) ...
                interleaver(arr(3,:))], 1600);
            f2 = @() obj.rate_match(arr);
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testRatematchingCompare ==========\n');
            fprintf('f1 (selector):      %.6f сек\n', t1);
            fprintf('f2 (obj.rate_match):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testScramblingCompare(testCase)
            arr = randi([0 1], 1, 1600);
            NNcellID = 489;
            obj1 = Scrambler(NNcellID);
            obj2 = NBIoTScrambler(arr, NNcellID,"NPBCH");
            res1 = obj1.scramble(arr, 1);
            res2 = obj2.scrambledBits;
            %gold_seq = ltePRBS(NNcellID, 1600)';
            %res3 = mod(arr + gold_seq, 2);
            %testCase.verifyEqual(res2, res3, 'Не совпадают');
            testCase.verifyEqual(res1, res2, 'Не совпадают');
            
            %Замер времени
            f1 = @() Scrambler(NNcellID).scramble(arr, 1);
            f2 = @() NBIoTScrambler(arr, NNcellID,"NPBCH").scrambledBits;
    
            t1 = timeit(f1);
            t2 = timeit(f2);
    
            fprintf('\n========== testScramblingCompare ==========\n');
            fprintf('f1 (Scrambler):      %.6f сек\n', t1);
            fprintf('f2 (NBIoTScrambler):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
    methods(Test)
        function testQpskMatlab(testCase)
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
    
            fprintf('\n========== testQpskMatlab ==========\n');
            fprintf('f1 (MATLAB QPSK):      %.6f сек\n', t1);
            fprintf('f2 (NBIoTQPSK):   %.6f сек\n', t2);
            fprintf('Отношение f1/f2:  %.2f\n', t1/t2);
            fprintf('====================================\n');
        end
    end
end