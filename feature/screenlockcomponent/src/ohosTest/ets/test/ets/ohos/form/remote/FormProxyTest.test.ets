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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import FormProxy, { FormCenterViewParam } from '@ohos/screenlockwidget/src/main/ets/form/remote/FormProxy';
import { FormResponseHandler } from '@ohos/screenlockwidget/src/main/ets/form/remote/FormCallbackStub';
import type abilityCommon from '@ohos.app.ability.common';
import { FormDisplayType } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { ScreenLockAniParam } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniData';

export default function FormProxyTest() {
  let context: abilityCommon.ServiceExtensionContext;
  let handler: FormResponseHandler;
  describe('FormProxyTest', () => {
    let mFormProxy: FormProxy = new FormProxy(context, handler);
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('FormProxyTest_OpenFormCenterTest_001', Level.LEVEL0, () => {
      let extra: FormCenterViewParam = {
        formDisplayType: FormDisplayType.DESKTOP_CARD,
        openHighIndexView: false,
        isSupportDrag: false,
        isSupportCreateAnimate: false
      };
      let result = mFormProxy.openFormCenter(extra);
      expect(result == null).assertTrue();
    })

    it('FormProxyTest_SendMessage_001', Level.LEVEL0, () => {
      let result = mFormProxy.closeFormCenter();
      expect(result == null).assertTrue();
    })

    it('FormProxyTest_SendMessage_002', Level.LEVEL0, () => {
      let result = mFormProxy.closeFormManager();
      expect(result == null).assertTrue();
    })

    it('FormProxyTest_SendMessage_003', Level.LEVEL0, () => {
      let key: string = 'red';
      let aniData: ScreenLockAniParam = {
        color: '#ffffff',
        isLightWallpaper: false,
        startPosition: {
          x: 0, y: 0
        },
        endPosition: {
          x: 0, y: 0
        },
        scaleX: 2,
        scaleY: 2
      };
      let result = mFormProxy.playDropAnimation(key, aniData);
      expect(result == null).assertTrue();
    })

    it('FormProxyTest_disConnect_001', Level.LEVEL0, () => {
      let result = mFormProxy.disConnect();
      expect(result == null).assertTrue();
    })

  })

}