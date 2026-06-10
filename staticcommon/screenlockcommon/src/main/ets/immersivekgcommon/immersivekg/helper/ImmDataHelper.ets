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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'ImmDataHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 有效UIExtension限制
const VALID_UI_EXTENSION_WANTS: Map<string, string> = new Map([
// 运动健康
  ['com.ohos.health', 'LiveViewAbility'],
  // Petal出行
  ['com.ohos.maps.app', 'NavigationLiveView'],
  // 美团
  ['com.sankuai.hmeituan', 'MtLiveViewLockScreenExtAbility'],
  // 东方航空
  ['com.ceair.hos', 'LiveLockScreenExtAbility'],
  // 高德地图
  ['com.amap.hmapp', 'LiveViewExtAbility'],
  // 情景模式
  ['com.ohos.intelligentscene', 'IntelligentSceneUIExtLockScreenAbility'],
]);

// 默认允许UIExtension事件交互名单
const VALID_INTERACTION_BUNDLE: string[] = [
  // 美团
  'com.sankuai.hmeituan',
  // 情景模式
  'com.ohos.intelligentscene'
];

// 沉浸卡片获取UIExtension安装包信息bundleFlags
const BUNDLE_FLAGS = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
  bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY;

/**
 * 沉浸通知数据辅助工具
 */
export class ImmDataHelper {
  // extensionAbilityTypeName匹配沉浸卡片UIExtension
  public static readonly EXT_ABILITY_TYPE_IMMERSIVE = 'liveViewLockScreen';

  // 情景模式包名
  public static readonly INTELLIGENT_BUNDLE_NAME = 'com.ohos.intelligentscene';

  // 实例
  private static sInstance?: ImmDataHelper;

  /**
   * 检测目标UIExtension是否有效
   *
   * @param bundleName 目标包名
   * @param abilityName 目标ability名
   * @returns true有效
   */
  public checkUIExtensionValid(bundleName?: string, abilityName?: string): boolean {
    if (!bundleName || !abilityName) {
      log.showWarn('checkUiExtensionValid has not UIExtension ability.');
      return false;
    }
    // 目标ability限制
    if (VALID_UI_EXTENSION_WANTS.get(bundleName) !== abilityName) {
      log.showWarn(`checkUIExtensionValid match ability fail. ${bundleName}`);
      return false;
    }
    try {
      let bundleInfo = bundleManager.getBundleInfoSync(bundleName, BUNDLE_FLAGS);
      let moduleInfo = bundleInfo?.hapModulesInfo?.find((moduleInfo) => {
        let extInfo = moduleInfo.extensionAbilitiesInfo?.find((extAbilityInfo) => {
          return extAbilityInfo.extensionAbilityTypeName === ImmDataHelper.EXT_ABILITY_TYPE_IMMERSIVE;
        });
        return Boolean(extInfo);
      });
      let isFindValidInfo = Boolean(moduleInfo);
      log.showInfo(`checkUIExtensionValid has valid info: ${isFindValidInfo}`);
      return isFindValidInfo;
    } catch (e) {
      log.showError(`checkUIExtensionValid bundle err: ${(e as BusinessError)?.code}`);
    }
    return false;
  }

  /**
   * 目标应用UIExtension是否支持交互
   *
   * @param bundleName 目标应用包名
   * @returns true支持交互
   */
  public isSupportInteraction(bundleName: string): boolean {
    return ArrayUtils.contains(VALID_INTERACTION_BUNDLE, bundleName);
  }

  /**
   * 单例实例获取
   *
   * @returns 实例
   */
  public static getInstance(): ImmDataHelper {
    if (!ImmDataHelper.sInstance) {
      ImmDataHelper.sInstance = new ImmDataHelper();
    }
    return ImmDataHelper.sInstance;
  }
}