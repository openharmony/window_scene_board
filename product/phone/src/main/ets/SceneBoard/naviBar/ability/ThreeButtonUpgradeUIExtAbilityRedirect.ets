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
import ThreeButtonUpgradeUIExtAbility
  from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/ability/ThreeButtonUpgradeUIExtAbility';

import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import type Want from '@ohos.app.ability.Want';

export default class ThreeButtonUpgradeUIExtAbilityRedirect extends ThreeButtonUpgradeUIExtAbility {
  onCreate(): void {
    super.onCreate();
  }

  onForeground(): void {
    super.onForeground();
  }

  onBackground(): void {
    super.onBackground();
  }

  onDestroy(): void {
    super.onDestroy();
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    super.onSessionCreate(want, session);
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    super.onSessionDestroy(session);
  }
}