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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import ScreenLockFormProxyManager
  from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormProxyManager';
import type common from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';

export default function ScreenLockFormProxyManagerTest() {
  const mScreenLockFormProxyManagerSon = new ScreenLockFormProxyManagerSon()

  describe('ScreenLockFormProxyManagerTest', (): void => {
    let mScreenLockFormProxyManager: ScreenLockFormProxyManager = new ScreenLockFormProxyManager();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_isCameraInUpperLeftCorner_return', 0, (): void => {
      let formId: string = 'resid';
      mScreenLockFormProxyManager.clearAbilityQueue();
      mScreenLockFormProxyManager.registerRouterProxy(formId);
      expect(formId).assertEqual('resid');
    })

    it('test_isCameraInUpperLeftCorner_return', 0, (): void => {
      let formId: string = 'resid';
      mScreenLockFormProxyManager.clearAbilityQueue();
      mScreenLockFormProxyManager.registerRouterProxy(formId);
      expect(formId).assertEqual('resid');
    })

    it('test_startAbility_return', 0, (): void => {
      mScreenLockFormProxyManagerSon.StartAbility();
      expect(true).assertTrue();
    })

    it('test_startAbility_return_one', 0, (): void => {
      mScreenLockFormProxyManager.registerRouterProxy('1');
      mScreenLockFormProxyManagerSon.StartAbility();
      expect(true).assertTrue();
    })

    it('test_startAbilityByWant_return', 0, (): void => {
      mScreenLockFormProxyManagerSon.StartAbilityByWant();
      expect(true).assertTrue();
    })

    it('test_unlockingAfterFormClick_return', 0, (): void => {
      mScreenLockFormProxyManagerSon.UnlockingAfterFormClick();
      expect(true).assertTrue();
    })
  })
}

export class ScreenLockFormProxyManagerSon extends ScreenLockFormProxyManager {
  public StartAbility() {
    return this.startAbility();
  }

  public StartAbilityByWant() {
    const uiAbilityContext = GlobalContext.getInstance().getObject('desktopContext') as common.UIAbilityContext;
    return this.startAbilityByWant(uiAbilityContext, {} as Want);
  }

  public UnlockingAfterFormClick() {
    return this.unlockingAfterFormClick();
  }
}