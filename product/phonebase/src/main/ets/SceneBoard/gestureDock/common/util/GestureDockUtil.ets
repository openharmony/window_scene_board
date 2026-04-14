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

import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { SCBSceneInfo, SCBSceneSessionManager, SceneInfoAdapterUtil, ScenePanelState } from '@ohos/windowscene';

import { bundleManager } from '@kit.AbilityKit';
import { GestureDockConstants } from '../GestureDockConstants';
import { GestureDockItemInfo } from '../../dockbar/model/GestureDockItemInfo';
import Prompt from '@ohos.promptAction';
import { AppItemInfo, CommonConstants, DockItemInfo, RdbStoreManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import lazy { AppModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { inputMethod } from '@kit.IMEKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';

const TAG = 'GestureDockUtil';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * Gesture Dock utils
 */
export class GestureDockUtil {
  /**
   * 判断T[]是否为空
   *
   * @param arr
   * @returns isEmptyArr
   */
  public static isEmptyArr<T>(arr: T[]): boolean {
    return arr === undefined || arr === null || arr.length === 0;
  }

  /**
   * showToast
   */
  public static showToast(): void {
    try {
      Prompt.showToast({
        message: $r('app.string.gesture_dock_add_limit', GestureDockConstants.MAX_CUSTOM_COUNT),
        showMode: Prompt.ToastShowMode.SYSTEM_TOP_MOST,
      });
    } catch (err) {
      log.error(`show gesture dock toast failed, error -> ${err}`);
    }
  }

  /**
   * hideTextInput
   */
  public static hideTextInput(): void {
    inputMethod.getController().hideTextInput((err: BusinessError) => {
      if (err) {
        log.showError(`Failed to hideTextInput: ${err.message}`);
        return;
      }
      log.showInfo('Succeeded in hiding text input.');
    });
  }

  /**
   * 获取侧边dock的itemKey
   *
   * @param type 侧边栏区域type
   * @param direction 侧边dock方向
   * @param index item的index
   * @param item GestureDockItemInfo
   * @returns itemKey
   */
  public static getItemKey(type: string, direction: number, index: number, item: GestureDockItemInfo): string {
    let itemKey = `${type}_${direction}_${item.bundleName}_${item.abilityName}_${item.appIndex}`;
    let appKey = itemKey + `${item.installTime}_${item.appIconId}`;
    return CheckEmptyUtils.isEmpty(item.bundleName) ? appKey + `_${index}` : appKey;
  }

  /**
   * get AppIcon Opacity
   *
   * @param item
   * @returns item opacity
   */
  public static getAppIconOpacity(item: GestureDockItemInfo): number {
    return GestureDockUtil.isNeedUpdateAppIconOpacity(item) ? GestureDockConstants.APP_ICON_OPACITY_60 :
    GestureDockConstants.APP_ICON_OPACITY_100;
  }

  /**
   * is need update AppIcon Opacity
   *
   * @param item
   * @returns isNeedUpdateAppIconOpacity
   */
  public static isNeedUpdateAppIconOpacity(item: GestureDockItemInfo): boolean {
    let scenePanelState = AppStorage.get<number>('scenePanelState');
    if (scenePanelState === ScenePanelState.RECENT) {
      log.showDebug(`scenePanelState is RECENT, return`);
      return false;
    }
    let adapterSceneInfo: SCBSceneInfo = SceneInfoAdapterUtil.getAdapterSceneInfo(item.bundleName,
      item.moduleName, item.abilityName, item.appIndex);
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    let activeContainerSession = containerSessionList.getTopActiveSession();
    if (GestureDockUtil.isNonMultiAndSameBundleAppIndex(adapterSceneInfo,
      activeContainerSession?.primarySession?.sceneInfo) || GestureDockUtil.isNonMultiAndSameBundleAppIndex(
        adapterSceneInfo, activeContainerSession?.secondarySession?.sceneInfo)) {
      return true;
    }
    let floatContainerSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    for (let floatContainerSession of floatContainerSessionList) {
      if (floatContainerSession.isActive && !floatContainerSession.floatingParam.isFloatingSceneClosed() &&
      GestureDockUtil.isNonMultiAndSameBundleAppIndex(adapterSceneInfo,
        floatContainerSession.primarySession?.sceneInfo)) {
        return true;
      }
    }
    return false;
  }

  private static isNonMultiAndSameBundleAppIndex(item: SCBSceneInfo, sceneInfo?: SCBSceneInfo,): boolean {
    if (sceneInfo === undefined) {
      return false;
    }
    return sceneInfo?.launchType !== bundleManager.LaunchType.MULTITON && sceneInfo?.bundleName === item.bundleName &&
      sceneInfo?.appIndex === item.appIndex;
  }

  /**
   * 两个应用是否相同
   *
   * @param item1
   * @param item2
   * @returns TwoAppItemsSame
   */
  public static areTwoAppItemsSame(item1: AppItemInfo | undefined, item2: AppItemInfo | undefined): boolean {
    if (!item1 || !item2) {
      return false;
    }
    return item1.bundleName === item2.bundleName && item1.appIndex === item2.appIndex &&
      item1.abilityName === item2.abilityName;
  }

  /**
   * 图片相关类资源释放
   *
   * @param imageSource 待释放的图片资源对象类
   * @param methodName 调用释放资源的方法名称
   */
  public static releaseSrc(imageSource: image.PixelMap, methodName: string): void {
    if (imageSource) {
      imageSource.release((err: BusinessError) => {
        if (err) {
          log.showError(`${methodName} Failed to release imageSource object.`);
        }
      });
    }
  }

  /**
   * 构建一个DockItemInfo
   *
   * @param appInfo
   * @returns
   */
  public static buildDockItemInfo(appInfo: AppItemInfo): DockItemInfo {
    let isFolder: boolean = appInfo.typeId === CommonConstants.TYPE_FOLDER;
    const dockItemInfo = new DockItemInfo();
    dockItemInfo.itemType = appInfo.typeId;
    dockItemInfo.typeId = appInfo.typeId;
    dockItemInfo.editable = true;
    dockItemInfo.appId = RdbStoreManager.getInstance().generateRandomUUID(false);
    dockItemInfo.appName = appInfo.appName;
    dockItemInfo.bundleName = appInfo.bundleName;
    dockItemInfo.moduleName = appInfo.moduleName;
    dockItemInfo.abilityName = appInfo.abilityName;
    dockItemInfo.keyName = appInfo.keyName;
    dockItemInfo.appIconId = appInfo.appIconId;
    dockItemInfo.appLabelId = appInfo.appLabelId;
    dockItemInfo.applicationLabelId = appInfo.applicationLabelId;
    dockItemInfo.applicationName = appInfo.applicationName;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.isUninstallAble = appInfo.isUninstallAble;
    dockItemInfo.codePath = appInfo?.codePath;
    dockItemInfo.visible = true;
    dockItemInfo.row = 0;
    dockItemInfo.iconResource = appInfo?.iconResource;
    dockItemInfo.column = appInfo.column;
    dockItemInfo.area = [1, 1];
    dockItemInfo.badgeNumber = appInfo.badgeNumber;
    dockItemInfo.layoutInfo = isFolder ? (appInfo as DockItemInfo).layoutInfo : undefined;
    dockItemInfo.appIndex = appInfo.appIndex;
    dockItemInfo.shortcutId = appInfo.shortcutId;
    dockItemInfo.enableNewAppInstance = appInfo.enableNewAppInstance;
    dockItemInfo.isActionItem = appInfo.isActionItem;
    dockItemInfo.intent = appInfo.intent;
    return dockItemInfo;
  }

  /**
   * 构建一个SceneInfo
   * @param appItemInfo
   * @param parameters
   * @returns 目标应用信息
   */
  public static buildSceneInfoByAppItem(appItemInfo: AppItemInfo,
    parameters: Record<string, Object> = {}): SCBSceneInfo {
    let bundleName: string;
    let moduleName: string;
    let abilityName: string;
    let appIndex = appItemInfo.appIndex;
    bundleName = appItemInfo.bundleName;
    moduleName = appItemInfo.moduleName ?? '';
    abilityName = appItemInfo.abilityName;
    log.showInfo(`appItemInfo bundleName:${appItemInfo.bundleName} target bundleName:${bundleName}`);
    let sceneInfo: SCBSceneInfo = SceneInfoAdapterUtil.getAdapterSceneInfo(bundleName, moduleName,
      abilityName, appIndex);
    let queryKey = bundleName + moduleName + abilityName;
    sceneInfo.launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    if (!sceneInfo.want) {
      sceneInfo.want = {}
    }
    if (!sceneInfo.want.bundleName) {
      sceneInfo.want.bundleName = sceneInfo.bundleName;
      sceneInfo.want.abilityName = sceneInfo.abilityName;
      sceneInfo.want.moduleName = sceneInfo.moduleName;
    }
    sceneInfo.want.parameters = parameters;
    return sceneInfo;
  }

  /**
   * 获得目标启动应用的包名
   * @param installSource
   * @returns 目标启动应用的包名
   */
  public static getTargetBundleName(installSource: string): string {
    let newBundleName: string;
    newBundleName = '';
    log.showDebug(`getTargetBundleName, newBundleName = ${newBundleName} installSource ${installSource}`);
    return newBundleName;
  }
}