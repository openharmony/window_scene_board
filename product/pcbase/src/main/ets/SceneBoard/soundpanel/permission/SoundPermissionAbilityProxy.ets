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

import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { Log } from '@ohos/basicutils';
import { SettingsKeyConstants } from '../util/CommonUtils';
import SettingsUtil from '../util/SettingsUtil';
import { common } from '@kit.AbilityKit';

// 自定义的Ability需继承UIExtensionAbility
const TAG = 'SoundPermissionAbilityProxy';
export default class SoundPermissionAbilityProxy {
  private static mInstance: SoundPermissionAbilityProxy;

  public static getInstance(): SoundPermissionAbilityProxy {
    if (!SoundPermissionAbilityProxy.mInstance) {
      SoundPermissionAbilityProxy.mInstance = new SoundPermissionAbilityProxy();
    }
    return SoundPermissionAbilityProxy.mInstance;
  }

  onCreate(context: common.UIExtensionContext) {
    context.eventHub.on('closeFirstUseWindow', async () => {
      let state = await SettingsUtil.getSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED, '0', getContext());
      if (state !== '1') {
        await SettingsUtil.setSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED, '0', getContext());
      }
      context.terminateSelf();
    });
    Log.showInfo(TAG, 'SoundPermissionAbility onCreate')
  }

  onDestroy(context: common.UIExtensionContext): void {
    context.eventHub.off('closeFirstUseWindow');
    Log.showInfo(TAG, 'SoundPermissionAbility onDestroy')
  }

  onForeground(): void {
    Log.showInfo(TAG, 'SoundPermissionAbility onForeground')
  }

  onBackground(): void {
    Log.showInfo(TAG, 'SoundPermissionAbility onBackground')
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    Log.showInfo(TAG, 'SoundPermissionAbility onSessionCreate')
    try {
      let storage: LocalStorage = new LocalStorage();
      storage.setOrCreate('session', session);
      // 加载自定义的页面
      Log.showInfo(TAG, 'SoundPermissionAbility set session to FirstUsePermissionRequest');
      session.loadContent('SceneBoard/soundpanel/pages/FirstUsePermissionRequest', storage);
      // 设置窗口透明
      session.setWindowBackgroundColor('#2f000000');
    } catch (e) {
      Log.showError(TAG, 'SoundPermissionAbility set session fail');
    }
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    Log.showInfo(TAG, 'SoundPermissionAbility onSessionDestroy')
  }
}