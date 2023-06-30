from pydub import AudioSegment
from pydub import silence

def format_label(start, end, idx):
    s = f"{start / 1000}\t{end / 1000}\t{idx}"
    return s

audio = AudioSegment.from_wav("data/audio/558CTL0505M_R-vannest-SRT_20190730_01.wav")
res = silence.detect_nonsilent(audio,silence_thresh=-43)

for idx, r in enumerate(res):
    print(r)
    label = format_label(r[0], r[1], idx)
    with open("test_label.txt", "a+") as f:
        f.write(f"{label}\n")
