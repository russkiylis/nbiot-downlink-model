# Предложения по единообразию имён

Ниже — список **предложений** по переименованию переменных/полей для единообразия.
Переименования не применены в коде автоматически, чтобы не ломать совместимость.

## Общие рекомендации
- Использовать единый стиль для аббревиатур: `NCellID`, `RNTI`, `NPDSCH` и т.п.
- Для логических флагов — префиксы `is`, `has`, `should`.
- Для индексов/счётчиков — суффиксы `Index`, `Id`, `Count`.
- Для временных/рабочих массивов — осмысленные имена вместо `d_`, `d__`, `a`.

## Конкретные предложения

### NBIoTResourceGrid
- `GridGenerated` → `isGridGenerated` (флаг).
- `NRS_shift` → `nrsShift` или `nrsShiftIndex` (единообразие camelCase).
- `default_NPDSCH_map` → `defaultNPDSCHMap`.
- `default_NPDCCH_map` → `defaultNPDCCHMap`.
- `default_cw1_rep`, `default_cw2_rep` → `defaultCw1Reps`, `defaultCw2Reps`.

### NBIoTFrame
- `frameID` → `frameId`.
- `subframesInFrame` → `subframesPerFrame`.
- `bitsToMap` → `mappedBits` или `bitsForMapping`.
- `cf` → `scramblingSequence` (чтобы не забыть через год, что это).
- `y` → `npbchSymbols` или `npbchModulated`.
- `yf` → `npbchBitsForFrame`.

### NBIoTSubframe
- `subframeID` → `subframeId`.
- `subframeType` → `subframeKind` или `type` (если не пересекается).
- `symbolsInSlot` → `ofdmSymbolsPerSlot`.
- `symbolsInSubframe` → `ofdmSymbolsPerSubframe`.
- `subframeGrid` → `grid` (если не конфликтует по смыслу).

### NBIoTNPDSCHScheduler
- `CW` → `codewords`.
- `currentNS` → `currentSlotIndex` (или `currentNs` с пояснением в комментарии).
- `currentCWID` → `currentCodewordId`.
- `currentMrep` → `currentRepetitionTarget`.
- `currentRepCount` → `currentRepetitionCount`.
- `currentModulatedCWRemain` → `remainingSymbols`.

### NBIoTScrambler
- `c_init` → `cInit`.
- `signal_type` → `signalType`.
- `scramblingSequence` можно оставить, но добавить комментарий о длине и назначении.

### NBIoTQPSK
- `modulatedBits` → `modulatedSymbols` (это комплексные символы, не биты).
- `a` → `symbolIndex`.

### gen_NSSS / gen_NPSS
- `d_`, `d__` → `sequenceMatrix`, `sequenceShifted`.
- `cusochek` → `chunk`.
- `n_` → `nMod`.

## Как применять
1. Начать с одного класса (например, `NBIoTNPDSCHScheduler`).
2. Переименовать поля/переменные и поправить все ссылки через `rg`.
3. Запускать простые сценарии (`Main.m`) после каждого набора правок.
