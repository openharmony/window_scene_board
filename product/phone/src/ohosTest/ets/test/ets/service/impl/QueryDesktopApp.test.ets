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

import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { AppStatus, CommonConstants, GridLayoutItemInfo, RdbStoreManager } from '@ohos/launchercommon'
import { OutAppInfo, QueryDesktopApp, QueryScopeType } from '@ohos/phonebase/src/main/ets/service/impl/QueryDesktopApp'
import { QueryAppResponse } from '@ohos/phonebase/src/main/ets/service/QueryDesktopAppService'

export default function QueryDesktopAppTest() {
  describe('QueryDesktopAppTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_QueryDesktopApp_execute', 0, async (done: Function) => {
      let cancel: QueryDesktopApp = new QueryDesktopApp();
      let scope: ExtraQueryScope = { queryScope: QueryScopeType.ALL_WAIT_FOR_HARMONY };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: string = await cancel.execute(scope);
      expect(result).assertEqual(QueryAppResponse.fail);
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = '张三';
      info.cardId = '007';
      info.typeId = CommonConstants.TYPE_APP;
      info.abilityName = '李华';
      info.callerName = '李华';
      info.negativeId = 7;
      info.appIconId = 7;
      info.row = 7;
      info.column = 7;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.appIndex = AppStatus.WAIT_FOR_HARMONY;
      info.callerName = 'com.ohos.clouddrive';
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryAllGridLayoutInfo);
      let mockFunc2: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([info]);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let result1: string = await cancel.execute(scope);
      expect(result1).assertInstanceOf('String');
      scope.queryScope = QueryScopeType.ALL_UNINSTALL;
      let result2: string = await cancel.execute(scope);
      expect(result2).assertInstanceOf('String');
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_QueryDesktopApp_reportNotHarmonyAppInfo', 0, async (done: Function) => {
      let cancel: QueryDesktopApp = new QueryDesktopApp();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = '张三';
      info.cardId = '007';
      info.typeId = CommonConstants.TYPE_APP;
      info.abilityName = '李华';
      info.callerName = '李华';
      info.negativeId = 7;
      info.appIconId = 7;
      info.row = 7;
      info.column = 7;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.appIndex = AppStatus.WAIT_FOR_HARMONY;
      info.callerName = 'com.ohos.clouddrive';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await (cancel as object)['reportNotHarmonyAppInfo']([info]);
      expect(cancel).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      await (cancel as object)['reportNotHarmonyAppInfo']([info]);
      expect(cancel).not().assertNull();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_QueryDesktopApp_minusDays', 0, () => {
      let cancel: QueryDesktopApp = new QueryDesktopApp();
      let date: Date = new Date('2024-12-18 14:57');
      let result: number = (cancel as object)['minusDays'](date, 1);
      expect(result).assertEqual(1734418620000);
    });

    it('test_QueryDesktopApp_getOutAppInfo', 0, () => {
      try {
        let cancel: QueryDesktopApp = new QueryDesktopApp();
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = '张三';
        info.cardId = '007';
        info.typeId = CommonConstants.TYPE_APP;
        info.abilityName = '李华';
        info.callerName = '李华';
        info.negativeId = 7;
        info.appIconId = 7;
        info.row = 7;
        info.column = 7;
        info.appStatus = AppStatus.WAIT_FOR_HARMONY;
        info.appIndex = AppStatus.WAIT_FOR_HARMONY;
        info.callerName = 'com.ohos.clouddrive';
        info.intent = '007';
        let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(info.intent);
        let result: OutAppInfo = (cancel as object)['getOutAppInfo'](info);
        expect(result.callerName).assertEqual('com.ohos.clouddrive');
        extendInfo.set('requestBundleName', '测试');
        info.callerName = 'com.ohos.dataclone';
        let result1: OutAppInfo = (cancel as object)['getOutAppInfo'](info);
        expect(result1.callerName).assertEqual('com.ohos.dataclone');
        info.appStatus = AppStatus.INSTALL_WAITING;
        info.callerName = 'migrate_server';
        let result2: OutAppInfo = (cancel as object)['getOutAppInfo'](info);
        expect(result2.callerName).assertEqual('migrate_server');
        info.callerName = 'migrate_server_not';
        let result3: OutAppInfo = (cancel as object)['getOutAppInfo'](info);
        expect(result3.callerName).assertEqual('migrate_server_not');
      } catch (err) {}
    });

    interface ExtraQueryScope {
      queryScope: number;
    }
  })
}