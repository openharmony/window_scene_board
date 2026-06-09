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

import Want from '@ohos.app.ability.Want';
import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import {
  SingletonHelper,
  CommonUtils,
  LogDomain,
  LogHelper,
  CheckEmptyUtils
} from '@ohos/basicutils';
import { LiveType, LiveViewData } from '@ohos/systemuicommon';
import { OverlayIconStyle } from '@ohos/systemuicommon';
import { ImmersiveNtfData } from '../../viewmodel/viewdata/ImmersiveNtfData';
import type NtfMgr from '@ohos.notificationManager';
import { ImmersiveCardData } from '../../viewmodel/viewdata/ImmersiveCardData';
import { transResToPicHelper } from '@ohos/systemuicommon';
import { ImmersiveCapsuleData } from '../../viewmodel/viewdata/ImmersiveCapsuleData';
import { ImmersiveCardAuthLevel, ImmersiveConstants as Constants } from '../../common/ImmersiveConstants';
import {
  ImmersiveCapsuleType,
  ImmersiveConstants
} from '@ohos/systemuicommon';
import { SysTypeCode } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import type { BaseNotification } from '@ohos/systemuicommon';
import type image from '@ohos.multimedia.image';

const TAG = 'ImmersiveNtfAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸卡片背景大图资源路径
 */
const IMMERSIVE_PIC_RES = 'PrimaryData.immersivePic.res';
/**
 * 情景模式包名
 */
const INTELLIGENT_SCENE_BUNDLE_NAME = 'com.ohos.intelligentscene';
/**
 * 沉浸卡片背景大图
 */
const IMMERSIVE_PIC = 'lockscreenPicture';

/**
 * 沉浸卡片abilityName
 */
const IMMERSIVE_ABILITY_NAME = 'PrimaryData.immersiveAbilityName';

/**
 * 沉浸卡片parameters
 */
const IMMERSIVE_PARAMETERS = 'PrimaryData.immersiveParameters';

/**
 * 沉浸卡片UIExtension字段名
 */
const IMMERSIVE_UIEXTENSION_TYPE = 'ability.want.params.uiExtensionType';

/**
 * 沉浸卡片UIExtension过滤类型
 */
const IMMERSIVE_UIEXTENSION_NAME = 'liveViewLockScreen';

const IMMERSIVE_SUPPORT_INTERACT = 'isSupportInteraction';

/**
 * 权益key
 */
const IMMERSIVE_AUTH_DATA_KEY = 'eventControl';

/**
 * 权益val
 */
const IMMERSIVE_AUTH_DATA_VAL = 'lockScreen';

// 沉浸态常亮开关
const IMM_KEEP_SCREEN_ON = 'openharmony_live_view_keep_screen_on';

// 开关标示
const FLAG_ENABLE = 'true';

/**
 * key值：(不传该key值表示支持交互)
 * isSupportInteraction
 * value值：
 * 0-不支持
 * 1-支持
 */
const IMMERSIVE_INTERACT_FALG = '1';

/**
 * 沉浸卡片获取UIExtension安装包信息bundleFlags
 */
const BUNDLE_FLAGS = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
 bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY;

/**
 * 计数最大值
 */
const MAX_ID = 1000;

/**
 * 计数初始值
 */
const ID_INIT_VALUE = 0;

/**
 * 解析封装沉浸式锁屏数据
 */
class ImmersiveNtfAdapter {
  /**
   * 记录通知数据的id,用于区分数据的新增、更新等
   */
  private id: number = ID_INIT_VALUE;

  /**
   * 解析封装沉浸锁屏数据
   *
   * @param entry 通知请求
   * @param liveViewData 实况通知数据
   * @param ntfInfo 普通通知数据
   * @returns 沉浸式锁屏数据
   */
  parse(entry?: BaseNotification): ImmersiveNtfData | undefined {
    if (entry === undefined || entry.hashCode === undefined) {
      return undefined;
    }
    if (entry?.isLiveType()) {
      transResToPicHelper.start(entry.creatorBundleName);
    }
    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    this.parseCommonData(immersiveNtfData, entry);
    this.parseImmersiveLiveData(immersiveNtfData, entry.request!, entry.liveViewData);
    this.parseImmersiveCapsuleData(immersiveNtfData, entry.liveViewData, entry);
    immersiveNtfData.setAppIcon(entry?.appIcon);
    immersiveNtfData.setAppName(entry?.appName?.value);
    if (entry?.isLiveType()) {
      transResToPicHelper.end();
    }
    return immersiveNtfData;
  }

  /**
   * 封装沉浸式锁屏公有数据
   *
   * @param immersiveNtfData 沉浸式锁屏数据
   * @param request 通知请求
   */
  private parseCommonData(immersiveNtfData: ImmersiveNtfData, entry: BaseNotification): void {
    immersiveNtfData.hashCode = entry.hashCode;
    immersiveNtfData.groupKey = entry.getGroupKey();
    immersiveNtfData.creatorBundleName = entry.request?.creatorBundleName ?? '';
    immersiveNtfData.wantAgent = entry.wantAgent;
    immersiveNtfData.id = this.id;
    this.id++;
    if (this.id > MAX_ID) {
      this.id = ID_INIT_VALUE;
    }
  }

  /**
   * 解析封装沉浸卡片数据
   *
   * @param immersiveNtfData 沉浸式锁屏数据
   * @param request 通知请求
   * @param liveViewData 实况数据
   * @returns ImmersiveCardData 沉浸卡片数据
   */
  private parseImmersiveLiveData(immersiveNtfData: ImmersiveNtfData, request: NtfMgr.NotificationRequest,
    liveViewData?: LiveViewData): void {
    // 普通通知无须封装实况数据
    if (!liveViewData) {
      log.showDebug('no live view data');
      return;
    }
    let immersiveLiveViewData: ImmersiveCardData = new ImmersiveCardData();
    immersiveLiveViewData.liveType = liveViewData.liveType;
    immersiveLiveViewData.liveView = liveViewData;
    immersiveLiveViewData.isSupportInteraction = false;
    let bigIcon = request?.content?.liveView?.[IMMERSIVE_PIC] as image.PixelMap;
    immersiveLiveViewData.setBigIcon(bigIcon);
    let bigIconRes = request?.content?.liveView?.extraInfo?.[IMMERSIVE_PIC_RES] as string;
    immersiveLiveViewData.setBigIconRes(bigIconRes);

    log.showInfo(`liveViewData.liveType:${liveViewData.liveType} typeCode:${request?.content?.systemLiveView?.typeCode}`);
    // 情景模式定制数据
    if (request?.content?.systemLiveView?.typeCode === SysTypeCode.SCENARIO_MODE) {
      this.parseIntelligentImmersiveLiveData(immersiveLiveViewData, request);
    } else {
      this.handleCommonImmersiveLiveData(immersiveLiveViewData, request, immersiveNtfData);
    }

    immersiveNtfData.setCardData(immersiveLiveViewData);
  }

  /**
   * 解析公共模式接入沉浸实况数据
   *
   * @param immersiveNtfData 沉浸式锁屏数据
   * @param request 通知请求
   * @param immersiveLiveViewData 沉浸卡片数据
   */
  private handleCommonImmersiveLiveData(immersiveLiveViewData: ImmersiveCardData,
    request: NtfMgr.NotificationRequest, immersiveNtfData: ImmersiveNtfData): void {
    let immersiveAbilityName = request?.content?.liveView?.extraInfo?.[IMMERSIVE_ABILITY_NAME] as string;
    let immersiveParameters = request?.content?.liveView?.extraInfo?.[IMMERSIVE_PARAMETERS] as Record<string, Object>;
    // 常亮开关
    let isKeepScreenOnEnable = false;
    if (immersiveAbilityName) {
      if (!immersiveParameters) {
        immersiveParameters = {};
      }
      let liveViewId = request?.id as number;
      immersiveParameters.id = liveViewId;
      let bundleName = immersiveNtfData.creatorBundleName;
      if (this.checkUIExtensionBundleInfo(bundleName, immersiveAbilityName)) {
        // 校验通过后在参数中添加类型传入UIExtensionComponent
        immersiveParameters[IMMERSIVE_UIEXTENSION_TYPE] = IMMERSIVE_UIEXTENSION_NAME;
        let want: Want = {
          bundleName: bundleName,
          abilityName: immersiveAbilityName,
          parameters: immersiveParameters
        };
        immersiveLiveViewData.setWantInfo(want);
        let isSupportInteraction = immersiveParameters[IMMERSIVE_SUPPORT_INTERACT] === IMMERSIVE_INTERACT_FALG;
        immersiveLiveViewData.setIsSupportInteraction(isSupportInteraction);
        isKeepScreenOnEnable = String(immersiveParameters[IMM_KEEP_SCREEN_ON]).toString() === FLAG_ENABLE;
        log.showInfo(`handleCommonImmersiveLiveData: ${isSupportInteraction}, ${isKeepScreenOnEnable}, ${bundleName}`);
      }
    }
    // 常亮开关只允许导航类型
    isKeepScreenOnEnable = isKeepScreenOnEnable && immersiveLiveViewData.isNavigationType();
    immersiveLiveViewData.setKeepScreenOnEnable(isKeepScreenOnEnable);
    this.setAuthData(immersiveLiveViewData, request);
  }

  private setAuthData(immersiveLiveViewData: ImmersiveCardData, request: NtfMgr.NotificationRequest): void {
    let lockScreen = ImmersiveCardAuthLevel.INVALID_AUTH;
    if (request?.content?.liveView?.extraInfo?.[IMMERSIVE_AUTH_DATA_KEY]) {
      try {
        lockScreen = (JSON.parse(request?.content?.liveView?.extraInfo?.[IMMERSIVE_AUTH_DATA_KEY] as string ?? '')?.[
        IMMERSIVE_AUTH_DATA_VAL]) as number ?? ImmersiveCardAuthLevel.INVALID_AUTH;
      } catch (err) {
        log.showError(`json parse failed.`);
      }
    }
    log.showInfo(`setAuthData ${lockScreen}, ${request?.content?.liveView?.extraInfo?.[IMMERSIVE_AUTH_DATA_KEY]}`);
    immersiveLiveViewData.setImmersiveCardAuthLevel(lockScreen);
    // 应用申请交互权益并且主动开启交互开关
    if ((immersiveLiveViewData?.isSupportInteraction &&
      lockScreen === ImmersiveCardAuthLevel.DYNAMIC_IMAGE_RIGHT_WITH_INTERACTION) ||
    Constants.isInInteractWhiteList(immersiveLiveViewData?.immersiveWant?.bundleName,
      immersiveLiveViewData?.immersiveWant?.abilityName)) {
      immersiveLiveViewData.setIsSupportInteraction(true);
    } else {
      immersiveLiveViewData.setIsSupportInteraction(false);
    }
  }
  /**
   * 解析情景模式接入沉浸实况数据
   *
   * @param immersiveLiveViewData 沉浸卡片数据
   * @param request 通知请求
   */
  private parseIntelligentImmersiveLiveData(immersiveLiveViewData: ImmersiveCardData,
    request: NtfMgr.NotificationRequest): void {
    let immersiveAbilityName = request?.extraInfo?.[IMMERSIVE_ABILITY_NAME] as string;
    let immersiveParameters = request?.extraInfo?.[IMMERSIVE_PARAMETERS] as Record<string, Object>;

    if (immersiveAbilityName) {
      if (!immersiveParameters) {
        immersiveParameters = {};
      }
      immersiveParameters[IMMERSIVE_UIEXTENSION_TYPE] = IMMERSIVE_UIEXTENSION_NAME;
      let liveViewId = request?.id as number;
      immersiveParameters.id = liveViewId;
      let want: Want = {
        bundleName: INTELLIGENT_SCENE_BUNDLE_NAME,
        abilityName: immersiveAbilityName,
        parameters: immersiveParameters
      };

      immersiveLiveViewData.setWantInfo(want);
      immersiveLiveViewData
        .setIsSupportInteraction(immersiveParameters[IMMERSIVE_SUPPORT_INTERACT] === IMMERSIVE_INTERACT_FALG);
      log.showInfo(`parseIntelligentImmersiveLiveData: isSupportInteraction:${immersiveParameters[IMMERSIVE_SUPPORT_INTERACT]}`);
    }
    this.setAuthData(immersiveLiveViewData, request);
  }

  /**
   * 获取和校验应用包信息
   *
   * @param bundleName 包名
   * @param abilityName abilityName
   * @returns 判断通知的UIExtension类型是否符合要求
   */
  private checkUIExtensionBundleInfo(bundleName: string, abilityName: string): boolean {
    if (!bundleName || !abilityName) {
      log.showError('invalid bundle name or ability name.');
      return false;
    }
    let bundleInfo: bundleManager.BundleInfo;
    try {
      bundleInfo = bundleManager.getBundleInfoSync(bundleName, BUNDLE_FLAGS);
    } catch (err) {
      let code = (err as BusinessError)?.code;
      log.showError(`getBundleInfoSync failed error code: ${code}`);
      return false;
    }
    if (CheckEmptyUtils.isEmpty(bundleInfo)) {
      log.showError('getBundleInfoSync bundleInfo is empty');
      return false;
    }
    return this.checkUIExtensionType(bundleInfo, abilityName);
  }

  /**
   * 校验应用UIExtension类型
   *
   * @param bundleInfo 包信息
   * @param abilityName abilityName
   * @returns 判断通知的UIExtension类型是否符合要求
   */
  private checkUIExtensionType(bundleInfo: bundleManager.BundleInfo, abilityName: string): boolean {
    if (CheckEmptyUtils.isEmptyArr(bundleInfo.hapModulesInfo)) {
      log.showWarn('getBundleInfoSync bundleInfo.hapModulesInfo is empty');
      return false;
    }
    for (let i = 0; i < bundleInfo.hapModulesInfo.length; i++) {
      if (CheckEmptyUtils.isEmptyArr(bundleInfo.hapModulesInfo[i].extensionAbilitiesInfo)) {
        continue;
      }
      for (let j = 0; j < bundleInfo.hapModulesInfo[i].extensionAbilitiesInfo.length; j++) {
        if (bundleInfo.hapModulesInfo[i].extensionAbilitiesInfo[j].name !== abilityName) {
          continue;
        }
        if (bundleInfo.hapModulesInfo[i].extensionAbilitiesInfo[j].extensionAbilityTypeName ===
          IMMERSIVE_UIEXTENSION_NAME) {
          return true;
        }
      }
    }
    log.showWarn('not find a extensionAbility that meets the requirements');
    return false;
  }

  /**
   * 解析封装沉浸胶囊数据
   *
   * @param immersiveNtfData 沉浸式锁屏数据
   * @param liveViewData 实况数据
   * @param ntfInfo 普通通知数据
   */
  private parseImmersiveCapsuleData(immersiveNtfData: ImmersiveNtfData, liveViewData?: LiveViewData,
                                    ntfInfo?: BaseNotification): void {
    let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
    capsuleData.setCapsuleType(liveViewData ? ImmersiveCapsuleType.LIVE_VIEW : ImmersiveCapsuleType.NORMAL);
    capsuleData.setHashCode(ntfInfo?.hashCode);
    capsuleData.setGroupKey(immersiveNtfData.groupKey);
    capsuleData.setTitle(ntfInfo?.notificationContent?.contentTitle);
    capsuleData.setContent(ntfInfo?.notificationContent?.contentText);
    capsuleData.setNtfHide(ntfInfo?.isHideContent ?? false);
    capsuleData.setOverlayIcon(ntfInfo?.overlayIcon);
    capsuleData.setOverlayIconStyle(ntfInfo?.overlayIconStyle ?? OverlayIconStyle.CIRCLE);
    if (ntfInfo?.isFromSystemApp) {
      capsuleData.setSmallIcon(ntfInfo?.smallIcon);
    }
    capsuleData.setLiveView(liveViewData);
    capsuleData.setBundleName(ntfInfo?.creatorBundleName);
    capsuleData.setAppIndex(ntfInfo?.appIndex);
    capsuleData.setAppLocked(ntfInfo?.isAppLocked);
    capsuleData.setProgressType(capsuleData.hasProgress());
    capsuleData.setCapRemindType(liveViewData?.capsule?.isRemind);
    immersiveNtfData.setCapsuleData(capsuleData, true);
  }
}

// 单例
export let immersiveNtfAdapter = SingletonHelper.getInstance(ImmersiveNtfAdapter, TAG);