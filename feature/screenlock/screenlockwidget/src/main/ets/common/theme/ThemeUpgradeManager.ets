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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ThemeScene } from '@ohos/screenlockcommon/src/main/ets/constants/ThemeEditAndScreenLockConstants';
import { Qualifier } from '@ohos/themeservicekit';
import { ClockComFamily, ClockLayout, LockscreenThemeConfig } from '../WidgetParam';
import { ThemeRemoteManager } from './ThemeRemoteManager';

const TAG = 'ThemeUpgradeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const XT_VERSION = 2;
const DEFAULT_CLOCK_POSITIONX = 1;
const WIDESCREEN_DEFAULT_CLOCK_POSITIONX = 3;

/**
 * 时钟宫格升级管理
 */
export class ThemeUpgradeManager {
  private currentVersion = 2;

  /**
   * 升级不支持异壁纸设备
   *
   * @param themeParam 主题参数
   */
  public upgradeBaseScene(themeParam: LockscreenThemeConfig): void {
    if (!themeParam || !themeParam.clock || !DeviceHelper.isThreeFoldProduct()) {
      log.showWarn('UpgradeBaseScene themeParam is invalid.');
      return;
    }
    if ((themeParam.clock?.version ?? 0) !== this.currentVersion) {
      log.showInfo('UpgradeBaseScene exec.');
      themeParam.clock.version = this.currentVersion;
      let themeRemoteMgr: ThemeRemoteManager = new ThemeRemoteManager();
      themeRemoteMgr.setCurrentThemeCfg(themeParam);
    }
  }

  /**
   * 升级支持异壁纸设备
   *
   * @param themeParams 主题参数
   */
  public upgradeMultiScene(themeParams: Map<Qualifier, LockscreenThemeConfig>): void {
    if (!themeParams || themeParams.size === 0 || !DeviceHelper.isThreeFoldProduct()) {
      log.showWarn('UpgradeMultiScene themeParams is invalid.');
      return;
    }
    let version = themeParams.get(ThemeScene.BASE)?.clock?.version ?? 0;
    if (!themeParams.get(ThemeScene.BASE)?.clock || version === this.currentVersion) {
      return;
    }
    let themeRemoteMgr: ThemeRemoteManager = new ThemeRemoteManager();
    if (DeviceHelper.isThreeFoldProduct() && version < XT_VERSION) {
      log.showInfo('UpgradeMultiScene threeFold exec.');
      themeParams.forEach((val, key) => {
        val.clock.version = this.currentVersion;
        this.upgradeXT(key, val);
      });
    } else {
      log.showInfo('UpgradeMultiScene exec.');
      themeParams.forEach((val, key) => {
        val.clock.version = this.currentVersion;
      });
    }
    themeRemoteMgr.setMultiSceneThemeCfg(themeParams);
  }

  private upgradeXT(scene: Qualifier, config: LockscreenThemeConfig): void {
    switch (scene) {
      case ThemeScene.BASE:
      case ThemeScene.LAND_UNFOLDED2:
        config.clock.positionX = DEFAULT_CLOCK_POSITIONX;
        break;
      case ThemeScene.UNFOLDED:
      case ThemeScene.LAND_UNFOLDED:
      case ThemeScene.UNFOLDED2:
        config.clock.positionX = WIDESCREEN_DEFAULT_CLOCK_POSITIONX;
        break;
      default:
        break;
    }
    config.clock.positionY = 0;
    config.clock.layout = (scene === ThemeScene.LAND_UNFOLDED2 || scene === ThemeScene.UNFOLDED2) ?
    ClockLayout.NORMAL_CLOCK_LAYOUT : ClockLayout.DEFAULT_CLOCK_LAYOUT;
    config.clock.fontFamily = (scene === ThemeScene.LAND_UNFOLDED2 || scene === ThemeScene.UNFOLDED2) ?
      ClockComFamily.HARMONY_CLOCK_01 : ClockComFamily.HARMONY_CLOCK_ULT_01;
  }
}

let sThemeUpgradeManager: ThemeUpgradeManager = SingletonHelper.getInstance(ThemeUpgradeManager, TAG);

export default sThemeUpgradeManager as ThemeUpgradeManager;