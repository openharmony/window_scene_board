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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import ExtendedScreenDialogAbilityProxy from '@ohos/pcbase/src/main/ets/SystemDialog/ExtendedScreenDialog/ability/ExtendedScreenDialogAbilityProxy';

// 自定义的Ability需继承UIExtensionAbility
export default class ExtendedScreenDialogAbility extends UIExtensionAbility {
    onCreate() {
        ExtendedScreenDialogAbilityProxy.getInstance().onCreate();
    }

    onDestroy(): void {
        ExtendedScreenDialogAbilityProxy.getInstance().onDestroy();
    }

    onForeground(): void {
        ExtendedScreenDialogAbilityProxy.getInstance().onForeground();
    }

    onBackground(): void {
        ExtendedScreenDialogAbilityProxy.getInstance().onBackground();
    }

    onSessionCreate(want: Want, session: UIExtensionContentSession): void {
        ExtendedScreenDialogAbilityProxy.getInstance().onSessionCreate(want, session);
    }

    onSessionDestroy(session: UIExtensionContentSession) {
        ExtendedScreenDialogAbilityProxy.getInstance().onSessionDestroy(session);
    }
}