# NPDSCH scheduler review

## Summary
The `NBIoTNPDSCHScheduler` implements a basic, stateful NPDSCH codeword scheduler. It
scrambles and QPSK-modulates a codeword on demand, feeds symbols into NPDSCH
subframes, and repeats the same codeword for a configured number of repetitions
before moving to the next one. Overall, the flow is coherent for a simplified
model, but there are several mismatches with real NB‑IoT scheduling and
transmission details.

## What looks reasonable (for a simplified model)

- **Stateful codeword handling:**
  The scheduler keeps track of the current codeword, repetition count, and what
  remains to be mapped. When a subframe is generated, it returns the remaining
  modulated symbols and lets the subframe consume them. This matches a
  “streaming” model and is easy to reason about.

- **Repetition flow:**
  When a codeword is fully mapped (no remaining symbols), the repetition counter
  is incremented and the scheduler will restart the same codeword on the next
  NPDSCH subframe until the configured repetition count is reached. This is a
  sensible abstraction of NPDSCH repetition.

- **Scrambling + QPSK modulation pipeline:**
  The scheduler scrambles bits and then performs QPSK modulation, producing
  complex symbols for mapping into the resource grid. This aligns with the
  overall NB‑IoT physical-layer pipeline (scrambling → modulation).

## Gaps / mismatches vs. real NB‑IoT

1. **Scrambling initialization uses subframe index, not slot index.**
   The code sets `currentNS` as `2*(10*frame + subframe)` (slot number), but then
   `c_init` uses `floor(currentNS/2)` which reduces this back to a **subframe
   index**. If the implementation always starts a (re)transmission on a new
   subframe boundary and only uses even slot numbers (0, 2, 4, ...), then the
   subframe index is equivalent to the slot index for the start of each
   repetition and this formula can be consistent with that assumption. This
   should be documented as an explicit constraint (e.g., no mid-subframe start
   and only even-slot starts).

2. **Repetition count is artificially capped to 4.**
   The scheduler sets `currentMrep = min(Mrep, 4)`, which limits repetitions to
   4. If this constraint follows the applicable 3GPP guidance for the modeled
   mode, then the cap is acceptable and should be referenced in the model
   documentation; otherwise, it will under-represent higher repetition counts
   used in coverage-extension modes.

3. **No transport block / coding / rate matching.**
   The scheduler accepts “codeword bits” as-is, scrambles and modulates them, and
   maps them into the grid. In reality, NPDSCH requires channel coding (turbo in
   LTE, convolutional/other variants in NB‑IoT), rate matching to the
   allocation, and HARQ processes. None of these are present, so the scheduler
   does not reflect actual physical layer processing.

4. **No MCS / resource allocation logic.**
   Real NPDSCH scheduling depends on the MCS, the number of resource elements
   available in each scheduled subframe, and the NPDCCH grant. Here, the
   scheduler simply streams symbols until the resource grid is full, which is a
   simplified model but not accurate for a full NB‑IoT implementation. The
   missing pieces include: (a) deriving the transport block size from the MCS
   and number of subframes/REs, (b) rate matching to fit exactly in the
   allocated REs per subframe, and (c) aligning repetition counts and starting
   subframes with the scheduling grant.

5. **No handling of “holes” in NPDSCH subframe map.**
   The NPDSCH map in the grid decides which subframes carry NPDSCH, but the
   scheduler has no explicit awareness of gaps or timing between subframes. If
   gap handling is intentionally out of scope, it should be documented; for
   higher fidelity, the scheduler should model allowed subframe patterns and
   repetition timing per NB‑IoT scheduling rules.

## Recommendations for closer NB‑IoT compliance

- **Use slot number in scrambling initialization.**
  Replace `floor(currentNS/2)` in `c_init` with `currentNS` if the specification
  expects the slot index.

- **Remove or raise the repetition cap.**
  Allow repetitions up to the NB‑IoT range required by coverage extension.

- **Introduce coding and rate matching.**
  Add a coding stage and rate matching so that the number of modulated symbols
  matches the available REs per scheduled NPDSCH subframe.

- **Integrate with NPDCCH grant parameters.**
  The scheduler should be driven by grant parameters (allocation, MCS, number of
  repetitions) rather than only the local configuration.

- **Add unit tests for scheduler state transitions.**
  For example: validate that repetitions increment correctly and that the
  scheduler advances to the next codeword after the required number of repeats.

## Conclusion
The current scheduler is a consistent *simplified* streaming model and can be
used to visualize NPDSCH mapping. However, several key physical-layer details
are missing or approximated (scrambling index, repetition limits, coding/rate
matching). For any serious NB‑IoT fidelity, these gaps should be addressed.
