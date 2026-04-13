/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { MetadataChangeEvent,
  PlaybackStateEvent,
  SessionCreateEvent, SessionDestroyEvent, TopSessionChangeEvent,
  ValidCommandChangeEvent } from './MediaEvent'
import { avSession } from '@kit.AVSessionKit'

/*
  媒体事件创造工厂，根据不同输入生产不同的媒体回调事件
  生产出的事件都继承MediaEvent，且有对应的专用事件回调
 */
export class MediaEventFactory {

  /*
    创建session create事件，需要输入创建session的descriptor
   */
  public static createSessionCreateEvent(descriptor: avSession.AVSessionDescriptor): SessionCreateEvent {
    return new SessionCreateEvent(descriptor.sessionId, descriptor);
  }

  /*
    创建session destroy事件，需要输入被销毁session的descriptor
   */
  public static createSessionDestroyEvent(descriptor: avSession.AVSessionDescriptor): SessionDestroyEvent {
    return new SessionDestroyEvent(descriptor.sessionId, descriptor);
  }

  /*
    创建top session change事件，需要输入变为top的session的descriptor
   */
  public static createTopSessionChangeEvent(descriptor: avSession.AVSessionDescriptor): TopSessionChangeEvent {
    return new TopSessionChangeEvent(descriptor.sessionId, descriptor);
  }

  /*
    创建metadata change事件，需要输入对应的sessionid，变化后全量metadata，和本次变化的key
   */
  public static createMetadataChangeEvent(sessionId: string, metadata: avSession.AVMetadata,
    updatedKeys: Array<string>): MetadataChangeEvent {
    return new MetadataChangeEvent(sessionId, metadata, updatedKeys);
  }

  /*
    创建playbackstate change事件，需要输入对应的sessionid，变化后全量playbackstate，和本次变化的key
   */
  public static createPlaybackStateEvent(sessionId: string, playbackState: avSession.AVPlaybackState,
    updatedKeys: Array<string>): PlaybackStateEvent {
    return new PlaybackStateEvent(sessionId, playbackState, updatedKeys);
  }

  /*
    创建validcommand change事件，需要输入对应的sessionid，变化后全量validcommand
   */
  public static createValidCommandEvent(sessionId: string,
    commands: Array<avSession.AVControlCommandType>): ValidCommandChangeEvent {
    return new ValidCommandChangeEvent(sessionId, commands);
  }
}