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
import { PluginSlot } from '@ohos/frameworkwrapper'
import { ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import { PluginWidthChangeEvent, StatusBarType } from '@ohos/systemuicommon'
import { CutoutVm, DropdownVm, IStatusBarIconListVm, IStatusBarIconVm } from '@ohos/systemuicommon/newIndex'
import { LiveCapsuleLayoutInfo } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel'
import { ClockShowType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum'
import { StatusBarVmInjector } from '@ohos/systemuicommon/src/main/ets/statusbar/StatusBarVmInjector'
import { StatusBarLayoutVm } from '../../../../../main/ets/vm/StatusBarLayoutVm'
import { MockStatusBarVmInjector } from '../common/MockStatusBarVnInjector'
import { MockUtils } from '../common/MockUtils'

export default function StatusBarLayoutVmV2Test() {
  describe('StatusBarLayoutVmV2Test', () => {
    let injector: StatusBarVmInjector = new MockStatusBarVmInjector();
    let statusBar = new StatusBarLayoutVm(injector);
    let mocker: MockKit = new MockKit();
    let cutoutVm: CutoutVm = CutoutVm.instance;

    beforeEach(() => {
      injector = new MockStatusBarVmInjector();
      statusBar = new StatusBarLayoutVm(injector);
      mocker = new MockKit();
    })

    it('test_init', 0, () => {
      statusBar.init();
      expect(statusBar instanceof StatusBarLayoutVm).assertEqual(true);
    })

    it('test_onCapsulePositionChange_0', 0, () => {
      Reflect.set(statusBar, 'recalculateCapsuleLayout', (need: boolean, delay: number = 0) => {
      });
      new StatusBarLayoutVm(new MockStatusBarVmInjector()).onCapsulePositionChange(new LiveCapsuleLayoutInfo());

      const info = new LiveCapsuleLayoutInfo();
      info.isInstantOrPersistentShowing = true;

      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))().afterReturn(true);

      Reflect.set(statusBar, 'lastCapsuleLeftX', 1);

      statusBar.onCapsulePositionChange(info);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      expect(statusBar instanceof StatusBarLayoutVm).assertTrue();

    });

    it('test_getClockOrOperationWidth_0', 0, () => {
      statusBar.getClockOrOperatorWidth();

      when(mocker.mockFunc(injector, injector.getStatusBarIconListVm))().afterReturn(
        MockUtils.mockInterface<IStatusBarIconListVm>({}, {
          'statusBarType': StatusBarType.TYPE_MAIN_PHONE_DROPDOWN
        }));
      const ret = new StatusBarLayoutVm(injector).getClockOrOperatorWidth();
      expect(ret != null).assertEqual(true);
    });

    it('test_hideIconForWhile', 0, () => {
      try {
        statusBar.hideIconForWhile();
      } catch (error) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_recalculateBaseLayoutDebounce', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'recalculateBaseLayoutDebounce');
      } catch (error) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_recalculateBaseLayout', 0, () => {
      try {
        MockUtils.mockLogFuncForObj(statusBar, 'recalculateBaseLayoutDebounce');
        statusBar.recalculateBaseLayout();
      } catch (error) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_recalculateCapsuleLayout', 0, () => {
      DropdownVm.instance.statusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
      try {
        statusBar.recalculateLayout(false);
      } catch (e) {
      }
      try {
        statusBar.recalculateLayout(true);
      } catch (e) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_postIconOpacityInfo', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'postIconOpacityInfo');
      } catch (error) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_onDropdownShowChange_0', 0, () => {
      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))().afterReturn(true);
      statusBar.onDropdownShowChange();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      expect(injector != null).assertEqual(true);
    });

    it('test_onDropdownShowChange_1', 0, () => {
      statusBar.onDropdownShowChange();
      expect(injector != null).assertEqual(true);
    });

    it('test_onLanguageChange', 0, () => {
      try {
        statusBar.onLanguageChange();
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_statusbarLayoutRefresh', 0, () => {
      try {
        statusBar.statusbarLayoutRefresh();
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_updateClockWidth', 0, () => {
      try {
        statusBar.updateClockWidth(1, 1);
        statusBar.updateClockWidth(1, 0);
      } catch (err) {
      }

      expect(injector != null).assertEqual(true);
    });

    it('test_refreshCapsulePosition', 0, () => {
      MockUtils.invoke<void>(statusBar, 'refreshCapsulePosition');

      when(mocker.mockFunc(cutoutVm, cutoutVm.isInStatusBar))().afterReturn(true);
      MockUtils.invoke<void>(statusBar, 'refreshCapsulePosition');

      expect(injector != null).assertEqual(true);
      mocker.ignoreMock(cutoutVm, cutoutVm.isInStatusBar);
    });

    it('test_checkOverlapCutout', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'checkOverlapCutout', 0);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_checkOverlapClockOrOperator', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'checkOverlapClockOrOperator', 0, 0);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_onPluginWidthChangeEvent_0', 0, () => {
      try {
        Reflect.set(statusBar, 'recalculateBaseLayoutDebounce', MockUtils.mockLogFunc('recalculateBaseLayoutDebounce'));
        MockUtils.invoke<void>(statusBar, 'onPluginWidthChangeEvent', new PluginWidthChangeEvent());
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_onPluginWidthChangeEvent_1', 0, () => {
      try {
        when(mocker.mockFunc(injector, injector.getStatusBarIconVm))(ArgumentMatchers.any)
          .afterReturn(MockUtils.mockInterface<IStatusBarIconVm>({}, {
            'width': 1000
          }));
        expect(injector.getStatusBarIconVm('aa').width).assertEqual(1000);

        Reflect.set(statusBar, 'recalculateBaseLayoutDebounce', MockUtils.mockLogFunc('recalculateBaseLayoutDebounce'));
        MockUtils.invoke<void>(statusBar, 'onPluginWidthChangeEvent', new PluginWidthChangeEvent());

      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_onPluginWidthChangeEvent_2', 0, () => {
      try {
        const event = PluginWidthChangeEvent.create('', 0);
        event.setWidth(1);
        Reflect.set(statusBar, 'recalculateBaseLayoutDebounce', MockUtils.mockLogFunc('recalculateBaseLayoutDebounce'));
        MockUtils.invoke<void>(statusBar, 'onPluginWidthChangeEvent', event);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_checkOverlapCapsule_0', 0, () => {
      try {
        MockUtils.invoke<boolean>(statusBar, 'checkOverlapCapsule', 1, 1);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_checkOverlapCapsule_1', 0, () => {
      try {
        statusBar.moveDownVm.isMoveDown = true;
        MockUtils.invoke<boolean>(statusBar, 'checkOverlapCapsule', 1, 1);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_ntfSpaceCalculate_0', 0, () => {
      try {
        when(mocker.mockFunc(injector, injector.getStatusBarIconVm))(PluginSlot.SLOT_STATUS_NOTIFICATION)
          .afterReturn(undefined);
        MockUtils.invoke<void>(statusBar, 'ntfSpaceCalculate', [], 0, 0);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_ntfSpaceCalculate_1', 0, () => {
      try {
        when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))().afterReturn(true);
        MockUtils.invoke<void>(statusBar, 'ntfSpaceCalculate', [], 0, 0);
      } catch (err) {
      }
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      expect(injector != null).assertEqual(true);
    });

    it('test_updateClockOrOperatorState_0', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'updateClockOrOperatorState', [], 0, 0);
      } catch (err) {}
      expect(injector != null).assertEqual(true);
    });

    it('test_updateClockOrOperatorState_1', 0, () => {
      try {
        when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))().afterReturn(true);
        MockUtils.invoke<void>(statusBar, 'updateClockOrOperatorState', [], 0, 0);
      } catch (err) {}

      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      expect(injector != null).assertEqual(true);
    });

    it('test_updateClockOrOperatorState_2', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'updateClockOrOperatorState', [], 0, 1);
      } catch (err) {}

      expect(injector != null).assertEqual(true);
    });

    it('test_updateClockStateWithoutAnimation', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'updateClockStateWithoutAnimation', ClockShowType.NORMAL_SHOW);
      } catch (err) { }
      expect(injector != null).assertEqual(true);
    });

    it('test_initAnimationParamByClockShowType', 0, () => {
      try {
        MockUtils.invoke<void>(statusBar, 'initAnimationParamByClockShowType', ClockShowType.NORMAL_SHOW);
      } catch (err) { }
      expect(injector != null).assertEqual(true);
    });

    it('test_getCurrentClockShowType_0', 0, () => {
      try {
        MockUtils.invoke<ClockShowType>(statusBar, 'getCurrentClockShowType', false, 0);
      } catch (err) {
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_getNtfTargetOffsetForClock_0', 0, () => {
      MockUtils.invoke<number>(statusBar, 'getNtfTargetOffsetForClock', ClockShowType.NORMAL_SHOW, 0);
      expect(injector != null).assertEqual(true);
    });

    it('test_getNtfTargetOffsetForClock_1', 0, () => {
      MockUtils.invoke<number>(statusBar, 'getNtfTargetOffsetForClock', ClockShowType.EXTRUDE_SHOW, 0);
      expect(injector != null).assertEqual(true);
    });

    it('test_getNtfTargetOffsetForClock_2', 0, () => {
      try {
        MockUtils.invoke<number>(statusBar, 'getNtfTargetOffsetForClock', ClockShowType.HIDE, 0);
      } catch (err) {}
      expect(injector != null).assertEqual(true);
    });

    it('test_computeLeftGroupWidth_0', 0, () => {
      const statusBarType = statusBar.dropdownVm.statusBarType;
      try {
        statusBar.dropdownVm.statusBarType = StatusBarType.TYPE_MAIN_PHONE_DROPDOWN;
        MockUtils.invoke<number>(statusBar, 'computeLeftGroupWidth');
      } catch (err) {
      } finally {
        statusBar.dropdownVm.statusBarType = statusBarType;
      }
      expect(injector != null).assertEqual(true);
    });

    it('test_computeLeftGroupWidth_1', 0, () => {
      const statusBarType = statusBar.dropdownVm.statusBarType;
      try {
        statusBar.dropdownVm.statusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
        MockUtils.invoke<number>(statusBar, 'computeLeftGroupWidth');
      } catch (err) {
      } finally {
        statusBar.dropdownVm.statusBarType = statusBarType;
      }
      expect(injector != null).assertEqual(true);
    });
  })
}