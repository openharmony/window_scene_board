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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { SystemuiConstants } from '@ohos/systemuicommon/src/main/ets/TsIndex'
import { NtfMgr } from '../../../../main/ets/model/NotificationManager'
import { Want, wantAgent } from '@kit.AbilityKit'
import { InvokePushAgentParam } from '../../../../main/ets/model/InvokePushAgentParam'

export default function NotificationManagerTest() {
  describe('NotificationManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('should_start_push_agent', 0, () => {
      const pushWant: Want = {
        'bundleName': SystemuiConstants.PUSH_BUNDLE_NAME,
        'parameters': {
          'startAppResult': SystemuiConstants.INVOKE_APP_SUCCESS
        }
      };

      const pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          pushWant
        ],
        wantAgentFlags: [wantAgent.WantAgentFlags.ONE_TIME_FLAG],
        requestCode: SystemuiConstants.INVOKE_APP_SUCCESS,
        actionType: 0
      }
      NtfMgr.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
        SystemuiConstants.INVOKE_APP_SUCCESS, ''));
      // 验证startPushAgent是否成功调用
      expect(NtfMgr.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
        SystemuiConstants.INVOKE_APP_SUCCESS, ''))).assertPromiseIsRejected();
      // 验证startPushAgent是否抛出特定错误
      expect(NtfMgr.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
        SystemuiConstants.INVOKE_APP_SUCCESS, ''))).assertPromiseIsRejectedWith(TypeError);
    })
  })
}