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
import { CustomMessageBase } from './CustomMessageBase';
import { audio } from '@kit.AudioKit';
import { LogDomain, LogHelper, AudioManagerHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'CaptureCustomMessage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class CaptureCustomMessage extends CustomMessageBase {
  private onCapturerArrayChange: Callback<Array<audio.AudioCapturerChangeInfo>> | undefined;
  private audioManager: audio.AudioManager | undefined;
  private audioStreamManager: audio.AudioStreamManager | undefined;

  protected initDiff(): boolean {
    this.registerCapturerInfoArrayListener();
    return true;
  }

  // 麦克风面板一级菜单监听逻辑控制显隐
  private registerCapturerInfoArrayListener(): void {
    log.showInfo(`initListenCapturerInfoChange begin`);
    try {
      this.audioManager = AudioManagerHelper.getAudioManager();
      this.audioStreamManager = this.audioManager.getStreamManager();
      this.audioStreamManager.getCurrentAudioCapturerInfoArray().then((audioCapturerChangeInfoArray) => {
        this.processAudioCapturerInfoArray(audioCapturerChangeInfoArray);
      });
      this.audioStreamManager.on('audioCapturerChange',
        (audioCapturerChangeInfoArray: Array<audio.AudioCapturerChangeInfo>) => {
          this.processAudioCapturerInfoArray(audioCapturerChangeInfoArray);
        });
    } catch (err) {
      log.showError(`init listen capturer info change error: ${err?.message}`);
    }
  };

  private processAudioCapturerInfoArray(audioCapturerChangeInfoArray: audio.AudioCapturerChangeInfo[]): void {
    log.showInfo(`currentAudioCapturerInfoArray length: ${audioCapturerChangeInfoArray.length}`);
    let isShow: boolean = false;
    audioCapturerChangeInfoArray.forEach((capturerInfo) => {
      if (capturerInfo.capturerState === audio.AudioState.STATE_RUNNING) {
        isShow = true;
      }
    });
    this.updateVisible(isShow);
  }

  protected deInitDiff(): void {
    this.unRegisterCapturerInfoArrayListener();
  }

  private unRegisterCapturerInfoArrayListener(): void {
    if (this.audioStreamManager !== undefined && this.onCapturerArrayChange !== undefined) {
      try {
        log.showInfo(`start off listen capturer info change`);
        this.audioStreamManager.off('audioCapturerChange');
      } catch (err) {
        log.showError(`off listen capturer info change error: ${err?.message}`);
      }
    }
  }
}