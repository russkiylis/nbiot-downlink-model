classdef testEssentials < matlab.unittest.TestCase

    methods (Test)
        % Test methods
        
        % Проверка обрезки спереди
        function zeroTrimmer_first(testCase)
            v = [0 0 0 1 2 3 4 0 0 0 0];
            result = EssentialsPack.zeroTrimmer(v, "first");
            
            testCase.verifyEqual(result, [1 2 3 4 0 0 0 0]);
        end

        % Проверка обрезки сзади
        function zeroTrimmer_last(testCase)
            v = [0 0 0 1 2 3 4 0 0 0 0];
            result = EssentialsPack.zeroTrimmer(v, "last");
            
            testCase.verifyEqual(result, [0 0 0 1 2 3 4]);
        end
        
        % Проверка обрезки спереди и сзади
        function zeroTrimmer_both(testCase)
            v = [0 0 0 1 2 3 4 0 0 0 0];
            result = EssentialsPack.zeroTrimmer(v, "both");
            
            testCase.verifyEqual(result, [1 2 3 4]);
        end

        % Проверка неправильно введённого типа операции
        function zeroTrimmer_WrongOperationType(testCase)
            v = [1 2 3 4];
            
            testCase.verifyError(@() EssentialsPack.zeroTrimmer(v, "aaa"), "EssentialsPack:WrongZeroTrimmerOperationType");
        end

        % Проверка вектора без нулей
        function zeroTrimmer_noZeros(testCase)
            v = [1 2 3 4];
            result = EssentialsPack.zeroTrimmer(v, "both");
            
            testCase.verifyEqual(result, [1 2 3 4]);
        end

        % Проверка вектора только с нулями
        function zeroTrimmer_onlyZeros(testCase)
            v = [0 0 0 0];
            result = EssentialsPack.zeroTrimmer(v, "both");
            
            testCase.verifyEqual(result, []);
        end

        % Проверка на пустоту
        function zeroTrimmer_empty(testCase)
            v = [];

            testCase.verifyError(@() EssentialsPack.zeroTrimmer(v, "first"), "EssentialsPack:EmptyZeroTrimmerVector");
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