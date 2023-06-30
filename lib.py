from pydub import AudioSegment
from pydub import silence

def format_label(start, end, idx):
    s = f"{start / 1000}\t{end / 1000}\t{idx}"
    return s

def extract_syllables(in_file):
    audio = AudioSegment.from_wav(in_file)
    res = silence.detect_nonsilent(audio,silence_thresh=-43)
    return res

