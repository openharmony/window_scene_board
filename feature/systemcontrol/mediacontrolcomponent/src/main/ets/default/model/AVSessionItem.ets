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

import AVSessionManager from '@ohos.multimedia.avsession';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { MediaEventFactory } from '../EventBus/MediaEventFactory';
import { MediaEventManager, MediaEventType } from '../EventBus/MediaEventManager';

const TAG = 'AVSessionItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

type PlaybackStateCallback = (state: AVSessionManager.AVPlaybackState) => void;
type MetadataCallback = (data: AVSessionManager.AVMetadata) => void;
type ValidCommandCallback = (commands: Array<AVSessionManager.AVControlCommandType>) => void;

/*
  单个avsession交互与数据储存
 */
export class AVSessionItem {
  /*
    session整体信息
   */
  private sessionId: string;
  private tempSessionId: string;
  private controller: AVSessionManager.AVSessionController | undefined;
  private descriptor: AVSessionManager.AVSessionDescriptor;

  /*
    回调信息
   */
  private playbackStateCallback: PlaybackStateCallback | undefined;
  private metadataCallback: MetadataCallback | undefined;
  private validCommandCallback: ValidCommandCallback | undefined;

  /*
    基础数据信息
   */
  private playbackState: AVSessionManager.AVPlaybackState | undefined;
  private metadata: AVSessionManager.AVMetadata | undefined;
  private validCommand: Array<AVSessionManager.AVControlCommandType> | undefined;


  /**
   * 创建AVSessionItem实例
   *
   * @param sessionId 对应id
   * @returns AVSessionItem实例
   */
  public static async createAVSessionItem(descriptor: AVSessionManager.AVSessionDescriptor): Promise<AVSessionItem> {
    let item = new AVSessionItem(descriptor);
    await item.init();
    return item;
  }

  private constructor(descriptor: AVSessionManager.AVSessionDescriptor) {
    this.descriptor = descriptor;
    this.sessionId = descriptor.sessionId;
    this.tempSessionId = descriptor.sessionId?.length < 10 ? '' : (descriptor.sessionId?.substr(0, 5) +
      '**' + descriptor.sessionId?.substr(descriptor.sessionId?.length - 5))
  }

  private async init() {
    log.showInfo(`create ${this.tempSessionId}`);
    this.controller = await AVSessionManager.createController(this.sessionId);
    this.controller.on('playbackStateChange', 'all', this.getPlaybackStateCallback());
    this.controller.on('metadataChange', 'all', this.getMetadataCallback());
    this.controller.on('validCommandChange', this.getValidCommandCallback());
  }

  public release() {
    log.showInfo(`release ${this.tempSessionId}`);
    this.controller?.off('playbackStateChange', this.getPlaybackStateCallback());
    this.controller?.off('metadataChange', this.getMetadataCallback());
    this.controller?.off('validCommandChange', this.getValidCommandCallback());
  }

  private getPlaybackStateCallback(): PlaybackStateCallback {
    if (!this.playbackStateCallback) {
      log.info(`getPlaybackStateCallback create new one for ${this.tempSessionId}`);
      this.playbackStateCallback = (playbackState: AVSessionManager.AVPlaybackState) => {
        this.updatePlaybackState(playbackState);
      }
    }
    return this.playbackStateCallback;
  }

  private updatePlaybackState(playbackState: AVSessionManager.AVPlaybackState) {
    if (!this.playbackState) {
      this.playbackState = playbackState;
    }
    let updatedKeys = Object.keys(playbackState);
    for (let key of updatedKeys) {
      this.playbackState[key] = playbackState[key];
    }
    log.info(`on playbackStateCallback for ${this.tempSessionId}: ${updatedKeys}`);
    MediaEventManager.notifyEvent(MediaEventType.PLAYBACK_STATE_CHANGE,
      MediaEventFactory.createPlaybackStateEvent(this.sessionId, this.playbackState, updatedKeys));
  }

  private getMetadataCallback(): MetadataCallback {
    if (!this.metadataCallback) {
      log.info(`getMetadataCallback create new one for ${this.tempSessionId}`);
      this.metadataCallback = (metadata: AVSessionManager.AVMetadata) => {
        this.updateMetadata(metadata);
      }
    }
    return this.metadataCallback;
  }

  private updateMetadata(metadata: AVSessionManager.AVMetadata) {
    if (!this.metadata) {
      this.metadata = metadata;
    }
    let updatedKeys = Object.keys(metadata);
    for (let key of updatedKeys) {
      this.metadata[key] = metadata[key];
    }
    log.info(`on metadataCallback for ${this.tempSessionId}: ${updatedKeys}`);
    MediaEventManager.notifyEvent(MediaEventType.METADATA_CHANGE,
      MediaEventFactory.createMetadataChangeEvent(this.sessionId, this.metadata, updatedKeys));
  }

  private getValidCommandCallback(): ValidCommandCallback {
    if (!this.validCommandCallback) {
      log.info(`getValidCommandCallback create new one for ${this.tempSessionId}`);
      this.validCommandCallback = (commands: Array<AVSessionManager.AVControlCommandType>) => {
        this.updateValidCommands(commands);
      }
    }
    return this.validCommandCallback;
  }

  private updateValidCommands(commands: Array<AVSessionManager.AVControlCommandType>) {
    log.info(`on validCommandCallback for ${this.tempSessionId}: ${commands}`);
    this.validCommand = commands;
    MediaEventManager.notifyEvent(MediaEventType.VALID_COMMAND_CHANGE,
      MediaEventFactory.createValidCommandEvent(this.sessionId, this.validCommand));
  }

  /*
    获取AVMetadata，以缓存形式储存，不会跨进程获取，考虑性能不做深拷贝，只读场景下获取后请勿修改参数
   */
  public getAVMetadata(): AVSessionManager.AVMetadata | undefined {
    return this.metadata;
  }

  /*
    获取AVPlaybackState，以缓存形式储存，不会跨进程获取，考虑性能不做深拷贝，只读场景下获取后请勿修改参数
   */
  public getAVPlaybackState() : AVSessionManager.AVPlaybackState | undefined {
    return this.playbackState;
  }

  /*
    获取ValidCommand，以缓存形式储存，不会跨进程获取，考虑性能不做深拷贝，只读场景下获取后请勿修改参数
   */
  public getValidCommand() : Array<AVSessionManager.AVControlCommandType> | undefined {
    return this.validCommand;
  }
}