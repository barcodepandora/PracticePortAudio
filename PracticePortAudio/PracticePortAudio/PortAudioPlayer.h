//
//  PortAudioPlayer.h
//  PracticePortAudio
//
//  Created by Juan Manuel Moreno on 21/08/24.
//

#ifndef PortAudioPlayer_h
#define PortAudioPlayer_h

//#import "portaudio.h"

#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface PortAudioPlayer: NSObject {
    ALCcontext *context;
    ALCdevice *device;
    ALuint source;
    ALuint buffer;
}

-(void)play:(NSString *)filePath;

@end

#endif /* PortAudioPlayer_h */
