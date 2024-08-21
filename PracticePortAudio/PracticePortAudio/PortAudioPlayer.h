//
//  PortAudioPlayer.h
//  PracticePortAudio
//
//  Created by Juan Manuel Moreno on 21/08/24.
//

#ifndef PortAudioPlayer_h
#define PortAudioPlayer_h

#import "portaudio.h"

@interface PortAudioPlayer: NSObject

-(void)play:(NSString *)filePath;

@end

#endif /* PortAudioPlayer_h */
