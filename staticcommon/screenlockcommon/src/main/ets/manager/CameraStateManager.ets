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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AbstractObserverManager, ObserverAble } from '../base/AbstractObserverManager';
import camera from '@ohos.multimedia.camera';
import { AsyncCallback, BusinessError } from '@ohos.base';

const TAG = 'CameraStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * camera状态变化监听
 */
export interface CameraStateChangeListener extends ObserverAble {
  /**
   * 相机禁用状态变化
   *
   * @param isCameraMuted 相机是否被禁用
   */
  onCameraMuteChange(isCameraMuted: boolean): void;
}

/**
 * camera状态管理器
 */
export class CameraStateManager extends AbstractObserverManager<CameraStateChangeListener> {
  private static sInstance: CameraStateManager;
  private cameraManager: camera.CameraManager | undefined;
  private _isCameraMuted: boolean = false;

  private readonly _callback: AsyncCallback<boolean> = (err: BusinessError, isCameraMuted: boolean) => {
    if (err) {
      log.showError(`onCameraMuteChange error, code:${err?.code}, message:${err?.message}`);
      return;
    }
    log.showInfo(`isCameraMuted：${isCameraMuted}`);
    this._isCameraMuted = isCameraMuted;
    this.broadcastDataChange(listener => listener?.onCameraMuteChange?.(isCameraMuted));
  };

  public static getInstance(): CameraStateManager {
    if (CameraStateManager.sInstance == null) {
      CameraStateManager.sInstance = new CameraStateManager();
    }
    return CameraStateManager.sInstance;
  }

  public get isCameraMuted(): boolean {
    return this._isCameraMuted;
  }

  /**
   * 初始化
   */
  protected doInit(): void {
    log.showInfo('doInit');
    super.doInit();

    try {
      this.cameraManager = camera?.getCameraManager(getContext());
    } catch (err) {
      log.showError(`getCameraManager error, code:${err?.code}, message:${err?.message}`);
    }
    this._isCameraMuted = this.cameraManager?.isCameraMuted() ?? false;
    log.showInfo(`init isCameraMuted：${this.isCameraMuted}`);
    this.cameraManager?.on('cameraMute', this._callback);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    super.doRelease();
    this.cameraManager?.off('cameraMute', this._callback);
  }
}