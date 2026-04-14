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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { MetadataChangeEvent, PlaybackStateEvent, TopSessionChangeEvent,
  ValidCommandChangeEvent } from '../EventBus/MediaEvent';
import { MetadataChangeCallback, PlaybackStateChangeCallback,
  TopSessionChangeCallback,
  ValidCommandChangeCallback} from '../EventBus/MediaEventCallback';
import { MediaEventManager, MediaEventType } from '../EventBus/MediaEventManager';
import { AVSessionAdapter } from '../model/AVSessionAdapter';
import { BasicMediaController } from '../viewmodel/BasicMediaVM';
import { CommonMediaData } from '../viewmodel/CommonMediaData';
import CommonUtils from '../Util/CommonUtils';
import ControllerUtils from '../Util/ControllerUtils';
import { avSession } from '@kit.AVSessionKit';

const TAG = 'CommonMediaController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

/*
  基础播控控制器，用来把基础avsession数据制作成给view使用的基础播控数据
  集合所有界面通用的播控展示数据
 */
export class CommonMediaController extends BasicMediaController {
  /*
    持续更新的基础播控数据集
   */
  private data: CommonMediaData;
  /*
    监听媒体事件的回调
   */
  private topSessionCallback: TopSessionChangeCallback;
  private metadataCallback: MetadataChangeCallback;
  private playbackStateCallback: PlaybackStateChangeCallback;
  private validCommandCallback: ValidCommandChangeCallback;
  /*
    不同字段变更触发的刷新函数
   */
  private metadataChangeMethodMap: Map<string, Array<Function>> = new Map<string, Array<Function>>([
    ['assetId', [this.handleAssetIdChange]],
    ['title', [this.handleTitleChange]],
    ['artist', [this.handleArtistChange]],
    ['mediaImage', [this.handleImageChange]],
    ['lyric', [this.handleLyricChange]],
  ]);
  /*
    当前显示的topSession
   */
  private topSessionId: string = '';

  constructor(data: CommonMediaData) {
    super();
    this.data = data;
    this.topSessionCallback = new TopSessionChangeCallback((event: TopSessionChangeEvent) => {
      if (this.topSessionId !== event.sessionId) {
        this.topSessionId = event.sessionId;
        this.refreshDataForSessionId(this.topSessionId);
      }
    });
    MediaEventManager.registerEventListener(MediaEventType.TOP_SESSION_CHANGE, this.topSessionCallback);

    this.metadataCallback = new MetadataChangeCallback((event: MetadataChangeEvent) => {
      this.handleMetadataChange(event);
    });
    MediaEventManager.registerEventListener(MediaEventType.METADATA_CHANGE, this.metadataCallback);

    this.playbackStateCallback = new PlaybackStateChangeCallback((event: PlaybackStateEvent) => {
      if (event.sessionId !== this.topSessionId) {
        return;
      }
      this.updatePlaybackState(event.playbackState);
    });
    MediaEventManager.registerEventListener(MediaEventType.PLAYBACK_STATE_CHANGE, this.playbackStateCallback);

    this.validCommandCallback = new ValidCommandChangeCallback((event: ValidCommandChangeEvent) => {
      if (event.sessionId !== this.topSessionId) {
        return;
      }
      this.updateValidCommand(event.commands);
    });
    MediaEventManager.registerEventListener(MediaEventType.VALID_COMMAND_CHANGE, this.validCommandCallback);
  }

  /*
    把显示数据更新为指定sessionId对应的数据
   */
  private refreshDataForSessionId(sessionId: string) {
    let item = AVSessionAdapter.getInstance().getAVSessionItem(sessionId);
    if (item === undefined) {
      log.showError(`refreshDataForSessionId session ${CommonUtils.getMaskStr(sessionId)} not found`);
      return;
    }
    this.updateMetadata(item.getAVMetadata() ?? { assetId : ''} );
    this.updatePlaybackState(item.getAVPlaybackState() ?? {});
    this.updateValidCommand(item.getValidCommand() ?? []);
  }

  private updatePlaybackState(playbackState: avSession.AVPlaybackState) {
    if (playbackState.state !== undefined) {
      this.data.playState = playbackState.state;
    }
  }

  private handleMetadataChange(event: MetadataChangeEvent) {
    if (event.sessionId !== this.topSessionId) {
      return;
    }
    let methods = ControllerUtils.getExecuteMethods(event.updatedKeys, this.metadataChangeMethodMap);
    for (const method of methods) {
      method(this, event.metadata);
    }
  }

  private updateMetadata(metadata: avSession.AVMetadata) {
    let methods = ControllerUtils.getExecuteMethods(Object.keys(metadata), this.metadataChangeMethodMap);
    for (const method of methods) {
      method(this, metadata);
    }
  }

  private handleAssetIdChange(controller: CommonMediaController, metadata: avSession.AVMetadata) {
    if (metadata.assetId === undefined || controller.data.assetId === metadata.assetId) {
      return;
    }
    controller.data.assetId = metadata.assetId;
    log.showInfo('clearForAssetIdChange');
    controller.data.clearForAssetIdChange();
  }

  private handleTitleChange(controller: CommonMediaController, metadata: avSession.AVMetadata) {
    if (metadata.title !== undefined) {
      controller.data.title = metadata.title;
    }
  }

  private handleArtistChange(controller: CommonMediaController, metadata: avSession.AVMetadata) {
    if (metadata.artist !== undefined) {
      controller.data.artist = metadata.artist;
    }
  }

  private handleImageChange(controller: CommonMediaController, metadata: avSession.AVMetadata) {
  }

  private handleLyricChange(controller: CommonMediaController, metadata: avSession.AVMetadata) {
  }

  private updateValidCommand(commands: Array<avSession.AVControlCommandType>) {
    this.data.isCanPlay = commands.includes('play');
    this.data.isCanPause = commands.includes('pause');
    this.data.isCanPlayNext = commands.includes('playNext');
    this.data.isCanPlayPrev = commands.includes('playPrevious');
    this.data.isCanFastForward = commands.includes('fastForward');
    this.data.isCanRewind = commands.includes('rewind');
  }

  public release(): void {
    MediaEventManager.unRegisterEventListener(MediaEventType.TOP_SESSION_CHANGE, this.topSessionCallback);
    MediaEventManager.unRegisterEventListener(MediaEventType.PLAYBACK_STATE_CHANGE, this.playbackStateCallback);
    MediaEventManager.unRegisterEventListener(MediaEventType.METADATA_CHANGE, this.metadataCallback);
    MediaEventManager.unRegisterEventListener(MediaEventType.VALID_COMMAND_CHANGE, this.validCommandCallback);
  }
}