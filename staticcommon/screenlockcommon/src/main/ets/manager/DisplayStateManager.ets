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

import display from '@ohos.display';
import {
  LogDomain,
  LogHelper,
  Trace
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { GlobalStatusCache, StatusCacheConst } from '../base/GlobalStatusCache';
import { DisplayUtils } from '../utils/DisplayUtils';

const TAG: string = 'DisplayStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 系统显示变化监听
 */
export interface DisplayStateListener {
  /**
   * 屏幕旋转状态发生改变
   */
  onOrientationChange?: (orientation: number) => void;

  /**
   * 屏幕尺寸发生改变
   */
  onScreenSizeChange?: (width: number, height: number) => void;

  /**
   * 屏幕属性发生改变
   */
  onScreenPropertyChange?: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => void;

  /**
   * 屏幕折叠状态发生改变（透传）
   */
  onFoldStateChange?: (isFoldExpand: boolean) => void;

  /**
   * 折叠状态变化监听
   *
   * @param foldStatus 折叠状态
   */
  onFoldStatusChange?: (foldStatus: number) => void;
}

export interface ChangeParams {
  isPropertyChange?: boolean;
  isWidthChange?: boolean;
  isHeightChange?: boolean;
  isOrientationChange?: boolean;
  isFoldChange?: boolean;
  isFoldStatusChange?: boolean;
}

/**
 * 系统显示变化管理类
 */
export class DisplayStateManager extends AbstractObserverManager<DisplayStateListener> {
  private static sInstance: DisplayStateManager;

  /**
   * 获取屏幕状态变化管理单例
   *
   * @returns 屏幕状态变化管理
   */
  public static getInstance(): DisplayStateManager {
    if (DisplayStateManager.sInstance == null) {
      DisplayStateManager.sInstance = new DisplayStateManager();
    }
    return DisplayStateManager.sInstance;
  }

  private _persistentId: number | undefined = 0;

  private _screenProperty?: SCBScreenProperty;

  private _reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;

  private _isFoldExpanded: boolean = false;

  private _foldStatus: number = DisplayUtils.getFoldStatus();

  private _screenWidth: number = 0;

  private _screenHeight: number = 0;

  private _screenRotation: number = 0;

  private readonly _screenPropertyChangeCallback =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
      Trace.start(Trace.CORE_METHOD_SCREEN_PROPERTY_CHANGE_KEYGUARD);
      this.updateScreenProperty(screenProperty, reason);
      Trace.end(Trace.CORE_METHOD_SCREEN_PROPERTY_CHANGE_KEYGUARD);
    };

  protected doInit(params?: number): void {
    this._persistentId = params;
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this._screenPropertyChangeCallback, undefined, false, this._persistentId);
    this.updateFoldExpandState();
  }

  protected doRelease(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this._screenPropertyChangeCallback, undefined, false, this._persistentId);
  }

  /**
   * 无条件设置屏幕属性
   */
  public setScreenProperty(screenProperty: SCBScreenProperty): void {
    this.updateScreenProperty(screenProperty);
  }

  public getFoldStatus(): number {
    return this._foldStatus;
  }

  /**
   * 注册屏幕显示变化监听
   *
   * @param listener 监听器
   */
  public registerObserver(
    listener: DisplayStateListener,
    isCallbackImmediately: boolean = true,
    highPriory: boolean = false
  ): void {
    if (!listener) {
      return;
    }
    super.registerObserver(listener, isCallbackImmediately, highPriory);
    if (isCallbackImmediately) {
      // 注册的时候默认立即通知一次
      log.showDebug('notifyScreenDisplayState immediate');
      // 注册时默认通知注册者，而不是所有

      this.notifyCurrentStateToListener(listener, {
        isPropertyChange: true,
        isWidthChange: true,
        isHeightChange: true,
        isOrientationChange: true,
        isFoldChange: true,
        isFoldStatusChange: true
      });
    }
  }

  /**
   * 获取当前屏幕是否为折叠状态
   */
  public isFoldExpanded(): boolean {
    return this._isFoldExpanded;
  }

  /**
   * 获取当前屏幕是否为竖屏
   */
  public isPortrait(): boolean {
    return this._screenRotation === display.Orientation.PORTRAIT ||
      this._screenRotation === display.Orientation.PORTRAIT_INVERTED;
  }

  /**
   * 获取当前屏幕属性
   *
   * @returns 屏幕属性
   */
  public getScreenProperty(): SCBScreenProperty | undefined {
    return this._screenProperty;
  }

  /**
   * 获取锁屏页面可旋转状态
   *
   * @return 是否可旋转
   */
  public getScreenSessionRotatable(): boolean {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this._persistentId);
    let rotateAble: boolean | undefined = systemSceneSession?.isRotatable ||
      (!DeviceHelper.isSmallFoldProduct() && this._isFoldExpanded);
    return rotateAble ?? false;
  }

  /**
   * 更新折叠状态
   */
  public updateFoldStatus(): void {
    this.broadcastStateChange({
      isFoldChange: this.updateFoldExpandState(),
      isFoldStatusChange: this.updateFoldStatusState()
    });
  }

  private updateScreenProperty(screenProperty: SCBScreenProperty, reason?: SCBPropertyChangeReason): void {
    let isWidthChange: boolean = this.updateWidth(screenProperty);
    let isHeightChange: boolean = this.updateHeight(screenProperty);
    let isOrientationChange: boolean = this.updateOrientation();
    let isFoldChange: boolean = this.updateFoldExpandState(screenProperty);
    let isFoldStatusChange: boolean = this.updateFoldStatusState();
    this._reason = reason ?? SCBPropertyChangeReason.UNDEFINED;
    this._screenProperty = screenProperty;
    this._screenWidth = screenProperty.width;
    this._screenHeight = screenProperty.height;
    this._screenRotation = DisplayUtils.getDefaultDisplaySync()?.orientation ?? 0;
    this.broadcastStateChange({
      isPropertyChange: true,
      isWidthChange: isWidthChange,
      isHeightChange: isHeightChange,
      isOrientationChange: isOrientationChange,
      isFoldChange: isFoldChange,
      isFoldStatusChange: isFoldStatusChange,
    });
  }

  private updateWidth(screenProperty: SCBScreenProperty): boolean {
    if (!this._screenProperty || (screenProperty.width !== this._screenWidth)) {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_WIDTH_KEY, screenProperty.width);
      return true;
    }
    return false;
  }

  private updateHeight(screenProperty: SCBScreenProperty): boolean {
    if (!this._screenProperty || (screenProperty.height !== this._screenHeight)) {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, screenProperty.height);
      return true;
    }
    return false;
  }

  private updateOrientation(): boolean {
    try {
      return display.getDefaultDisplaySync().orientation !== this._screenRotation;
    } catch (e) {
      log.showError('getDefaultDisplaySync failed');
      return false;
    }
  }

  private updateFoldExpandState(screenProperty?: SCBScreenProperty): boolean {
    if (!DisplayUtils.isFoldAble()) {
      return false;
    }
    log.showInfo(`updateFoldExpandState`);
    let isFoldExpanded: boolean = DisplayUtils.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
      DisplayUtils.getFoldStatus() === display.FoldStatus.FOLD_STATUS_HALF_FOLDED ||
      DisplayUtils.isThreeFoldGStatus(screenProperty);
    let isFoldChange: boolean = this._isFoldExpanded !== isFoldExpanded;
    this._isFoldExpanded = isFoldExpanded;
    return isFoldChange;
  }

  private updateFoldStatusState(): boolean {
    if (!DisplayUtils.isFoldAble()) {
      return false;
    }
    log.showInfo(`updateFoldStatusState`);
    let foldStatus: number = DisplayUtils.getFoldStatus();
    let isFoldStatusChange: boolean = this._foldStatus !== foldStatus;
    this._foldStatus = foldStatus;
    return isFoldStatusChange;
  }

  private broadcastStateChange(params: ChangeParams): void {
    if (!this.hasObserver()) {
      log.showError('empty observer, skip broadcast');
      return;
    }
    this.printCurrentDisplayState(params);
    this.broadcastDataChange(observer => this.notifyScreenDisplayStateChange(observer, params));
  }

  private printCurrentDisplayState(params: ChangeParams, immediately: boolean = false): void {
    log.showInfo(`broadcastStateChange` + (immediately ? ` immediately` : ``) +
      ` isWidthChange ${!!params.isWidthChange},` + ` isHeightChange ${!!params.isHeightChange},` +
      (!!params.isWidthChange || !!params.isHeightChange ?
      ` width ${this._screenProperty?.width} height ${this._screenProperty?.height},` : ``) +
        ` isOrientationChange ${!!params.isOrientationChange}` +
      (!!params.isOrientationChange ? ` rotation ${this._screenRotation},` : ``) +
        ` isFoldChange ${!!params.isFoldChange},` +
      (!!params.isFoldChange ? ` isFoldExpanded ${this._isFoldExpanded},` : ``) +
        ` isFoldStatusChange ${!!params.isFoldStatusChange}` +
      (!!params.isFoldStatusChange ? ` foldStatus ${this._foldStatus}` : ``));
  }

  private notifyCurrentStateToListener(self: DisplayStateListener, params: ChangeParams): void {
    this.printCurrentDisplayState(params, true);
    this.notifyScreenDisplayStateChange(self, params);
  }

  private notifyScreenDisplayStateChange(listener: DisplayStateListener, changeParams: ChangeParams): void {
    if (!!this._screenProperty && !!changeParams.isPropertyChange) {
      listener.onScreenPropertyChange?.(this._screenProperty, this._reason);
      if (!!changeParams.isOrientationChange) {
        listener.onOrientationChange?.(this._screenRotation);
      }
      if (!!changeParams.isWidthChange || !!changeParams.isHeightChange) {
        listener.onScreenSizeChange?.(this._screenWidth, this._screenHeight);
      }
    }
    if (!!changeParams.isFoldChange) {
      listener.onFoldStateChange?.(this._isFoldExpanded);
    }
    if (!!changeParams.isFoldStatusChange) {
      listener.onFoldStatusChange?.(this._foldStatus);
    }
  }
}