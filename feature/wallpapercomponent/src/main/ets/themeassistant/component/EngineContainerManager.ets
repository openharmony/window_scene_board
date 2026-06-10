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
import { TsProxyHandler } from '../handler/TsProxyHandler';
import { ThemeServiceHelper } from '../ThemeServiceHelper';

const TAG: string = 'EngineContainerManager';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const HIGH_LEVEL_INDEX: number = 2;
const LOW_LEVEL_INDEX: number = 1;

/**
 * Manager class to directly manipulate the lifecycle of the dual TE instance
 *
 * @since 2024-07-18
 */
export class EngineContainerManager {
  private static instance: EngineContainerManager;

  private currentActiveInstance: string = 'primary';
  private outerCurrentActiveInstance: string = 'primary';

  private proxyHandler?: TsProxyHandler;

  private constructor() {
  }

  /**
   * Getting the singleton instance of ECM
   *
   * @returns ECM instance
   */
  public static getInstance(): EngineContainerManager {
    if (!EngineContainerManager.instance) {
      EngineContainerManager.instance = new EngineContainerManager();
    }

    return EngineContainerManager.instance;
  }

  /**
   * Lifecycle interface to be called when ThemeEngine instance is ready.
   *
   * @param proxy UIExtensionProxy instance, used to establish IPC with ThemeEngine
   */
  public onInstanceLoad(proxy: UIExtensionProxy): void {
    if (!proxy) {
      LOG.warn(TAG, `Refusing register an invalid proxy instance.`);
      return;
    }
    this.setActiveProxy(proxy);
  }

  public setActiveProxy(proxy?: UIExtensionProxy): void {
    if (!proxy) {
      LOG.warn(TAG, 'Invalid proxy.');
      return;
    }
    this.proxyHandler = new TsProxyHandler(proxy);
    ThemeServiceHelper.getInstance().updateProxyInstance(this.proxyHandler);
  }

  public notifyNewRootPath(path: string): void {
    if (!path) {
      LOG.warn(TAG, 'Invalid path will not be sent to ThemeEngine.');
      return;
    }
    this.proxyHandler?.sendRootPathUpdate(path);
  }

  /**
   * Start new TE instance, which will be the current active instance's counterpart
   */
  public startNewInstance(): void {
    // On starting new instance, make sure current using one is always on top
    if (this.proxyHandler) {
      // If proxyHandler is not empty, a new engine instance needs to be started.
      // Perform pre-processing on the old instance.
      LOG.info(TAG, 'before startNewInstance, do sth before change theme');
      this.proxyHandler.sendBeforeChangeTheme();
    }

    if (AppStorage.get<boolean>('dualEngineSwitchPrimary')) {
      this.startSecondaryInstance();
      this.elevatePrimaryInstance();
      this.currentActiveInstance = 'secondary';
    } else {
      this.startPrimaryInstance();
      this.elevateSecondaryInstance();
      this.currentActiveInstance = 'primary';
    }
    LOG.info(TAG, `Starting new instance ${this.currentActiveInstance}`);

    if (AppStorage.get<boolean>('outerDualEngineSwitchPrimary')) {
      this.startOuterSecondaryInstance();
      this.elevateOuterPrimaryInstance();
      this.outerCurrentActiveInstance = 'secondary';
    } else {
      this.startOuterPrimaryInstance();
      this.elevateOuterSecondaryInstance();
      this.outerCurrentActiveInstance = 'primary';
    }
    LOG.info(TAG, `Starting new instance ${this.outerCurrentActiveInstance}`);
  }

  public getActiveInstanceId(): string {
    return this.currentActiveInstance;
  }

  public getOuterActiveInstanceId(): string {
    return this.outerCurrentActiveInstance;
  }

  /**
   * Release and kill the unused TE instance once the new one is ready to use.
   */
  public killIdleInstance(proxyId: string = 'DefaultProxy'): void {
    if (proxyId === 'OuterProxy') {
      LOG.info(TAG, `Current outerscreen active instance is ${this.outerCurrentActiveInstance}, killing its counterpart`);
      if (this.outerCurrentActiveInstance === 'secondary') {
        this.purgeOuterPrimaryInstance();
        this.elevateOuterSecondaryInstance();
      } else {
        this.purgeOuterSecondaryInstance();
        this.elevateOuterPrimaryInstance();
      }
      return;
    }

    LOG.info(TAG, `Current active instance is ${this.currentActiveInstance}, killing its counterpart`);
    if (this.currentActiveInstance === 'secondary') {
      this.purgePrimaryInstance();
      this.elevateSecondaryInstance();
    } else {
      this.purgeSecondaryInstance();
      this.elevatePrimaryInstance();
    }
  }

  /**
   * On singleton TE mode, a restart is enough to reload the TE instance
   */
  public restartCurrentInstance(): void {
    LOG.info(TAG, 'Restart current instance without starting a new one');
    let trigger: boolean = AppStorage.get<boolean>('themeEngineRestartTrigger') ?? true;
    trigger = !trigger;
    AppStorage.setOrCreate<boolean>('themeEngineRestartTrigger', trigger);
  }

  /**
   * get this proxyHandler
   *
   * @returns proxyHandler or undefined
   */
  public getProxyHandler(): TsProxyHandler | undefined {
    return this.proxyHandler;
  }

  private elevatePrimaryInstance(): void {
    AppStorage.setOrCreate<number>('dualEnginePrimaryZIndex', HIGH_LEVEL_INDEX);
    AppStorage.setOrCreate<number>('dualEngineSecondaryZIndex', LOW_LEVEL_INDEX);
  }

  private elevateOuterPrimaryInstance(): void {
    AppStorage.setOrCreate<number>('outerDualEnginePrimaryZIndex', HIGH_LEVEL_INDEX);
    AppStorage.setOrCreate<number>('outerDualEngineSecondaryZIndex', LOW_LEVEL_INDEX);
  }

  private elevateSecondaryInstance(): void {
    AppStorage.setOrCreate<number>('dualEngineSecondaryZIndex', HIGH_LEVEL_INDEX);
    AppStorage.setOrCreate<number>('dualEnginePrimaryZIndex', LOW_LEVEL_INDEX);
  }

  private elevateOuterSecondaryInstance(): void {
    AppStorage.setOrCreate<number>('outerDualEngineSecondaryZIndex', HIGH_LEVEL_INDEX);
    AppStorage.setOrCreate<number>('outerDualEnginePrimaryZIndex', LOW_LEVEL_INDEX);
  }

  private startPrimaryInstance(): void {
    AppStorage.setOrCreate<boolean>('dualEngineSwitchPrimary', true);
  }

  private startOuterPrimaryInstance(): void {
    AppStorage.setOrCreate<boolean>('outerDualEngineSwitchPrimary', true);
  }

  private purgePrimaryInstance(): void {
    AppStorage.setOrCreate<boolean>('dualEngineSwitchPrimary', false);
  }

  private purgeOuterPrimaryInstance(): void {
    AppStorage.setOrCreate<boolean>('outerDualEngineSwitchPrimary', false);
  }

  private startSecondaryInstance(): void {
    AppStorage.setOrCreate<boolean>('dualEngineSwitchSecondary', true);
  }

  private startOuterSecondaryInstance(): void {
    AppStorage.setOrCreate<boolean>('outerDualEngineSwitchSecondary', true);
  }

  private purgeSecondaryInstance(): void {
    AppStorage.setOrCreate<boolean>('dualEngineSwitchSecondary', false);
  }

  private purgeOuterSecondaryInstance(): void {
    AppStorage.setOrCreate<boolean>('outerDualEngineSwitchSecondary', false);
  }
}