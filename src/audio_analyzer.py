import numpy as np
import librosa
from scipy.fft import rfft, rfftfreq
from matplotlib import pyplot as plt
import seaborn as sns

class AudioAnalyzer:
    SAMPLE_RATE = 44100
    MAX_AMPLITUDE = 32767
    done_fft = False

    def __init__(self, path_to_file, **kwargs):
        self.path_to_file = path_to_file

        self.SAMPLE_RATE = kwargs.get("SAMPLE_RATE", self.SAMPLE_RATE)
        self.MAX_AMPLITUDE = kwargs.get("MAX_AMPLITUDE", self.MAX_AMPLITUDE)

        self.y, _ = librosa.load(self.path_to_file, sr=self.SAMPLE_RATE)
        self.x = np.linspace(0, self.y.size / self.SAMPLE_RATE, self.y.size, endpoint=False)

    def do_fft(self):
        if not self.done_fft:
            y_normalized = np.int16((self.y / self.y.max()) * self.MAX_AMPLITUDE)
            self.yf = rfft(y_normalized)
            self.xf = rfftfreq(y_normalized.size, 1/self.SAMPLE_RATE)

            self.max_freq = round(self.xf[self.yf.real.argmax()])
            self.done_fft = True

    def plot_audio_info(self):
        self.do_fft()

        sns.set_theme()
        fig, axes = plt.subplots(1, 2, figsize=(16, 9))

        plt.suptitle(f"{self.path_to_file}\nAudio File Information", 
                    fontsize=16, fontweight='bold')

        sns.lineplot(data={"Time" : self.x, "Amplitude" : self.y}, x="Time", y="Amplitude", ax=axes[0])

        sns.lineplot({"Frequences" : self.xf, "Amplitude" : np.abs(self.yf)}, x="Frequences", y="Amplitude", ax=axes[1])

        fig.text(0.9, 0.85, str(self.max_freq) + " Hz", fontsize=12, color='red', 
                bbox=dict(boxstyle='round', facecolor='yellow', alpha=0.5))

        plt.tight_layout()
        plt.show()
