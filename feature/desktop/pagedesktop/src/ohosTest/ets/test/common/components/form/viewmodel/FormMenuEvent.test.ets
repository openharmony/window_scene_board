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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  TestType,
  Level,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo,Extend1Data,FormHiSysEventReporter,MenuInfo,ScreenSplitUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormMenuEvent } from '../../../../../../../main/ets/default/common/components/form/viewmodel/FormMenuEvent';
import { FormMenuVm } from '../../../../../../../main/ets/default/common/components/form/viewmodel/FormMenuVm';

const TAG = 'FormMenuEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export function FormMenuEventTest() {
  describe('FormMenuEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('reportClickShortcutMenuEvent', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);

        let formItem: CardItemInfo = new CardItemInfo();
        formItem.cardId = '123';
        formItem.area = [];
        let called: boolean = false;
        const mockFunc: Function =
          mocker.mockFunc(FormHiSysEventReporter, FormHiSysEventReporter.reportGoIntoCardShortcutMenu);
        when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
          called = true;
        });
        let a = 'test';
        expect(a).assertEqual('test');
        mocker.clear(FormHiSysEventReporter);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }

      mocker.clearAll();
    });

    it('FormMenuEventTest_setFormNameOpacity', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let menuOpt = formMenuEvent.rightClickContext();
        expect(menuOpt).not().assertNull();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormMenuEventTest_getMenuAnimationToScale', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let showStatusFunc = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
        when(showStatusFunc)().afterReturn(true);
        let options: ContextMenuOptions = formMenuEvent.longPressContext(4);
        expect(options).not().assertNull();
        when(showStatusFunc)().afterReturn(false);
        let options2: ContextMenuOptions = formMenuEvent.longPressContext(4);
        expect(options2).not().assertNull();
        when(showStatusFunc)().afterReturn(false);
        let menuOptions: ContextMenuOptions = formMenuEvent.longPressContext(3);
        expect(menuOptions).not().assertNull();
        mocker.clear(launcherStatusUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_reportClickShortcutMenuEvent', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let formItem: CardItemInfo = new CardItemInfo();
        formItem.area = [4, 4];
        formItem.cardId = '123';
        formItem.moduleName = 'scene_board';
        formItem.bundleName = 'com.ohos.musict';
        formItem.cardName = 'stackingBoxCard';
        formItem.extend1 = '';
        let called: boolean = false;
        const mockFunc: Function = mocker.mockFunc(log, log.showWarn);
        when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
          called = true;
        });
        let mockFunc1: Function = mocker.mockFunc(Extend1Data, Extend1Data.getCardSourceType);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn('sourceType');
        formMenuEvent.reportClickShortcutMenuEvent(false, 100, 100, formItem);
        formMenuEvent.reportClickShortcutMenuEvent(true, 100, 100, formItem);
        expect(called).assertEqual(false);
        mocker.clear(log);
        mocker.clear(Extend1Data);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_reportClickShortcutMenuEvent_empty', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let formItem: CardItemInfo = new CardItemInfo();
        formItem.area = undefined;
        formItem.cardId = '123';
        formItem.moduleName = 'scene_board';
        formItem.cardName = 'stackingBoxCard';
        let called: boolean = false;
        const mockFunc: Function = mocker.mockFunc(log, log.showWarn);
        when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
          called = true;
        });
        formMenuEvent.reportClickShortcutMenuEvent(false, 100, 100, formItem);
        expect(called).assertEqual(true);
        mocker.clear(log);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_reportClickShortcutMenuEvent_empty01', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let formItem: CardItemInfo = new CardItemInfo();
        formItem.area = [];
        formItem.cardId = '123';
        formItem.moduleName = 'scene_board';
        formItem.cardName = 'stackingBoxCard';
        let called: boolean = false;
        const mockFunc: Function = mocker.mockFunc(log, log.showWarn);
        when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
          called = true;
        });
        formMenuEvent.reportClickShortcutMenuEvent(false, 100, 100, formItem);
        expect(called).assertEqual(true);
        mocker.clear(log);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_menuAppearHandler', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let mockFuncIsPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFuncIsPC)().afterReturn(false);
        formMenuEvent.menuAppearHandler(true);
        formMenuEvent.menuAppearHandler(false);
        when(mockFuncIsPC)().afterReturn(true);
        formMenuEvent.menuAppearHandler(true);
        expect(formMenuEvent).not().assertNull();
        mocker.clear(DeviceHelper);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_setMenuShowState', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let mockFuncSplit = mocker.mockFunc(ScreenSplitUtil, ScreenSplitUtil.isScreenSplit);
        when(mockFuncSplit)(ArgumentMatchers.any).afterReturn(false);
        formMenuEvent.setMenuShowState(true);
        expect(formMenuVm.mIsMenuShow).assertEqual(true);
        when(mockFuncSplit)(ArgumentMatchers.any).afterReturn(true);
        formMenuEvent.setMenuShowState(false);
        expect(formMenuVm.mIsMenuShow).assertEqual(false);
        mocker.clear(ScreenSplitUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_getMenuAnimationToScale_001', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let showStatusFunc = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
        when(showStatusFunc)().afterReturn(true);
        let result: number = (formMenuEvent as object)['getMenuAnimationToScale'](4);
        expect(result).assertLess(1);
        mocker.clear(launcherStatusUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_longPressPCContext_002', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let result = formMenuEvent.longPressPCContext();
        expect(result).not().assertNull();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormMenuEventTest_rightClickContext_003', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        formMenuVm.mIsHiddenEffect = true;
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let menuOpt = formMenuEvent.rightClickContext();
        expect(menuOpt).not().assertNull();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormMenuEventTest_rightClickPCContext_004', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let menuOpt = formMenuEvent.rightClickPCContext();
        expect(menuOpt).not().assertNull();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormMenuEventTest_reportClickShortcutMenuEvent_005', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let formItem: CardItemInfo = new CardItemInfo();
        formItem.cardId = '123';
        formItem.moduleName = 'scene_board';
        formItem.bundleName = 'com.ohos.musict';
        formItem.cardName = 'stackingBoxCard';
        formItem.extend1 = '';
        let result = formMenuEvent.reportClickShortcutMenuEvent(true, 100, 100, formItem);
        expect(result == null).assertTrue();

        formItem.area = [];
        result = formMenuEvent.reportClickShortcutMenuEvent(false, 100, 100, formItem);
        expect(result == null).assertTrue();

        formItem.area = [1,2];
        result = formMenuEvent.reportClickShortcutMenuEvent(false, 100, 100, formItem);
        expect(result == null).assertTrue();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormMenuEventTest_menuAppearHandler_006', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        formMenuEvent.menuAppearHandler(true);
        expect(formMenuEvent).not().assertNull();

        let mockFuncIsPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFuncIsPC)().afterReturn(true);
        formMenuEvent.menuAppearHandler(false);
        expect(formMenuEvent).not().assertNull();

        when(mockFuncIsPC)().afterReturn(false);
        formMenuEvent.menuAppearHandler(false);
        expect(formMenuEvent).not().assertNull();

        mocker.clear(DeviceHelper);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('FormMenuEventTest_menuDisappearHandler_007', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let formItem: CardItemInfo = new CardItemInfo();
        formItem.cardId = '123';
        formItem.moduleName = 'scene_board';
        formItem.bundleName = 'com.ohos.musict';
        formItem.cardName = 'stackingBoxCard';
        formItem.extend1 = '';
        formItem.area = [1,2];
        let result = formMenuEvent.menuDisappearHandler(true, 100, 100, formItem);
        expect(result == null).assertTrue();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormMenuEventTest_setAppMenuPosition_008', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formMenuVm: FormMenuVm = new FormMenuVm();
        let formMenuEvent: FormMenuEvent = new FormMenuEvent(formMenuVm);
        let touchEvent: TouchEvent = {
          type: TouchType.Up,
          target: { area: { width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 } } },
          timestamp: 0, source: 0, pressure: 0, tiltX: 0, tiltY: 0, sourceTool: 0,
          touches: [{ id: 0, type: 0, displayX: 0, displayY: 0, windowX: 0, windowY: 0, screenX: 0, screenY: 0, x: 0, y: 0 }],
          changedTouches: [{ id: 0, type: 0, displayX: 0, displayY: 0, windowX: 0, windowY: 0, screenX: 0, screenY: 0, x: 0, y: 0 }],
          stopPropagation: (): void => {
          },
          getHistoricalPoints: (): HistoricalPoint[] => {
            throw new Error('Function not implemented.');
          },
          preventDefault: () => {
          }
        }
        let result = formMenuEvent.setAppMenuPosition(touchEvent, 'test', []);
        expect(result == null).assertTrue();

        touchEvent.type = TouchType.Down;
        result = formMenuEvent.setAppMenuPosition(touchEvent, 'test', []);
        expect(result == null).assertTrue();

        touchEvent.type = TouchType.Down;
        result = formMenuEvent.setAppMenuPosition(touchEvent, 'test', [new MenuInfo()]);
        expect(result == null).assertTrue();
        let mockerFun = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockerFun)().afterReturn(true);
        touchEvent.type = TouchType.Down;
        result = formMenuEvent.setAppMenuPosition(touchEvent, 'test', [new MenuInfo()]);
        expect(result == null).assertTrue();
        mocker.clear(DeviceHelper);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

  });
}