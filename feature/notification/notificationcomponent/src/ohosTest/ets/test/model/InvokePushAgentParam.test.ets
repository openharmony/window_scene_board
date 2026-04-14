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
import { InvokePushAgentParam } from '../../../../main/ets/model/InvokePushAgentParam';
import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import { wantAgent } from '@kit.AbilityKit';

export default function InvokePushAgentParamTest() {

  describe('setPushWantInfo_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_pushWantInfo_when_pushWantInfo_is_valid', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = new wantAgent.WantAgentInfo();
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 0, 0, "");
      invokepushagentparam.setPushWantInfo(pushWantInfo);
      expect(invokepushagentparam.pushWantInfo).assertEqual(pushWantInfo);
    });
  });

  describe('getPushWantInfo_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_pushWantInfo_when_getPushWantInfo_is_called', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = new wantAgent.WantAgentInfo();
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 0, 0, "");
      const result = invokepushagentparam.getPushWantInfo();
      expect(result).assertEqual(pushWantInfo);
    });
  });

  describe('setStartResult_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_startResult_correctly', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            deviceId: 'device1',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 100, 200, "success");
      invokepushagentparam.setStartResult(300);
      expect(invokepushagentparam.startResult).assertEqual(300);
    });
  });

  describe('getStartResult_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_get_startResult_correctly', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            deviceId: 'device1',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 100, 200, "success");
      const result = invokepushagentparam.getStartResult(300);
      expect(result).assertEqual(300);
    });
  });

  describe('setCode', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should set the correct code', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            deviceId: 'device1',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 100, 200, "success");
      invokepushagentparam.setCode(123);
      expect(InvokePushAgentParam.code).assertEqual(123);
    });
  });

  describe('getCode', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should get the correct code', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            deviceId: 'device1',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 100, 200, "success");
      invokepushagentparam.setCode(123);
      const result = invokepushagentparam.getCode();
      expect(result).assertEqual(123);
    });
  });

  describe('setMessage', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should set the correct message', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            deviceId: 'device1',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 100, 200, "success");
      invokepushagentparam.setMessage('123');
      expect(InvokePushAgentParam.message).assertEqual('123');
    });
  });

  describe('getMessage', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should get the correct message', 0, () => {
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            deviceId: 'device1',
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITIES,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };
      let invokepushagentparam: InvokePushAgentParam = new InvokePushAgentParam(pushWantInfo, 100, 200, "success");
      invokepushagentparam.setMessage('123');
      const result = invokepushagentparam.getMessage('123');
      expect(result).assertEqual('123');
    });
  });
}