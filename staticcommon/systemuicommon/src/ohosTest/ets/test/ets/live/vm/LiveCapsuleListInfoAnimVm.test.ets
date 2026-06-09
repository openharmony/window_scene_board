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
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, DEFAULT, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { AnimateParams, AnimationBase, LiveVmInjector } from '../../../../../../../newIndex';
import {
  LiveCapsuleListMultipleHoleAnimVm
} from '../../../../../../main/ets/live/vm/LiveCapsuleListMultipleHoleAnimVm';
import { ILiveCapsuleListAnimVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleListAnimVm';
import { CapsuleShowType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { SystemUICommonUtil } from '../../../../../../main/ets/utils/SystemUICommonUtil';
import { BaseVm } from '../../../../main/ets/vm/BaseVm';
import { Log, LogUtil } from '../../../../main/ets/utils/LogUtil';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';

export default function LiveCapsuleListMultipleHoleInfoAnimVmTest() {
  describe('updateCapsuleWidthAndOffset_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_updateCapsuleAttribute_when_live_is_undefined', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.updateCapsuleAttribute);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.resolve());

      let liveList: LiveNotification[] = [new LiveNotification()];
      await livecapsulelistmultipleholeanimvm.updateCapsuleWidthAndOffset(liveList);

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.updateCapsuleAttribute);
    });

    it('should_call_updateCapsuleAttribute_when_live_is_defined', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.updateCapsuleAttribute);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.resolve());

      let liveList: LiveNotification[] = [new LiveNotification()];
      let live: LiveNotification = new LiveNotification();
      await livecapsulelistmultipleholeanimvm.updateCapsuleWidthAndOffset(liveList, live);

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.updateCapsuleAttribute);
    });

    it('should_call_updateCapsuleAttribute_with_correct_params', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.updateCapsuleAttribute);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(Promise.resolve());

      let liveList: LiveNotification[] = [new LiveNotification()];
      let live: LiveNotification = new LiveNotification();
      live.liveStyle = new LiveStyle();
      live.liveStyle.capsuleShowType = CapsuleShowType.Live;
      await livecapsulelistmultipleholeanimvm.updateCapsuleWidthAndOffset(liveList, live);

      let animateParams: AnimateParams = {
        width: LiveCapsuleListAnimBaseVm.DEFAULT_WIDTH,
        offset: LiveCapsuleListAnimBaseVm.DEFAULT_OFFSET,
        liveNotification: live
      };
      mocker.verify('updateCapsuleAttribute', [ArgumentMatchers.any, animateParams]).atLeast(1);

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.updateCapsuleAttribute);
    });
  });

  describe('expandCapsuleList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_capsuleList_is_empty', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
      when(mockfunc)().afterReturn({ liveList: [] });

      await livecapsulelistmultipleholeanimvm.expandCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
    });

    it('should_execute_animation_when_capsules_are_valid', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);

      let liveList: LiveNotification[] = [
        { id: 1, type: LiveStyle.NOTIFICATION, fixedShowType: CapsuleShowType.NONE, isShowed: false },
        { id: 2, type: LiveStyle.NOTIFICATION, fixedShowType: CapsuleShowType.ROUND_CAKE, isShowed: false }
      ];

      when(mockGetCapsuleListVm)().afterReturn({ liveList: liveList });
      when(mockGetCapsuleVm)({ live: liveList[0] }).afterReturn({ fixedShowType: CapsuleShowType.NONE, isShowed: false });
      when(mockGetCapsuleVm)({ live: liveList[1] }).afterReturn({ fixedShowType: CapsuleShowType.ROUND_CAKE, isShowed: false });
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj]).afterReturn(Promise.resolve());

      await livecapsulelistmultipleholeanimvm.expandCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);
    });
  });

  describe('collapseCapsuleList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_capsuleList_is_empty', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm(), livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm().getCapsuleListVm);
      when(mockfunc)([]).afterReturn({ liveList: [] });

      await livecapsulelistmultipleholeanimvm.collapseCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm(), livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm().getCapsuleListVm);
    });

    it('should_call_offsetDisappear_for_each_capsule_in_list', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfuncCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      let mockfuncCapsuleListVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm(), livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm().getCapsuleListVm);
      let mockfuncAnimation: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);

      let liveNotification: LiveNotification = new LiveNotification({});
      when(mockfuncCapsuleVm)([ArgumentMatchers.any]).afterReturn({ fixedShowType: CapsuleShowType.NONE });
      when(mockfuncCapsuleListVm)([]).afterReturn({ liveList: [liveNotification] });
      when(mockfuncAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistmultipleholeanimvm.collapseCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm(), livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm().getCapsuleListVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);
    });

    it('should_call_executeAnimation_when_cmds_is_not_empty', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfuncCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      let mockfuncCapsuleListVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm(), livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm().getCapsuleListVm);
      let mockfuncAnimation: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);

      let liveNotification: LiveNotification = new LiveNotification({});
      when(mockfuncCapsuleVm)([ArgumentMatchers.any]).afterReturn({ fixedShowType: CapsuleShowType.NONE });
      when(mockfuncCapsuleListVm)([]).afterReturn({ liveList: [liveNotification] });
      when(mockfuncAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistmultipleholeanimvm.collapseCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm(), livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm().getCapsuleListVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);
    });
  });

  describe('setCapsuleListFinalState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_all_necessary_functions_when_setCapsuleListFinalState_is_called', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();

      let mockCollapseCapsuleList: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockExpandCapsuleList: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSetCapsuleTransferState: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);
      when(mockSleep)(ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
    });

    it('should_handle_animation_correctly_when_setCapsuleListFinalState_is_called', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();

      let mockCollapseCapsuleList: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockExpandCapsuleList: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSetCapsuleTransferState: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);
      when(mockSleep)(ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

      let mockNotify: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.notify);
      when(mockNotify)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
      livecapsulelistmultipleholeanimvm.animation = mockAnimation;

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      expect(livecapsulelistmultipleholeanimvm.animation.params).assertInstanceOf(AnimateParams);
      expect(livecapsulelistmultipleholeanimvm.animation.name).assertEqual(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.notify);
    });

    it('should_handle_capsule_transfer_state_correctly_when_setCapsuleListFinalState_is_called', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();

      let mockCollapseCapsuleList: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockExpandCapsuleList: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSetCapsuleTransferState: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);
      when(mockSleep)(ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

      let mockNotify: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.notify);
      when(mockNotify)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleTransferParam: CapsuleTransferParam = {
        liveNotification: new LiveNotification(),
        capsuleShowType: CapsuleShowType.DEFAULT,
        isMock: false,
        mockLiveCapsule: null,
        mockCapsuleId: 0,
        style: LiveStyle.getStyle(LiveStyle.Names.DEFAULT)
      };

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      expect(livecapsulelistmultipleholeanimvm.capsuleTransferParam).assertDeepEquals(mockCapsuleTransferParam);

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.notify);
    });
  });

  describe('checkPointInArea_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_y_is_less_than_top', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let area: Area = new Area();
      area.globalPosition.y = 100;
      area.height = 200;
      area.globalPosition.x = 100;
      area.width = 200;

      let result = livebasevm.checkPointInArea(150, 50, area);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_y_is_greater_than_bottom', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let area: Area = new Area();
      area.globalPosition.y = 100;
      area.height = 200;
      area.globalPosition.x = 100;
      area.width = 200;

      let result = livebasevm.checkPointInArea(150, 250, area);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_x_is_less_than_left', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let area: Area = new Area();
      area.globalPosition.y = 100;
      area.height = 200;
      area.globalPosition.x = 100;
      area.width = 200;

      let result = livebasevm.checkPointInArea(50, 150, area);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_x_is_greater_than_right', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let area: Area = new Area();
      area.globalPosition.y = 100;
      area.height = 200;
      area.globalPosition.x = 100;
      area.width = 200;

      let result = livebasevm.checkPointInArea(250, 150, area);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_point_is_within_area', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let area: Area = new Area();
      area.globalPosition.y = 100;
      area.height = 200;
      area.globalPosition.x = 100;
      area.width = 200;

      let result = livebasevm.checkPointInArea(150, 150, area);
      expect(result).assertEqual(true);
    });
  });

  describe('convertColorToRgba_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_rgba_when_color_length_is_6', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let color: string = '#123456';
      let alpha: number = 0.5;
      let result: string = livebasevm.convertColorToRgba(color, alpha);
      expect(result).assertEqual('rgba(17,52,85,0.5)');
    });

    it('should_return_correct_rgba_when_color_length_is_8', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let color: string = '#12345678';
      let alpha: number = 0.5;
      let result: string = livebasevm.convertColorToRgba(color, alpha);
      expect(result).assertEqual('rgba(17,52,85,0.5)');
    });

    it('should_return_correct_rgba_when_color_length_is_6_with_alpha_0', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let color: string = '#123456';
      let alpha: number = 0;
      let result: string = livebasevm.convertColorToRgba(color, alpha);
      expect(result).assertEqual('rgba(17,52,85,0)');
    });

    it('should_return_correct_rgba_when_color_length_is_8_with_alpha_0', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let color: string = '#12345678';
      let alpha: number = 0;
      let result: string = livebasevm.convertColorToRgba(color, alpha);
      expect(result).assertEqual('rgba(17,52,85,0)');
    });

    it('should_return_correct_rgba_when_color_length_is_6_with_alpha_1', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let color: string = '#123456';
      let alpha: number = 1;
      let result: string = livebasevm.convertColorToRgba(color, alpha);
      expect(result).assertEqual('rgba(17,52,85,1)');
    });

    it('should_return_correct_rgba_when_color_length_is_8_with_alpha_1', 0, () => {
      let livebasevm: LiveBaseVm = new LiveBaseVm();
      let color: string = '#12345678';
      let alpha: number = 1;
      let result: string = livebasevm.convertColorToRgba(color, alpha);
      expect(result).assertEqual('rgba(17,52,85,1)');
    });
  });
}