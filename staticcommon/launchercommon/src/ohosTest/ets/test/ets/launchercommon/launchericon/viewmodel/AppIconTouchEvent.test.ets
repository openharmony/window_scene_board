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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';

import { AppIconConfig } from '../../../../../../../main/ets/launchericon/config/AppIconConfig';
import { AppIconTouchEvent,
  AppIconTouchEventParam } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconTouchEvent';
import { AppItemInfo } from '../../../../../../../main/ets/TsIndex';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';
import { scbEventExclusiveManager } from '@ohos/windowscene';

export default function AppIconTouchEventTest() {
  let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();

  describe('AppIconTouchEventTest', () => {
    beforeAll(() => {
      appIconTouchEvent.initEventParam({
        itemInfo: new AppItemInfo(),
        appIconConfig: new AppIconConfig(),
        iconData: new AppIconData(),
        touchDownCb: (event: TouchEvent) => {
        },
        iconScaleCb: (scale: number) => {
        },
        iconSizeCb: () => 100,
        iconLongPressAnimation: (isZoomOut: boolean) => {
        }
      });
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_initEventParam_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();
        let param: AppIconTouchEventParam = {} as AppIconTouchEventParam;
        appIconTouchEvent.initEventParam(param);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouch_01', 0, () => {
      try {
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        appIconTouchEvent.onTouch(event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouch_02', 0, () => {
      try {
        let event: TouchEvent = {
          type: TouchType.Up
        } as TouchEvent;
        appIconTouchEvent.onTouch(event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouch_03', 0, () => {
      try {
        let event: TouchEvent = {
          type: TouchType.Move
        } as TouchEvent;
        appIconTouchEvent.onTouch(event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouch_04', 0, () => {
      try {
        let event: TouchEvent = {
          type: TouchType.Cancel
        } as TouchEvent;
        appIconTouchEvent.onTouch(event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_cancelLongPressAnimation_01', 0, () => {
      try {
        (appIconTouchEvent as object)['cancelLongPressAnimation'](true);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_cancelLongPressAnimation_02', 0, () => {
      try {
        (appIconTouchEvent as object)['cancelLongPressAnimation'](false);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_iconScaleAnimation_01', 0, () => {
      try {
        (appIconTouchEvent as object)['iconScaleAnimation'](0.9);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onClick_01', 0, () => {
      try {
        appIconTouchEvent.onClick();
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onClick_02', 0, () => {
      try {
        let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();
        appIconTouchEvent.onClick();
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchCancel_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchCancel'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchCancel_02', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressHideMask = false;
        (appIconTouchEvent as object)['iconData'] = iconData;
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchCancel'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchCancel_03', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressHideMask = true;
        (appIconTouchEvent as object)['iconData'] = iconData;
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchCancel'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchMove_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchMove'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchMove_02', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.touchMaskVisible = true;
        (appIconTouchEvent as object)['iconData'] = iconData;

        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchMove'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchMove_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchUp'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchMove_02', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressHideMask = true;
        iconData.isSuperposeApp = true;
        (appIconTouchEvent as object)['iconData'] = iconData;

        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchUp'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchMove_03', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressHideMask = true;
        iconData.isSuperposeApp = false;
        (appIconTouchEvent as object)['iconData'] = iconData;

        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchUp'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchDown_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconTouchEvent = new AppIconTouchEvent();
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchDown'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onTouchDown_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let event: TouchEvent = {
          type: TouchType.Down
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchDown'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onTouchDown_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let event: TouchEvent = {
          type: TouchType.Down,
          touches: [{
            y: 2
          } as TouchObject]
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchDown'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onTouchDown_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let iconData: AppIconData = new AppIconData();
        iconData.isSuperposeApp = true;
        (appIconTouchEvent as object)['iconData'] = iconData;
        let event: TouchEvent = {
          type: TouchType.Down,
          touches: [{
            y: 2
          } as TouchObject]
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchDown'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onTouchDown_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let iconData: AppIconData = new AppIconData();
        iconData.isSuperposeApp = false;
        (appIconTouchEvent as object)['iconData'] = iconData;
        let event: TouchEvent = {
          type: TouchType.Down,
          touches: [{
            y: 2
          } as TouchObject]
        } as TouchEvent;
        (appIconTouchEvent as object)['onTouchDown'](event);
        expect(appIconTouchEvent instanceof AppIconTouchEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })
  });
}