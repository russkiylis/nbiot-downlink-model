classdef testQPSK < matlab.unittest.TestCase
    
    methods (Test)

        % Проверка маппинга 00 -> (1+1i)/sqrt(2)
        function mod_00(testCase)
            modulator = NBIoTQPSK([0 0]);
            testCase.verifyEqual(modulator.modulatedBits, (1+1i)./sqrt(2));
        end

        % Проверка маппинга 01 -> (1-1i)/sqrt(2)
        function mod_01(testCase)
            modulator = NBIoTQPSK([0 1]);
            testCase.verifyEqual(modulator.modulatedBits, (1-1i)./sqrt(2));
        end

        % Проверка маппинга 10 -> (-1+1i)/sqrt(2)
        function mod_10(testCase)
            modulator = NBIoTQPSK([1 0]);
            testCase.verifyEqual(modulator.modulatedBits, (-1+1i)./sqrt(2));
        end

        % Проверка маппинга 11 -> (-1-1i)/sqrt(2)
        function mod_11(testCase)
            modulator = NBIoTQPSK([1 1]);
            testCase.verifyEqual(modulator.modulatedBits, (-1-1i)./sqrt(2));
        end

        % Проверка длины выходного вектора
        function mod_outputLength(testCase)
            bits = randi([0 1], 1, 100);
            modulator = NBIoTQPSK(bits);
            testCase.verifyEqual(length(modulator.modulatedBits), 50);
        end

        % Проверка единичной амплитуды всех символов
        function mod_unitAmplitude(testCase)
            bits = randi([0 1], 1, 1000);
            modulator = NBIoTQPSK(bits);
            testCase.verifyEqual(abs(modulator.modulatedBits), ones(1, 500), "AbsTol", 1e-10);
        end

        % Проверка ошибки при нечётном количестве битов
        function mod_oddBitsError(testCase)
            testCase.verifyError(@() NBIoTQPSK([0 1 0]), "");
        end

    end

    methods (TestClassSetup)
        
        function classSetup1(testCase)
            % Set up shared state for all tests.
            addpath(genpath('../'));
            % Tear down with testCase.addTeardown.
        end
        
    end
end