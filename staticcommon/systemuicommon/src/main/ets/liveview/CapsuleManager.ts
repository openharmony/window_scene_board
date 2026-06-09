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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper';
import { baseStateMgr, DisplaySizeState, IState,
  OnStateChangeListener, StateType } from '@ohos/systemuiutils';
import { LiveViewCapsuleStyle } from './common/LiveViewCapsuleStyle';
import { LiveCapsuleStyle } from './data/extend/LiveCapsuleStyle';
import { CapsuleListState } from './info/capsule/CapsuleListState';
import { CapsulePosition } from './info/capsule/CapsulePosition';

const TAG = 'CapsuleManager';
/**
 * 横幅、实况面板状态管理
 */
class CapsuleManager {
  /**
   * 胶囊数量
   */
  public capsuleNum: number = 0;

  /**
   * capsule面板状态管理
   */
  private capsuleState: CapsuleListState = new CapsuleListState();

  /**
   * 默认样式，常量值
   */
  private defaultCapsuleStyle: LiveCapsuleStyle = new LiveCapsuleStyle();

  /**
   * 胶囊全局位置
   */
  private capsulePosition: CapsulePosition = new CapsulePosition();

  /**
   * 胶囊全局位置
   */
  private capsuleArea?: Area;

  /**
   * 动效代替胶囊显示期间的Promise
   */
  public animPromise?: CustomPromise<void>;

  /**
   * 状态切换监听
   * 宽屏状态
   * banner面板状态
   */
  private onStateChange: OnStateChangeListener = {
    onStateChange: (state: IState): void => {
      switch (state?.getStateType()) {
        case StateType.TYPE_DISPLAY_SIZE:
          this.onDisplaySizeChange(state as DisplaySizeState);
          break;
        default:
          break;
      }
    }
  };

  /**
   * 构造
   */
  constructor() {
    // 监听屏幕大小
    this.onDisplaySizeChange(baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState);
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onStateChange);
  }

  /**
   * 屏幕宽高切换处理
   *
   * @param state 屏幕大小状态
   */
  private onDisplaySizeChange = (state: DisplaySizeState): void => {
      return;
  };

  private setLiveViewCapsuleStyle(style: CapsuleListState, height: number, iconWidth: number, iconLeftMargin: number,
    mainTextWidth: number, extendTextWidth: number): void {
    style.capsuleHeight = height;
    style.capsuleIconWidth = iconWidth;
    style.capsuleIconLeftMargin = iconLeftMargin;
    style.capsuleMainTextWidth = mainTextWidth;
    style.capsuleExtendTextWidth = extendTextWidth;
  }

  /**
   * 获取banner面板状态管理器
   *
   * @returns 状态管理
   */
  getCapsuleState(): CapsuleListState {
    return this.capsuleState;
  }

  /**
   * 获取banner面板默认样式
   *
   * @returns 默认样式
   */
  getDefaultCapsuleStyle(): LiveCapsuleStyle {
    return this.defaultCapsuleStyle;
  }

  /**
   * 获取胶囊位置
   *
   * @returns 胶囊位置
   */
  getCapsulePosition(): CapsulePosition {
    return this.capsulePosition;
  }

  /**
   * 刷新胶囊位置
   *
   * @param position 组件监听回调位置
   */
  refreshCapsulePosition(position: Area): void {
    this.capsulePosition.refreshCapsulePosition(position);
    this.capsuleArea = position;
  }

  /**
   * 获取胶囊位置
   *
   * @returns 胶囊位置
   */
  getCapsuleArea(): Area | undefined {
    return this.capsuleArea;
  }

  /**
   * 是否存在胶囊
   *
   * @returns 校验结果
   */
  isExistCapsule(): boolean {
    return this.capsuleNum > 0;
  }
}

// 单例
export let capsuleStateMgr: CapsuleManager = SingletonHelper.getInstance(CapsuleManager, TAG);