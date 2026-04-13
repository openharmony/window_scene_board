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

import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { camera } from '@kit.CameraKit';
import { LogDomain } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { Logger } from '@ohos/basicutils/src/main/ets/utils/Logger';

const TAG = 'NotificationFlashReminder';
const log: Logger = Logger.getLogHelper(LogDomain.NC);
const TORCH_FLASH_DURATION = 250;

export class NotificationFlashReminder {
  /**
   * 相机状态管理器
   */
  private mCameraManager: camera.CameraManager | undefined = undefined;
  /**
   * 通知持续闪烁的intervalId
   */
  private flashIntervalId: number = -1;

  /**
   * 获取相机状态管理器
   *
   * @returns mCameraManager
   */
  private getCameraManager(): camera.CameraManager | undefined {
    if (this.mCameraManager === undefined) {
      const context: Context = GlobalContext.getContext();
      try {
        this.mCameraManager = camera.getCameraManager(context);
      } catch (error) {
        log.showError(TAG, `getCameraManager error, errorCode = ${error.code}, message = ${error.message}`);
      }
    }
    return this.mCameraManager;
  }

  /**
   * 设置手电筒状态
   */
  private setTorchMode(torchMode: camera.TorchMode): void {
    if (this.getTorchMode() === torchMode) {
      log.showWarn(TAG, `setTorchMode ${torchMode} fail, torchMode is already ${torchMode}`);
      return;
    }
    try {
      const manager: camera.CameraManager | undefined = this.getCameraManager();
      if (!manager) {
        log.showWarn(TAG, `setTorchMode fail, no camera manager`);
        return;
      }
      manager.setTorchMode(torchMode);
    } catch (error) {
      log.showError(TAG, `setTorchMode ${torchMode} error, errorCode = ${error.code}, message = ${error.message}`);
    }
  }

  /**
   * 获取当前手电筒状态
   *
   * @returns torchMode
   */
  private getTorchMode(): camera.TorchMode | undefined {
    try {
      const manager: camera.CameraManager | undefined = this.getCameraManager();
      if (!manager) {
        log.showWarn(TAG, `getTorchMode fail, no camera manager`);
        return undefined;
      }
      return manager.getTorchMode();
    } catch (error) {
      log.showError(TAG, `getTorchMode error, errorCode = ${error.code}, message = ${error.message}`);
      return undefined;
    }
  }

  /**
   * 打开手电筒
   */
  private openTorchLight(): void {
    this.setTorchMode(camera.TorchMode.ON);
  }

  /**
   * 关闭手电筒
   */
  private closeTorchLight(): void {
    this.setTorchMode(camera.TorchMode.OFF);
  }

  /**
   * 手电筒开始持续闪烁
   */
  public startFlashTorchLight(): void {
    if (this.getTorchMode() === camera.TorchMode.ON) {
      log.showInfo(TAG, `startFlashTorchLight fail, current torch mode = ${camera.TorchMode.ON}`);
      return;
    }
    this.flashIntervalId = setInterval(() => {
      const isTorchMode = this.getTorchMode();
      if (isTorchMode === camera.TorchMode.OFF) {
        this.openTorchLight();
      } else if (isTorchMode === camera.TorchMode.ON) {
        this.closeTorchLight();
      }
    }, TORCH_FLASH_DURATION);
  }

  /**
   * 手电筒停止持续闪烁
   */
  public stopFlashTorchLight(): void {
    const interval: number = this.flashIntervalId;
    if (interval >= 0) {
      clearInterval(interval);
      this.flashIntervalId = -1;
      this.closeTorchLight();
      // 退出闪烁模式
      log.showWarn(TAG, `stopFlashTorchLight success`);
    }
  }

  /**
   * 手电筒闪烁指定次数，默认2次
   */
  public flashTorchLight(stopCallback: (() => void) | undefined, flashTime: number = 2): void {
    const curTorchMode: camera.TorchMode | undefined = this.getTorchMode();
    if (curTorchMode !== camera.TorchMode.OFF) {
      log.showWarn(TAG, `flashTorchLight fail, current torch mode = ${curTorchMode}`);
      stopCallback?.();
      return;
    }
    let count: number = 0;
    const intervalId: number = setInterval(() => {
      const isTorchMode = this.getTorchMode();
      if (isTorchMode === camera.TorchMode.OFF) {
        this.openTorchLight();
      } else if (isTorchMode === camera.TorchMode.ON) {
        this.closeTorchLight();
      }
      count++;
      if (count >= (2 * flashTime)) {
        clearInterval(intervalId);
        stopCallback?.();
      }
    }, TORCH_FLASH_DURATION);
  }
}