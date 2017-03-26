import scipy.io.wavfile
import pretty_midi
import argparse
import sys

if __name__ == '__main__':
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(
        description='Synthesize a MIDI file.',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('midi_file', action='store',
                        help='Path to the MIDI file to synthesize')
    parser.add_argument('output_file', action='store',
                        help='Path where the synthesized wav will be written')
    parser.add_argument('--sf', default=None, type=str, action='store',
                        help='Path to the soundfont file used for synthesis' )
    parser.add_argument('--fs', default=44100, type=int, action='store',
                        help='Output sampling rate to use')

    # Parse command line arguments
    parameters = vars(parser.parse_args(sys.argv[1:]))
    print "Synthesizing {} ...".format(parameters['midi_file'])
    # Load in MIDI data and synthesize using chiptunes_synthesize
    midi_object = pretty_midi.PrettyMIDI(parameters['midi_file'])
    synthesized = midi_object.fluidsynth(parameters['fs'], parameters['sf'])
    print "Writing {} ...".format(parameters['output_file'])
    # Write out
    scipy.io.wavfile.write(
        parameters['output_file'], parameters['fs'], synthesized)
