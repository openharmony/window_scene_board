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

import { avSession } from '@kit.AVSessionKit';

/*
  媒体事件基类
 */
export abstract class MediaEvent {
  // 事件对应所属session id
  public sessionId: string;

  constructor(sessionId: string) {
    this.sessionId = sessionId;
  }
}

/*
  session create事件，包含创建的session和对应descriptor
 */
export class SessionCreateEvent extends MediaEvent {
  public descriptor: avSession.AVSessionDescriptor;

  constructor(sessionId: string, descriptor: avSession.AVSessionDescriptor) {
    super(sessionId);
    this.descriptor = descriptor;
  }
}

/*
  session destroy事件，包含销毁的session和对应descriptor
 */
export class SessionDestroyEvent extends MediaEvent {
  public descriptor: avSession.AVSessionDescriptor;

  constructor(sessionId: string, descriptor: avSession.AVSessionDescriptor) {
    super(sessionId);
    this.descriptor = descriptor;
  }
}

/*
  top session change事件，包含对应的session和descriptor
 */
export class TopSessionChangeEvent extends MediaEvent {
  public descriptor: avSession.AVSessionDescriptor;

  constructor(sessionId: string, descriptor: avSession.AVSessionDescriptor) {
    super(sessionId);
    this.descriptor = descriptor;
  }
}

/*
  metadata change事件，包含对应的sessionid，metadata，和单次刷新的key
 */
export class MetadataChangeEvent extends MediaEvent {
  public metadata: avSession.AVMetadata;
  public updatedKeys: Array<string>;

  constructor(sessionId: string, metadata: avSession.AVMetadata, updatedKeys: Array<string>) {
    super(sessionId);
    this.metadata = metadata;
    this.updatedKeys = updatedKeys;
  }
}

/*
  playbackstate change事件，包含对应的sessionid，playbackstate，和单次刷新的key
 */
export class PlaybackStateEvent extends MediaEvent {
  public playbackState: avSession.AVPlaybackState;
  public updatedKeys: Array<string>;

  constructor(sessionId: string, playbackState: avSession.AVPlaybackState, updatedKeys: Array<string>) {
    super(sessionId);
    this.playbackState = playbackState;
    this.updatedKeys = updatedKeys;
  }
}

/*
  validcommand change事件，包含对应的sessionid和validcommand
 */
export class ValidCommandChangeEvent extends MediaEvent {
  public commands: Array<avSession.AVControlCommandType>;

  constructor(sessionId: string, commands: Array<avSession.AVControlCommandType>) {
    super(sessionId);
    this.commands = commands;
  }
}