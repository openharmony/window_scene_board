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
import { DeviceHelper, EvtBus, ThemeActivationEvent } from '@ohos/frameworkwrapper';
import base from '@ohos.base';
import { ThemeActivationTarget } from '@ohos/themeservicekit/Index';
import { EngineContainerManager } from '../component/EngineContainerManager';
import { EngineLoadStrategy } from '../strategy/EngineLoadStrategy';
import { GracefullyLoadStrategy } from '../strategy/GracefullyLoadStrategy';
import { TsResilienceHandler } from './TsResilienceHandler';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG: string = 'DualInstanceHandler';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const ACTIVATION_IGNORE_LIST: number[] = [
  ThemeActivationTarget.NIL,
  ThemeActivationTarget.AOD,
  ThemeActivationTarget.ONLY_LOCK_CLOCK,
];

const THEME_LOAD_FINISH_WAIT: number = 10000;

const THEME_RELOAD_WAIT: number = 100;

/**
 * Entry module to receive theme activation event and using strategies to reload TE instance
 *
 * @since 2024-07-18
 */
export class DualInstanceHandler {
  private static instance: DualInstanceHandler;

  // Use GLS by default
  private loadStrategy: EngineLoadStrategy = new GracefullyLoadStrategy();

  private timeoutId?: number;

  private outerTimeoutId?: number;

  private finishedEngineCount: number = 0;

  private totalEngineCount: number = 1;

  private isLoading: boolean = false;

  private needReloadNum: number = 0;

  private constructor() {
    EvtBus.on(ThemeActivationEvent, (event) => this.onActivateTheme(event));
  }

  /**
   * Acquire the DualInstanceHandler's singleton instance
   *
   * @returns DualInstanceHandler's singleton instance
   */
  public static getInstance(): DualInstanceHandler {
    if (!DualInstanceHandler.instance) {
      DualInstanceHandler.instance = new DualInstanceHandler();
    }

    return DualInstanceHandler.instance;
  }

  /**
   * Set total wallpaper engine count
   *
   * @param set total wallpaper engine count
   */
  public setTotalEngineCount(totalEngineCount: number = 1): void {
    this.totalEngineCount = totalEngineCount;
  }

  /**
   * Set the current enforcing load strategy
   *
   * @param strat Current EngineLoadStrategy
   */
  public registerCurrentStrategy(strat: EngineLoadStrategy): void {
    this.loadStrategy = strat;
    this.finishedEngineCount = 0;
  }

  /**
   * Main implementation when TE instance is ready
   */
  public onEngineReady(proxyId: string = 'DefaultProxy'): void {
    LOG.info(TAG, `On ThemeEngine instance ready for ${proxyId}`);
    if (proxyId === 'OuterProxy') {
      clearTimeout(this.outerTimeoutId);
    } else {
      clearTimeout(this.timeoutId);
    }
    this.loadStrategy.onExecutionSuccess(proxyId);
      this.loadFinish();
  }

  /**
   * Send a broadcast for subscribers when theme has finished loading.
   */
  public publishThemeLoaded(): void {
    try {
      commonEventManager.publish('ThemeFinishLoading', this.onPublish);
    } catch (err) {
      LOG.error(TAG, `Error on publishing ThemeFinishLoading event, ${err.code} - ${err.message}`);
    }
  }

  private onPublish(err: base.BusinessError): void {
    if (err) {
      LOG.error(TAG, `publishThemeLoaded failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    LOG.info(TAG, 'Succeeded publish event:ThemeFinishLoading');
  }

  /**
   * Main implementation when theme is activated
   *
   * @param event ThemeActivationEvent, containing activation target and other info
   */
  public onActivateTheme(event: ThemeActivationEvent): void {
    if (!event) {
      LOG.warn(TAG, 'Invalid theme activation event.');
      return;
    }
    if (ACTIVATION_IGNORE_LIST.includes(event.target)) {
      EngineContainerManager.getInstance().notifyNewRootPath(event.activeThemePath);
      return;
    }
    AppStorage.setOrCreate<boolean>('isThemeActivationTargetAll',
      event.target === ThemeActivationTarget.ALL || event.target === ThemeActivationTarget.WHOLE_THEME_ALL);

    // On each new theme, start with strat GLS by default
    // And reset some resilience stats
    LOG.info(TAG, 'Receiving ThemeActivationEvent from ThemeService');
    TsResilienceHandler.getInstance().reset();

    if (this.isLoading) {
      this.needReloadNum++;
      LOG.warn(TAG, `Receiving ThemeActivationEvent needReloadNum: ${this.needReloadNum}.`);
      return;
    }
    this.loadTheme();
  }

  private loadTheme(): void {
    this.isLoading = true;
    this.loadStrategy = new GracefullyLoadStrategy();
    this.loadStrategy.execution();
    clearTimeout(this.outerTimeoutId);
    clearTimeout(this.timeoutId);
    this.timeoutId = setTimeout(() => {
      LOG.warn(TAG, 'Force kill idle instance on wait timeout');
      this.loadStrategy.onExecutionSuccess();
    }, THEME_LOAD_FINISH_WAIT);
    this.outerTimeoutId = setTimeout(() => {
      LOG.warn(TAG, 'Force kill idle outer instance on wait timeout');
      this.loadStrategy.onExecutionSuccess('OuterProxy');
    }, THEME_LOAD_FINISH_WAIT);
  }

  private loadFinish(): void {
    if (this.needReloadNum > 0) {
      LOG.info(TAG, 'need reload.');
      this.needReloadNum = 0;
      setTimeout(() => {
        this.loadTheme();
      }, THEME_RELOAD_WAIT);
    } else {
      this.isLoading = false;
    }
  }

  /**
   * Lifecycle interface on exceptional circumstances during TE running
   */
  public onUiExtError(): void {
    LOG.warn(TAG, 'Error occurred from UIExtension instance, retrying.');
    TsResilienceHandler.getInstance().retry();
  }
}