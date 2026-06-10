/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { MediaEvent, MetadataChangeEvent,
  PlaybackStateEvent,
  SessionCreateEvent, SessionDestroyEvent,
  TopSessionChangeEvent,
  ValidCommandChangeEvent} from './MediaEvent';

/*
  媒体事件回调基类
 */
export abstract class MediaEventCallback {
  private callback: Function;

  constructor(callback: Function) {
    this.callback = callback;
  }

  /*
    触发回调
   */
  public onEventNotify(event: MediaEvent): void {
    if (this.callback) {
      this.callback(event);
    };
  }
}

/*
  avsession创建事件监听器，只处理session create事件
 */
export class SessionCreateCallback extends MediaEventCallback {
  constructor(callback: (event: SessionCreateEvent) => void) {
    super(callback);
  }

  /*
    触发回调，只处理session create事件
   */
  public onEventNotify(event: SessionCreateEvent): void {
    super.onEventNotify(event);
  }
}

/*
  avsession销毁事件监听器，只处理session destroy事件
 */
export class SessionDestroyCallback extends MediaEventCallback {
  constructor(callback: (event: SessionDestroyEvent) => void) {
    super(callback);
  }

  /*
    触发回调，只处理session destroy事件
   */
  public onEventNotify(event: SessionDestroyEvent): void {
    super.onEventNotify(event);
  }
}

/*
  topsession变化事件监听器，只处理top session change事件
 */
export class TopSessionChangeCallback extends MediaEventCallback {
  constructor(callback: (event: TopSessionChangeEvent) => void) {
    super(callback);
  }

  /*
    触发回调，只处理top session change事件
   */
  public onEventNotify(event: TopSessionChangeEvent): void {
    super.onEventNotify(event);
  }
}

/*
  metadata变化事件监听器，只处理metadata change事件
 */
export class MetadataChangeCallback extends MediaEventCallback {
  private sessionId: string;
  constructor(callback: (event: MetadataChangeEvent) => void, sessionId: string = '') {
    super(callback);
    this.sessionId = sessionId;
  }

  /*
    触发回调，只处理metadata change事件
   */
  public onEventNotify(event: MetadataChangeEvent): void {
    if (this.sessionId && this.sessionId !== event.sessionId) {
      return;
    }
    super.onEventNotify(event);
  }
}

/*
  playbackstate变化事件监听器，只处理playback state change事件
 */
export class PlaybackStateChangeCallback extends MediaEventCallback {
  private sessionId: string;
  constructor(callback: (event: PlaybackStateEvent) => void, sessionId: string = '') {
    super(callback);
    this.sessionId = sessionId;
  }

  /*
    触发回调，只处理playback state change事件
   */
  public onEventNotify(event: PlaybackStateEvent): void {
    if (this.sessionId && this.sessionId !== event.sessionId) {
      return;
    }
    super.onEventNotify(event);
  }
}

/*
  validcommand变化事件监听器，只处理valid command change事件
 */
export class ValidCommandChangeCallback extends MediaEventCallback {
  private sessionId: string;
  constructor(callback: (event: ValidCommandChangeEvent) => void, sessionId: string = '') {
    super(callback);
    this.sessionId = sessionId;
  }

  /*
    触发回调，只处理valid command change事件
   */
  public onEventNotify(event: ValidCommandChangeEvent): void {
    if (this.sessionId && this.sessionId !== event.sessionId) {
      return;
    }
    super.onEventNotify(event);
  }
}