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

import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'RestoringTipsController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class RestoringTipsController {
  private session?: UIExtensionContentSession;

  public setSession(session: UIExtensionContentSession): void {
    this.session = session;
  }

  /**
   * close the dialog
   */
  public destroy(): void {
    log.showInfo('destroy');
    this.session?.terminateSelf();
  }
}

export let restoringTipsController: RestoringTipsController = SingletonHelper.getInstance(RestoringTipsController, TAG);
