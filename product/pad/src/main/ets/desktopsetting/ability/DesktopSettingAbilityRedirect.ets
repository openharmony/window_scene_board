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
import DesktopSettingAbility from '@ohos/phonebase/src/main/ets/desktopsetting/ability/DesktopSettingAbility';

import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';

export default class DesktopSettingAbilityRedirect extends DesktopSettingAbility {
  onCreate(): void {
    super.onCreate();
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): Promise<void> {
    return super.onSessionCreate(want, session);
  }

  onBackground(): Promise<void> {
    return super.onBackground();
  }

  onForeground(): Promise<void> {
    return super.onForeground();
  }
}