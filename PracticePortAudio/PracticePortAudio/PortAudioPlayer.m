//
//  PortAudioPlayer.m
//  PracticePortAudio
//
//  Created by Juan Manuel Moreno on 21/08/24.
//

#import <Foundation/Foundation.h>
#import "PortAudioPlayer.h"

//@implementation PortAudioPlayer {
//    PaStream *stream;
//    PaError err;
//}

@implementation PortAudioPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize OpenAL
        device = alcOpenDevice(NULL); // Open default device
        context = alcCreateContext(device, NULL); // Create context
        alcMakeContextCurrent(context); // Set the context
    }
    return self;
}
-(void)play:(NSString *)filePath {
    // Load the audio file
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AudioFileID audioFile;
    OSStatus result = AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, 0, &audioFile);
    if (result != noErr) {
        NSLog(@"Cannot open file: %@", filePath);
        return;
    }
    
    // Get the audio file's data format
    AudioStreamBasicDescription fileFormat;
    UInt32 propertySize = sizeof(fileFormat);
    AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);

    // Get the audio data size
    UInt64 audioDataSize = 0;
    UInt32 propertySize2 = sizeof(audioDataSize);
    AudioFileGetProperty(audioFile, kAudioFilePropertyAudioDataByteCount, &propertySize2, &audioDataSize);

    // Allocate memory to store the audio data
    void *audioData = malloc(audioDataSize);

    // Read the audio data into memory
    UInt32 bytesRead = (UInt32)audioDataSize;
    AudioFileReadBytes(audioFile, false, 0, &bytesRead, audioData);
    
    // Close the audio file
    AudioFileClose(audioFile);

    // Generate a buffer and load the audio data into it
    alGenBuffers(1, &buffer);
    ALenum format = (fileFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO16 : AL_FORMAT_STEREO16;
    alBufferData(buffer, format, audioData, (ALsizei)audioDataSize, fileFormat.mSampleRate);
    
    // Generate a source and attach the buffer to it
    alGenSources(1, &source);
    alSourcei(source, AL_BUFFER, buffer);
    
    // Play the audio
    alSourcePlay(source);
    
    // Free the memory used for the audio data
    free(audioData);
    
    // Check for errors
    ALenum error = alGetError();
    if (error != AL_NO_ERROR) {
        NSLog(@"OpenAL error: %x", error);
    }
}

- (void)dealloc {
    // Clean up OpenAL
    alDeleteSources(1, &source);
    alDeleteBuffers(1, &buffer);
    alcDestroyContext(context);
    alcCloseDevice(device);
}

     // Open the audio file
//    FILE *file = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
//    if (!file) {
//        NSLog(@"Error opening file: %@", filePath);
//        return;
//    }
//
//    // Read the WAV file header
//    char header[44];
//    fread(header, 1, 44, file);
//
//    // Get the audio format and parameters
//    int numChannels = *(int *)(header + 22);
//    int sampleRate = *(int *)(header + 24);
//    int bitsPerSample = *(short *)(header + 34);
//    int dataSize = *(int *)(header + 40);
//
//    // Initialize PortAudio
//    err = Pa_Initialize();
//    if (err != paNoError) {
//        NSLog(@"Error initializing PortAudio: %@", Pa_GetErrorText(err));
//        return;
//    }
//
//    // Open the stream
//    err = Pa_OpenDefaultStream(&stream, 0, numChannels, paInt16, sampleRate, 1024, NULL, NULL);
//    if (err != paNoError) {
//        NSLog(@"Error opening stream: %@", Pa_GetErrorText(err));
//        return;
//    }
//
//    // Start the stream
//    err = Pa_StartStream(stream);
//    if (err != paNoError) {
//        NSLog(@"Error starting stream: %@", Pa_GetErrorText(err));
//        return;
//    }
//
//    // Read and play the audio data
//    int16_t buffer[1024];
//    int bytesRead;
//    while ((bytesRead = fread(buffer, 2, 1024, file)) > 0) {
//        err = Pa_WriteStream(stream, buffer, bytesRead / 2);
//        if (err != paNoError) {
//            NSLog(@"Error writing to stream: %@", Pa_GetErrorText(err));
//            break;
//        }
//    }
//
//    // Stop and close the stream
//    err = Pa_StopStream(stream);
//    if (err != paNoError) {
//        NSLog(@"Error stopping stream: %@", Pa_GetErrorText(err));
//    }
//
//    err = Pa_CloseStream(stream);
//    if (err != paNoError) {
//        NSLog(@"Error closing stream: %@", Pa_GetErrorText(err));
//    }
//
//    // Terminate PortAudio
//    err = Pa_Terminate();
//    if (err != paNoError) {
//        NSLog(@"Error terminating PortAudio: %@", Pa_GetErrorText(err));
//    }
//
//    fclose(file);

@end
