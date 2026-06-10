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
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { Singleton } from '../../../../../../main/ets/utils/Singleton';
import { ILiveCapsuleListLayoutVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleLayoutVm';
import { ILiveCapsuleListAnimVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleListAnimVm';
import { ILiveMetaBallVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVm';
import { LiveVmInjector } from '../../../../../../main/ets/live/LiveVmInjector';
import { LiveCapsuleListMultipleHoleAnimVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListMultipleHoleAnimVm';
import { LiveCapsuleListMultipleHoleLayoutVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListMultipleHoleLayoutVm';
import { LiveCapsuleListSingleHoleAnimVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListSingleHoleAnimVm';
import { LiveCapsuleListSingleHoleLayoutVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListSingleHoleLayoutVm';
import { LiveCapsuleListWithoutHoleAnimVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListWithoutHoleAnimVm';
import { LiveCapsuleListWithoutHoleLayoutVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListWithoutHoleLayoutVm';
import { LiveSingleMetaBallVm } from '../../../../../../main/ets/live/vm/LiveSingleMetaBallVm';
import { LiveThreeMetaBallVm } from '../../../../../../main/ets/live/vm/LiveThreeMetaBallVm';
import { LiveZeroMetaBallVm } from '../../../../../../main/ets/live/vm/LiveZeroMetaBallVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveVmFactory } from '../../../../../../main/ets/live/vm/LiveVmFactory';

export default function LiveVmFactoryTest() {
  describe('createMetaBallVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_LiveSingleMetaBallVm_when_vmName_is_LiveSingleMetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createMetaBallVm(LiveSingleMetaBallVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveSingleMetaBallVm);
    });

    it('should_return_LiveThreeMetaBallVm_when_vmName_is_LiveThreeMetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createMetaBallVm(LiveThreeMetaBallVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveThreeMetaBallVm);
    });

    it('should_return_LiveZeroMetaBallVm_when_vmName_is_LiveZeroMetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createMetaBallVm(LiveZeroMetaBallVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveZeroMetaBallVm);
    });

    it('should_return_LiveCapsuleListSingleHoleLayoutVm_when_vmName_is_LiveCapsuleListSingleHoleLayoutVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm =
        livevmfactory.createMetaBallVm(LiveCapsuleListSingleHoleLayoutVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListSingleHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListSingleHoleAnimVm_when_vmName_is_LiveCapsuleListSingleHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm =
        livevmfactory.createMetaBallVm(LiveCapsuleListSingleHoleAnimVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListSingleHoleAnimVm);
    });

    it('should_return_LiveCapsuleListMultipleHoleLayoutVm_when_vmName_is_LiveCapsuleListMultipleHoleLayoutVm', 0,
      () => {
        let livevmfactory: LiveVmFactory = new LiveVmFactory();
        let vmInjector: LiveVmInjector = new LiveVmInjector();
        let result: ILiveCapsuleListLayoutVm =
          livevmfactory.createMetaBallVm(LiveCapsuleListMultipleHoleLayoutVm.name, vmInjector);
        expect(result).assertInstanceOf(LiveCapsuleListMultipleHoleLayoutVm);
      });

    it('should_return_LiveCapsuleListMultipleHoleAnimVm_when_vmName_is_LiveCapsuleListMultipleHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm =
        livevmfactory.createMetaBallVm(LiveCapsuleListMultipleHoleAnimVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListMultipleHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleLayoutVm_when_vmName_is_LiveCapsuleListWithoutHoleLayoutVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm =
        livevmfactory.createMetaBallVm(LiveCapsuleListWithoutHoleLayoutVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_vmName_is_LiveCapsuleListWithoutHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm =
        livevmfactory.createMetaBallVm(LiveCapsuleListWithoutHoleAnimVm.name, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveSingleMetaBallVm_when_isMiddleCutout_is_true_and_holeNum_is_1', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = new CutoutVm();
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
      const result = livevmfactory.getMetaBallVmNameByCutoutVm();
      expect(result).assertEqual(LiveSingleMetaBallVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveThreeMetaBallVm_when_isMiddleCutout_is_true_and_holeNum_is_3', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = new CutoutVm();
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(3);
      const result = livevmfactory.getMetaBallVmNameByCutoutVm();
      expect(result).assertEqual(LiveThreeMetaBallVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveZeroMetaBallVm_when_isMiddleCutout_is_false', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = new CutoutVm();
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      const result = livevmfactory.getMetaBallVmNameByCutoutVm();
      expect(result).assertEqual(LiveZeroMetaBallVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveCapsuleListSingleHoleLayoutVm_when_vmName_is_LiveCapsuleListSingleHoleLayoutVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleLayoutVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListSingleHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListMultipleHoleLayoutVm_when_vmName_is_LiveCapsuleListMultipleHoleLayoutVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListMultipleHoleLayoutVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListMultipleHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleLayoutVm_when_vmName_is_LiveCapsuleListWithoutHoleLayoutVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleLayoutVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleLayoutVm_when_vmName_is_unknown', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = "Unknown";
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleLayoutVm_when_LiveCapsuleListWithoutHoleLayoutVm_is_not_a_class', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleLayoutVm;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListLayoutVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleLayoutVm);
    });

    it('should_return_LiveCapsuleListSingleHoleAnimVm_when_vmName_is_LiveCapsuleListSingleHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListSingleHoleAnimVm);
    });

    it('should_return_LiveCapsuleListMultipleHoleAnimVm_when_vmName_is_LiveCapsuleListMultipleHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListMultipleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListMultipleHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_vmName_is_LiveCapsuleListWithoutHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_vmName_is_unknown_for_animVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = "Unknown";
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListWithoutHoleAnimVm_is_not_a_class_for_animVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveSingleMetaBallVm_when_vmName_is_LiveSingleMetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveSingleMetaBallVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveSingleMetaBallVm);
    });

    it('should_return_LiveThreeMetaBallVm_when_vmName_is_LiveThreeMetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveThreeMetaBallVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveThreeMetaBallVm);
    });

    it('should_return_LiveZeroMetaBallVm_when_vmName_is_LiveZeroMetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveZeroMetaBallVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveZeroMetaBallVm);
    });

    it('should_return_LiveZeroMetaBallVm_when_vmName_is_unknown_for_MetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = "Unknown";
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveZeroMetaBallVm);
    });

    it('should_return_LiveZeroMetaBallVm_when_LiveZeroMetaBallVm_is_not_a_class_for_MetaBallVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveZeroMetaBallVm;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveMetaBallVm = livevmfactory.createCapsuleListLayoutVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveZeroMetaBallVm);
    });

    it('should_return_LiveCapsuleListSingleHoleLayoutVm_when_isMiddleCutout_is_true_and_holeNum_is_1', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(cutoutVm, cutoutVm.holeNum))(ArgumentMatchers.any).afterReturn(1);
      const result = livevmfactory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListSingleHoleLayoutVm.name);
    });

    it('should_return_LiveCapsuleListMultipleHoleLayoutVm_when_isMiddleCutout_is_true_and_holeNum_is_3', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(cutoutVm, cutoutVm.holeNum))(ArgumentMatchers.any).afterReturn(3);
      const result = livevmfactory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListMultipleHoleLayoutVm.name);
    });

    it('should_return_LiveCapsuleListWithoutHoleLayoutVm_when_isMiddleCutout_is_true_and_holeNum_is_not_1_or_3', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(cutoutVm, cutoutVm.holeNum))(ArgumentMatchers.any).afterReturn(2);
      const result = livevmfactory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListWithoutHoleLayoutVm.name);
    });

    it('should_return_LiveCapsuleListWithoutHoleLayoutVm_when_isMiddleCutout_is_false', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(false);
      const result = livevmfactory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListWithoutHoleLayoutVm.name);
    });

    it('should_return_LiveCapsuleListSingleHoleAnimVm_when_vmName_is_LiveCapsuleListSingleHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListSingleHoleAnimVm);
    });

    it('should_return_LiveCapsuleListMultipleHoleAnimVm_when_vmName_is_LiveCapsuleListMultipleHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListMultipleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListMultipleHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_vmName_is_LiveCapsuleListWithoutHoleAnimVm', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_vmName_is_unknown', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = "UnknownVmName";
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListWithoutHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListSingleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListMultipleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListMultipleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListWithoutHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListSingleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListMultipleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListMultipleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListWithoutHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListSingleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListMultipleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListMultipleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListWithoutHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListWithoutHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_LiveCapsuleListSingleHoleAnimVm_is_null', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = LiveCapsuleListSingleHoleAnimVm.name;
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_vmName_is_default', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let vmName: string = "default";
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let result: ILiveCapsuleListAnimVm = livevmfactory.createCapsuleListAnimVm(vmName, vmInjector);
      expect(result).assertInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    it('should_return_LiveCapsuleListSingleHoleAnimVm_when_isMiddleCutout_is_true_and_holeNum_is_1', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)([]).afterReturn(true);
      when(mockfunc)([]).afterReturn(1);
      const result = livevmfactory.getCapsuleListAnimVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListSingleHoleAnimVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveCapsuleListMultipleHoleAnimVm_when_isMiddleCutout_is_true_and_holeNum_is_3', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)([]).afterReturn(true);
      when(mockfunc)([]).afterReturn(3);
      const result = livevmfactory.getCapsuleListAnimVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListMultipleHoleAnimVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_isMiddleCutout_is_false', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)([]).afterReturn(false);
      const result = livevmfactory.getCapsuleListAnimVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListWithoutHoleAnimVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveCapsuleListWithoutHoleAnimVm_when_isMiddleCutout_is_true_and_holeNum_is_other', 0, () => {
      let livevmfactory: LiveVmFactory = new LiveVmFactory();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)([]).afterReturn(true);
      when(mockfunc)([]).afterReturn(2);
      const result = livevmfactory.getCapsuleListAnimVmNameByCutoutVm();
      expect(result).assertEqual(LiveCapsuleListWithoutHoleAnimVm.name);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    describe('createMetaBallVm', () => {
      it('should return LiveSingleMetaBallVm when holeNum is 1',DEFAULT, () => {
        const factory = new LiveVmFactory();
        const vmInjector = LiveVmInjector.instance;
        const vmName = LiveSingleMetaBallVm.name;
        const result = factory.createMetaBallVm(vmName, vmInjector);
        expect(result).toBeInstanceOf(LiveSingleMetaBallVm);
      });

      it('should return LiveThreeMetaBallVm when holeNum is 3',DEFAULT, () => {
        Mock.update(CutoutVm, {
          holeNum: 3,
        });
        const factory = new LiveVmFactory();
        const vmInjector = LiveVmInjector.instance;
        const vmName = LiveSingleMetaBallVm.name;
        const result = factory.createMetaBallVm(vmName, vmInjector);
        expect(result).toBeInstanceOf(LiveThreeMetaBallVm);
      });
    });

    describe('getMetaBallVmNameByCutoutVm', () => {
      it('should return LiveSingleMetaBallVm when holeNum is 1',DEFAULT, () => {
        const factory = new LiveVmFactory();
        expect(factory.getMetaBallVmNameByCutoutVm()).toBe(LiveSingleMetaBallVm.name);
      });

      it('should return LiveThreeMetaBallVm when holeNum is 3',DEFAULT, () => {
        Mock.update(CutoutVm, {
          holeNum: 3,
        });
        const factory = new LiveVmFactory();
        expect(factory.getMetaBallVmNameByCutoutVm()).toBe(LiveThreeMetaBallVm.name);
      });
    });

    it('should return LiveSingleMetaBallVm when holeNum is 1 for createMetaBallVm', DEFAULT,() => {
      Mock.update(CutoutVm, {
        holeNum: 1,
        isMiddleCutout: () => true,
      });
      const result = factory.createMetaBallVm(LiveSingleMetaBallVm.name, vmInjector);
      expect(result).toBeInstanceOf(LiveSingleMetaBallVm);
    });

    it('should return LiveThreeMetaBallVm when holeNum is 3 for createMetaBallVm', DEFAULT,() => {
      Mock.update(CutoutVm, {
        holeNum: 3,
        isMiddleCutout: () => true,
      });
      const result = factory.createMetaBallVm(LiveThreeMetaBallVm.name, vmInjector);
      expect(result).toBeInstanceOf(LiveThreeMetaBallVm);
    });

    it('should return LiveZeroMetaBallVm when holeNum is neither 1 nor 3 for createMetaBallVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 4,
        isMiddleCutout: () => true,
      });
      const result = factory.createMetaBallVm('SomeUnknownVm', vmInjector);
      expect(result).toBeInstanceOf(LiveZeroMetaBallVm);
    });

    // Tests for getMetaBallVmNameByCutoutVm

    it('should return LiveSingleMetaBallVm when holeNum is 1 for getMetaBallVmNameByCutoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 1,
        isMiddleCutout: () => true,
      });
      const result = factory.getMetaBallVmNameByCutoutVm();
      expect(result).toBe(LiveSingleMetaBallVm.name);
    });

    it('should return LiveThreeMetaBallVm when holeNum is 3 for getMetaBallVmNameByCutoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 3,
        isMiddleCutout: () => true,
      });
      const result = factory.getMetaBallVmNameByCutoutVm();
      expect(result).toBe(LiveThreeMetaBallVm.name);
    });

    it('should return LiveZeroMetaBallVm when holeNum is neither 1 nor 3 for getMetaBallVmNameByCutoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 4,
        isMiddleCutout: () => true,
      });
      const result = factory.getMetaBallVmNameByCutoutVm();
      expect(result).toBe(LiveZeroMetaBallVm.name);
    });

    // Tests for createCapsuleListLayoutVm

    it('should return LiveCapsuleListSingleHoleLayoutVm when holeNum is 1 for createCapsuleListLayoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 1,
        isMiddleCutout: () => true,
      });
      const result = factory.createCapsuleListLayoutVm(LiveCapsuleListSingleHoleLayoutVm.name, vmInjector);
      expect(result).toBeInstanceOf(LiveCapsuleListSingleHoleLayoutVm);
    });

    it('should return LiveCapsuleListMultipleHoleLayoutVm when holeNum is 3 for createCapsuleListLayoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 3,
        isMiddleCutout: () => true,
      });
      const result = factory.createCapsuleListLayoutVm(LiveCapsuleListMultipleHoleLayoutVm.name, vmInjector);
      expect(result).toBeInstanceOf(LiveCapsuleListMultipleHoleLayoutVm);
    });

    it('should return LiveCapsuleListWithoutHoleLayoutVm when holeNum is neither 1 nor 3 for createCapsuleListLayoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 4,
        isMiddleCutout: () => true,
      });
      const result = factory.createCapsuleListLayoutVm('SomeUnknownVm', vmInjector);
      expect(result).toBeInstanceOf(LiveCapsuleListWithoutHoleLayoutVm);
    });

    // Tests for getCapsuleListLayoutVmNameByCutoutVm
    it('should return LiveCapsuleListSingleHoleLayoutVm when holeNum is 1 for getCapsuleListLayoutVmNameByCutoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 1,
        isMiddleCutout: () => true,
      });
      const result = factory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).toBe(LiveCapsuleListSingleHoleLayoutVm.name);
    });

    it('should return LiveCapsuleListMultipleHoleLayoutVm when holeNum is 3 for getCapsuleListLayoutVmNameByCutoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 3,
        isMiddleCutout: () => true,
      });
      const result = factory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).toBe(LiveCapsuleListMultipleHoleLayoutVm.name);
    });

    it('should return LiveCapsuleListWithoutHoleLayoutVm when holeNum is neither 1 nor 3 for getCapsuleListLayoutVmNameByCutoutVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 4,
        isMiddleCutout: () => true,
      });
      const result = factory.getCapsuleListLayoutVmNameByCutoutVm();
      expect(result).toBe(LiveCapsuleListWithoutHoleLayoutVm.name);
    });

    // Tests for createCapsuleListAnimVm

    it('should return LiveCapsuleListSingleHoleAnimVm when holeNum is 1 for createCapsuleListAnimVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 1,
        isMiddleCutout: () => true,
      });
      const result = factory.createCapsuleListAnimVm(LiveCapsuleListSingleHoleAnimVm.name, vmInjector);
      expect(result).toBeInstanceOf(LiveCapsuleListSingleHoleAnimVm);
    });

    it('should return LiveCapsuleListMultipleHoleAnimVm when holeNum is 3 for createCapsuleListAnimVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 3,
        isMiddleCutout: () => true,
      });
      const result = factory.createCapsuleListAnimVm(LiveCapsuleListMultipleHoleAnimVm.name, vmInjector);
      expect(result).toBeInstanceOf(LiveCapsuleListMultipleHoleAnimVm);
    });

    it('should return LiveCapsuleListWithoutHoleAnimVm when holeNum is neither 1 nor 3 for createCapsuleListAnimVm',DEFAULT, () => {
      Mock.update(CutoutVm, {
        holeNum: 4,
        isMiddleCutout: () => true,
      });
      const result = factory.createCapsuleListAnimVm('SomeUnknownVm', vmInjector);
      expect(result).toBeInstanceOf(LiveCapsuleListWithoutHoleAnimVm);
    });

    // Tests for getCapsuleListAnimVmNameByCutoutVm
    it('should return LiveCapsuleListSingleHoleAnimVm when holeNum is 1 for getCapsuleListAnimVmNameByCutoutVm',DEFAULT,() => {
      Mock.update(CutoutVm, {
        holeNum: 1,
        isMiddleCutout: () => true,
      });
      const result = factory.getCapsuleListAnimVmNameByCutoutVm();
      expect(result).toBe(LiveCapsuleListSingleHoleAnimVm.name);
    });
  });
}