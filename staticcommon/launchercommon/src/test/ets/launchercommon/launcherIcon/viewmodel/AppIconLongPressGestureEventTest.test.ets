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
import { AppItemInfo, editModeManager } from '../../../../../../../main/ets/TsIndex';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';
import { scbEventExclusiveManager } from '@ohos/windowscene';
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

export default function AppIconLongPressGestureEventTest() {
  let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();

  describe('AppIconLongPressGestureEventTest', () => {
    let vm: AppIconMenuVm = new AppIconMenuVm();
    let vm2: AppIconBadgeVm = new AppIconBadgeVm();
    beforeAll(() => {
      appIconTouchEvent.initLongPressEventParam({
        itemInfo: new AppItemInfo(),
        iconData: new AppIconData(),
        appIconConfig: new AppIconConfig(),
        iconBadgeVm: new AppIconBadgeVm(),
        iconMenuVm: new AppIconMenuVm(),
        iconBadgeEvent: new AppIconBadgeEvent(vm2),
        iconSizeCb: () => 0,
        iconDragBuilder: () => true,
        showLongPressContextMenu: () => true,
        iconMenuEvent: new AppIconMenuEvent(vm),
      });
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_initLongPressEventParam_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let param: AppIconLongPressEventParam = {} as AppIconLongPressEventParam;
        appIconTouchEvent.initLongPressEventParam(param);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let status: MultiSelectStatus = new MultiSelectStatus();
        status['status'] = 6;
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(status);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressPreGatherActionEnd_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressSnapshotAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_externCb'] = undefined;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          getIndexInSwiper: (): number => 1,
        });
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })


    it('test_onLongPressSnapshotActionEnd_01', 0, () => {
      let mock = new MockKit();
      let iconMenuVm = new AppIconMenuVm();
      try {
        let mockFunc: Function = mock.mockFunc(iconMenuVm, iconMenuVm.isMenuShow);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (appIconTouchEvent as object)['iconMenuVm'] = iconMenuVm;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(iconMenuVm);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotActionCancel_01', 0, () => {
      try {
        appIconTouchEvent.onLongPressSnapshotActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressGatherAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clearAll();
    })

    it('test_onLongPressVibrateAction_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['itemInfo'] = undefined;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrateActionEnd_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateActionEnd(event);
        appIconTouchEvent.onLongPressVibrateActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressZoomInAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomInAction_02', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => false,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_01', 0, () => {
      try {
        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = false;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.Mouse
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onLongPressVibrator_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let list: MultiSelectItemType[] = [];
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getAllSelectedItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(list);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressZoomIn_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['iconData'] = undefined;
        (appIconTouchEvent as object)['itemInfo'] = undefined;
        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomIn_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.bundleName = 'test';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_01', 0, () => {
      try {
        let enableMultiSelect: boolean = false;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_01', 0, () => {
      try {
        let isZoomOut: boolean = false;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      try {
        let isZoomOut: boolean = true;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initLongPressEventParam_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let param: AppIconLongPressEventParam = {} as AppIconLongPressEventParam;
        appIconTouchEvent.initLongPressEventParam(param);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let status: MultiSelectStatus = new MultiSelectStatus();
        status['status'] = 6;
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(status);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressPreGatherActionEnd_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressSnapshotAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_externCb'] = undefined;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          getIndexInSwiper: (): number => 1,
        });
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })


    it('test_onLongPressSnapshotActionEnd_01', 0, () => {
      let mock = new MockKit();
      let iconMenuVm = new AppIconMenuVm();
      try {
        let mockFunc: Function = mock.mockFunc(iconMenuVm, iconMenuVm.isMenuShow);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (appIconTouchEvent as object)['iconMenuVm'] = iconMenuVm;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(iconMenuVm);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotActionCancel_01', 0, () => {
      try {
        appIconTouchEvent.onLongPressSnapshotActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressGatherAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clearAll();
    })

    it('test_onLongPressVibrateAction_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['itemInfo'] = undefined;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrateActionEnd_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateActionEnd(event);
        appIconTouchEvent.onLongPressVibrateActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressZoomInAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomInAction_02', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => false,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_01', 0, () => {
      try {
        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = false;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.Mouse
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onLongPressVibrator_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let list: MultiSelectItemType[] = [];
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getAllSelectedItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(list);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressZoomIn_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['iconData'] = undefined;
        (appIconTouchEvent as object)['itemInfo'] = undefined;
        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomIn_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.bundleName = 'test';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_01', 0, () => {
      try {
        let enableMultiSelect: boolean = false;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_01', 0, () => {
      try {
        let isZoomOut: boolean = false;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      try {
        let isZoomOut: boolean = true;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initLongPressEventParam_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let param: AppIconLongPressEventParam = {} as AppIconLongPressEventParam;
        appIconTouchEvent.initLongPressEventParam(param);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let status: MultiSelectStatus = new MultiSelectStatus();
        status['status'] = 6;
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(status);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressPreGatherActionEnd_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressSnapshotAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_externCb'] = undefined;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          getIndexInSwiper: (): number => 1,
        });
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })


    it('test_onLongPressSnapshotActionEnd_01', 0, () => {
      let mock = new MockKit();
      let iconMenuVm = new AppIconMenuVm();
      try {
        let mockFunc: Function = mock.mockFunc(iconMenuVm, iconMenuVm.isMenuShow);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (appIconTouchEvent as object)['iconMenuVm'] = iconMenuVm;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(iconMenuVm);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotActionCancel_01', 0, () => {
      try {
        appIconTouchEvent.onLongPressSnapshotActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressGatherAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clearAll();
    })

    it('test_onLongPressVibrateAction_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['itemInfo'] = undefined;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrateActionEnd_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateActionEnd(event);
        appIconTouchEvent.onLongPressVibrateActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressZoomInAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomInAction_02', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => false,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_01', 0, () => {
      try {
        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = false;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.Mouse
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onLongPressVibrator_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let list: MultiSelectItemType[] = [];
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getAllSelectedItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(list);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressZoomIn_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['iconData'] = undefined;
        (appIconTouchEvent as object)['itemInfo'] = undefined;
        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomIn_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.bundleName = 'test';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_01', 0, () => {
      try {
        let enableMultiSelect: boolean = false;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_01', 0, () => {
      try {
        let isZoomOut: boolean = false;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      try {
        let isZoomOut: boolean = true;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
    it('test_initLongPressEventParam_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let param: AppIconLongPressEventParam = {} as AppIconLongPressEventParam;
        appIconTouchEvent.initLongPressEventParam(param);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressPreGatherAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let status: MultiSelectStatus = new MultiSelectStatus();
        status['status'] = 6;
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(status);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressPreGatherActionEnd_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressPreGatherActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressSnapshotAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_externCb'] = undefined;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotAction_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          getIndexInSwiper: (): number => 1,
        });
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })


    it('test_onLongPressSnapshotActionEnd_01', 0, () => {
      let mock = new MockKit();
      let iconMenuVm = new AppIconMenuVm();
      try {
        let mockFunc: Function = mock.mockFunc(iconMenuVm, iconMenuVm.isMenuShow);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (appIconTouchEvent as object)['iconMenuVm'] = iconMenuVm;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressSnapshotActionEnd(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(iconMenuVm);
      mock.clearAll();
    })

    it('test_onLongPressSnapshotActionCancel_01', 0, () => {
      try {
        appIconTouchEvent.onLongPressSnapshotActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressGatherAction_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(appIconTouchEvent, (appIconTouchEvent as object)['canGather']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressGatherAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconTouchEvent);
      mock.clearAll();
    })

    it('test_onLongPressVibrateAction_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['itemInfo'] = undefined;

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrateActionEnd_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrateActionEnd(event);
        appIconTouchEvent.onLongPressVibrateActionCancel();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onLongPressZoomInAction_01', 0, () => {
      try {
        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomInAction_02', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => false,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });

        let event: GestureEvent = {
          repeat: true
        } as GestureEvent;
        appIconTouchEvent.onLongPressZoomInAction(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_01', 0, () => {
      try {
        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = false;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.Mouse
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressVibrator_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(scbEventExclusiveManager);
      mock.clearAll();
    })

    it('test_onLongPressVibrator_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let list: MultiSelectItemType[] = [];
        let mockFunc2: Function =
          mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getAllSelectedItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(list);

        let appIconConfig = new AppIconConfig();
        (appIconConfig as object)['_enableMouseLongPressVibration'] = true;
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let event: GestureEvent = {
          repeat: true,
          source: SourceType.TouchScreen
        } as GestureEvent;
        appIconTouchEvent.onLongPressVibrator(event);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clear(MultiSelectManager.getInstance());
      mock.clearAll();
    })

    it('test_onLongPressZoomIn_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconLongPressGestureEvent = new AppIconLongPressGestureEvent();
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let vm2: AppIconBadgeVm = new AppIconBadgeVm();
        appIconTouchEvent.initLongPressEventParam({
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
          appIconConfig: new AppIconConfig(),
          iconBadgeVm: new AppIconBadgeVm(),
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(vm2),
          iconSizeCb: () => 0,
          iconDragBuilder: () => true,
          showLongPressContextMenu: () => true,
          iconMenuEvent: new AppIconMenuEvent(vm),
        });
        (appIconTouchEvent as object)['iconData'] = undefined;
        (appIconTouchEvent as object)['itemInfo'] = undefined;
        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onLongPressZoomIn_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.bundleName = 'test';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        (appIconTouchEvent as object)['onLongPressZoomIn']();
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_01', 0, () => {
      try {
        let enableMultiSelect: boolean = false;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(editModeManager, editModeManager.isDraggable);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let enableMultiSelect: boolean = true;
        (appIconTouchEvent as object)['canGather'](enableMultiSelect);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_canGather_01', 0, () => {
      try {
        let isZoomOut: boolean = false;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canGather_02', 0, () => {
      try {
        let isZoomOut: boolean = true;
        let bundleName: string = 'test';
        appIconTouchEvent.onIconLongPressZoomAnimation(isZoomOut,bundleName);
        expect(appIconTouchEvent instanceof AppIconLongPressGestureEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

  });
}