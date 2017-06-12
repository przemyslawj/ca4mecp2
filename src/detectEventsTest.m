function tests = detectEventsTest
% Unit test for detect_events function
tests = functiontests(localfunctions);
end

function setupOnce(test_case)
test_case.TestData.vargs.stddev = 1;
test_case.TestData.vargs.min_duration = 2;
test_case.TestData.vargs.min_peak_distance = 1;
test_case.TestData.vargs.peak_base = 0.2; 
end

function testDetectsSinglePeak(test_case)
F = [1:5,fliplr(1:5)] - 5;
[event_bins, ~, peaks] = detectEvents(F, test_case.TestData.vargs);
expected_bins = zeros(1,10);
expected_bins(5) = 1;
expected_bins(6) = 1;
verifyEqual(test_case,event_bins,expected_bins)
verifyEqual(test_case,size(peaks), [1 1])
peak = peaks{1};
verifyEqual(test_case,peak(1).start_index,5)
verifyEqual(test_case,peak(1).end_index,6)
verifyEqual(test_case,peak(1).amplitude,0)
end

function testNoPeaksDetected(test_case)
F = zeros(1,10);
verifyEqual(test_case, detectEvents(F, test_case.TestData.vargs), zeros(1,10));
end

function testNoPeaksDetectedPeakTooShort(test_case)
F = cat(2, zeros(1,9), 1);
verifyEqual(test_case, detectEvents(F, test_case.TestData.vargs), zeros(1,10));
end
