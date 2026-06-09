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
import { EvtBus } from '@ohos/frameworkwrapper';
import { PageDesktopOneShotManager } from '@ohos/launchercommon/Index';
import { SlViewController } from '@ohos/screenlockcommon/Index';
import { Qualifier } from '@ohos/themeservicekit';
import { ClockComFamily } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import ScreenLockThemeManager, {
  DEFAULT_SANDBOX_THEME_QUALIFIER,
  ScreenLockThemeChangeEvent
} from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { LockscreenThemeConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { ScreenLockStateManager } from '@ohos/screenlockcommon';

const TAG = 'ScreenLockViewControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏主题改变监听
 */
export interface ScreenLockThemeChangeCallback {
  /**
   * 通知预亮屏处理
   */
  onScreenLockThemeChange?: (themeParam?: LockscreenThemeConfig, isDisplayChange?: boolean) => void;
}

/**
 * screen lock view control
 *
 * @since 2024-08-31
 */
export abstract class ScreenLockVc<T> extends SlViewController<T> {
  private _screenLockThemeChangeListener = (event?: ScreenLockThemeChangeEvent): void => {
    log.showInfo('receive ScreenLockThemeChangeEvent');
    let themeParams: Map<Qualifier, LockscreenThemeConfig> | undefined =
      ScreenLockThemeManager.getInstance().getCurrentThemeParams();
    if (!themeParams) {
      log.showError('themeParams invalid');
      return;
    }
    let currentThemeParam: LockscreenThemeConfig | undefined = themeParams.get(DEFAULT_SANDBOX_THEME_QUALIFIER);
    if (ScreenLockThemeManager.getInstance().isSupportMultiScene()) {
      let currentScene = MultiSceneThemeManager.getCurrentThemeQualifier();
      currentThemeParam = MultiSceneThemeManager.getThemeParamsByPriority(currentScene, themeParams);
      if (event?.isDisplayChange && ScreenLockStateManager.getInstance().isInEdite) {
        let cacheParams: LockscreenThemeConfig | undefined =
          MultiSceneThemeManager.getTargetSceneThemeEditCfg(currentScene);
        currentThemeParam = cacheParams ?? currentThemeParam;
      }
    }
    this.onScreenLockThemeChange(currentThemeParam, event?.isDisplayChange);
    // 通知桌面天气时钟更新字体
    ScreenLockThemeManager.getInstance().notifyUpdateCardStyle(JSON.stringify({
      fontFamily: currentThemeParam?.clock?.fontFamily,
      mainTextWeight: ClockStaticData.getTimeFontWeightStr(currentThemeParam?.clock?.fontFamily ??
      ClockComFamily.HARMONY_CLOCK_01),
    }));

  }
  private _screenLockThemeChangeCallback: ScreenLockThemeChangeCallback | null = null;

  protected doInit(params?: object | undefined): void {
    super.doInit(params);
    EvtBus.on(ScreenLockThemeChangeEvent, this._screenLockThemeChangeListener);
  }

  protected doRelease(): void {
    super.doRelease();
    EvtBus.off(ScreenLockThemeChangeEvent, this._screenLockThemeChangeListener);
  }

  /**
   * 设置主题变化回调
   *
   * @param callback 主题变化回调
   */
  public setScreenLockThemeChangeCallback(callback: ScreenLockThemeChangeCallback | null) {
    this._screenLockThemeChangeCallback = callback;
    if (this._screenLockThemeChangeCallback) {
      log.showInfo('trigger callback when first set theme callback');
      this._screenLockThemeChangeListener();
    }
  }

  /**
   * 锁屏主题变化回调
   */
  protected onScreenLockThemeChange(themeParam?: LockscreenThemeConfig, isDisplayChange?: boolean) {
    log.showInfo('onScreenLockThemeChange');
    this._screenLockThemeChangeCallback?.onScreenLockThemeChange?.(themeParam, isDisplayChange);
  }

  protected isEnable(): boolean {
    return super.isEnable();
  }
}
