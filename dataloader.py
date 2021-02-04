import numpy as np
import scipy.io as sio
import tensorflow as tf

def dataloader():
    path=u'DREAMER.mat'
    data=sio.loadmat(path)
    
    # 23명의 실험참여자가 18개의 비디오 클립을 시청하고, 128Hz로 60초간 14개의 채널로 측정한 RAW 데이터
    numOfSubjects = 23      # 실험 참여자 수
    numOfVideo = 18         # 시청한 비디오 클립 수
    numOfEEGChannel = 14    # EEG 측정 채널 수
    numOfECGChannel = 2     # ECG 측정 채널 수
    numOfCategory = 3       # 감성 분류 카테고리 수 (Valence, Arousal, Dominance)

    EEG_baseline = []
    EEG_stimuli = []
    ECG_baseline = []
    ECG_stimuli = []
    Labels = np.zeros((numOfCategory, numOfSubjects * numOfVideo))

    for iter_subject in range(0, numOfSubjects):
        for iter_video in range(0, numOfVideo):
            baseline_e = data['DREAMER'][0,0]['Data'][0,iter_subject]['EEG'][0,0]['baseline'][0,0][iter_video,0][:,:]
            stimuli_e  = data['DREAMER'][0,0]['Data'][0,iter_subject]['EEG'][0,0]['stimuli'][0,0][iter_video,0][-7808:,:]
            EEG_baseline.append(baseline_e)
            EEG_stimuli.append(stimuli_e)

            baseline_c = data['DREAMER'][0,0]['Data'][0,iter_subject]['ECG'][0,0]['baseline'][0,0][iter_video,0][:,:]
            stimuli_c = data['DREAMER'][0,0]['Data'][0,iter_subject]['ECG'][0,0]['stimuli'][0,0][iter_video,0][-15616:,:] 
            ECG_baseline.append(baseline_c)
            ECG_stimuli.append(stimuli_c)

        Labels[0].append(data['DREAMER'][0,0]['Data'][0,iter_subject]['ScoreValence'][0,0][:, 0])
        Labels[1].append(data['DREAMER'][0,0]['Data'][0,iter_subject]['ScoreArousal'][0,0][:,0])
        Labels[2].append(data['DREAMER'][0,0]['Data'][0,iter_subject]['ScoreDominance'][0,0][:,0])

    EEG_baseline = np.asarray(EEG_baseline)
    EEG_baseline = np.swapaxes(EEG_baseline, 1, 2)
    EEG_stimuli = np.asarray(EEG_stimuli)
    EEG_stimuli = np.swapaxes(EEG_stimuli, 1, 2)
    ECG_baseline = np.asarray(ECG_baseline)
    ECG_baseline = np.swapaxes(ECG_baseline, 1, 2)
    ECG_stimuli = np.asarray(ECG_stimuli)
    ECG_stimuli = np.swapaxes(ECG_stimuli, 1, 2)

    # Tensorflow 배열 타입으로 변형
    EEG_baseline = tf.convert_to_tensor(EEG_baseline, dtype=tf.float32)
    EEG_stimuli = tf.convert_to_tensor(EEG_stimuli, dtype=tf.float32)
    ECG_baseline = tf.convert_to_tensor(ECG_baseline, dtype=tf.float32)
    ECG_stimuli = tf.convert_to_tensor(ECG_stimuli, dtype=tf.float32)

    print(EEG_baseline.shape)           # 414, 14, 7808
    print(EEG_stimuli.shape)
    print(ECG_baseline.shape)
    print(ECG_stimuli.shape)
    print(Labels.shape)

    return EEG_baseline, EEG_stimuli, ECG_baseline, ECG_stimuli, Labels
