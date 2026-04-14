/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogHelper, LogDomain, SingletonHelper } from '@ohos/basicutils';
import AVSessionManager from '@ohos.multimedia.avsession';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'RecentMediaPlay';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class RecentMediaPlay {
  private bundleNameControllerMap: Map<string, [AVSessionManager.AVSessionController, AVSessionManager.AVPlaybackState,
    AVPlayStateCallback]> = new Map();

  public static getInstance(): RecentMediaPlay {
    return SingletonHelper.getInstance(RecentMediaPlay, TAG);
  }

  /**
   * 获取已有媒体播放列表
   * @returns
   */
  private async initControllerMap(): Promise<void> {
    // 获取会话描述符
    try {
      let descriptors = await AVSessionManager.getAllSessionDescriptors();
      for (let idx = 0; idx < descriptors?.length; ++idx) {
        try {
          let controller = await AVSessionManager.createController(descriptors[idx].sessionId);
          let elementName = descriptors[idx].elementName;
          let keyName = `${elementName.bundleName}${elementName.abilityName}`;
          await this.monitorPlayState(keyName, controller);
        } catch (err) {
          this.bundleNameControllerMap.clear();
          log.showInfo(`Failed to create controller. Code: ${err.code}, message: ${err.message}`);
        }
      }
    } catch (err) {
      log.showInfo(`Failed to get all session descriptors. Code: ${err.code}, message: ${err.message}`);
    };
    log.showInfo(`initControllerMap SUCC!`);
  }

  /**
   * 开启播放状态监听
   * @param keyName
   * @param controller
   */
  private async monitorPlayState(keyName: string, controller: AVSessionManager.AVSessionController) {
    let callback = (playbackState: AVSessionManager.AVPlaybackState) => {
      let currentState = this.bundleNameControllerMap?.get(keyName)?.[1];
      if (playbackState?.state != undefined && currentState?.state !== playbackState?.state) {
        this.bundleNameControllerMap.set(keyName, [controller, playbackState, callback]);
        log.showInfo(`on playbackStateChange bundleName: ${keyName} state : ${playbackState.state}`);
      }
    };
    this.bundleNameControllerMap.set(keyName, [controller, await controller?.getAVPlaybackState(), callback]);
    // 注册播放状态更新监听
    controller.on('playbackStateChange', ['state', 'speed', 'loopMode'], callback);
  }

  /**
   * 开启媒体应用创建or销毁监听
   * @returns
   */
  private async monitorSessionAction(): Promise<void> {
    AVSessionManager.on('sessionCreate', (session) => {
      // 新增会话，需要创建控制器
      AVSessionManager.createController(session.sessionId).then(async (controller) => {
        let elementName = session.elementName;
        let keyName = `${elementName.bundleName}${elementName.abilityName}`;
        if (!this.bundleNameControllerMap.has(keyName)) {
          log.showInfo(`RecentMediaPlay sessionCreate ${keyName}`);
          await this.monitorPlayState(keyName, controller);
        }
      }).catch((err: BusinessError) => {
        this.bundleNameControllerMap.clear();
        log.showInfo(`Failed to create controller. Code: ${err.code}, message: ${err.message}`);
      });
    });
    log.showInfo(`monitorSessionAction sessionCreate SUCC!`);

    AVSessionManager.on('sessionDestroy', (session) => {
      if (this.bundleNameControllerMap.has(`${session.elementName.bundleName}${session.elementName.abilityName}`)) {
        let elementName = session.elementName;
        let keyName = `${elementName.bundleName}${elementName.abilityName}`
        log.showInfo(`RecentMediaPlay sessionDestroy ${keyName}`);
        let controller = this.bundleNameControllerMap.get(keyName)?.[0];
        let callback = this.bundleNameControllerMap.get(keyName)?.[2];
        if (callback) {
          controller?.off('playbackStateChange', callback);
        }
        this.bundleNameControllerMap.delete(keyName);
      }
    });
    log.showInfo(`monitorSessionAction sessionDestroy SUCC!`);
  }

  /**
   * 根据应用名判断是否音频播放应用
   * @param keyName
   * @returns
   */
  public isContainerMediaPlay(keyName: string): boolean {
    if (this.bundleNameControllerMap.has(keyName)) {
      let playState = this.bundleNameControllerMap.get(keyName)?.[1];
      log.showInfo(`IsContainerMediaPlay ->  bundleName: ${keyName} playState: ${playState?.state}`);
      return playState?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
        playState?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING;
    }
    log.showInfo(`IsContainerMediaPlay NoPlayState: ${keyName}`);
    return false;
  }

  /**
   * 初始化map和开启监听
   * @returns
   */
  public async initAvSessionMap(): Promise<void> {
    await this.initControllerMap();
    await this.monitorSessionAction();
    log.showInfo(`initAVSessionMap SUCC!`);
  }
}

export type AVPlayStateCallback = (playbackState: AVSessionManager.AVPlaybackState) => void;
export const recentMediaPlayInstance = RecentMediaPlay.getInstance();