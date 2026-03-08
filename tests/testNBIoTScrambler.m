classdef testNBIoTScrambler < matlab.unittest.TestCase

    methods (Test)

        % Проверка того, что скремблирование изменяет исходную последовательность
        function scramble_changesBits(testCase)
            bits = (square(1:1600, 50)+1)/2;
            NCellID = 504;

            scrambler = NBIoTScrambler(bits, NCellID, "NPBCH");

            testCase.verifyNotEqual(scrambler.scrambledBits, bits);
        end

        % Проверка того, что при дескремблировании вернётся исходная
        % последовательность
        function scramble_isReversible(testCase)
            bits = (square(1:1600, 50)+1)/2;
            NCellID = 504;

            scrambler = NBIoTScrambler(bits, NCellID, "NPBCH");
            descrambler = NBIoTScrambler(scrambler.scrambledBits, NCellID, "NPBCH");

            testCase.verifyEqual(descrambler.scrambledBits, bits);
        end

        % Проверка возврата исходной последовательности при рандомных
        % значениях
        function scramble_isReversible_random(testCase)
            bits = randi([0 1], 1, 1600);
            NCellID = randi([0 503]);

            scrambler = NBIoTScrambler(bits, NCellID, "NPBCH");
            descrambler = NBIoTScrambler(scrambler.scrambledBits, NCellID, "NPBCH");

            testCase.verifyEqual(descrambler.scrambledBits, bits);
        end

        % Проверка того, что разные NCellID дают разные скремблирующие последовательности
        function scramble_differentNCellID_differentResult(testCase)
            bits = randi([0 1], 1, 1600);

            scrambler1 = NBIoTScrambler(bits, 0,   "NPBCH");
            scrambler2 = NBIoTScrambler(bits, 504, "NPBCH");

            testCase.verifyNotEqual(scrambler1.scrambledBits, scrambler2.scrambledBits);
        end
        
        % Проверка того, что скремблирование улучшает АКФ
        function scramble_improvesACF(testCase)
            bits = (square(1:1600, 50)+1)/2;    % Заведомо отвратительная АКФ
            NCellID = 504;
        
            scrambler = NBIoTScrambler(bits, NCellID, "NPBCH");
        
            % Перевод в -1/+1
            bipolar_original  = 1 - 2.*bits;
            bipolar_scrambled = 1 - 2.*scrambler.scrambledBits;
        
            % Подсчёт боковых лепестков КФ (сдвиги 1..N-1)
            N = length(bits);
            lepestki_original  = zeros(1, N-1);
            lepestki_scrambled = zeros(1, N-1);
            for k = 1:N-1
                lepestki_original(k)  = abs(sum(bipolar_original  .* circshift(bipolar_original,  k)));
                lepestki_scrambled(k) = abs(sum(bipolar_scrambled .* circshift(bipolar_scrambled, k)));
            end
        
            % Максимальный боковой лепесток после скремблирования должен быть
            % значительно меньше, чем до него
            testCase.verifyLessThan(max(lepestki_scrambled), max(lepestki_original));
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