from pydub import AudioSegment
from pydub import silence
import numpy as np

def format_label(start, end, idx):
    s = f"{start / 1000}\t{end / 1000}\t{idx}"
    return s

def extract_syllables(in_file):
    audio = AudioSegment.from_wav(in_file)
    res = silence.detect_nonsilent(audio,silence_thresh=-43)
    return res

def create_trl(label_file):
    sample_rate = 2400
    labels = np.genfromtxt(label_file, delimiter='\t')
    pre_offset_ms = 400
    post_offset_ms = -10
    trl = np.zeros((labels.shape[0], 3),dtype=int)
    for i in range(labels.shape[0]):
        start_sec = labels[i,0]
        label_start_samp = start_sec * sample_rate
        trl_start = label_start_samp - (pre_offset_ms / 1000 * sample_rate)
        trl_end = label_start_samp + (post_offset_ms / 1000 * sample_rate)
        trig_offset = -1 * pre_offset_ms
        trl[i, 0] = trl_start
        trl[i, 1] = trl_end
        trl[i, 2] = trig_offset
    return trl