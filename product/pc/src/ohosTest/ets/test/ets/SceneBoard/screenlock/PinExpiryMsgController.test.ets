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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import dataPreferences from '@ohos.data.preferences';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  PinExpiryNotificationController
} from '@ohos/pcbase/src/main/ets/SceneBoard/control/SceneDesktopController/PinExpiryNotificationController';

const SCREEN_LOCK_PIN_ONE_DAY: number = 1 * 24 * 60 * 60 * 1000;
const SCREEN_LOCK_PIN_VALIDITY_PERIOD: number = 15 * SCREEN_LOCK_PIN_ONE_DAY;
const PIN_EXPRIY_TAG: string = 'PinExpiryNotificationController';
const PIN_NTF_SEND_TIME: string = 'PIN_NTF_SEND_TIME';

export default function PinExpiryMsgControllerTest() {
  describe('PinExpiryMsgControllerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    /**
     * @tc.number:checkSendPinExpiryMsgSuccess_01
     * @tc.name: 校验发送pin码消息通知是否成功
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 校验当有效期小于15时，notification接口是否正常，能成功调用
     */
    it('checkSendPinExpiryMsgSuccess_01', 0, checkSendPinExpiryMsgSuccess_01);

    /**
     * @tc.number:checkSendPinExpiryMsgFail_01
     * @tc.name: 校验发送pin码消息通知是否成功
     * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
     * @tc.desc: 校验当有效期大于15时，工具类应不发送消息，返回false
     */
    it('checkSendPinExpiryMsgFail_01', 0, checkSendPinExpiryMsgFail_01);

  })
}


/**
 * 校验有效期小于15天时，发送pin码消息通知是否成功
 */
function checkSendPinExpiryMsgSuccess_01() {
  let preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: PIN_EXPRIY_TAG });
  preferences.deleteSync(PIN_NTF_SEND_TIME);
  let res: boolean = PinExpiryNotificationController.getInstance().publishNotification
  (SCREEN_LOCK_PIN_VALIDITY_PERIOD - 1);
  expect(res).assertTrue();
}

/**
 * 校验有效期大于15天时，发送pin码消息通知不发送通知
 */
function checkSendPinExpiryMsgFail_01() {
  let res: boolean = PinExpiryNotificationController.getInstance().publishNotification
  (SCREEN_LOCK_PIN_VALIDITY_PERIOD + 1);
  expect(res).assertFalse();
}