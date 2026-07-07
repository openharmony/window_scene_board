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

import { FormViewModel } from '@ohos/form';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
} from '@ohos/hypium';
import {
  CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AiSuggestionEventReporter } from '../../../../../../main/ets/default/donate/AiSuggestionEventReporter';

export default function AiSuggestionEventReporterTest() {
  describe('AiSuggestionEventReporterTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('AiSuggestionEventReporterTest_getDeviceType_01', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(func)().afterReturn(true);

      expect((reporter as object)['getDeviceType']()).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionEventReporterTest_getDeviceType_02', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      const func2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(func1)().afterReturn(false);
      when(func2)().afterReturn(true);

      expect((reporter as object)['getDeviceType']()).assertEqual(1);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionEventReporterTest_getRequestTime_01', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      reporter.requestTime = TIME_MIN;
      expect((reporter as object)['getRequestTime']()).assertEqual(0);
    });

    it('AiSuggestionEventReporterTest_getRequestTime_02', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      reporter.receiveTime = TIME_MIN;
      expect((reporter as object)['getRequestTime']()).assertEqual(0);
    });

    it('AiSuggestionEventReporterTest_getRequestTime_03', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      const TIME_MAX = 10;
      reporter.receiveTime = TIME_MAX;
      reporter.requestTime = TIME_MIN;
      expect((reporter as object)['getRequestTime']()).assertEqual(4);
    });

    it('AiSuggestionEventReporterTest_getRequestTime_04', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      const TIME_MAX = 10;
      reporter.receiveTime = TIME_MIN;
      reporter.requestTime = TIME_MAX;
      expect((reporter as object)['getRequestTime']()).assertEqual(0);
    });

    it('AiSuggestionEventReporterTest_getRefreshTime_01', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      reporter.receiveTime = 0;
      reporter.requestTime = TIME_MIN;
      expect((reporter as object)['getRefreshTime']()).assertEqual(0);
    });

    it('AiSuggestionEventReporterTest_getRefreshTime_02', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      reporter.receiveTime = TIME_MIN;
      reporter.requestTime = 0;
      expect((reporter as object)['getRefreshTime']()).assertEqual(0);
    });

    it('AiSuggestionEventReporterTest_getRefreshTime_03', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      const TIME_MAX = 10;
      reporter.receiveTime = TIME_MIN;
      reporter.requestTime = TIME_MAX;
      expect((reporter as object)['getRefreshTime']() > 0).assertTrue();
    });

    it('AiSuggestionEventReporterTest_getRefreshTime_04', 0, () => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      const TIME_MIN = 6;
      const TIME_MAX = 10;
      reporter.receiveTime = TIME_MIN;
      reporter.requestTime = new Date().getTime() + TIME_MAX;
      expect((reporter as object)['getRefreshTime']()).assertEqual(0);
    });

    it('AiSuggestionEventReporterTest_reportSuggestionFormIconLongPress_01', 0,
      async (done: Function): Promise<void> => {
        let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
        const recItem: LauncherRecItem = new LauncherRecItem();
        recItem.itemType = CommonConstants.TYPE_CARD;
        let mocker: MockKit = new MockKit();
        let called: boolean = false;
        let action: () => void = (): void => {
          called = true;
        };
        const func: Function = mocker.mockFunc(reporter, reporter.getVersionCode);
        when(func)().afterAction(action);

        reporter.reportSuggestionFormIconLongPress(new GridLayoutItemInfo(), recItem);
        expect(called).assertFalse();
        mocker.clear(reporter);
        mocker.clearAll();
        done();
      });

    it('AiSuggestionEventReporterTest_reportSuggestionFormIconLongPress_02', 0,
      async (done: Function): Promise<void> => {
        let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
        const recItem: LauncherRecItem = new LauncherRecItem();
        recItem.itemType = CommonConstants.TYPE_APP;
        let mocker: MockKit = new MockKit();
        let called: boolean = false;
        let action: () => void = (): void => {
          called = true;
        };
        const func: Function = mocker.mockFunc(reporter, reporter.getVersionCode);
        when(func)().afterAction(action);

        reporter.reportSuggestionFormIconLongPress(new GridLayoutItemInfo(), recItem);
        expect(called).assertTrue();
        mocker.clear(reporter);
        mocker.clearAll();
        done();
      });

    it('AiSuggestionEventReporterTest_reportSuggestionFormMenu_01', 0, async (done: Function): Promise<void> => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      let instance: FormViewModel = FormViewModel.getInstance();
      const recItem: LauncherRecItem = new LauncherRecItem();
      recItem.itemType = CommonConstants.TYPE_APP;
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => {
        called = true;
      };
      const func: Function = mocker.mockFunc(instance, instance.getFormStyleConfig);
      when(func)().afterAction(action);

      reporter.reportSuggestionFormMenu(new GridLayoutItemInfo(), recItem);
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('AiSuggestionEventReporterTest_reportSuggestionFormMenu_02', 0, async (done: Function): Promise<void> => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      let instance: FormViewModel = FormViewModel.getInstance();
      const recItem: LauncherRecItem = new LauncherRecItem();
      recItem.itemType = CommonConstants.TYPE_CARD;
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => {
        called = true;
      };
      const func: Function = mocker.mockFunc(instance, instance.getFormStyleConfig);
      when(func)().afterAction(action);

      reporter.reportSuggestionFormMenu(new GridLayoutItemInfo(), recItem);
      expect(called).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('AiSuggestionEventReporterTest_getVersionCode', 0, async (done: Function): Promise<void> => {
      let reporter: AiSuggestionEventReporter = AiSuggestionEventReporter.getInstance();
      (reporter as object)['codeValue'] = '3.2';
      expect(await reporter.getVersionCode()).assertEqual('3.2');
      (reporter as object)['codeValue'] = '';
      done();
    });
  });
}