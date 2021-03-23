% ========================== Cut-off Data =================================
% baseline : 눈 뜨고 15초, 눈 감고 15초 총 40초 잘라내기 → 대략 1분 20초
% stimuli : 앞 부분 5초, 뒷부분 2초 제거 → 대략 1분 8초 남는다.
% experimentTime : 실험 시간 (초 단위)
% restEnd : 휴식 종료 시간 (초 단위)
% cptStart : CPT 시작 시간 (초 단위)

% => subject1 : 김찬우
% subject = 1;
% experimentTime = [195, 190, 196, 195, 210, 195, 200, 195, 195, 205];
% restEnd =        [123, 121, 121, 120, 134, 120, 125, 120, 120, 130];
% cptStart =       [133, 128, 123, 120, 135, 123, 125, 130, 120, 137];

% => subject3 : 조윤혁
% subject = 3;
% experimentTime = [195, 195, 195, 195, 195, 195, 195, 195, 195, 195];
% restEnd =        [120, 120, 120, 120, 120, 117, 120, 120, 120, 120];
% cptStart =       [120, 125, 126, 120, 120, 126, 125, 126, 122, 120];

% => subject4 : 김인애
% subject = 4;
% experimentTime = [195, 195, 195, 195, 195, 195, 195, 195, 195, 195];
% restEnd =        [120, 120, 120, 120, 120, 120, 120, 120, 120, 120];
% cptStart =       [125, 124, 126, 124, 125, 125, 126, 125, 124, 124];

% => subject5 : 안이솔
% subject = 5;
% experimentTime = [195, 195, 195, 195, 193, 210, 195, 195, 196, 196];
% restEnd =        [120, 120, 120, 120, 120, 135, 120, 120, 121, 121];
% cptStart =       [122, 123, 122, 120, 120, 137, 122, 122, 121, 124];

% => subject6 : 김성윤
% subject = 6;
% experimentTime = [195, 195, 195, 195, 193, 195, 195, 195, 195, 195];
% restEnd =        [120, 120, 120, 120, 120, 122, 121, 122, 120, 120];
% cptStart =       [123, 123, 123, 123, 123, 128, 122, 124, 123, 122];

% => subject7 : 왕윤성
% subject = 7;
% experimentTime = [195, 195, 195, 195, 195, 195, 195, 195, 195, 195];
% restEnd =        [120, 120, 120, 122, 120, 120, 120, 121, 120, 120];
% cptStart =       [127, 124, 123, 125, 123, 123, 125, 124, 123, 124];

% => subject8 : 유종우
% subject = 8;
% experimentTime = [195, 195, 195, 195, 199, 195, 195, 195, 196, 197];
% restEnd =        [120, 120, 121, 121, 125, 121, 123, 120, 120, 122];
% cptStart =       [126, 125, 127, 128, 132, 127, 125, 126, 125, 127];

% => subject9 : 강범석
% subject = 9;
% experimentTime = [195, 195, 195, 195, 195, 195, 195, 195, 195, 195];
% restEnd =        [121, 121, 121, 120, 121, 121, 119, 114, 122, 120];
% cptStart =       [125, 124, 125, 125, 127, 125, 126, 125, 129, 126];

noOfSamples = 10;
SamplingRate_EEG = 128;      % Emotive EpocX Sampling Rate (Hz 단위)

load_path_EEG = "C:\\Users\\user\\Desktop\\Experiment Data\\EEG\\";
load_path_ECG = "C:\\Users\\user\\Desktop\\Experiment Data\\ECG\\";
save_path_EEG = "C:\\Users\\user\\Desktop\\data_preprocessed\\cutoff_preprocessed\\EEG\\";
save_path_ECG = "C:\\Users\\user\\Desktop\\data_preprocessed\\cutoff_preprocessed\\ECG\\";
% =========================================================================



for i = 1:noOfSamples
    fprintf('========= Sample %d of Subject %d =========\n',i,subject);
    fprintf('Total Experiment Time %d (s)\n', experimentTime(i));
    fprintf('CPT Start Time %d (s)\n', cptStart(i));
    fprintf('CPT Time %d (s)\n', experimentTime(i) - cptStart(i));
    
    % ========================= EEG ==================================
    fprintf('=> EEG\n');
    % Data load
    file_path = char(load_path_EEG + "s" + subject + "_" + i + ".csv");
    EEG_data = readtable(file_path,"VariableNamingRule","preserve");

    % Data Cut-off
    experimentTime(i) = experimentTime(i) * SamplingRate_EEG;
    exData = EEG_data{1:experimentTime(i), [1,4:17]};  % table 데이터를 matrix 데이터로 변경  
    cptStart(i) = cptStart(i) * SamplingRate_EEG;
    restEnd(i) = restEnd(i) * SamplingRate_EEG;
    stimuli_eeg = exData(cptStart(i):end, :);          % baseline
    baseline_eeg = exData(1:restEnd(i),:);             % stimuli

    baseline_eeg(1:5120, :) = [];                % 앞 부분 40초 제거
    stimuli_eeg([1:256, end-256:end], :) = [];   % 앞 부분 5초, 뒷 부분 2초 제거
    timeStamp_EEG = [baseline_eeg(1,1), baseline_eeg(end,1), stimuli_eeg(1,1), stimuli_eeg(end,1)]; %(s)단위
    
    baseline_eeg(:,1) = []; % time stamp 열 제거
    stimuli_eeg(:,1) = [];  % time stamp 열 제거
    
    fprintf('EEG baseline size :');
    disp(size(baseline_eeg));
    fprintf('EEG stimuli size :');
    disp(size(stimuli_eeg));

    % Save csv file
    filename = char(save_path_EEG + "baseline\\s" + subject + "_" + i + ".csv");
    writematrix(baseline_eeg, filename);
    filename = char(save_path_EEG + "stimuli\\s" + subject + "_" + i + ".csv");
    writematrix(stimuli_eeg, filename);
    
    
    
    % ========================= ECG ==================================
    fprintf('=> ECG\n');
    % Data load
    file_path = char(load_path_ECG + "s" + subject + "_" + i + ".csv");
    ECG_data = readtable(file_path,"VariableNamingRule","preserve");
    
    % Synchronize EEG, ECG time stamp
    timeStamp_ECG = [1,1,1,1];
    index = 1;
    ECG_timeIndex = [1,1,1,1];
    timeStamp = ECG_data{:,1}.';
    timeStamp = timeStamp./1000;
    previousTime = timeStamp(1);
    for time = timeStamp
        if previousTime <= timeStamp_EEG(1) && timeStamp_EEG(1) <= time
            timeStamp_ECG(1) = previousTime;
            ECG_timeIndex(1) = index;
        end
        if previousTime <= timeStamp_EEG(2) && timeStamp_EEG(2) <= time
            timeStamp_ECG(2) = previousTime;
            ECG_timeIndex(2) = index;
        end
        if previousTime <= timeStamp_EEG(3) && timeStamp_EEG(3) <= time
            timeStamp_ECG(3) = previousTime;
            ECG_timeIndex(3) = index;
        end
        if previousTime <= timeStamp_EEG(4) && timeStamp_EEG(4) <= time
            timeStamp_ECG(4) = previousTime;
            ECG_timeIndex(4) = index;
        end
        previousTime = time;
        index = index + 1;
    end

    % Data Cut-off
    baseline_ecg = ECG_data{ECG_timeIndex(1):ECG_timeIndex(2), 4:6};    % baseline
    stimuli_ecg = ECG_data{ECG_timeIndex(3):ECG_timeIndex(4), 4:6};     % stimuli
    
    fprintf('ECG baseline size :');
    disp(size(baseline_ecg));
    fprintf('ECG stimuli size :');
    disp(size(stimuli_ecg));

    % Save csv file
    filename = char(save_path_ECG + "baseline\\s" + subject + "_" + i + ".csv");
    writematrix(baseline_ecg, filename);
    filename = char(save_path_ECG + "stimuli\\s" + subject + "_" + i + ".csv");
    writematrix(stimuli_ecg, filename);
end
