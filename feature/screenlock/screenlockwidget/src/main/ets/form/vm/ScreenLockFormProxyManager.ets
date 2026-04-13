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

import type Base from '@ohos.base';
import formHost from '@ohos.app.form.formHost';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type Want from '@ohos.app.ability.Want';
import { ScreenLockUnlockService } from '@ohos/screenlockcommon';
import type common from '@ohos.app.ability.common';

const TAG = 'ScreenLockFormProxyManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const START_ABILITY_DELAY: number = 100;

export default class ScreenLockFormProxyManager {
  private formIds: string[] = [];
  private startAbilityQueue: Want[] = [];

  public clearAbilityQueue(): void {
    log.showInfo('clear ability queue.');
    this.startAbilityQueue = [];
  }

  protected startAbility(): void {
    if (this.startAbilityQueue.length === 0) {
      return;
    }
    let uiAbilityContext = GlobalContext.getInstance().getObject('desktopContext') as common.UIAbilityContext;
    setTimeout(() => {
      this.startAbilityByWant(uiAbilityContext, this.startAbilityQueue.pop());
      this.clearAbilityQueue();
    }, START_ABILITY_DELAY);
  }

  protected startAbilityByWant(uiAbilityContext: common.UIAbilityContext, item?: Want): void {
    if (!item) {
      log.showError('start ability failed, Want is undefined');
      return;
    }
    try {
      log.showInfo(`start ability, want: ${item.bundleName}`);
      uiAbilityContext.startAbility(item)
        .then((data) => {
          log.showInfo('startAbility succeed.');
        })
        .catch((err: Base.BusinessError) => {
          log.showError(`start ability error, code: ${err.code}, message: ${err.message}`);
        });
    } catch (error) {
      log.showError(`start ability error, code is ${error.code}, message is ${error.message}`);
    }
  }

  public registerRouterProxy(formId: string): void {
    log.showInfo('Starting to register router proxy.');
    try {
      this.formIds.push(formId);
      formHost.setRouterProxy([formId], (want: Want) => {
        log.showInfo(`formHost recv router event, want: ${want.bundleName}`);
        this.startFormDirectly(want);
      }).then(() => {
        log.showInfo('formHost set router proxy success');
      }).catch((err: Base.BusinessError) => {
        log.showError(`set router proxy error, code: ${err.code}, message: ${err.message}`);
      });
    } catch (error) {
      log.showError(`start ability error, code is ${error.code}, message is ${error.message}`);
    }
  }

  public startFormDirectly(want: Want): void {
    this.startAbilityQueue.push(want);
    this.unlockingAfterFormClick();
  }

  protected unlockingAfterFormClick(): void {
    ScreenLockUnlockService.getInstance().requestUnlock({success: () => {
      this.startAbility();
    }});
  }
}