/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, SettingsUtil } from '@ohos/frameworkwrapper';
import { UIContext } from '@kit.ArkUI';
import { PowerStatus } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { osAccount } from '@kit.BasicServicesKit';

const TAG = 'PCUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PCUtils {
  private static statusBarType: number | undefined;

  private static readonly DEFAULT_ENABLE_ANIMATION: string = 'true';

  private static readonly enterSpaceEnabled =
    systemParameterEnhance.getSync('persist.space_mgr_service.enterprise_space_enable', 'empty') === 'true';

  /**
   * whether the device version is 2D version
   *
   * @return true 2D version
   */
  public static is2D(): boolean {
    if (DeviceHelper.isPC() && DeviceHelper.isEmulator()) {
      return true;
    }
    if (!PCUtils.isEnableDesktopFeatureAnimation()) {
      return true;
    }
    return false;
  }

  public static isEnableDesktopFeatureAnimation(): boolean {
    try {
      return systemParameterEnhance.getSync('const.pcsceneboard.enable_desktop_feature_animation',
        PCUtils.DEFAULT_ENABLE_ANIMATION) === PCUtils.DEFAULT_ENABLE_ANIMATION;
    } catch (e) {
      log.showError('Get enable desktop feature animation state failed');
      return true;
    }
  }

  /**
   * whether the device is DoubleSpace
   *
   * @returns true DoubleSpace
   */
  public static getIsEnterSpaceEnabled(): boolean {
    return PCUtils.enterSpaceEnabled;
  }

  /**
   * Converts a value in vp units to a value in px with UiContext
   *
   * @param uiContext the current UIContext instance
   * @param value the value
   * @returns
   */
  public static vp2px(uiContext: UIContext, value: number): number {
    return uiContext ? uiContext.vp2px(value) : vp2px(value);
  }

  /**
   * Converts a value in px units to a value in vp with UiContext
   *
   * @param uiContext the current UIContext instance
   * @param value the value
   * @returns
   */
  public static px2vp(uiContext: UIContext, value: number): number {
    return uiContext ? uiContext.px2vp(value) : px2vp(value);
  }

  /**
   * Indicate whether the device status is CenterStatus
   *
   * @returns if the device is CenterStatus, return true
   */
  public static isCenterStatus(): boolean {
    const isWindowScenesUnlock = AppStorage.get('isWindowScenesUnlock') as boolean;
    return AppStorage.get('powerStatus') === PowerStatus.RUNNING && !isWindowScenesUnlock;
  }

  private static onStatusBarTypeChanged(statusBarType: number): void {
    PCUtils.statusBarType = statusBarType;
    log.showInfo(`statusBarType updated to ${PCUtils.statusBarType}`);
  }

  /**
   * Check if disable modify wallpaper
   *
   * @returns if disable, return true
   */
  public static async isModifyWallpaperDisable(): Promise<boolean> {
    try {
      const isEnterpriseDevice: boolean =
        systemParameterEnhance.getSync('const.edm.is_enterprise_device', 'false') === 'true';
      if (!isEnterpriseDevice) {
        log.showInfo('not enterprise device');
        return false;
      }
      const result: boolean =
        await osAccount.getAccountManager().isOsAccountConstraintEnabled('constraint.wallpaper.set');
      log.showInfo(`set wallpaper isOsAccountConstraintEnabled : ${result}`);
      return result;
    } catch (e) {
      log.showError(`get isModifyWallpaperDisable error, code:${e?.code} message:${e?.message}`);
      return false;
    }
  }

  /**
   * Read status bar type
   *
   * @returns StatusBarType
   */
  public static readStatusBarType(): number {
    if (PCUtils.statusBarType === undefined) {
      log.showInfo(`Start to Init statusBarType and change listener.`);
      GlobalContext.getContext()?.eventHub.off('WindowStyleChange', PCUtils.onStatusBarTypeChanged);
      GlobalContext.getContext()?.eventHub.on('WindowStyleChange', PCUtils.onStatusBarTypeChanged);
      PCUtils.statusBarType = Number(SettingsUtil.getSecureValue('settings_in_status_bar_type'));
      log.showInfo(`statusBarType init to ${PCUtils.statusBarType}. Register stlye change successfully`);
    }
 
    if (!(StatusBarType.isMacStyle(PCUtils.statusBarType) || StatusBarType.isWindowStyle(PCUtils.statusBarType))) {
      // 默认是Mac风格
      PCUtils.statusBarType = StatusBarType.TYPE_MAIN_MAC_STATUS_BAR;
    }
    return PCUtils.statusBarType;
  }
}