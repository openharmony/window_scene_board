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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { Log } from '@ohos/basicutils';
import { SettingsKeyConstants } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/CommonUtils';
import SettingsUtil from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/SettingsUtil';
import SoundPermissionAbilityProxy from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/permission/SoundPermissionAbilityProxy';

// 自定义的Ability需继承UIExtensionAbility
const TAG = 'SoundPermissionAbility';
export default class SoundPermissionAbility extends UIExtensionAbility {
  onCreate() {
    SoundPermissionAbilityProxy.getInstance().onCreate(this.context);
  }

  onDestroy(): void {
    SoundPermissionAbilityProxy.getInstance().onDestroy(this.context);
  }

  onForeground(): void {
    SoundPermissionAbilityProxy.getInstance().onForeground();
  }

  onBackground(): void {
    SoundPermissionAbilityProxy.getInstance().onBackground();
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    SoundPermissionAbilityProxy.getInstance().onSessionCreate(want, session);
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    SoundPermissionAbilityProxy.getInstance().onSessionDestroy(session);
  }
}