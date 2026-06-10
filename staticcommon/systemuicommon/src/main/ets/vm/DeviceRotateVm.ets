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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import lazy { SCBRotateChangeReason } from '@ohos/windowscene';
import { messageChannel } from '../messageChannel/MessageChannel';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { CutoutVm } from '../statusbar/vm/CutoutVm';
import { Singleton } from '../utils/Singleton';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'DeviceRotateVm');

/**
 * 设备信息ViewModel
 */
@ObservedV2
export class DeviceRotateVm {
  @Singleton.decorate()
  public static get instance(): DeviceRotateVm {
    return new DeviceRotateVm();
  }
  constructor() {
    messageChannel.onMessage('onRegisterRotateChangeEvent', (reason: SCBRotateChangeReason) => {
      log.showFatal(`onRegisterRotateChangeEvent ${reason}`);
      if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
        this.beginRotation();
      } else if (reason === SCBRotateChangeReason.ROTATE_END) {
        this.endRotation();
      }
    });
  }

  /**
   * 旋转超时定时器
   */
  private rotateTimerId?: number;
  /**
   * 旋转处理promise
   */
  public rotationPromise?: CustomPromise<void>;
  /**
   * 是否处于旋转动效过程中
   */
  @Trace public isInRotateAnim: boolean = false;

  /**
   * 开始旋转
   * @param timeout 超时时间
   */
  public beginRotation(timeout = 2000): void {
    log.showInfo('begin rotation');
    if (!this.rotationPromise) {
      this.rotationPromise = new CustomPromise();
      this.isInRotateAnim = true;
    }
    if (this.rotateTimerId !== undefined) {
      clearTimeout(this.rotateTimerId);
    }
    // 超时时间2000ms，避免旋转一直不完成影响胶囊动效。
    this.rotateTimerId = setTimeout(() => {
      log.showWarn('Timeout for rotation.');
      this.endRotation();
    }, timeout);
  }

  /**
   * 结束旋转
   */
  public endRotation(): void {
    log.showInfo('end rotation.');
    if (this.rotateTimerId !== undefined) {
      clearTimeout(this.rotateTimerId);
      this.rotateTimerId = undefined;
    }
    if (this.rotationPromise) {
      this.rotationPromise.resolve();
      this.rotationPromise = undefined;
      this.isInRotateAnim = false;
      log.showWarn(`resolve rotationPromise by ROTATE_END`);
    }
  }

  /**
   * 非手动旋转屏幕时，触发改兜底逻辑，是begin/endRotation不触发的兜底措施，保证屏幕旋转事件一定会执行
   */
  public onDeviceRotateChange(): void {
    // 手动旋转屏幕导致的旋转过程中，不创建rotationPromise，由onDeviceRotationChange处理。
    log.showWarn(`cutout position: ${CutoutVm.instance.position}, hole num: ${CutoutVm.instance.holeNum}, isMiddleCutout: ${CutoutVm.instance.isMiddleCutout()}, isInRotateAnim: ${this.isInRotateAnim}`);
    if (this.isInRotateAnim) {
      return;
    }
    // 处理直接上滑应用至桌面导致的屏幕旋转和屏幕折叠展开场景触发的屏幕/窗口属性变化。
    if (!this.rotationPromise) {
      this.rotationPromise = new CustomPromise();
    }
    this.isInRotateAnim = true;
    setTimeout(() => {
      this.rotationPromise?.resolve();
      this.rotationPromise = undefined;
      this.isInRotateAnim = false;
      log.showWarn(`resolve rotationPromise by setTimeout`)
    }, 500)
  }
}