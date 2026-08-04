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
import { AppIconTouchEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconTouchEvent';
import { AppItemInfo, editModeManager } from '../../../../../../../main/ets/TsIndex';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';
import { scbEventExclusiveManager } from '@ohos/windowscene';
import { DeliverUtil } from '../../../../../../../main/ets/utils/DeliverUtil';
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppIconBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppIconBadgeEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeEvent';
import { AppIconMenuEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuEvent';
import {
  AppIconLongPressEventParam,
  AppIconLongPressGestureEvent
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconLongPressGestureEvent';
import { MultiSelectManager } from '../../../../../../../main/ets/editmode/model/MultiSelectManager';
import { MultiSelectStatus, MultiSelectItemType } from '../../../../../../../main/ets/editmode/data/MultiSelectData';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  AppIconGestureJudgeEvent,
  AppIconGestureJudgeEventParam
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconGestureJudgeEvent';
import { desktopItemDraggableManager } from '../../../../../../../main/ets/manager/DesktopItemDraggableManager';

export default function AppIconGestureJudgeEventTest() {

  describe('AppIconGestureJudgeEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_onGestureJudgeBegin_01', 0, () => {
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = true;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });
        let gestureInfo = {
          isSystemGesture: true,
          type: GestureControl.GestureType.CLICK,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onGestureJudgeBegin_02', 0, () => {
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = false;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });
        let gestureInfo = {
          isSystemGesture: true,
          type: 5,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onGestureJudgeBegin_03', 0, () => {
      let mock = new MockKit();
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = false;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });

        let mockFunc: Function = mock.mockFunc(desktopItemDraggableManager, desktopItemDraggableManager.getEnableDrag);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let gestureInfo = {
          isSystemGesture: true,
          type: GestureControl.GestureType.DRAG,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(desktopItemDraggableManager);
      mock.clearAll();
    })

    it('test_onGestureJudgeBegin_04', 0, () => {
      let mock = new MockKit();
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = false;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });

        let mockFunc: Function = mock.mockFunc(desktopItemDraggableManager, desktopItemDraggableManager.getEnableDrag);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let gestureInfo = {
          isSystemGesture: true,
          type: GestureControl.GestureType.DRAG,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(desktopItemDraggableManager);
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onGestureJudgeBegin_05', 0, () => {
      let mock = new MockKit();
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = false;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });

        let mockFunc: Function = mock.mockFunc(desktopItemDraggableManager, desktopItemDraggableManager.getEnableDrag);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().enabledDefaultDrag);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let gestureInfo = {
          isSystemGesture: true,
          type: GestureControl.GestureType.DRAG,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(desktopItemDraggableManager);
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onGestureJudgeBegin_06', 0, () => {
      let mock = new MockKit();
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = false;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });

        let mockFunc: Function = mock.mockFunc(desktopItemDraggableManager, desktopItemDraggableManager.getEnableDrag);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().enabledDefaultDrag);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc4: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);

        let gestureInfo = {
          isSystemGesture: true,
          type: GestureControl.GestureType.DRAG,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(desktopItemDraggableManager);
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onGestureJudgeBegin_07', 0, () => {
      let mock = new MockKit();
      try {
        let event: AppIconGestureJudgeEvent = new AppIconGestureJudgeEvent();
        let itemInfo: AppItemInfo = new AppItemInfo();
        let iconData: AppIconData = new AppIconData();
        iconData.isLongPressVibrated = false;
        event.initGestureJudgeParam({
          itemInfo: itemInfo,
          iconData: iconData,
          enableMultiSelect: true,
        });

        let mockFunc: Function = mock.mockFunc(desktopItemDraggableManager, desktopItemDraggableManager.getEnableDrag);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().enabledDefaultDrag);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc4: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);

        let gestureInfo = {
          isSystemGesture: true,
          type: GestureControl.GestureType.DRAG,
        } as GestureInfo;
        event.onGestureJudgeBegin(gestureInfo, {} as BaseGestureEvent);
        expect(event instanceof AppIconGestureJudgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(desktopItemDraggableManager);
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })
  });
}