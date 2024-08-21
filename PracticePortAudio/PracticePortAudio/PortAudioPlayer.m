//
//  PortAudioPlayer.m
//  PracticePortAudio
//
//  Created by Juan Manuel Moreno on 21/08/24.
//

#import <Foundation/Foundation.h>
#import "PortAudioPlayer.h"

@implementation PortAudioPlayer {
    PaStream *stream;
    PaError err;
}

- (void)playFile:(NSString *)filePath {
    // Open the audio file
    FILE *file = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (!file) {
        NSLog(@"Error opening file: %@", filePath);
        return;
    }

    // Read the WAV file header
    char header[44];
    fread(header, 1, 44, file);

    // Get the audio format and parameters
    int numChannels = *(int *)(header + 22);
    int sampleRate = *(int *)(header + 24);
    int bitsPerSample = *(short *)(header + 34);
    int dataSize = *(int *)(header + 40);

    // Initialize PortAudio
    err = Pa_Initialize();
    if (err != paNoError) {
        NSLog(@"Error initializing PortAudio: %@", Pa_GetErrorText(err));
        return;
    }

    // Open the stream
    err = Pa_OpenDefaultStream(&stream, 0, numChannels, paInt16, sampleRate, 1024, NULL, NULL);
    if (err != paNoError) {
        NSLog(@"Error opening stream: %@", Pa_GetErrorText(err));
        return;
    }

    // Start the stream
    err = Pa_StartStream(stream);
    if (err != paNoError) {
        NSLog(@"Error starting stream: %@", Pa_GetErrorText(err));
        return;
    }

    // Read and play the audio data
    int16_t buffer[1024];
    int bytesRead;
    while ((bytesRead = fread(buffer, 2, 1024, file)) > 0) {
        err = Pa_WriteStream(stream, buffer, bytesRead / 2);
        if (err != paNoError) {
            NSLog(@"Error writing to stream: %@", Pa_GetErrorText(err));
            break;
        }
    }

    // Stop and close the stream
    err = Pa_StopStream(stream);
    if (err != paNoError) {
        NSLog(@"Error stopping stream: %@", Pa_GetErrorText(err));
    }

    err = Pa_CloseStream(stream);
    if (err != paNoError) {
        NSLog(@"Error closing stream: %@", Pa_GetErrorText(err));
    }

    // Terminate PortAudio
    err = Pa_Terminate();
    if (err != paNoError) {
        NSLog(@"Error terminating PortAudio: %@", Pa_GetErrorText(err));
    }

    fclose(file);
}

@end
