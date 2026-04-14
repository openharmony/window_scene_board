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

export default function LiveCapsuleListMultipleHoleInfoAnimVmTest() {
  describe('setCapsuleListFinalState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_setCapsuleTransferState_and_expandCapsuleList_and_collapseCapsuleList', 0, async () => {
      let mocker: MockKit = new MockKit();
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm =
        new LiveCapsuleListMultipleHoleAnimVm();

      let mockSetCapsuleTransferState: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockExpandCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockCollapseCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
    });

    it('should_handle_animation_correctly', 0, async () => {
      let mocker: MockKit = new MockKit();
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm =
        new LiveCapsuleListMultipleHoleAnimVm();

      let mockSetCapsuleTransferState: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockExpandCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockCollapseCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
      livecapsulelistmultipleholeanimvm.animation = mockAnimation;

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      expect(mockAnimation.duration).assertEqual(livecapsulelistmultipleholeanimvm.expandListDelayTime * 2);
      expect(mockAnimation.playMode).assertEqual(AnimationBase.PlayMode.PLAY_MODE_SEQUENTIAL);

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
    });

    it('should_handle_capsuleShowType_correctly', 0, async () => {
      let mocker: MockKit = new MockKit();
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm =
        new LiveCapsuleListMultipleHoleAnimVm();

      let mockSetCapsuleTransferState: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockExpandCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockCollapseCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      livecapsulelistmultipleholeanimvm.capsuleShowType = CapsuleShowType.SHOW_TYPE_SIMULTANEOUS;

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      expect(livecapsulelistmultipleholeanimvm.animation.params)
        .assertContain(new AnimateParams(LiveStyle.LIVE_ANIMATION_SIMULTANEOUS_TYPE,
          CapsuleShowType.SHOW_TYPE_SIMULTANEOUS));

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
    });

    it('should_handle_capsuleTransferParam_correctly', 0, async () => {
      let mocker: MockKit = new MockKit();
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm =
        new LiveCapsuleListMultipleHoleAnimVm();

      let mockSetCapsuleTransferState: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockSetCapsuleTransferState)(ArgumentMatchers.any).afterReturnNothing();

      let mockExpandCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      when(mockExpandCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockCollapseCapsuleList: Function =
        mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
      when(mockCollapseCapsuleList)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      livecapsulelistmultipleholeanimvm.capsuleTransferParam = new CapsuleTransferParam(true, true);

      await livecapsulelistmultipleholeanimvm.setCapsuleListFinalState();

      expect(livecapsulelistmultipleholeanimvm.animation.params)
        .assertContain(new AnimateParams(LiveStyle.LIVE_ANIMATION_TRANSFER_SUCCESS, true));
      expect(livecapsulelistmultipleholeanimvm.animation.params)
        .assertContain(new AnimateParams(LiveStyle.LIVE_ANIMATION_TRANSFER_CONTINUOUS, true));

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.collapseCapsuleList);
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
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
      when(mockfunc)([]).afterReturn({ liveList: [] });

      await livecapsulelistmultipleholeanimvm.collapseCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
    });

    it('should_execute_animation_when_capsuleList_is_not_empty', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);

      let liveList: LiveNotification[] = [
        new LiveNotification(),
        new LiveNotification()
      ];
      let capsuleShowType: CapsuleShowType = CapsuleShowType.NONE;
      let liveCapsuleVm: ILiveCapsuleVm = {
        fixedShowType: capsuleShowType,
        style: LiveStyle.HIGHLIGHT
      };
      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: liveList });
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(liveCapsuleVm);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      await livecapsulelistmultipleholeanimvm.collapseCapsuleList();

      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.vmInjector, livecapsulelistmultipleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);
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
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListVm);
      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: [] });
      livecapsulelistmultipleholeanimvm.vmInjector = vmInjector;
      await livecapsulelistmultipleholeanimvm.expandCapsuleList();
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListVm);
    });

    it('should_skip_capsules_when_fixedShowType_is_NONE', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListVm);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn({ fixedShowType: CapsuleShowType.NONE, isShowed: false });
      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: [new LiveNotification()] });
      livecapsulelistmultipleholeanimvm.vmInjector = vmInjector;
      await livecapsulelistmultipleholeanimvm.expandCapsuleList();
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListVm);
    });

    it('should_skip_capsules_when_fixedShowType_is_ROUND_CAKE_and_isShowed_is_false', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListVm);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn({ fixedShowType: CapsuleShowType.ROUND_CAKE, isShowed: false });
      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: [new LiveNotification()] });
      livecapsulelistmultipleholeanimvm.vmInjector = vmInjector;
      await livecapsulelistmultipleholeanimvm.expandCapsuleList();
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListVm);
    });

    it('should_execute_animation_when_cmds_is_not_empty', 0, async () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn({ fixedShowType: CapsuleShowType.NONE, isShowed: true });
      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: [new LiveNotification()] });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());
      livecapsulelistmultipleholeanimvm.vmInjector = vmInjector;
      await livecapsulelistmultipleholeanimvm.expandCapsuleList();
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListVm);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm.animation, livecapsulelistmultipleholeanimvm.animation.executeAnimation);
    });
  });

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

  describe('setCapsuleTransferState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_setCapsuleTransferState_when_capsuleTransferParam_is_null', 0, () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      livecapsulelistmultipleholeanimvm.setCapsuleTransferState();
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
    });

    it('should_call_setCapsuleTransferState_when_capsuleTransferParam_is_not_null', 0, () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let capsuleTransferParam: CapsuleTransferParam = {
        liveNotification: new LiveNotification(),
        expand: true,
        style: LiveStyle.LiveStyleNone,
        showType: CapsuleShowType.CapsuleShowTypeInit,
        animateio: new AnimateParams(),
        animation: new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION),
        delayTime: 0
      };
      livecapsulelistmultipleholeanimvm.setCapsuleTransferState(capsuleTransferParam);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
    });

    it('should_call_setCapsuleTransferState_when_capsuleTransferParam_is_not_null_and_expand_is_false', 0, () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let capsuleTransferParam: CapsuleTransferParam = {
        liveNotification: new LiveNotification(),
        expand: false,
        style: LiveStyle.LiveStyleNone,
        showType: CapsuleShowType.CapsuleShowTypeInit,
        animateio: new AnimateParams(),
        animation: new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION),
        delayTime: 0
      };
      livecapsulelistmultipleholeanimvm.setCapsuleTransferState(capsuleTransferParam);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
    });

    it('should_call_setCapsuleTransferState_when_capsuleTransferParam_is_not_null_and_style_is_not_None', 0, () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let capsuleTransferParam: CapsuleTransferParam = {
        liveNotification: new LiveNotification(),
        expand: true,
        style: LiveStyle.LiveStyleBold,
        showType: CapsuleShowType.CapsuleShowTypeInit,
        animateio: new AnimateParams(),
        animation: new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION),
        delayTime: 0
      };
      livecapsulelistmultipleholeanimvm.setCapsuleTransferState(capsuleTransferParam);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
    });

    it('should_call_setCapsuleTransferState_when_capsuleTransferParam_is_not_null_and_showType_is_not_Init', 0, () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let capsuleTransferParam: CapsuleTransferParam = {
        liveNotification: new LiveNotification(),
        expand: true,
        style: LiveStyle.LiveStyleNone,
        showType: CapsuleShowType.CapsuleShowTypeRunning,
        animateio: new AnimateParams(),
        animation: new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION),
        delayTime: 0
      };
      livecapsulelistmultipleholeanimvm.setCapsuleTransferState(capsuleTransferParam);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
    });

    it('should_call_setCapsuleTransferState_when_capsuleTransferParam_is_not_null_and_delayTime_is_not_0', 0, () => {
      let livecapsulelistmultipleholeanimvm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let capsuleTransferParam: CapsuleTransferParam = {
        liveNotification: new LiveNotification(),
        expand: true,
        style: LiveStyle.LiveStyleNone,
        showType: CapsuleShowType.CapsuleShowTypeInit,
        animateio: new AnimateParams(),
        animation: new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION),
        delayTime: 1000
      };
      livecapsulelistmultipleholeanimvm.setCapsuleTransferState(capsuleTransferParam);
      mocker.ignoreMock(livecapsulelistmultipleholeanimvm, livecapsulelistmultipleholeanimvm.setCapsuleTransferState);
    });
  });
}