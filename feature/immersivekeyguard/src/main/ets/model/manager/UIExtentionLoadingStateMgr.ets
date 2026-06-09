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
import { CardWgBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { LimitSet } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/LimitSet';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';

const TAG = 'UIExtentionLoadingStateMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// loading时长
const MAX_LOADING_TIME_MS: number = 500;

// 影响沉浸卡片UIExtention loading加载的参数
class LoadingEnableParam {
  // 当前显示沉浸大卡标识
  public curShowingImmHash?: string;
  // 延时回收的沉浸数据
  public delayImmHash?: string;
  // UIExtention onRemoteReady状态
  public isRemoteReady: boolean = false;

  // loading最终状态
  private _isShowLoad: boolean = false;

  /**
   * loading开启状态
   *
   * @returns true开启loading
   */
  public isShowLoad(): boolean {
    return this._isShowLoad;
  }

  /**
   * 刷新loading开启状态
   */
  public updateLoadingEnable(): void {
    // loading状态开启 = 沉浸UI显示 + UIExtention未连接
    if (Boolean(this.curShowingImmHash)) {
      this._isShowLoad = !this.isRemoteReady;
    } else {
      this._isShowLoad = false;
    }
  }
}

/**
 * 沉浸态UIExtention loading加载管理器
 */
export class UIExtentionLoadingStateMgr {
  // 单例
  private static instance?: UIExtentionLoadingStateMgr;

  // 申请能加载UIExtention loading的沉浸应用标识
  private readonly canLoadingSet: LimitSet<string | undefined> = new LimitSet();

  // 沉浸卡片loading加载开关状态管理
  private readonly loadingEnable: LoadingEnableParam = new LoadingEnableParam();

  // 当前沉浸卡片loading加载是否结束
  private isShowLoad: boolean = this.loadingEnable.isShowLoad();

  // 沉浸卡片loading加载定时器
  private loadingStateTimer?: number;

  /**
   * 单例
   *
   * @returns 单例
   */
  public static getInstance(): UIExtentionLoadingStateMgr {
    if (!UIExtentionLoadingStateMgr.instance) {
      UIExtentionLoadingStateMgr.instance = new UIExtentionLoadingStateMgr();
    }
    return UIExtentionLoadingStateMgr.instance;
  }

  /**
   * 设置延时回收的沉浸态数据
   *
   * @param hashcode 应用标识
   */
  public setDelayImmHash(hashcode?: string): void {
    if (this.loadingEnable.delayImmHash === hashcode) {
      return;
    }
    this.loadingEnable.delayImmHash = hashcode;
  }

  /**
   * 缓存沉浸数据状态
   *
   * @param hashcode 应用标识
   * @param isEnable true 能加载loading的沉浸态数据
   */
  public setCanLoadingState(hashcode?: string, isEnable?: boolean): void {
    if (!isEnable) {
      if (this.canLoadingSet.delete(hashcode) && this.isCurHashcode(hashcode)) {
        this.checkLoadingChange();
      }
      return;
    }

    if (this.canLoadingSet.has(hashcode)) {
      return;
    }
    // 新增当前显示数据，则刷新状态
    this.canLoadingSet.add(hashcode);
    if (this.isCurHashcode(hashcode)) {
      this.checkLoadingChange();
    }
  }

  /**
   * 重置loading状态
   *
   */
  public resetLoadingState(): void {
    log.showInfo('resetLoadingState start');
    this.canLoadingSet.clear();
    // 清除当前沉浸应用信息
    this.setCurShowingImmersive();
    this.loadingEnable.isRemoteReady = false;
  }

  /**
   * 设置当前沉浸态显示的应用标识
   *
   * @param hashcode 标识
   */
  public setCurShowingImmersive(hashcode?: string): void {
    if (this.loadingEnable.curShowingImmHash === hashcode) {
      return;
    }
    // extention沉浸态之间切换逻辑
    if (this.loadingEnable.delayImmHash && this.loadingEnable.delayImmHash !== hashcode &&
    this.canLoadingSet.has(hashcode)) {
      log.showInfo(`delayImmHashChange start delayImmHash：${this.loadingEnable.delayImmHash} hashcode:${hashcode}`);
      this.loadingEnable.isRemoteReady = false;
    }
    this.loadingEnable.curShowingImmHash = hashcode;
    this.loadingEnable.updateLoadingEnable();
    // extention与非Extention沉浸态之间切换逻辑
    if (hashcode && !this.canLoadingSet.has(hashcode)) {
      log.showInfo(`notExtentionChange start hashcode:${hashcode}`);
      this.loadingEnable.isRemoteReady = false;
      return;
    }
    this.checkLoadingChange();
  }

  /**
   * 设置卡片isRemoteReady连接状态
   *
   * @param isRemoteReady true 卡片extention连接成功
   *
   */
  public setOnRemoteReady(isRemoteReady: boolean): void {
    if (this.loadingEnable.isRemoteReady === isRemoteReady) {
      return;
    }
    log.showInfo(`setOnRemoteReady change isRemoteReady:${isRemoteReady}`);
    this.loadingEnable.isRemoteReady = isRemoteReady;
    this.loadingEnable.updateLoadingEnable();
    // 如果Loading没发生改变，但是isRemoteReady回调为true，强行更新
    if (!this.checkLoadingChange() && isRemoteReady) {
      log.showWarn('loadingChange is false and forceUpdate delayUpdateLoadingState');
      this.delayUpdateLoadingState();
    }
  }

  /**
   * 设置卡片extention显示状态
   *
   * @param isShowLoad true 卡片extention显示
   */
  private setIsShowLoadState(isShowLoad: boolean): void {
    log.showInfo(`setIsShowLoadState isShowLoad:${isShowLoad}`);
    let cardWidgetBindState = slUiStateMgr.getSlState(SlMainStateType.SL_CARD_WG_BIND_STATE);
    cardWidgetBindState?.setSlState(CardWgBindStateType.UI_EXTENTION_LOADING_STATE, isShowLoad);
  }

  private isCurHashcode(hashcode?: string): boolean {
    // 当前显示沉浸数据匹配
    return this.loadingEnable.curShowingImmHash === hashcode;
  }

  /**
   * 校验loading状态改变
   *
   * @returns true loading状态发生改变
   */
  private checkLoadingChange(): boolean {
    // 检测当前为extention沉浸态卡片切换
    let curLoadState = this.loadingEnable.isShowLoad() && this.canLoadingSet.has(this.loadingEnable.curShowingImmHash);
    if (this.isShowLoad === curLoadState) {
      return false;
    }
    this.isShowLoad = curLoadState;
    // 刷新当前状态
    if (this.isShowLoad) {
      this.clearLoadingState();
      this.setIsShowLoadState(true);
    } else {
      if (this.loadingEnable.isRemoteReady) {
        log.showInfo('checkLoadingChange remoteReady is true');
        this.delayUpdateLoadingState();
      }
    }
    return true;
  }

  /**
   * 清除定时器
   *
   */
  private clearLoadingState(): void {
    if (this.loadingStateTimer) {
      clearTimeout(this.loadingStateTimer);
      this.loadingStateTimer = undefined;
    }
  }

  /**
   * 创建定时器
   *
   */
  private delayUpdateLoadingState(): void {
    this.clearLoadingState();
    this.loadingStateTimer = setTimeout(() => {
      this.clearLoadingState();
      this.setIsShowLoadState(false);
    }, MAX_LOADING_TIME_MS);
  }
}