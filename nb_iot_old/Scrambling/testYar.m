function tests = testYar
    tests = functiontests(localfunctions);
end
function setup(testCase)
    testCase.TestData.data = randi([0 1], 1, 16);
    testCase.TestData.NNcellID = 489;
end

%setupOnce, teardownOnce
%function teardown(testCase)
%
%end
%results = runtests('testYar.m');
%rt = table(results)

%Тест проверяющий корректность конечного результата скремблирования
%Заранее заданы NNcellID и data
function testRes(testCase)
    s = Scrambler(testCase.TestData.NNcellID);
    ds = Scrambler(testCase.TestData.NNcellID);
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
end

%В случае нормальной длины циклического префикса (1920 бит) 
function testNormalLen(testCase)
    testCase.TestData.data = randi([0 1], 1, 1920);
    s = Scrambler(testCase.TestData.NNcellID);
    ds = Scrambler(testCase.TestData.NNcellID);
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
end

%В случае увеличенной длины циклического префикса (1728 бит) 
function testExtendedLen(testCase)
    testCase.TestData.data = randi([0 1], 1, 1728);
    s = Scrambler(testCase.TestData.NNcellID);
    ds = Scrambler(testCase.TestData.NNcellID);
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
end

%В случае увеличенной длины циклического префикса (1600 бит) 
function testNPBCHLen(testCase)
    testCase.TestData.data = randi([0 1], 1, 1728);
    s = Scrambler(testCase.TestData.NNcellID);
    ds = Scrambler(testCase.TestData.NNcellID);
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
end

%В случае многократного использования скремблера
function testRepeatedUse(testCase)
    s = Scrambler(testCase.TestData.NNcellID);
    ds = Scrambler(testCase.TestData.NNcellID);
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
    scrambled = s.scramble(testCase.TestData.data, 1);
    descrambled = ds.scramble(scrambled, 1);
    verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
end

%Проверка работы для каждого возможного NNCellID
function testAnotherNNCellID(testCase)
    for i = 0:503
        s = Scrambler(i);
        ds = Scrambler(i);
        scrambled = s.scramble(testCase.TestData.data, 1);
        descrambled = ds.scramble(scrambled, 1);
        verifyEqual(testCase,descrambled,testCase.TestData.data, ...
        'Начальная и дескремблированная последовательности не совпадают')
    end
end