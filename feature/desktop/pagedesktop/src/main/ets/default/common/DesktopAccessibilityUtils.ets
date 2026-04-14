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
import { AccessibilityManager, ResourceManager, GlobalContext } from '@ohos/frameworkwrapper';
import {
  GridLayoutItemInfo,
  CommonConstants,
  GridLayoutUtil,
  CardItemInfo,
} from '@ohos/launchercommon';
import { ResUtils } from '@ohos/windowscene';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import type ctx from '@ohos.app.ability.common';

const TAG: string = 'DesktopAccessibilityUtils';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DesktopAccessibilityUtils {

  /**
   * 获取DesktopItem的accessibilityLevel属性
   *
   * @param {GridLayoutItemInfo} item
   * @param {boolean} isAccessibilityMode 是否开启了无障碍模式
   * @returns string accessibilityLevel属性
   */
  public static getDesktopItemAccessibilityLevel(item: GridLayoutItemInfo, isAccessibilityMode: boolean): string {
    if (item && isAccessibilityMode) {
      // app
      if (item.typeId === CommonConstants.TYPE_APP) {
        return 'yes';
      }
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        return 'no';
      }
      if (item.typeId === CommonConstants.TYPE_CARD ) {
        return 'no';
      }
      if (item.typeId === CommonConstants.TYPE_FORM_STACK && (item.layoutInfo?.[0]?.length ?? 0) > 1) {
        return 'no';
      }
      if (item.typeId === CommonConstants.TYPE_CARD) {
        return 'no';
      }
    }
    return 'auto';
  }

  /**
   * 获取DesktopItem的accessibilityGroup属性
   *
   * @param {GridLayoutItemInfo} item
   * @param {boolean} isAccessibilityMode 是否开启了无障碍模式
   * @returns boolean accessibilityGroup属性
   */
  public static getDesktopItemAccessibilityGroup(item: GridLayoutItemInfo, isAccessibilityMode: boolean): boolean {
    if (item && isAccessibilityMode) {
      // app
      if (item.typeId === CommonConstants.TYPE_APP) {
        return false;
      }
    }
    return false;
  }

  /**
   * 获取外屏FormItemRelative的AccessibilityText属性
   *
   * @param {CardItemInfo} 卡片项
   * @param {isAccessibilityMode}  是否开启了无障碍模式
   * @param {isOuterDesktop} 是否在外屏
   * @returns string AccessibilityText属性
   */
  public static getOuterDesktopCardAccessibilityText(mFormItem: CardItemInfo, isAccessibilityMode: boolean,
    isOuterDesktop: boolean): string {
    if (mFormItem && isOuterDesktop && isAccessibilityMode) {
      let mResourceManager: ResourceManager = ResourceManager.getInstance();
      mResourceManager.getAppNameWithCache(mFormItem.appLabelId, mFormItem.bundleName, mFormItem.mainModuleName,
        mFormItem.appName, (name: string): void => {mFormItem.appName = name});
      log.showInfo(`getOuterDesktopCardAccessibilityText succes, appName:${mFormItem.appName},
        appLabelId:${mFormItem.appLabelId}, bundleName:${mFormItem.bundleName}, moduleName:${mFormItem.moduleName}+`);
      return `${mFormItem.appName}${ResUtils.getInnerString($r('app.string.form_service'))}` ?? '';
    }
    log.showError('getOuterDesktopCardAccessibilityText wrong, return empty string');
    return '';
  }

  /**
   * 获取DesktopItem的accessibilityText属性
   *
   * @param {GridLayoutItemInfo} 桌面项
   * @param {isAccessibilityMode} 是否开启了无障碍模式
   * @param {isOuterDesktop} 是否在外屏
   * @returns string accessibilityText属性
   */
  public static getDesktopItemAccessibilityText(item: GridLayoutItemInfo, isAccessibilityMode: boolean,
    isOuterDesktop?: boolean): string {
    if (item && isAccessibilityMode) {
      // 外屏只获取应用名称
      if (isOuterDesktop && item.typeId === CommonConstants.TYPE_APP) {
        let mResourceManager: ResourceManager = ResourceManager.getInstance();
        mResourceManager.getAppNameWithCache(item.appLabelId, item.bundleName, item.moduleName,
          item.appName, (name: string): void => {item.appName = name});
        log.showInfo(`getDesktopItemAccessibilityText succes, appName:${item.appName},
        appLabelId:${item.appLabelId}, bundleName:${item.bundleName}, moduleName:${item.moduleName}+`);
        return item.appName ?? '';
      }
    }
    log.showError('getDesktopItemAccessibilityText wrong, return empty string');
    return '';
  }

  /**
   * 在无障碍模式进入负一屏主动播报
   */
  public static async textAnnouncedForFocusNegativeScreen(): Promise<void> {
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      const desktopText: string = ResUtils.getInnerString($r('app.string.smart_assistant_today'));
      log.showInfo(`textAnnouncedForFocusDesktop ${desktopText}`);
      accessibilityManager.sendTextAnnouncedForAccessibility(desktopText, 'textAnnouncedForFocusNegativeScreen');
    }
  }

  /**
   * 在无障碍模式进入桌面主动播报
   */
  public static async textAnnouncedForFocusDesktop(): Promise<void> {
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      const desktopText: string = ResUtils.getInnerString($r('app.string.home_screen'));
      log.showInfo(`textAnnouncedForFocusDesktop ${desktopText}`);
      accessibilityManager.sendTextAnnouncedForAccessibility(desktopText, 'textAnnouncedForFocusDesktop');
    }
  }

  /**
   * 在无障碍模式主动播报当前第几屏共几屏
   */
  public static async textAnnouncedForCurrentPage(current: number, total: number): Promise<void> {
    log.showInfo(`textAnnouncedForCurrentPage current:${current}, total:${total}}`);
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      try {
        let currentPageText: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
          .resourceManager.getStringSync($r('app.string.desktop_current_page_tips').id, String(current), String(total));
        log.showInfo(`textAnnouncedForCurrentPage ${currentPageText}`);
        accessibilityManager.sendTextAnnouncedForAccessibility(currentPageText, 'textAnnouncedForCurrentPage');
      } catch (err) {
        if (err) {
          log.showError(`textAnnouncedForCurrentPage failed, Code is ${err.code}, message is ${err.message}`);
        }
      }
    }
  }

  /**
   * 在无障碍模式跳转至主屏播报
   *
   * @param current 当前页
   * @param total 页总数
   * @returns 空
   */
  public static async textAnnouncedWhenJumpToHomePage(current: number, total: number): Promise<void> {
    log.showInfo(`textAnnouncedWhenJumpToHomePage current:${current}, total:${total}}`);
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      try {
        let currentPageText: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
          .resourceManager.getStringSync($r('app.string.jump_to_homepage').id, String(current), String(total));
        log.showInfo(`textAnnouncedWhenJumpToHomePage ${currentPageText}`);
        accessibilityManager.sendTextAnnouncedForAccessibility(currentPageText, 'textAnnouncedWhenJumpToHomePage');
      } catch (err) {
        if (err) {
          log.showError(`textAnnouncedWhenJumpToHomePage failed, Code is ${err.code}, message is ${err.message}`);
        }
      }
    }
  }
}
