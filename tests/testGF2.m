classdef testGF2 < matlab.unittest.TestCase
    
    methods (Test)
        % Test methods

        % Тест с одинаковыми
        function divide_equal(testCase)
            a = [1 0];   % 1
            b = [1 0 0];   % 1
            
            [res, rem] = GF2Pack.divide(a,b);
            
            testCase.verifyEqual(res, 1);
            testCase.verifyEqual(rem, 0);
        end
        
        % Обычный тест
        function divide_normalTest(testCase)
            a = [0 1 0 1 0 1]; % x5+x3+x
            b = [1 1 0 0 0 0]; % x+1
            
            [res, rem] = GF2Pack.divide(a,b);
            
            testCase.verifyEqual(res, [1 0 0 1 1])
            testCase.verifyEqual(rem, 1);
        end

        % Степень делителя сразу выше степени делимого
        function divide_higherDivider(testCase)
            a = [1 0 1];
            b = [1 0 1 1 1];

            [res, rem] = GF2Pack.divide(a,b);
            
            testCase.verifyEqual(res, 0)
            testCase.verifyEqual(rem, a);
        end
        
        % Деление на 1
        function divide_divideByOne(testCase)
            a = [0 1];
            b = 1;

            [res, rem] = GF2Pack.divide(a,b);
            
            testCase.verifyEqual(res, a)
            testCase.verifyEqual(rem, 0);
        end

        % Проверка стресстестом
        function divide_stressTest(testCase)
            for k = 1:10000
                a = randi([0 1], 1, 10000);
                b = randi([0 1], 1, 9999);
    
                [res, rem] = GF2Pack.divide(a,b);
                
                reconstructed = mod(mod(conv(res,b),2) + [rem zeros(1,length(res)+length(b)-1-length(rem))], 2);
                testCase.verifyEqual(EssentialsPack.zeroTrimmer(reconstructed,"last"), EssentialsPack.zeroTrimmer(a,"last"));
            end
        end
    end
end