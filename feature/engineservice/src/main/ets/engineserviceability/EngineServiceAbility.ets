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

import lazy Want from '@ohos.app.ability.Want';
import lazy UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { ThemeConstant } from '../utils/ThemeConstant';
import lazy { EngineProxy } from './EngineProxy';
import lazy { Configuration } from '@ohos.app.ability.Configuration';
import lazy { EngineStateHelper } from './EngineStateHelper';
import { Log } from '../utils/Log';
import { GlobalContext } from '../utils/GlobalContext';

const TAG: string = 'EngineServiceAbility';

export default class EngineServiceAbility extends UIExtensionAbility {
  private engineProxy?: EngineProxy;

  private stateHelper?: EngineStateHelper;

  onCreate() {
    Log.info(TAG, 'onCreate');
    this.stateHelper = new EngineStateHelper(this.context);
    this.stateHelper.setInitState(this.context?.config);
    this.stateHelper.listenOrientationChange();
    this.stateHelper.listenFoldStatusChange();
    this.stateHelper.listenWindowSizeChange();
  }

  /**
   * On EngineService ability configuration update
   *
   * @param newConfig New ability configuration
   */
  public onConfigurationUpdate(newConfig: Configuration): void {
    if (newConfig) {
      this.stateHelper?.onConfigurationUpdate(newConfig);
    }
  }

  /**
   * On destroy EngineService ability
   */
  public onDestroy(): void {
    this.stateHelper?.destroyListener();
    Log.info(TAG, 'onDestroy');
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Log.info(TAG, 'onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Log.info(TAG, 'onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Log.info(TAG, 'onBackground');
  }

  private initWant(want: Want, session: UIExtensionContentSession) {
    if (!want || !want.parameters) {
      Log.error(TAG, `No valid want was provided when starting ThemeEngine, engine will not be loaded.`);
      this.notifyKillUiExt(session);
      return;
    }

    if (want.parameters['savedTargetState'] !== undefined) {
      Log.info(TAG, `On ThemeEngine UIExt create, savedTargetState is ${want.parameters['savedTargetState']}`);
      AppStorage.setOrCreate<number>('savedTargetState', want.parameters['savedTargetState'] as number);
      this.engineProxy?.setScbState(want.parameters['savedTargetState'] as number);
    }

    if (want.parameters['screenWidth'] !== undefined) {
      Log.info(TAG, `On ThemeEngine UIExt create, screenWidth is ${want.parameters['screenWidth']}`);
      GlobalContext.getContext().setObject('screenWidth', want.parameters['screenWidth'] as number);
    }

    if (want.parameters['screenHeight'] !== undefined) {
      Log.info(TAG, `On ThemeEngine UIExt create, screenHeight is ${want.parameters['screenHeight']}`);
      GlobalContext.getContext().setObject('screenHeight', want.parameters['screenHeight'] as number);
    }

    if (want.parameters['screenOrientation'] !== undefined) {
      Log.info(TAG, `On ThemeEngine UIExt create, screenOrientation is ${want.parameters['screenOrientation']}`);
      GlobalContext.getContext().setObject('screenOrientation', want.parameters['screenOrientation'] as number);
    }

    if (want.parameters['onDeskTopState']) {
      Log.info(TAG, `On ThemeEngine UIExt create, onDeskTopState is ${want.parameters['onDeskTopState']}`);
      AppStorage.setOrCreate('onDeskTopState', want.parameters['onDeskTopState'] as number);
    }
    GlobalContext.getContext().setObject('darkMode', this.context.config?.colorMode ?? ThemeConstant.SYSTEM_NOT_SUPPORT);
  }

  async onSessionCreate(want: Want, session: UIExtensionContentSession): Promise<void> {
    Log.info(TAG, 'onSessionCreate');
    if (!want || !want.parameters) {
      Log.error(TAG, `No valid want was provided when starting ThemeEngine, engine will not be loaded.`);
      this.notifyKillUiExt(session);
      return;
    }
    Log.info(TAG, 'onSessionCreate EngineManager beforeStartup end');

    AppStorage.setOrCreate<Context>('AodSettingsSwitchStatusContext', this.context);
    let activeThemePath: string = want.parameters['activeThemePath'] as string ?? '';
    AppStorage.setOrCreate<string>('activeThemePath', activeThemePath);
    this.engineProxy = EngineProxy.getInstance();
    this.engineProxy?.setUiExtSession(session);
    AppStorage.setOrCreate<UIExtensionContentSession>('uiExtSession', session);

    this.initWant(want, session);

    AppStorage.setOrCreate<boolean>('isChangeThemeAll', want.parameters['isChangeThemeAll'] as boolean);

    let para: Record<string, UIExtensionContentSession> = { 'session': session };
    let storage: LocalStorage = new LocalStorage(para);
    session.loadContent('pages/EngineWallpaperPage', storage);
    session.setWindowBackgroundColor('#00000000');
    Log.info(TAG, 'Finished UIExtension session create.');

    if (want.parameters['initBaseScale'] !== undefined) {
      Log.info(TAG, `On ThemeEngine UIExt create, initial baseScale is ${want.parameters['initBaseScale']}`);
      AppStorage.setOrCreate<number>('engineBaseScale', want.parameters['initBaseScale'] as number);
    }

    this.notifyResetRetry(session);
    this.stateHelper?.listenLayoutChange(session);
  }

  private notifyResetRetry(session: UIExtensionContentSession): void {
    try {
      session.sendData({ 'isResetRetry': true });
    } catch (e) {
      Log.warn(TAG, `Failed to notify reset retry ${e?.code}`);
    }
  }

  private notifyKillUiExt(session: UIExtensionContentSession | undefined): void {
    try {
      session?.terminateSelfWithResult({ 'resultCode': 0 });
    } catch (err) {
      Log.error(TAG, `Failed killing UIExtension on theme load failed. ${err?.code} ${err?.message}`);
    }
  }
}
