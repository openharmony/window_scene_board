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


import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  when } from '@ohos/hypium'
import { FormHiSysEventReporter } from '../../../../../../main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  ClickAddCardEvent,
  DragAddCardEvent,
  ClickCardShortcutMenuEvent,
  RemoveCardEvent
} from '../../../../../../main/ets/utils/FormHiSysEventReporter';

export default function FormHiSysEventReporterTest() {
  describe('FormHiSysEventReporterTest', () => {
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
    it('FormHiSysEventReporterTest_reportAddCardToScreenByClick', 0, () => {
      FormHiSysEventReporter.reportAddCardToScreenByClick({
        packageName: 'com.ohos.test',
        area: [1, 1],
        dpSize: '',
        formId: '',
        moduleName: 'module',
        formName: '',
        page: 0,
        addType: 0,
        column: 0,
        row: 0,
        screenType: 0
      } as ClickAddCardEvent);
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_reportAddCardToScreenByDrag', 0, () => {
      FormHiSysEventReporter.reportAddCardToScreenByDrag({
        packageName: 'com.ohos.test',
        area: [],
        dpSize: '1',
        formId: '',
        moduleName: 'm',
        formName: '1',
        page: 0,
        addType: 0,
        resultType: 0,
        column: 0,
        row: 0,
        sourceType: '1',
      } as DragAddCardEvent);
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_reportGoIntoCardShortcutMenu', 0, () => {
      FormHiSysEventReporter.reportGoIntoCardShortcutMenu({
        packageName: 'com.ohos.test',
        area: [],
        dpSize: '',
        formId: '',
        moduleName: 'name',
        formName: '',
        menuType: 0,
        infoType: 0,
        sourceType: '0',
      } as ClickCardShortcutMenuEvent);
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_reportClickCard', 0, () => {
      FormHiSysEventReporter.reportClickCard({
        bundleName: 'com.ohos.dtest',
        cellSize: '',
        dpSize: '',
        page: 0,
        pageCount: 0,
        formId: '',
        moduleName: 'abc',
        formName: '',
        column: 0,
        row: 0,
        infoType: 0,
        sourceType: '0',
      });
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_reportRemoveCard', 0, () => {
      FormHiSysEventReporter.reportRemoveCard({
        packageName: 'com.ohos.test',
        area: [],
        formId: '',
        moduleName: 'time',
        formName: '',
        position: '',
        resultType: 0,
        sourceType: '0',
      } as RemoveCardEvent);
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_reportMoveCard', 0, () => {
      FormHiSysEventReporter.reportMoveCard({
        packageName: 'com.ohos.test',
        area: [],
        moveFrom: '',
        moveTo: '2',
        formId: '',
        moduleName: 'app',
        formName: '',
        sourceType: '0',
      });
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_reportMoveCardToIntelligent', 0, () => {
      FormHiSysEventReporter.reportMoveCardToIntelligent({
        packageName: 'com.ohos.test',
        area: [11, 22],
        moveFrom: '5',
        formId: '',
        moduleName: '',
        formName: '',
        sourceType: '0',
      });
      expect(true).assertTrue();
    })

    it('FormHiSysEventReporterTest_getDeviceType', 0, () => {
      expect(FormHiSysEventReporter.getDeviceType()).assertInstanceOf('Number');
      let mocker: MockKit = new MockKit();
      try{
        const mockerFunc1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
        when(mockerFunc1)().afterReturn(true);
        FormHiSysEventReporter.getDeviceType();
        when(mockerFunc1)().afterReturn(false);
        const mockerFunc2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockerFunc2)().afterReturn(true);
        expect(FormHiSysEventReporter.getDeviceType()).assertEqual(0);
      } catch (e){}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
  })
}
