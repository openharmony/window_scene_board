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
import curves from '@ohos.curves';
import { AnimateParams, AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { ILiveCapsuleListAnimVm } from '../../../../main/ets/live/interface/ILiveCapsuleListAnimVm';
import { CapsuleShowType } from '../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleListAnimBaseVm } from '../../../../main/ets/live/vm/LiveCapsuleListAnimBaseVm';
import { CapsuleTransferParam } from '../../../../main/ets/live/interface/ILiveCapsuleListVm';
import { SystemUICommonUtil } from '../../../../main/ets/utils/SystemUICommonUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleListSingleHoleAnimVm } from '../../../../main/ets/live/vm/LiveCapsuleListSingleHoleAnimVm';

export default function LiveCapsuleListSingleHoleAnimVmTest() {
  describe('setCapsuleListFinalState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_collapseCapsuleList_and_expandCapsuleList_when_capsuleTransferParam_is_undefined', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCollapse: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      let mockExpand: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);

      when(mockCollapse)([]).afterReturn(Promise.resolve());
      when(mockExpand)([]).afterReturn(Promise.resolve());

      await livecapsulelistsingleholeanimvm.setCapsuleListFinalState();

      mocker.verify('expandCapsuleList', []).once();
      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);
    });
    it('should_call_collapseCapsuleList_and_expandCapsuleList_when_capsuleTransferParam_is_provided', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCollapse: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      let mockExpand: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);
      let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);

      let param: CapsuleTransferParam = new CapsuleTransferParam();
      param.showType = CapsuleShowType.LIVE_SHOW_TYPE_DIALOG;
      param.liveNotification = new LiveNotification();
      param.liveNotification.style = LiveStyle.LIVE_STYLE_SUCCESS;
      param.liveCapsuleIndex = 0;
      param.liveNotification.expandStartTime = 0;
      param.liveNotification.expandEndTime = 0;
      param.liveNotification.contractStartTime = 0;
      param.liveNotification.contractEndTime = 0;
      param.liveNotification.liveStartTime = 0;
      param.liveNotification.liveEndTime = 0;
      param.liveNotification.duration = 0;
      param.liveNotification.speed = 0;
      param.liveNotification.curve = curves.Curve.EaseIn;
      param.liveCapsuleListItem = new EsObject();
      param.liveCapsuleListItem.startTime = 0;
      param.liveCapsuleListItem.endTime = 0;
      param.liveCapsuleListItem.currentIndex = 0;
      param.liveCapsuleListItem.totalNum = 0;
      param.liveCapsuleListItem.speed = 0;
      param.liveCapsuleListItem.curve = curves.Curve.EaseIn;
      param.liveCapsuleListItem.expandStartTime = 0;
      param.liveCapsuleListItem.expandEndTime = 0;
      param.liveCapsuleListItem.contractStartTime = 0;
      param.liveCapsuleListItem.contractEndTime = 0;
      param.liveCapsuleListItem.liveStartTime = 0;
      param.liveCapsuleListItem.liveEndTime = 0;
      param.liveCapsuleListItem.duration = 0;
      param.liveCapsuleListItem.speed = 0;
      param.liveCapsuleListItem.curve = curves.Curve.EaseIn;

      when(mockCollapse)([]).afterReturn(Promise.resolve());
      when(mockExpand)([ArgumentMatchers.any]).afterReturn(Promise.resolve());
      when(mockSleep)([ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsulelistsingleholeanimvm.setCapsuleListFinalState(param);

      mocker.verify('expandCapsuleList', []).once();
      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
    });

    it('should_execute_animation_when_capsule_list_is_not_empty', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      let capsuleVm1: ILiveCapsuleVm = {
        offsetX: 10,
        isRemindShow: false,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm2: ILiveCapsuleVm = {
        offsetX: 0,
        isRemindShow: true,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm3: ILiveCapsuleVm = {
        offsetX: 5,
        isRemindShow: false,
        styleType: CapsuleShowType.DEFAULT
      };
      let liveList: LiveNotification[] = [
        { id: 1, capsuleId: 1, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 2, capsuleId: 2, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 3, capsuleId: 3, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) }
      ];

      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: liveList });
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm2);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm3);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livecapsulelistsingleholeanimvm.vmInjector = liveVmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;

      await livecapsulelistsingleholeanimvm.collapseCapsuleList();

      mocker.verify('getCapsuleListVm', []).once();
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_not_execute_animation_when_capsule_list_is_empty', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);

      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: [] });

      livecapsulelistsingleholeanimvm.vmInjector = liveVmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;

      await livecapsulelistsingleholeanimvm.collapseCapsuleList();

      mocker.verify('getCapsuleListVm', []).once();
    });

    it('should_execute_animation_for_remind_capsules_first', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      let capsuleVm1: ILiveCapsuleVm = {
        offsetX: 10,
        isRemindShow: true,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm2: ILiveCapsuleVm = {
        offsetX: 0,
        isRemindShow: false,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm3: ILiveCapsuleVm = {
        offsetX: 5,
        isRemindShow: true,
        styleType: CapsuleShowType.DEFAULT
      };
      let liveList: LiveNotification[] = [
        { id: 1, capsuleId: 1, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 2, capsuleId: 2, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 3, capsuleId: 3, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) }
      ];

      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: liveList });
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm2);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm3);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livecapsulelistsingleholeanimvm.vmInjector = liveVmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;

      await livecapsulelistsingleholeanimvm.collapseCapsuleList();
      mocker.verify('getCapsuleListVm', []).once();
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      let mockCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      let mockLiveRemindVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      let mockCapsuleListVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      let mockIsScreenRecorder: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      let mockIsPersistent: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isPersistent);
      let mockIsInstant: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isInstant);

      when(mockCapsuleVm)([ArgumentMatchers.any]).afterReturn({
        isShow: true,
        fixedShowType: CapsuleShowType.SHADOW,
        showType: CapsuleShowType.SHADOW,
        width: 0,
        offsetX: 0,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        zIndex: 0,
        blur: 0,
        isRemindShow: false,
        isShowed: false,
        isMarqueeEnabled: false,
        setCakeShowVal: () => {},
        updateUIProperty: () => {}
      });
      when(mockCapsuleMarqueeVm)([ArgumentMatchers.any]).afterReturn({
        radius: 0,
        updateUIProperty: () => {}
      });
      when(mockLiveRemindVm)([ArgumentMatchers.any]).afterReturn({
        isCurrentRemindCapsule: () => false
      });
      when(mockIsScreenRecorder)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsPersistent)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsInstant)([ArgumentMatchers.any]).afterReturn(true);
      when(mockCapsuleListVm)([ArgumentMatchers.any]).afterReturn({
        liveList: [new LiveNotification()]
      });

      let transferParam: CapsuleTransferParam = {
        delay: 100,
        isUpdateImmediately: true
      };
      livecapsulelistsingleholeanimvm.setCapsuleTransferState(transferParam);

      mocker.verify('getCapsuleListVm', []).once();
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isPersistent);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isInstant);
    });

    it('should_execute_animation_when_capsule_is_hide', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      let mockCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      let mockLiveRemindVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      let mockCapsuleListVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      let mockIsScreenRecorder: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      let mockIsPersistent: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isPersistent);
      let mockIsInstant: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isInstant);

      when(mockCapsuleVm)([ArgumentMatchers.any]).afterReturn({
        isShow: false,
        fixedShowType: CapsuleShowType.SHADOW,
        showType: CapsuleShowType.SHADOW,
        width: 0,
        offsetX: 0,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        zIndex: 0,
        blur: 0,
        isRemindShow: false,
        isShowed: false,
        isMarqueeEnabled: false,
        setCakeShowVal: () => {},
        updateUIProperty: () => {}
      });
      when(mockCapsuleMarqueeVm)([ArgumentMatchers.any]).afterReturn({
        radius: 0,
        updateUIProperty: () => {}
      });
      when(mockLiveRemindVm)([ArgumentMatchers.any]).afterReturn({
        isCurrentRemindCapsule: () => false
      });
      when(mockIsScreenRecorder)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsPersistent)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsInstant)([ArgumentMatchers.any]).afterReturn(true);
      when(mockCapsuleListVm)([ArgumentMatchers.any]).afterReturn({
        liveList: [new LiveNotification()]
      });

      let transferParam: CapsuleTransferParam = {
        delay: 100,
        isUpdateImmediately: true
      };
      livecapsulelistsingleholeanimvm.setCapsuleTransferState(transferParam);

      mocker.verify('getCapsuleListVm', []).once();

      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isPersistent);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isInstant);
    });

    it('should_execute_animation_when_capsuleVm_is_show', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleVm();
      capsuleVm.isShow = true;
      capsuleVm.showType = CapsuleShowType.HANGING_HOLE;
      capsuleVm.fixedWidth = 100;
      capsuleVm.isRemindShow = false;
      let lightWaveVm: ILiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      lightWaveVm.lightShow = false;
      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.delay = 100;
      capsuleTransferParam.isNeedLight = false;
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleLightWaveVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleLightWaveVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleLightWaveVm)(ArgumentMatchers.any).afterReturn(lightWaveVm);
      livecapsulelistsingleholeanimvm.vmInjector = vmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;
      let cmds: AnimateParams[] = [];
      let cmd: AnimateParams = new AnimateParams();
      cmd.duration = 1000;
      cmd.curve = curves.Curve.LINEAR;
      cmds.push(cmd);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecapsulelistsingleholeanimvm.expandCapsuleList(capsuleTransferParam);
      expect(mockExecuteAnimation).assertCalledWith(cmds, 'expandCapsuleList');
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_capsuleVm_is_remindShow', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleVm();
      capsuleVm.isShow = true;
      capsuleVm.showType = CapsuleShowType.HANGING_HOLE;
      capsuleVm.fixedWidth = 100;
      capsuleVm.isRemindShow = true;
      let lightWaveVm: ILiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      lightWaveVm.lightShow = false;
      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.delay = 100;
      capsuleTransferParam.isNeedLight = false;
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleLightWaveVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleLightWaveVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleLightWaveVm)(ArgumentMatchers.any).afterReturn(lightWaveVm);
      livecapsulelistsingleholeanimvm.vmInjector = vmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;
      let cmds: AnimateParams[] = [];
      let cmd: AnimateParams = new AnimateParams();
      cmd.duration = 1000;
      cmd.curve = curves.Curve.LINEAR;
      cmds.push(cmd);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecapsulelistsingleholeanimvm.expandCapsuleList(capsuleTransferParam);
      expect(mockExecuteAnimation).assertCalledWith(cmds, 'expandCapsuleList');
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_lightShow_is_true', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleVm();
      capsuleVm.isShow = true;
      capsuleVm.showType = CapsuleShowType.HANGING_HOLE;
      capsuleVm.fixedWidth = 100;
      capsuleVm.isRemindShow = false;
      let lightWaveVm: ILiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      lightWaveVm.lightShow = true;
      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.delay = 100;
      capsuleTransferParam.isNeedLight = true;
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleLightWaveVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleLightWaveVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleLightWaveVm)(ArgumentMatchers.any).afterReturn(lightWaveVm);
      livecapsulelistsingleholeanimvm.vmInjector = vmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;
      let cmds: AnimateParams[] = [];
      let cmd: AnimateParams = new AnimateParams();
      cmd.duration = 1000;
      cmd.curve = curves.Curve.LINEAR;
      cmds.push(cmd);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecapsulelistsingleholeanimvm.expandCapsuleList(capsuleTransferParam);
      expect(mockExecuteAnimation).assertCalledWith(cmds, 'expandCapsuleList');
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_return_animate_params_when_live_is_screen_recorder_and_capsule_show_type_is_round_cake', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsScreenRecorderFunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      let mockGetCapsuleVmFunc: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);

      when(mockIsScreenRecorderFunc)(ArgumentMatchers.any).afterReturn(true);
      let capsule: ILiveCapsuleListAnimVm = {
        showType: CapsuleShowType.ROUND_CAKE,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        offsetX: 0,
        width: 0,
        blur: 0
      };
      when(mockGetCapsuleVmFunc)(ArgumentMatchers.any).afterReturn(capsule);

      const result = livecapsulelistsingleholeanimvm.collapseOtherCapsule(live);
      expect(result.length).assertEqual(2);
      expect(result[0].curve).assertEqual(curves.springMotion(0.3, 1));
      expect(result[0].duration).assertEqual(50);
      expect(result[1].curve).assertEqual(Curve.Linear);
      expect(result[1].duration).assertEqual(1);
      expect(result[1].delay).assertEqual(250);

      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
    });

    it('should_return_default_animate_params_when_live_is_not_screen_recorder_or_capsule_show_type_is_not_round_cake', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsScreenRecorderFunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      let mockGetCapsuleVmFunc: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);

      when(mockIsScreenRecorderFunc)(ArgumentMatchers.any).afterReturn(false);
      let capsule: ILiveCapsuleListAnimVm = {
        showType: CapsuleShowType.NOT_ROUND_CAKE,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        offsetX: 0,
        width: 0,
        blur: 0
      };
      when(mockGetCapsuleVmFunc)(ArgumentMatchers.any).afterReturn(capsule);
      const result = livecapsulelistsingleholeanimvm.collapseOtherCapsule(live);
      expect(result.length).assertEqual(2);
      expect(result[0].curve).assertEqual(LiveCapsuleListAnimBaseVm.CAPSULE_CURVE);
      expect(result[0].duration).assertEqual(1);
      expect(result[1].curve).assertEqual(Curve.Linear);
      expect(result[1].duration).assertEqual(1);
      expect(result[1].delay).assertEqual(250);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
    });

    it('should_return_correct_animate_params_when_live_notification_is_valid', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleListAnimVm = new LiveCapsuleListAnimBaseVm();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(capsuleVm);
      const result = livecapsulelistsingleholeanimvm.collapseRemindCapsule(live);
      expect(result.length).assertEqual(3);
      expect(result[0].curve).assertEqual(curves.Curve.Linear);
      expect(result[0].duration).assertEqual(250);
      expect(result[1].curve).assertEqual(curves.Curve.Linear);
      expect(result[1].duration).assertEqual(100);
      expect(result[2].curve).assertEqual(curves.Curve.Linear);
      expect(result[2].duration).assertEqual(1);
      expect(result[2].delay).assertEqual(250);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
    });

    const generateTestDataForSetCapsuleListFinalState = () => ({
      capsuleTransferParam: {
        delay: 100,
        isUpdateImmediately: false
      }
    });

    it('should set capsule list final state correctly',DEFAULT, async () => {
      const testSubject = createTestSubject();
      await testSubject.setCapsuleListFinalState(generateTestDataForSetCapsuleListFinalState().capsuleTransferParam);
    });

    const generateTestDataForCollapseCapsuleList = () => ({
      capsuleList: [
        mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
        mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2)
      ]
    });

    it('should collapse capsule list correctly',DEFAULT, async () => {
      const testSubject = createTestSubject();
      await testSubject.collapseCapsuleList(generateTestDataForCollapseCapsuleList().capsuleList);
    });

    const generateTestDataForExpandCapsuleList = () => ({
      capsuleList: [
        mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
        mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2)
      ]
    });

    it('should expand capsule list correctly',DEFAULT, async () => {
      const testSubject = createTestSubject();
      await testSubject.expandCapsuleList(generateTestDataForExpandCapsuleList().capsuleList);
    });

    const generateTestDataForCollapseOtherCapsule = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)
    });

    it('should collapse other capsule correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.collapseOtherCapsule(generateTestDataForCollapseOtherCapsule().live);
    });

    const generateTestDataForCollapseRemindCapsule = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)
    });

    it('should collapse remind capsule correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.collapseRemindCapsule(generateTestDataForCollapseRemindCapsule().live);
    });

    const generateTestDataForExpandOtherCapsule = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      delay: 100
    });

    it('should expand other capsule correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.expandOtherCapsule(generateTestDataForExpandOtherCapsule().live, generateTestDataForExpandOtherCapsule().delay);
    });

    const generateTestDataForExpandRemindCapsule = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      delay: 100
    });

    it('should expand remind capsule correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.expandRemindCapsule(generateTestDataForExpandRemindCapsule().live, generateTestDataForExpandRemindCapsule().delay);
    });

    const generateTestDataForSetCapsuleListFinalStateWithNoTransfer = () => ({
      capsuleTransferParam: {
        delay: 0,
        isUpdateImmediately: false
      }
    });

    it('should set capsule list final state correctly when no transfer',DEFAULT, async () => {
      const testSubject = createTestSubject();
      await testSubject.setCapsuleListFinalState(generateTestDataForSetCapsuleListFinalStateWithNoTransfer().capsuleTransferParam);

    });

    const generateTestDataForCollapseCapsuleListWithNoCapsules = () => ({
      capsuleList: []
    });

    it('should handle empty capsule list correctly',DEFAULT, async () => {
      const testSubject = createTestSubject();
      await testSubject.collapseCapsuleList(generateTestDataForCollapseCapsuleListWithNoCapsules().capsuleList);

    });

    const generateTestDataForExpandCapsuleListWithNoCapsules = () => ({
      capsuleList: []
    });

    it('should handle empty capsule list correctly during expansion',DEFAULT, async () => {
      const testSubject = createTestSubject();
      await testSubject.expandCapsuleList(generateTestDataForExpandCapsuleListWithNoCapsules().capsuleList);

    });

    const generateTestDataForCollapseOtherCapsuleWithScreenRecorder = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)
    });

    it('should collapse other capsule correctly for screen recorder', DEFAULT,() => {
      const testSubject = createTestSubject();
      const cmds = testSubject.collapseOtherCapsule(generateTestDataForCollapseOtherCapsuleWithScreenRecorder().live);

    });

    const generateTestDataForCollapseRemindCapsuleWithPersistent = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 1)
    });

    it('should collapse remind capsule correctly for persistent', DEFAULT,() => {
      const testSubject = createTestSubject();
      const cmds = testSubject.collapseRemindCapsule(generateTestDataForCollapseRemindCapsuleWithPersistent().live);

    });

    const generateTestDataForExpandOtherCapsuleWithRoundCake = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      delay: 100
    });

    it('should expand other capsule correctly for round cake',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.expandOtherCapsule(generateTestDataForExpandOtherCapsuleWithRoundCake().live, generateTestDataForExpandOtherCapsuleWithRoundCake().delay);
    });
  });

  describe('testsuite_3', () => {
    it('should_call_collapseCapsuleList_and_expandCapsuleList_when_capsuleTransferParam_is_undefined', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCollapse: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      let mockExpand: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);

      when(mockCollapse)([]).afterReturn(Promise.resolve());
      when(mockExpand)([]).afterReturn(Promise.resolve());

      await livecapsulelistsingleholeanimvm.setCapsuleListFinalState();

      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);
    });
    it('should_call_collapseCapsuleList_and_expandCapsuleList_when_capsuleTransferParam_is_provided', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCollapse: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      let mockExpand: Function =
        mocker.mockFunc(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);
      let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);

      let param: CapsuleTransferParam = new CapsuleTransferParam();
      param.showType = CapsuleShowType.LIVE_SHOW_TYPE_DIALOG;
      param.liveNotification = new LiveNotification();
      param.liveNotification.style = LiveStyle.LIVE_STYLE_SUCCESS;
      param.liveCapsuleIndex = 0;
      param.liveNotification.expandStartTime = 0;
      param.liveNotification.expandEndTime = 0;
      param.liveNotification.contractStartTime = 0;
      param.liveNotification.contractEndTime = 0;
      param.liveNotification.liveStartTime = 0;
      param.liveNotification.liveEndTime = 0;
      param.liveNotification.duration = 0;
      param.liveNotification.speed = 0;
      param.liveNotification.curve = curves.Curve.EaseIn;
      param.liveCapsuleListItem = new EsObject();
      param.liveCapsuleListItem.startTime = 0;
      param.liveCapsuleListItem.endTime = 0;
      param.liveCapsuleListItem.currentIndex = 0;
      param.liveCapsuleListItem.totalNum = 0;
      param.liveCapsuleListItem.speed = 0;
      param.liveCapsuleListItem.curve = curves.Curve.EaseIn;
      param.liveCapsuleListItem.expandStartTime = 0;
      param.liveCapsuleListItem.expandEndTime = 0;
      param.liveCapsuleListItem.contractStartTime = 0;
      param.liveCapsuleListItem.contractEndTime = 0;
      param.liveCapsuleListItem.liveStartTime = 0;
      param.liveCapsuleListItem.liveEndTime = 0;
      param.liveCapsuleListItem.duration = 0;
      param.liveCapsuleListItem.speed = 0;
      param.liveCapsuleListItem.curve = curves.Curve.EaseIn;

      when(mockCollapse)([]).afterReturn(Promise.resolve());
      when(mockExpand)([ArgumentMatchers.any]).afterReturn(Promise.resolve());
      when(mockSleep)([ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsulelistsingleholeanimvm.setCapsuleListFinalState(param);

      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.collapseCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm, livecapsulelistsingleholeanimvm.expandCapsuleList);
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
    });

    it('should_execute_animation_when_capsule_list_is_not_empty', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      let capsuleVm1: ILiveCapsuleVm = {
        offsetX: 10,
        isRemindShow: false,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm2: ILiveCapsuleVm = {
        offsetX: 0,
        isRemindShow: true,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm3: ILiveCapsuleVm = {
        offsetX: 5,
        isRemindShow: false,
        styleType: CapsuleShowType.DEFAULT
      };
      let liveList: LiveNotification[] = [
        { id: 1, capsuleId: 1, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 2, capsuleId: 2, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 3, capsuleId: 3, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) }
      ];

      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: liveList });
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm2);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm3);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livecapsulelistsingleholeanimvm.vmInjector = liveVmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;

      await livecapsulelistsingleholeanimvm.collapseCapsuleList();

      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_not_execute_animation_when_capsule_list_is_empty', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);

      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: [] });

      livecapsulelistsingleholeanimvm.vmInjector = liveVmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;

      await livecapsulelistsingleholeanimvm.collapseCapsuleList();

    });

    it('should_execute_animation_for_remind_capsules_first', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockGetCapsuleListVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      let capsuleVm1: ILiveCapsuleVm = {
        offsetX: 10,
        isRemindShow: true,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm2: ILiveCapsuleVm = {
        offsetX: 0,
        isRemindShow: false,
        styleType: CapsuleShowType.DEFAULT
      };
      let capsuleVm3: ILiveCapsuleVm = {
        offsetX: 5,
        isRemindShow: true,
        styleType: CapsuleShowType.DEFAULT
      };
      let liveList: LiveNotification[] = [
        { id: 1, capsuleId: 1, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 2, capsuleId: 2, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) },
        { id: 3, capsuleId: 3, capsuleType: 1, beginTime: 1, endTime: 1, remindTime: 1, styleType: CapsuleShowType.DEFAULT, remindType: 1, capsuleTransferParam: new CapsuleTransferParam(1, 1, 1) }
      ];

      when(mockGetCapsuleListVm)([]).afterReturn({ liveList: liveList });
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm2);
      when(mockGetCapsuleVm)([ArgumentMatchers.any]).afterReturn(capsuleVm3);
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livecapsulelistsingleholeanimvm.vmInjector = liveVmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;

      await livecapsulelistsingleholeanimvm.collapseCapsuleList();
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      let mockCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      let mockLiveRemindVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      let mockCapsuleListVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      let mockIsScreenRecorder: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      let mockIsPersistent: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isPersistent);
      let mockIsInstant: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isInstant);

      when(mockCapsuleVm)([ArgumentMatchers.any]).afterReturn({
        isShow: true,
        fixedShowType: CapsuleShowType.SHADOW,
        showType: CapsuleShowType.SHADOW,
        width: 0,
        offsetX: 0,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        zIndex: 0,
        blur: 0,
        isRemindShow: false,
        isShowed: false,
        isMarqueeEnabled: false,
        setCakeShowVal: () => {},
        updateUIProperty: () => {}
      });
      when(mockCapsuleMarqueeVm)([ArgumentMatchers.any]).afterReturn({
        radius: 0,
        updateUIProperty: () => {}
      });
      when(mockLiveRemindVm)([ArgumentMatchers.any]).afterReturn({
        isCurrentRemindCapsule: () => false
      });
      when(mockIsScreenRecorder)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsPersistent)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsInstant)([ArgumentMatchers.any]).afterReturn(true);
      when(mockCapsuleListVm)([ArgumentMatchers.any]).afterReturn({
        liveList: [new LiveNotification()]
      });

      let transferParam: CapsuleTransferParam = {
        delay: 100,
        isUpdateImmediately: true
      };
      livecapsulelistsingleholeanimvm.setCapsuleTransferState(transferParam);

      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isPersistent);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isInstant);
    });

    it('should_execute_animation_when_capsule_is_hide', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      let mockCapsuleMarqueeVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      let mockLiveRemindVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      let mockCapsuleListVm: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      let mockIsScreenRecorder: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      let mockIsPersistent: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isPersistent);
      let mockIsInstant: Function = mocker.mockFunc(new LiveNotification(), LiveNotification.prototype.isInstant);

      when(mockCapsuleVm)([ArgumentMatchers.any]).afterReturn({
        isShow: false,
        fixedShowType: CapsuleShowType.SHADOW,
        showType: CapsuleShowType.SHADOW,
        width: 0,
        offsetX: 0,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        zIndex: 0,
        blur: 0,
        isRemindShow: false,
        isShowed: false,
        isMarqueeEnabled: false,
        setCakeShowVal: () => {},
        updateUIProperty: () => {}
      });
      when(mockCapsuleMarqueeVm)([ArgumentMatchers.any]).afterReturn({
        radius: 0,
        updateUIProperty: () => {}
      });
      when(mockLiveRemindVm)([ArgumentMatchers.any]).afterReturn({
        isCurrentRemindCapsule: () => false
      });
      when(mockIsScreenRecorder)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsPersistent)([ArgumentMatchers.any]).afterReturn(true);
      when(mockIsInstant)([ArgumentMatchers.any]).afterReturn(true);
      when(mockCapsuleListVm)([ArgumentMatchers.any]).afterReturn({
        liveList: [new LiveNotification()]
      });

      let transferParam: CapsuleTransferParam = {
        delay: 100,
        isUpdateImmediately: true
      };
      livecapsulelistsingleholeanimvm.setCapsuleTransferState(transferParam);

      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getLiveRemindVm);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleListVm);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isScreenRecorder);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isPersistent);
      mocker.ignoreMock(new LiveNotification(), LiveNotification.prototype.isInstant);
    });

    it('should_execute_animation_when_capsuleVm_is_show', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleVm();
      capsuleVm.isShow = true;
      capsuleVm.showType = CapsuleShowType.HANGING_HOLE;
      capsuleVm.fixedWidth = 100;
      capsuleVm.isRemindShow = false;
      let lightWaveVm: ILiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      lightWaveVm.lightShow = false;
      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.delay = 100;
      capsuleTransferParam.isNeedLight = false;
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleLightWaveVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleLightWaveVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleLightWaveVm)(ArgumentMatchers.any).afterReturn(lightWaveVm);
      livecapsulelistsingleholeanimvm.vmInjector = vmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;
      let cmds: AnimateParams[] = [];
      let cmd: AnimateParams = new AnimateParams();
      cmd.duration = 1000;
      cmd.curve = curves.Curve.LINEAR;
      cmds.push(cmd);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecapsulelistsingleholeanimvm.expandCapsuleList(capsuleTransferParam);
      expect(mockExecuteAnimation).assertCalledWith(cmds, 'expandCapsuleList');
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_capsuleVm_is_remindShow', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleVm();
      capsuleVm.isShow = true;
      capsuleVm.showType = CapsuleShowType.HANGING_HOLE;
      capsuleVm.fixedWidth = 100;
      capsuleVm.isRemindShow = true;
      let lightWaveVm: ILiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      lightWaveVm.lightShow = false;
      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.delay = 100;
      capsuleTransferParam.isNeedLight = false;
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleLightWaveVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleLightWaveVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleLightWaveVm)(ArgumentMatchers.any).afterReturn(lightWaveVm);
      livecapsulelistsingleholeanimvm.vmInjector = vmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;
      let cmds: AnimateParams[] = [];
      let cmd: AnimateParams = new AnimateParams();
      cmd.duration = 1000;
      cmd.curve = curves.Curve.LINEAR;
      cmds.push(cmd);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecapsulelistsingleholeanimvm.expandCapsuleList(capsuleTransferParam);
      expect(mockExecuteAnimation).assertCalledWith(cmds, 'expandCapsuleList');
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_lightShow_is_true', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let capsuleVm: ILiveCapsuleVm = new LiveCapsuleVm();
      capsuleVm.isShow = true;
      capsuleVm.showType = CapsuleShowType.HANGING_HOLE;
      capsuleVm.fixedWidth = 100;
      capsuleVm.isRemindShow = false;
      let lightWaveVm: ILiveCapsuleLightWaveVm = new LiveCapsuleLightWaveVm();
      lightWaveVm.lightShow = true;
      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.delay = 100;
      capsuleTransferParam.isNeedLight = true;
      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleLightWaveVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleLightWaveVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleLightWaveVm)(ArgumentMatchers.any).afterReturn(lightWaveVm);
      livecapsulelistsingleholeanimvm.vmInjector = vmInjector;
      livecapsulelistsingleholeanimvm.expandListDelayTime = 383;
      let cmds: AnimateParams[] = [];
      let cmd: AnimateParams = new AnimateParams();
      cmd.duration = 1000;
      cmd.curve = curves.Curve.LINEAR;
      cmds.push(cmd);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturn(Promise.resolve());
      await livecapsulelistsingleholeanimvm.expandCapsuleList(capsuleTransferParam);
      expect(mockExecuteAnimation).assertCalledWith(cmds, 'expandCapsuleList');
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_return_animate_params_when_live_is_screen_recorder_and_capsule_show_type_is_round_cake', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsScreenRecorderFunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      let mockGetCapsuleVmFunc: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);

      when(mockIsScreenRecorderFunc)(ArgumentMatchers.any).afterReturn(true);
      let capsule: ILiveCapsuleListAnimVm = {
        showType: CapsuleShowType.ROUND_CAKE,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        offsetX: 0,
        width: 0,
        blur: 0
      };
      when(mockGetCapsuleVmFunc)(ArgumentMatchers.any).afterReturn(capsule);

      const result = livecapsulelistsingleholeanimvm.collapseOtherCapsule(live);
      expect(result.length).assertEqual(2);
      expect(result[0].curve).assertEqual(curves.springMotion(0.3, 1));
      expect(result[0].duration).assertEqual(50);
      expect(result[1].curve).assertEqual(Curve.Linear);
      expect(result[1].duration).assertEqual(1);
      expect(result[1].delay).assertEqual(250);

      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
    });

    it('should_return_default_animate_params_when_live_is_not_screen_recorder_or_capsule_show_type_is_not_round_cake', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsScreenRecorderFunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      let mockGetCapsuleVmFunc: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);

      when(mockIsScreenRecorderFunc)(ArgumentMatchers.any).afterReturn(false);
      let capsule: ILiveCapsuleListAnimVm = {
        showType: CapsuleShowType.NOT_ROUND_CAKE,
        scaleX: 0,
        scaleY: 0,
        opacity: 0,
        offsetX: 0,
        width: 0,
        blur: 0
      };
      when(mockGetCapsuleVmFunc)(ArgumentMatchers.any).afterReturn(capsule);
      const result = livecapsulelistsingleholeanimvm.collapseOtherCapsule(live);
      expect(result.length).assertEqual(2);
      expect(result[0].curve).assertEqual(LiveCapsuleListAnimBaseVm.CAPSULE_CURVE);
      expect(result[0].duration).assertEqual(1);
      expect(result[1].curve).assertEqual(Curve.Linear);
      expect(result[1].duration).assertEqual(1);
      expect(result[1].delay).assertEqual(250);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
    });

    it('should_return_correct_animate_params_when_live_notification_is_valid', 0, async () => {
      let livecapsulelistsingleholeanimvm: LiveCapsuleListSingleHoleAnimVm = new LiveCapsuleListSingleHoleAnimVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleListAnimVm = new LiveCapsuleListAnimBaseVm();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(capsuleVm);
      const result = livecapsulelistsingleholeanimvm.collapseRemindCapsule(live);
      expect(result.length).assertEqual(3);
      expect(result[0].curve).assertEqual(curves.Curve.Linear);
      expect(result[0].duration).assertEqual(250);
      expect(result[1].curve).assertEqual(curves.Curve.Linear);
      expect(result[1].duration).assertEqual(100);
      expect(result[2].curve).assertEqual(curves.Curve.Linear);
      expect(result[2].duration).assertEqual(1);
      expect(result[2].delay).assertEqual(250);
      mocker.ignoreMock(livecapsulelistsingleholeanimvm.vmInjector, livecapsulelistsingleholeanimvm.vmInjector.getCapsuleVm);
    });
  })
}
