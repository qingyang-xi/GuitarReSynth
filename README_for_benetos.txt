AMT-PLCA-5D:
An efficient temporally-constrained probabilistic model for multiple-instrument music transcription

Copyright (c) 2015 Emmanouil Benetos and Tillman Weyde and Queen Mary University of London
emails: emmanouil.benetos@qmul.ac.uk, t.e.weyde@city.ac.uk

For licence information see the file named COPYING.

If you use this code, please cite the following paper:
E. Benetos and T. Weyde, "An efficient temporally-constrained probabilistic model for multiple-instrument music transcription", in Proc. 16th International Society for Music Information Retrieval Conference, Oct. 2015. 

===

Description: This code performs automatic music transcription for multiple-instrument music (supporting Western orchestral instruments). The output is a non-binary piano-roll representation which if post-processed (e.g. thresholded) can be used to derive a MIDI-like representation of the transcription. The present demo includes 3 sets of piano templates computed from isolated note samples from the MAPS database [i].

Environment: Tested on MATLAB 7.x 32/64 bit. 

Command line calling format: [pianoRoll] = transcription(filename,iter,S,sz,su,sh); - more info on transcription.m file

Example: [pianoRoll] = transcription('bcfho_mix.wav',50,3,1.0,1.0,1.0);

NOTE: This code includes VQT functions developed by C. Schorkhuber, A. Klapuri, N. Holighaus, and M. Dofler (http://www.cs.tut.fi/sgn/arg/CQT/).

===

[i] http://www.tsi.telecom-paristech.fr/aao/en/2010/07/08/maps-database-a-piano-database-for-multipitch-estimation-and-automatic-transcription-of-music/
