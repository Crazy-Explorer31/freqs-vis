import argparse
import sys
from src.audio_analyzer import AudioAnalyzer

SAMPLE_RATE = 44100
MAX_AMPLITUDE = 32767

def main(*args, **kwargs):
    path_to_file = kwargs["path_to_file"]

    audio_analyzer_ = AudioAnalyzer(path_to_file)
    audio_analyzer_.plot_audio_info()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Frequences visualization Argument Parser',
        usage='freqs-vis [OPTIONS]'
    )
    
    parser.add_argument('-p', '--path-to-file', 
                       help='Path to input audiofile')

    args = parser.parse_args()

    main(path_to_file = args.path_to_file)
