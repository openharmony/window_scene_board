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
import { AppStorageUtil, DataProperty, LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimateParams, AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { ColorUtil } from '../../../../../../main/ets/utils/ColorUtil';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { ILiveCapsuleVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleVm';
import { ILiveCapsuleWaveVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleWaveVm';
import { LiveCapsuleProgressModel } from '../../../../../../main/ets/live/model/LiveCapsuleProgressModel';
import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleWaveVm } from '../../../../../../main/ets/live/vm/LiveCapsuleWaveVm';
export default function LiveCapsuleWaveVmTest() {
  describe('refreshProgressWaveMarginLeft_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_refreshProgressWaveMarginLeft_correctly_when_processWaveMarginLeft_is_different', 0, async () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      livecapsulewavevm.processWaveMarginLeft = 100;
      livecapsulewavevm.isFullProgress = false;
      livecapsulewavevm.capsuleWidth = 100;
      livecapsulewavevm.capsuleProgressRadio = 0.5;
      livecapsulewavevm.isVisible = false;

      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      when(mockIsMiddleCutout)([]).afterReturn(true);

      let mockExecuteAnimation: Function =
        mocker.mockFunc(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber],
        Promise.resolve());

      livecapsulewavevm.refreshProgressWaveMarginLeft();

      expect(livecapsulewavevm.processWaveMarginLeft).assertEqual(50);
      expect(livecapsulewavevm.isVisible).assertTrue();

      mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      mocker.ignoreMock(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
    });

    it('should_refreshProgressWaveMarginLeft_correctly_when_processWaveMarginLeft_is_same', 0, async () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      livecapsulewavevm.processWaveMarginLeft = 100;
      livecapsulewavevm.isFullProgress = false;
      livecapsulewavevm.capsuleWidth = 100;
      livecapsulewavevm.capsuleProgressRadio = 0.5;
      livecapsulewavevm.isVisible = true;

      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      when(mockIsMiddleCutout)([]).afterReturn(true);

      let mockExecuteAnimation: Function =
        mocker.mockFunc(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber],
        Promise.resolve());

      livecapsulewavevm.refreshProgressWaveMarginLeft();

      expect(livecapsulewavevm.processWaveMarginLeft).assertEqual(100);
      expect(livecapsulewavevm.isVisible).assertTrue();

      mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      mocker.ignoreMock(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
    });

    it('should_refreshProgressWaveMarginLeft_correctly_when_isFullProgress_is_true', 0, async () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      livecapsulewavevm.processWaveMarginLeft = 100;
      livecapsulewavevm.isFullProgress = true;
      livecapsulewavevm.capsuleWidth = 100;
      livecapsulewavevm.capsuleProgressRadio = 0.5;
      livecapsulewavevm.isVisible = false;

      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      when(mockIsMiddleCutout)([]).afterReturn(true);

      let mockExecuteAnimation: Function =
        mocker.mockFunc(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber],
        Promise.resolve());

      livecapsulewavevm.refreshProgressWaveMarginLeft();

      expect(livecapsulewavevm.processWaveMarginLeft).assertEqual(50);
      expect(livecapsulewavevm.isVisible).assertTrue();

      mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      mocker.ignoreMock(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
    });

    it('should_refreshProgressWaveMarginLeft_correctly_when_capsuleWidth_is_less_than_LiveStyle.CAPSULE_WIDTH', 0,
      async () => {
        let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
        livecapsulewavevm.processWaveMarginLeft = 100;
        livecapsulewavevm.isFullProgress = false;
        livecapsulewavevm.capsuleWidth = LiveStyle.CAPSULE_WIDTH - 1;
        livecapsulewavevm.capsuleProgressRadio = 0.5;
        livecapsulewavevm.isVisible = false;

        let mocker: MockKit = new MockKit();
        let mockIsMiddleCutout: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
        when(mockIsMiddleCutout)([]).afterReturn(true);

        let mockExecuteAnimation: Function =
          mocker.mockFunc(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
        when(mockExecuteAnimation)([ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber],
          Promise.resolve());

        livecapsulewavevm.refreshProgressWaveMarginLeft();

        expect(livecapsulewavevm.processWaveMarginLeft).assertEqual(50);
        expect(livecapsulewavevm.isVisible).assertTrue();

        mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
        mocker.ignoreMock(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
      });

    it('should_refreshProgressWaveMarginLeft_correctly_when_waveMoving_is_true', 0, async () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      livecapsulewavevm.processWaveMarginLeft = 100;
      livecapsulewavevm.isFullProgress = false;
      livecapsulewavevm.capsuleWidth = 100;
      livecapsulewavevm.capsuleProgressRadio = 0.5;
      livecapsulewavevm.isVisible = false;
      livecapsulewavevm.waveMoving = true;

      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      when(mockIsMiddleCutout)([]).afterReturn(true);

      let mockExecuteAnimation: Function =
        mocker.mockFunc(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber],
        Promise.resolve());

      livecapsulewavevm.refreshProgressWaveMarginLeft();

      expect(livecapsulewavevm.processWaveMarginLeft).assertEqual(-LiveStyle.WAVE_WIDTH);
      expect(livecapsulewavevm.isVisible).assertTrue();

      mocker.ignoreMock(CutoutVm.instance, CutoutVm.instance.isMiddleCutout);
      mocker.ignoreMock(livecapsulewavevm.animationBase, livecapsulewavevm.animationBase.executeAnimation);
    });
  });

  describe('destroy_testSuite', () => {

    beforeEach(() => {

    });

    afterEach(() => {

    });

    it('should_set_isVisible_to_false_when_destroy_is_called', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      livecapsulewavevm.destroy();
      expect(livecapsulewavevm.isVisible).assertEqual(false);
    });
  });

  describe('capsuleProgressRadio_testSuite', () => {

    beforeEach(() => {

    });

    afterEach(() => {

    });

    it('should_return_radio_when_progressData_is_valid', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let liveCapsuleProgressModel: LiveCapsuleProgressModel = new LiveCapsuleProgressModel();
      liveCapsuleProgressModel.progress = {
        currentValue: 50,
        maxValue: 100
      };
      livecapsulewavevm.live = {
        capsule: liveCapsuleProgressModel
      };
      const result = livecapsulewavevm.capsuleProgressRadio;
      expect(result).assertEqual(0.5);
    });

    it('should_return_radio_when_progressData_is_invalid', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let liveCapsuleProgressModel: LiveCapsuleProgressModel = new LiveCapsuleProgressModel();
      liveCapsuleProgressModel.progress = {
        currentValue: 150,
        maxValue: 100
      };
      livecapsulewavevm.live = {
        capsule: liveCapsuleProgressModel
      };
      const result = livecapsulewavevm.capsuleProgressRadio;
      expect(result).assertEqual(1);
    });

    it('should_return_radio_when_currentValue_is_zero', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let liveCapsuleProgressModel: LiveCapsuleProgressModel = new LiveCapsuleProgressModel();
      liveCapsuleProgressModel.progress = {
        currentValue: 0,
        maxValue: 100
      };
      livecapsulewavevm.live = {
        capsule: liveCapsuleProgressModel
      };
      const result = livecapsulewavevm.capsuleProgressRadio;
      expect(result).assertEqual(0);
    });

    it('should_return_radio_when_currentValue_equals_to_maxValue', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let liveCapsuleProgressModel: LiveCapsuleProgressModel = new LiveCapsuleProgressModel();
      liveCapsuleProgressModel.progress = {
        currentValue: 100,
        maxValue: 100
      };
      livecapsulewavevm.live = {
        capsule: liveCapsuleProgressModel
      };
      const result = livecapsulewavevm.capsuleProgressRadio;
      expect(result).assertEqual(1);
    });
  });

  describe('waveImageResource_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_week_wave_when_backgroundColor_is_light_color', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let live: ILiveCapsuleVm = {
        capsule: {
          backgroundColor: LiveStyle.CAPSULE_CONTENT_COLOR
        }
      };
      livecapsulewavevm.live = live;
      const result = livecapsulewavevm.waveImageResource;
      expect(result).assertEqual($r('app.media.week_wave'));
    });

    it('should_return_strong_wave_when_backgroundColor_is_not_light_color', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let live: ILiveCapsuleVm = {
        capsule: {
          backgroundColor: LiveStyle.CAPSULE_CONTENT_COLOR + 1
        }
      };
      livecapsulewavevm.live = live;
      const result = livecapsulewavevm.waveImageResource;
      expect(result).assertEqual($r('app.media.strong_wave'));
    });
  });

  describe('capsuleWidth_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_width_when_capsuleVm_width_is_set', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulewavevm.capsuleVm, 'width');
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      const result = livecapsulewavevm.capsuleWidth;
      expect(result).assertEqual(100);
      mocker.ignoreMock(livecapsulewavevm.capsuleVm, 'width');
    });

    it('should_return_0_when_capsuleVm_width_is_not_set', 0, () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulewavevm.capsuleVm, 'width');
      when(mockfunc)(ArgumentMatchers.any).afterReturn(0);
      const result = livecapsulewavevm.capsuleWidth;
      expect(result).assertEqual(0);
      mocker.ignoreMock(livecapsulewavevm.capsuleVm, 'width');
    });
  });

  describe('capsuleVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_ILiveCapsuleVm_when_getCapsuleVm_is_called', 0, async () => {
      let livecapsulewavevm: LiveCapsuleWaveVm = new LiveCapsuleWaveVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new ILiveCapsuleVm());
      livecapsulewavevm.vmInjector = vmInjector;
      const result = livecapsulewavevm.capsuleVm;
      expect(result).assertInstanceOf(ILiveCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
    });
  });

  it('should refreshProgressWaveMarginLeft with anim',DEFAULT, () => {
    liveCapsuleWaveVm.refreshProgressWaveMarginLeft();
    expect(liveCapsuleWaveVm.processWaveMarginLeft).toBe(-LiveStyle.WAVE_WIDTH);
    expect(liveCapsuleWaveVm.isVisible).toBe(true);
    expect(liveCapsuleWaveVm.animationBase.executeAnimation).toHaveBeenCalled();
  });

  // Tests for doWaveMove

  it('should doWaveMove without animation', DEFAULT,() => {
    liveCapsuleWaveVm.doWaveMove();
    expect(liveCapsuleWaveVm.waveMoving).toBe(false);
    expect(appStorageUtil.setOrCreate).toHaveBeenCalled();
  });

  // Additional tests for properties and methods

  it('should have default isVisible',DEFAULT, () => {
    expect(liveCapsuleWaveVm.isVisible).toBe(false);
  });

  it('should have default waveMoving',DEFAULT, () => {
    expect(liveCapsuleWaveVm.waveMoving).toBe(false);
  });

  it('should have default isFullProgress',DEFAULT, () => {
    expect(liveCapsuleWaveVm.isFullProgress).toBe(false);
  });

  it('should have default processWaveMarginLeft', DEFAULT,() => {
    expect(liveCapsuleWaveVm.processWaveMarginLeft).toBe(-LiveStyle.WAVE_WIDTH);
  });

  it('should have default moveWaveMarginLeft', DEFAULT,() => {
    expect(liveCapsuleWaveVm.moveWaveMarginLeft).toBe(-LiveStyle.WAVE_WIDTH);
  });

  it('should have default moveWaveOpacity',DEFAULT, () => {
    expect(liveCapsuleWaveVm.moveWaveOpacity).toBe(LiveStyle.MOVE_WAVE_OPACITY);
  });

  it('should have default capsuleVm',DEFAULT, () => {
    expect(liveCapsuleWaveVm.capsuleVm).toBeInstanceOf(ILiveCapsuleVm);
  });

  it('should have default waveImageResource',DEFAULT, () => {
    expect(liveCapsuleWaveVm.waveImageResource).toBe($r('app.media.week_wave'));
  });

  it('should have default capsuleWidth',DEFAULT, () => {
    expect(liveCapsuleWaveVm.capsuleWidth).toBe(LiveStyle.CAPSULE_WIDTH);
  });

  it('should have default capsuleProgressRadio',DEFAULT, () => {
    expect(liveCapsuleWaveVm.capsuleProgressRadio).toBe(0);
  });

  it('should refreshProgressWaveMarginLeft with anim',DEFAULT, () => {
    liveCapsuleWaveVm.refreshProgressWaveMarginLeft();
    expect(liveCapsuleWaveVm.processWaveMarginLeft).toBe(-LiveStyle.WAVE_WIDTH);
    expect(liveCapsuleWaveVm.isVisible).toBe(true);
    expect(liveCapsuleWaveVm.animationBase.executeAnimation).toHaveBeenCalled();
  });

  // Tests for doWaveMove

  it('should doWaveMove without animation', DEFAULT,() => {
    liveCapsuleWaveVm.doWaveMove();
    expect(liveCapsuleWaveVm.waveMoving).toBe(false);
    expect(appStorageUtil.setOrCreate).toHaveBeenCalled();
  });

  // Additional tests for properties and methods

  it('should have default isVisible',DEFAULT, () => {
    expect(liveCapsuleWaveVm.isVisible).toBe(false);
  });

  it('should have default waveMoving', DEFAULT,() => {
    expect(liveCapsuleWaveVm.waveMoving).toBe(false);
  });

  it('should have default isFullProgress', DEFAULT,() => {
    expect(liveCapsuleWaveVm.isFullProgress).toBe(false);
  });

  it('should have default processWaveMarginLeft', DEFAULT,() => {
    expect(liveCapsuleWaveVm.processWaveMarginLeft).toBe(-LiveStyle.WAVE_WIDTH);
  });

  it('should have default moveWaveMarginLeft',DEFAULT, () => {
    expect(liveCapsuleWaveVm.moveWaveMarginLeft).toBe(-LiveStyle.WAVE_WIDTH);
  });

  it('should have default moveWaveOpacity', DEFAULT,() => {
    expect(liveCapsuleWaveVm.moveWaveOpacity).toBe(LiveStyle.MOVE_WAVE_OPACITY);
  });

  it('should have default capsuleVm',DEFAULT, () => {
    expect(liveCapsuleWaveVm.capsuleVm).toBeInstanceOf(ILiveCapsuleVm);
  });

  it('should have default waveImageResource',DEFAULT, () => {
    expect(liveCapsuleWaveVm.waveImageResource).toBe($r('app.media.week_wave'));
  });

  it('should have default capsuleWidth', DEFAULT,() => {
    expect(liveCapsuleWaveVm.capsuleWidth).toBe(LiveStyle.CAPSULE_WIDTH);
  });

  it('should have default capsuleProgressRadio',DEFAULT, () => {
    expect(liveCapsuleWaveVm.capsuleProgressRadio).toBe(0);
  });
}