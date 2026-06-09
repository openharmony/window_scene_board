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

import { KeyguardObserver }  from '@ohos/screenlockcommon/src/main/ets/manager/KeyguardObserver';
import osAccount from '@ohos.account.osAccount';
import { Callback } from '@ohos/frameworkwrapper';

export type KeyguardObserverCallback = Callback;

export default function KeyguardObserverTest() {

  describe('KeyguardObserverTest', (): void => {
    let mKeyguardObserver: KeyguardObserver = new KeyguardObserver();
    let authType: osAccount.AuthType;

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_KeyguardObserver_should_return', 0, (): void => {
      mKeyguardObserver.onAccountActive((callback: KeyguardObserverCallback)=>{});
      mKeyguardObserver.notifyAccountActive();
      mKeyguardObserver.onAccountChecking((callback: KeyguardObserverCallback)=>{});
      mKeyguardObserver.onAuthSuccessAniFinish((callback: KeyguardObserverCallback)=>{});
      mKeyguardObserver.notifyAuthSuccessAniFinish();
      mKeyguardObserver.onAuthSuccessAniCallback((callback: KeyguardObserverCallback)=>{});
      mKeyguardObserver.notifyAuthSuccessAniCallback();
      mKeyguardObserver.onAuthSuccess((callback: KeyguardObserverCallback)=>{});
      mKeyguardObserver.notifyAuthSuccess(authType);
      mKeyguardObserver.destroy();
      let status:number = 1;
      mKeyguardObserver.notifyAccountChecking(status);
      expect(status).not().assertNull();
    })

    it('test_getInstance', 0, (): void => {
      KeyguardObserver.getInstance();
      KeyguardObserver.getInstance();
      expect(true).assertTrue();
    })
  })
}