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
import { EvtBus, WindowEvent } from '@ohos/frameworkwrapper';
import { OccludeKeygaurdScene, SCBSceneSessionManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { KeyguardStatusService } from './KeyguardStatusService';

const TAG = 'OccludedStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 遮盖状态监听器
 */
export interface OccludedStateManagerListener {
  /**
   * 遮盖状态变化通知
   *
   * @param isOccluded 是否被遮盖
   */
  onOccludedStateChange?: (isOccluded: boolean) => void;
}

/**
 * 遮盖状态管理器（统一定义+收集+分发）
 */
export class OccludedStateManager extends AbstractObserverManager<OccludedStateManagerListener> {
  private static sInstance: OccludedStateManager;
  private readonly OCCLUDED_ON_BOUNCER: OccludeKeygaurdScene[] =
    [OccludeKeygaurdScene.SPECIFIC_TYPE_VOICE_INTERACTION, OccludeKeygaurdScene.SYSTEM_DIALOG_UNOCCLUDE];

  public static getInstance(): OccludedStateManager {
    if (OccludedStateManager.sInstance == null) {
      OccludedStateManager.sInstance = new OccludedStateManager();
    }
    return OccludedStateManager.sInstance;
  }

  private _windowOccludedState: number = 0; // 遮挡状态
  private _isDropdownShow: boolean = false; // 是否双中心下拉
  private _isMetaBallShow: boolean = false; // 充电动效

  /**
   * 是否遮盖
   *
   * @returns 是否遮盖
   */
  public get isOccluded(): boolean {
    return this.isWindowOccluded || this.isDropdownOccluded;
  }

  /**
   * 是否窗口遮挡
   *
   * @returns 是否窗口遮挡
   */
  public get isWindowOccluded(): boolean {
    return this._windowOccludedState !== 0;
  }

  /**
   *  获取窗口遮挡类型
   *
   * @returns 窗口遮挡类型
   */
  public get windowOccludedState(): number {
    return this._windowOccludedState;
  }

  private set windowOccludedState(occludedState: number) {
    if (this._windowOccludedState !== occludedState) {
      this._windowOccludedState = occludedState;
      this.broadcastDataChange(observer => observer.onOccludedStateChange?.(this.isOccluded));
    }
  }

  /**
   * 是否双中心遮挡
   *
   * @returns 是否双中心遮挡
   */
  public get isDropdownOccluded(): boolean {
    return this._isDropdownShow;
  }

  /**
   * 设置双中心遮挡状态
   *
   * @param 双中心遮挡状态
   */
  public set isDropdownOccluded(isDropdownShow: boolean) {
    if (this._isDropdownShow !== isDropdownShow) {
      this._isDropdownShow = isDropdownShow;
      this.broadcastDataChange(observer => observer.onOccludedStateChange?.(this.isOccluded));
    }
  }

  /**
   * 设置充电动效状态
   *
   * @param 充电动效状态
   */
  public set isMetaBallOccluded(_isMetaBallShow: boolean) {
    this._isMetaBallShow = _isMetaBallShow;
  }

  /**
   * 是否充电动效遮挡
   *
   * @returns 是否充电动效遮挡
   */
  public get isMetaBallOccluded(): boolean {
    return this._isMetaBallShow;
  }

  /**
   * 是否密码界面之上的遮挡
   *
   * @returns 是否密码界面之上的遮挡
   */
  public get isOccludeOnBouncer(): boolean {
    log.showInfo(`isOccludeOnBouncer ${this._windowOccludedState}, ${this._isMetaBallShow}`);
    return this.OCCLUDED_ON_BOUNCER.includes(this._windowOccludedState) || this._isMetaBallShow;
  }

  protected doInit(): void {
    log.showInfo('doInit');
    SCBSceneSessionManager.getInstance().registerKeyguardOccludedChangeCallbacks(this.handleOccludedChange.bind(this));
    EvtBus.on(WindowEvent, this.handleWindowEvent.bind(this));
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    SCBSceneSessionManager.getInstance().unRegisterKeyguardOccludedChangeCallbacks(
      this.handleOccludedChange.bind(this));
    EvtBus.off(WindowEvent, this.handleWindowEvent.bind(this));
  }

  private handleOccludedChange(occludedState: number): void {
    if (this._windowOccludedState === occludedState) {
      return;
    }
    log.showWarn(`receive occludedState: ${occludedState}.`);
    KeyguardStatusService.switchToOccluded(occludedState);
    this.windowOccludedState = occludedState;
  }

  private handleWindowEvent(event: WindowEvent): void {
    if (event.windowName !== WindowConstants.WINDOW_NAME_DROPDOWN) {
      return;
    }
    let isDropdownShow: boolean | undefined = undefined;
    switch (event.eventType) {
      case WindowEvent.EVENT_TYPE_SHOW:
        isDropdownShow = true;
        break;
      case WindowEvent.EVENT_TYPE_HIDE:
        isDropdownShow = false;
        break;
      default:
        break;
    }
    if (isDropdownShow !== undefined && this._isDropdownShow !== isDropdownShow) {
      log.showInfo(`receive isDropdownShow: ${isDropdownShow}`);
      this.isDropdownOccluded = isDropdownShow;
    }
  }
}