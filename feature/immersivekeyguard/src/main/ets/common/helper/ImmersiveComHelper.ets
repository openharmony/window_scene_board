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

import { EvtBus } from '@ohos/frameworkwrapper';
import systemDateTime from '@ohos.systemDateTime';
import { bundleManager } from '@kit.AbilityKit';
import { StartAbilityUtil } from '@ohos/windowscene';
import { AppStorageUtil, DataProperty, LogDomain, Logger } from '@ohos/basicutils';
import { NotificationBase, NotificationUtil, WantAgentUtil } from '@ohos/systemuicommon/newTsIndex';
import { CommonConstants, PowerUtils, ScreenLockApi } from '@ohos/screenlockcommon';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { AnimationController } from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/AnimationController';
import { EnableBackGestureEvent, LiveViewEnterImmersiveEvent, LiveViewExitImmersiveEvent } from '@ohos/systemuicommon';
import { ComponentPosition, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { sharedData } from '@ohos/systemuicommon/Index';
import { CardAnimSuffix, LocationPermission } from '../constants/ImmCardConst';
import { ImmComAnimScene } from '../constants/ImmComConst';

const TAG = 'ImmersiveComHelper';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 计时器隐藏文本替代
const TIME_HIDE_FUZZ: string = '--:--';

// 计时器替代正则表达式，保持正则多实例
function timerRegx(): RegExp {
  return /\$\{placeholder.timer\}/g;
}

// 沉浸态布局中实况卡片动效状态v1兼容
const LIVE_CARD_ANIM_V1ST: WidgetAnimState = BaseState.wrap(WidgetAnimState, CardAnimSuffix.LIVE_CARD_ANIM);

/**
 * 沉浸模块通用辅助工具
 */
export class ImmersiveComHelper {
  /**
   * 私有构造
   */
  private constructor() {
  }

  /**
   * 获取当前系统时间戳
   *
   * @returns 时间戳
   */
  public static getSysTime(): number {
    try {
      return systemDateTime.getTime();
    } catch (e) {
      log.showError(TAG, 'getSysTime error.');
      return Number.MAX_VALUE;
    }
  }

  /**
   * 测试原文本中是否可以拼接计时器文本
   * undefined按纯计时器文本算
   *
   * @param oriText 原文本
   * @returns true含有计时器
   */
  public static testTimeRegx(oriText?: string): boolean {
    if (!oriText) {
      return true;
    }
    return timerRegx().test(oriText);
  }

  /**
   * 字符串中特殊标记由计时文本替换
   *
   * @param oriStr 原字串
   * @param timeStr 计时文本
   * @returns 替换后文本
   */
  public static getTimeReplaceStr(oriStr?: string, timeStr?: string): string {
    // 无计时文本，则按隐藏计时文本算
    let timeResult = timeStr ?? TIME_HIDE_FUZZ;
    // 无原文本，则按纯计时文本算
    if (!oriStr) {
      return timeResult;
    }
    // 原文本中特殊标记由计时文本替换
    return oriStr.replace(timerRegx(), timeResult);
  }

  /**
   * 目标应用是否存在定位权限
   *
   * @param bundleName 应用包名
   * @returns true存在定位权限
   */
  public static hasLocationPermission(bundleName?: string): boolean {
    let userId = AppStorage.get<number>('mCurrentUserId') ?? CommonConstants.DEFAULT_USER_ID;
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION;
    try {
      let bundleInfo = bundleManager.getBundleInfoSync(bundleName, bundleFlags, userId);
      if (!bundleInfo || !bundleInfo.reqPermissionDetails || bundleInfo.reqPermissionDetails.length === 0) {
        return false;
      }

      for (let i = 0; i < bundleInfo.reqPermissionDetails.length; i++) {
        if (bundleInfo.reqPermissionDetails[i].name === LocationPermission.APPROXIMATELY_LOCATION) {
          return bundleInfo.permissionGrantStates[i] === 0;
        }
      }
    } catch (error) {
      log.showError(TAG, 'hasLocationPermission err.');
    }
    return false;
  }

  /**
   * 用于使能锁屏back手势
   *
   * @param isEnable 是否使能back手势
   */
  public static enableBackGesture(isEnable: boolean): void {
    EvtBus.post(EnableBackGestureEvent, new EnableBackGestureEvent(isEnable, TAG));
  }

  /**
   * 沉浸数据排序比较
   *
   * @param a 比较数据
   * @param b 比较数据
   * @returns 对比结果
   */
  public static compareImmData(a: NotificationBase, b: NotificationBase): number {
    return NotificationUtil.sortComparer(a, b, NotificationUtil.getLivePriority);
  }

  /**
   * 同步实况卡片的动效控制器到播控
   */
  public static setMediaLiveCardAnim(): void {
    AnimationController.setImmLiveCardAnim(LIVE_CARD_ANIM_V1ST);
  }

  /**
   * 取用沉浸态布局中实况卡片动效控制器
   *
   * @returns 实况卡片v1动效
   */
  public static getLiveCardV1Anim(): WidgetAnimState {
    return LIVE_CARD_ANIM_V1ST;
  }

  /**
   * 分享沉浸大卡中实况卡片位置
   *
   * @param liveCardPos 实况卡片位置
   */
  public static shareLiveCardArea(liveCardPos?: ComponentPosition): void {
    sharedData?.immersiveCardRect?.update({
      x: liveCardPos?.globalX ?? 0,
      y: liveCardPos?.globalY ?? 0,
      width: liveCardPos?.width ?? 0,
      height: liveCardPos?.height ?? 0,
    });
  }

  /**
   * 取用实况列表中点击卡片的位置
   *
   * @returns 点击实况卡片位置
   */
  public static getShareLiveCardArea(): ComponentPosition {
    let shareRect = sharedData.clickCardRect;
    return { globalX: shareRect.x, globalY: shareRect.y, width: shareRect.width, height: shareRect.height, radius: 20 };
  }

  /**
   * 实况胶囊位置
   *
   * @returns 胶囊位置
   */
  public static getLiveCapArea(): ComponentPosition {
    // 实况胶囊默认大小、位置
    return { globalX: 20, globalY: 6, width: 76, height: 28, radius: 16 };
  }

  /**
   * 发送进入沉浸态事件，实况模块感知
   *
   * @param hashcode
   */
  public static postEnterImmEvent(hashcode?: string): void {
    if (!hashcode) {
      return;
    }
    log.showInfo(TAG, `postEnterImmEvent hashcode: ${hashcode}`);
    EvtBus.post(LiveViewEnterImmersiveEvent, new LiveViewEnterImmersiveEvent(hashcode));
  }

  /**
   * 发送进入沉浸态事件，实况模块感知
   *
   * @param hashcode
   */
  public static postExitImmEvent(hashcode?: string): void {
    if (!hashcode) {
      return;
    }
    log.showInfo(TAG, `postExitImmEvent hashcode: ${hashcode}`);
    EvtBus.post(LiveViewExitImmersiveEvent, new LiveViewExitImmersiveEvent(hashcode));
  }

  /**
   * 同步开启播控动效
   *
   * @param animScene 动效场景
   */
  public static startMediaAnim(animScene: ImmComAnimScene): void {
    switch (animScene) {
      case ImmComAnimScene.ANIM_CAP_CARD:
        AnimationController.startCapsuleToCardAnim();
        break;
      case ImmComAnimScene.ANIM_CARD_CAP:
        AnimationController.startCardToCapsuleAnim();
        break;
      case ImmComAnimScene.ANIM_LIST_CARD:
        AnimationController.startListToCardAnim();
        break;
      case ImmComAnimScene.ANIM_CARD_LIST:
        AnimationController.startCardToListAnim();
        break;
      default:
        break;
    }
  }

  /**
   * 启动wantAgent
   *
   * @param ntf 通知数据
   */
  public static startWantAgentWithUnlock(ntf: NotificationBase): void {
    if (ntf?.wantAgent) {
      ScreenLockApi.requestUnlock({
        success: () => {
          log.showInfo(TAG, `startWantAgentWithUnlock unlock success: ${ntf?.groupKey}`);
          WantAgentUtil.startWantAgent(ntf.wantAgent);
        },
        fail: () => {
          log.showInfo(TAG, `startWantAgentWithUnlock unlock fail: ${ntf?.groupKey}`);
        },
        cancel: () => {
          log.showInfo(TAG, `startWantAgentWithUnlock unlock cancel: ${ntf?.groupKey}`);
        }
      }, true);
    } else {
      log.showInfo(TAG, `startWantAgentWithUnlock has not agent: ${ntf?.groupKey}`);
    }
  }

  /**
   * 启动设置定位授权页面
   *
   * @param settingWant 定位授权
   */
  public static startLocationAuthWithUnlock(settingWant?: Want): void {
    if (settingWant) {
      ScreenLockApi.requestUnlock({
        success: () => {
          log.showInfo(TAG, 'startLocationAuthWithUnlock unlock success');
          StartAbilityUtil.startAbility(settingWant);
        },
        fail: () => {
          log.showInfo(TAG, 'startLocationAuthWithUnlock unlock fail');
        },
        cancel: () => {
          log.showInfo(TAG, 'startLocationAuthWithUnlock unlock cancel');
        }
      }, true);
    } else {
      log.showInfo(TAG, 'startLocationAuthWithUnlock has not setting want');
    }
  }

  /**
   * 开始来通知自动亮屏
   */
  public static startNtfAutoScreenOn(): void {
    // 自动亮屏后锁屏触发人脸解锁标记
    AppStorageUtil.setOrCreate('isNotificationWakeUpForFace', true, new DataProperty(false, false));
    PowerUtils.asyncWakeupDevice('ntf_auto_wakeup');
  }
}