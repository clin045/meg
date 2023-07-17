from pydub import AudioSegment
from scipy.signal import correlate, decimate
import numpy as np
from matplotlib import pyplot as plt


def pydub_to_np(audio: AudioSegment):
    """
    Converts pydub audio segment into np.float32 of shape [duration_in_seconds*sample_rate, channels],
    where each value is in range [-1.0, 1.0]. 
    Returns tuple (audio_np_array, sample_rate).
    """
    return np.array(audio.get_array_of_samples(), dtype=np.float32).reshape((-1, audio.channels)) / (
            1 << (8 * audio.sample_width - 1)), audio.frame_rate

lofi_audio = AudioSegment.from_wav("data/audio/558CTL0505M_R-vannest-SRT_20190730_01.wav")
hifi_audio = AudioSegment.from_wav("qc_data/CTL_05_05M_SRT_30Jul2019.wav").set_frame_rate(lofi_audio.frame_rate)

lq_samples, lq_rate = pydub_to_np(lofi_audio)
hq_samples, hq_rate = pydub_to_np(hifi_audio)
print(f"Lq: {lq_samples.shape[0]}")
print(f"Hq: {hq_samples.shape[0]}")
corr = correlate(hq_samples, lq_samples)[:,0]
offset = corr.argmax() - lq_samples.shape[0] - 1

print(f"Samples offset: {offset}")
print(f"Seconds offset: {offset / lq_rate}")
