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

import { CommonUtils } from '@ohos/basicutils';
import type { IState } from '@ohos/systemuiutils';
import { StateType } from '@ohos/systemuiutils';

/**
 * 沉浸类型切换场景
 */
export enum ImmersiveTypeScene {
  /**
   * 手势返回
   */
  SCENE_GESTURE_BACK = 'gestureBack',

  /**
   * 沉浸列表下滑
   */
  SCENE_LIST_DOWN_SCROLL = 'listDownScroll',

  /**
   * 沉浸胶囊上滑
   */
  SCENE_CAP_UP_SCROLL = 'capUpScroll',

  /**
   * 沉浸胶囊点击
   */
  SCENE_CAP_CLICK = 'capClick',

  /**
   * 列表点击
   */
  SCENE_LIST_ITEM_CLICK = 'listItemClick',

  /**
   * 默认进沉浸态
   */
  SCENE_DEFAULT_IMM = 'defaultEnterImm',

  /**
   * 大卡上滑
   */
  SCENE_CARD_UP_SCROLL = 'cardUpScroll',

  /**
   * 大卡下滑
   */
  SCENE_CARD_DOWN_SCROLL = 'cardDownScroll',

  /**
   * 通话实况切换列表态
   */
  SCENE_PHONE_SWITCH_LIST = 'phoneSwitchList',

  /**
   * 实况胶囊过渡实况列表场景退出沉浸态
   */
  SCENE_LIVE_CAP_LIST = 'liveCapToLiveList',

  /**
   * 实况列表条目头图点击过渡沉浸态
   */
  SCENE_LIVE_LIST_CARD = 'liveListClickToImmCard',
}

/**
 * 沉浸锁屏显示类型
 */
export enum ImmersiveType {
  /**
   * 列表
   */
  TYPE_LIST,

  /**
   * 胶囊
   */
  TYPE_CAPSULE,

  /**
   * 沉浸态
   */
  TYPE_IMMERSIVE,

  /**
   * 宽布局态
   */
  TYPE_WIDTH_DISPLAY_STATE,
}

/**
 * 沉浸锁屏显示状态
 */
@Observed
export class ImmersiveState implements IState {
  /**
   * 沉浸锁屏显示类型
   */
  @Track immersiveType: ImmersiveType = ImmersiveType.TYPE_CAPSULE;

  /**
   * 切换场景
   */
  @Track changeScene?: ImmersiveTypeScene;

  @Track ntfNum: number;

  @Track isMediaCard: boolean;

  /**
   * 判断是否是列表态
   *
   * @param type 目标类型
   * @returns 是否是列表态
   */
  isList(type?: ImmersiveType): boolean {
    return this.getValidType(type) === ImmersiveType.TYPE_LIST;
  }

  /**
   * 判断是否是胶囊态
   *
   * @param type 目标类型
   * @returns 是否是胶囊态
   */
  isCapsule(type?: ImmersiveType): boolean {
    return this.getValidType(type) === ImmersiveType.TYPE_CAPSULE;
  }

  /**
   * 判断是否是沉浸态
   *
   * @param type 目标类型
   * @returns 是否是沉浸态
   */
  isImmersive(type?: ImmersiveType): boolean {
    return this.getValidType(type) === ImmersiveType.TYPE_IMMERSIVE;
  }

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE;
  }

  /**
   * 判断是否显示列表
   *
   * @param type 目标类型
   * @returns 是否显示列表
   */
  isShowList(type?: ImmersiveType): boolean {
    return this.isList(type);
  }

  /**
   * 判断是否显示胶囊
   *
   * @param type 目标类型
   * @returns 是否显示胶囊
   */
  isShowCapsule(type?: ImmersiveType): boolean {
    return this.isCapsule(type) || this.isImmersive(type);
  }

  /**
   * 判断是否显示卡片
   *
   * @param type 目标类型
   * @returns 是否显示卡片
   */
  isShowCard(type?: ImmersiveType): boolean {
    return this.isImmersive(type);
  }

  /**
   * 判断是否存在通知胶囊
   *
   * @returns 是否存在通知胶囊
   */
  isCapsuleShow(): boolean {
    if (this.ntfNum <= 0) {
      return false;
    }
    if (this.isCapsule()) {
      return true;
    }
    if (this.isImmersive() && this.ntfNum > 1) {
      return true;
    }
    return false;
  }

  /**
   * 判断是否播控沉浸态
   *
   * @returns 是否播控沉浸态
   */
  isMediaImmersive(): boolean {
    return this.isMediaCard;
  }

  /**
   * 更新通知数量
   *
   * @param num 通知数量
   */
  updateNtfNumber(num: number): void {
    this.ntfNum = num;
  }

  /**
   * 有效类型
   *
   * @param type 目标类型
   * @returns 有效类型
   */
  private getValidType(type?: ImmersiveType): ImmersiveType {
    if (CommonUtils.isInvalid(type)) {
      return this.immersiveType;
    }
    return type;
  }
}

/**
 * 指纹状态
 */
@Observed
export class FingerprintState implements IState {
  /**
   * 是否是屏上低位指纹
   */
  isUnderScreenLowPosition: boolean = false;

  /**
   * 是否开启指纹识别功能
   */
  isEnable: boolean = false;

  /**
   * 指纹高度
   */
  fingerHeight: number = 0;

  /**
   * 指纹类型
   */
  fingerType: number = 0;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_FINGERPRINT;
  }

  /**
   * 是否是屏上低位指纹
   *
   * @returns 是否是屏上低位指纹
   */
  isUnderScreenLowPos(): boolean {
    return this.isUnderScreenLowPosition;
  }

  /**
   * 是否开启识别
   *
   * @returns 是否开启识别
   */
  isEnableRecognition(): boolean {
    return this.isEnable;
  }

  /**
   * 是否是屏上低位指纹识别, 仅开启指纹状态下有效
   *
   * @returns 是否是屏上低位指纹识别
   */
  isLowPosRecognition(): boolean {
    return this.isEnableRecognition() && this.isUnderScreenLowPos();
  }
}

/**
 * 沉浸锁屏状态
 */
@Observed
export class ImmersiveKeyguardState {
  /**
   * 进入沉浸态前的状态
   */
  beforeImmersiveState: ImmersiveState = new ImmersiveState();

  /**
   * 沉浸状态
   */
  immersiveState: ImmersiveState = new ImmersiveState();

  /**
   * 指纹状态
   */
  fingerprintState: FingerprintState = new FingerprintState();
}