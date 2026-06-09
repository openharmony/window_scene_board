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
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'ScbIntentUIExtensionAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);


/**
 * ScbIntentUIExtensionAbility
 *
 * @since 2024-05-23
 */
export default class ScbIntentUIExtensionAbility extends UIExtensionAbility {
  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    log.showInfo('onSessionCreate is called');
    AppStorage.setOrCreate<Context>('intentPageContext', this.context);
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    log.showInfo('onSessionDestroy is called');
    AppStorage.delete('intentPageContext');
  }

  onCreate(): void {
    log.showInfo('onCreate is called');
  }

  onDestroy(): void | Promise<void> {
    log.showInfo('onDestroy is called');
  }
}