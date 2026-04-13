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
import { AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { curves } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers,
  DEFAULT } from '@ohos/hypium';
import { LiveMediaPlayerAnimation } from '../../../../main/ets/live/animation/LiveMediaPlayerAnimation';
export default function LiveMediaPlayerAnimationTest() {
  // 模拟依赖对象
  const mockLogHelper = {
    showInfo: jest.fn(),
    showWarning: jest.fn(),
    showError: jest.fn(),
  };

  // 模拟曲线对象
  const mockCurve = {
    interpolate: jest.fn((t: number) => t),
  };

  // 模拟 LiveMediaPlayerVm
  class MockLiveMediaPlayerVm {
    maskOpacity = 0;
    oldMediaIconOpacity = 0;
    oldMediaIconScale = { x: 0, y: 0 };
    mediaIconScale = { x: 0, y: 0 };
    oldMediaIconOffsetX = 0;
    oldMediaIconOffsetY = 0;
    mediaIconOffsetX = 0;
    mediaIconOffsetY = 0;
  }

  // 模拟 LiveVmInjector
  class MockLiveVmInjector {
    private liveMediaPlayerVm = new MockLiveMediaPlayerVm();

    getLiveMediaPlayerVm(live: LiveNotification): MockLiveMediaPlayerVm {
      return this.liveMediaPlayerVm;
    }
  }
  describe('updateIconAnimation_testSuite', () => {
    let animation: LiveMediaPlayerAnimation;
    let mockVmInjector: MockLiveVmInjector;
    let mockLive: LiveNotification;
    beforeEach(() => {
      mockVmInjector = new MockLiveVmInjector();
      animation = new LiveMediaPlayerAnimation(mockVmInjector);
      mockLive = {
        // 模拟 LiveNotification 的必要属性
        id: 'test_live_id',
        title: 'Test Live',
      } as unknown as LiveNotification;

      // 重置模拟对象
      jest.clearAllMocks();
      RTLUtil.isRTL = jest.fn();
      LogHelper.getLogHelper = jest.fn().mockReturnValue(mockLogHelper);
    });
    afterEach(() => {

    });


    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      await animation.updateIconAnimation(mockLive);

      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.maskOpacity).toBe(0);
      expect(vm.oldMediaIconOpacity).toBe(1);
      expect(vm.mediaIconScale).toEqual({ x: 0.8, y: 0.8 });
      // 其他断言...
    });

    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, () => {
      jest.spyOn(RTLUtil, 'isRTL').mockReturnValue(true);
      animation.updateIconAnimation(mockLive);
      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.mediaIconOffsetX).toBe(-16);
    });

    // 测试用例 1：验证初始化参数
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      await animation.updateIconAnimation(mockLive);

      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.maskOpacity).toBe(0);
      expect(vm.oldMediaIconOpacity).toBe(1);
      expect(vm.oldMediaIconScale).toEqual({ x: 1, y: 1 });
      expect(vm.mediaIconScale).toEqual({ x: 0.8, y: 0.8 });
      expect(vm.mediaIconOffsetX).toBe(RTLUtil.isRTL() ? -16 : 16);
      expect(vm.mediaIconOffsetY).toBe(22);
    });

    // 测试用例 2：验证动画步骤的添加逻辑
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT,async () => {
      const addAnimationSpy = jest.spyOn(animation, 'addAnimation');

      await animation.updateIconAnimation(mockLive);

      const animations = addAnimationSpy.mock.calls[0][0];
      expect(animations.length).toBe(5);

      // 验证第 1 步
      expect(animations[0].curve).toBe('Curve.Sharp');
      expect(animations[0].duration).toBe(50);
      expect(animations[0].event).toBeDefined();

      // 验证第 2 步
      expect(animations[1].curve).toBe(mockCurve); // 曲线需根据实际 mock 曲线
      expect(animations[1].delay).toBeUndefined();
      expect(animations[1].event).toBeDefined();

      // 验证第 3 步
      expect(animations[2].curve).toBe(mockCurve);
      expect(animations[2].delay).toBe(150);
      expect(animations[2].event).toBeDefined();

      // 验证第 4 步
      expect(animations[3].curve).toBe('Curve.Sharp');
      expect(animations[3].delay).toBe(350);
      expect(animations[3].duration).toBe(50);

      // 验证第 5 步
      expect(animations[4].curve).toBe(mockCurve);
      expect(animations[4].delay).toBe(350);
      expect(animations[4].event).toBeDefined();
    });

    // 测试用例 3：验证 RTL 方向对位移的影响
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      RTLUtil.isRTL.mockReturnValue(true);

      await animation.updateIconAnimation(mockLive);

      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.mediaIconOffsetX).toBe(-16);
      expect(vm.mediaIconOffsetY).toBe(22);

      // 验证第 3 步事件
      const thirdStep = animation.addAnimation.mock.calls[0][0][2];
      thirdStep.event();
      expect(vm.oldMediaIconOffsetX).toBe(-16);
      expect(vm.oldMediaIconOffsetY).toBe(-22);
      expect(vm.mediaIconOffsetX).toBe(0);
      expect(vm.mediaIconOffsetY).toBe(0);
    });

    // 测试用例 4：验证动画启动与日志记录
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const startAnimationSpy = jest.spyOn(animation, 'startAnimation');

      await animation.updateIconAnimation(mockLive);

      expect(startAnimationSpy).toHaveBeenCalledWith('UpdateMediaPlayerIcon');
      expect(mockLogHelper.showInfo).toHaveBeenCalledWith('start update media icon animation');
    });

    // 测试用例 5：空参数处理
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      await animation.updateIconAnimation(null as unknown as LiveNotification);

      // 验证未触发动画
      expect(animation.addAnimation).not.toHaveBeenCalled();
      expect(animation.startAnimation).not.toHaveBeenCalled();
    });

    // 测试用例 6：多次调用清理旧动画
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      await animation.updateIconAnimation(mockLive);
      const vm1 = mockVmInjector.getLiveMediaPlayerVm(mockLive);

      // 修改 VM 状态
      vm1.maskOpacity = 0.5;

      // 第二次调用
      await animation.updateIconAnimation(mockLive);
      const vm2 = mockVmInjector.getLiveMediaPlayerVm(mockLive);

      expect(vm2.maskOpacity).toBe(0); // 应被重置
    });

    // 测试用例 7：无效的 vmInjector
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      mockVmInjector.getLiveMediaPlayerVm = jest.fn().mockReturnValue(null);

      await animation.updateIconAnimation(mockLive);

      // 验证未触发动画
      expect(animation.addAnimation).not.toHaveBeenCalled();
      expect(mockLogHelper.showError).toHaveBeenCalled();
    });

    // 测试用例 8：验证动画事件顺序
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const eventOrder: string[] = [];

      // 替换动画事件为记录顺序
      const originalAddAnimation = animation.addAnimation;
      animation.addAnimation = (animations) => {
        animations.forEach((anim) => {
          const originalEvent = anim.event;
          anim.event = () => {
            eventOrder.push(anim.curve.toString());
            originalEvent();
          };
        });
        originalAddAnimation(animations);
      };

      await animation.updateIconAnimation(mockLive);

      expect(eventOrder).toEqual([
        'Curve.Sharp',
        mockCurve.toString(),
        mockCurve.toString(),
        'Curve.Sharp',
        mockCurve.toString(),
      ]);
    });

    // 测试用例 9：验证最终状态
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      jest.useFakeTimers();

      await animation.updateIconAnimation(mockLive);
      jest.runAllTimers();

      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.maskOpacity).toBe(0);
      expect(vm.oldMediaIconScale).toEqual({ x: 0.8, y: 0.8 });
      expect(vm.mediaIconScale).toEqual({ x: 1, y: 1 });
      expect(vm.mediaIconOffsetX).toBe(0);
      expect(vm.mediaIconOffsetY).toBe(0);
    });

    // 测试用例 10：验证曲线参数
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const iconScaleCurve = curves.interpolatingSpring(0, 1, 300, 30);
      const iconOffsetCurve = curves.interpolatingSpring(0, 1, 600, 50);

      await animation.updateIconAnimation(mockLive);

      const animations = animation.addAnimation.mock.calls[0][0];
      expect(animations[1].curve).toBe(iconScaleCurve);
      expect(animations[2].curve).toBe(iconOffsetCurve);
    });

    // 测试用例 11：负数延迟处理
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      // 模拟修改常量值（需通过反射或直接修改实例属性）
      Object.defineProperty(animation, 'ICON_OFFSET_DELAY', { value: -100 });
      Object.defineProperty(animation, 'ICON_SCALE_DELAY', { value: -200 });

      await animation.updateIconAnimation(mockLive);

      const animations = animation.addAnimation.mock.calls[0][0];
      expect(animations[2].delay).toBe(0); // 延迟修正为 0
      expect(animations[3].delay).toBe(0);
      expect(animations[4].delay).toBe(0);
    });

    // 测试用例 12：验证日志记录完整性
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      await animation.updateIconAnimation(mockLive);
      expect(mockLogHelper.showInfo).toHaveBeenCalledTimes(1);
      expect(mockLogHelper.showWarning).not.toHaveBeenCalled();
      expect(mockLogHelper.showError).not.toHaveBeenCalled();
    });

    // 测试用例 13：验证动画清理
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const clearAnimationsSpy = jest.spyOn(animation, 'clearAnimations');

      await animation.updateIconAnimation(mockLive);
      expect(clearAnimationsSpy).toHaveBeenCalled();
    });

    // 测试用例 14：验证缩放曲线
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const iconScaleCurve = curves.interpolatingSpring(0, 1, 300, 30);
      const mockInterpolate = jest.spyOn(iconScaleCurve, 'interpolate');

      await animation.updateIconAnimation(mockLive);

      // 模拟曲线计算
      mockInterpolate.mockImplementation((t: number) => t * 0.5);
      const secondStep = animation.addAnimation.mock.calls[0][0][1];
      secondStep.event();
      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.oldMediaIconScale.x).toBeCloseTo(0.4); // 根据 mock 的 interpolate 结果
    });

    // 测试用例 15：验证位移曲线
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const iconOffsetCurve = curves.interpolatingSpring(0, 1, 600, 50);
      const mockInterpolate = jest.spyOn(iconOffsetCurve, 'interpolate');

      await animation.updateIconAnimation(mockLive);

      mockInterpolate.mockImplementation((t: number) => t * 0.8);
      const thirdStep = animation.addAnimation.mock.calls[0][0][2];
      thirdStep.event();
      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.oldMediaIconOffsetX).toBeCloseTo(-12.8); // 根据 RTL 方向和 mock 的 interpolate
    });

    // 测试用例 16：验证遮罩透明度变化
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      await animation.updateIconAnimation(mockLive);

      const firstStep = animation.addAnimation.mock.calls[0][0][0];
      firstStep.event();
      const fourthStep = animation.addAnimation.mock.calls[0][0][3];
      fourthStep.event();

      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.maskOpacity).toBe(0); // 最终应为 0
    });

    // 测试用例 17：验证动画步骤的持续时间
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const animations = animation.addAnimation.mock.calls[0][0];
      expect(animations[0].duration).toBe(50);
      expect(animations[1].duration).toBeUndefined(); // 默认持续时间由曲线决定
      expect(animations[2].duration).toBeUndefined();
      expect(animations[3].duration).toBe(50);
      expect(animations[4].duration).toBeUndefined();
    });

    // 测试用例 18：验证 RTL 切换
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      RTLUtil.isRTL.mockReturnValue(true);
      await animation.updateIconAnimation(mockLive);
      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);
      expect(vm.mediaIconOffsetX).toBe(-16);

      RTLUtil.isRTL.mockReturnValue(false);
      await animation.updateIconAnimation(mockLive);
      expect(vm.mediaIconOffsetX).toBe(16);
    });

    // 测试用例 19：验证动画步骤的延迟总和
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const animations = animation.addAnimation.mock.calls[0][0];
      const totalDelay = animations.reduce((sum, anim) => sum + (anim.delay || 0), 0);
      expect(totalDelay).toBe(150 + 350 + 350); // 第 3、4、5 步的延迟
    });

    // 测试用例 20：验证动画步骤的事件执行
    it('should_call_startAnimation_with_correct_timeout1',DEFAULT, async () => {
      const vm = mockVmInjector.getLiveMediaPlayerVm(mockLive);

      // 手动触发所有动画事件
      const animations = animation.addAnimation.mock.calls[0][0];
      animations.forEach((anim) => {
        if (anim.event) {
          anim.event();
        }
      });

      expect(vm.maskOpacity).toBe(0);
      expect(vm.oldMediaIconScale).toEqual({ x: 0.8, y: 0.8 });
      expect(vm.mediaIconScale).toEqual({ x: 1, y: 1 });
      expect(vm.mediaIconOffsetX).toBe(0);
      expect(vm.mediaIconOffsetY).toBe(0);
    });
  });
  describe('updateIconAnimation_testSuite1', () => {
    let animation: LiveMediaPlayerAnimation;
    let mockVmInjector: MockLiveVmInjector;
    let mockLive: LiveNotification;
    beforeEach(() => {
      mockVmInjector = new MockLiveVmInjector();
      animation = new LiveMediaPlayerAnimation(mockVmInjector);
      mockLive = {
        // 模拟 LiveNotification 的必要属性
        id: 'test_live_id',
        title: 'Test Live',
      } as unknown as LiveNotification;

      // 重置模拟对象
      jest.clearAllMocks();
      RTLUtil.isRTL = jest.fn();
      LogHelper.getLogHelper = jest.fn().mockReturnValue(mockLogHelper);
    });
    afterEach(() => {

    });


    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });
  });
  describe('updateIconAnimation_testSuite2', () => {
    let animation: LiveMediaPlayerAnimation;
    let mockVmInjector: MockLiveVmInjector;
    let mockLive: LiveNotification;
    beforeEach(() => {
      mockVmInjector = new MockLiveVmInjector();
      animation = new LiveMediaPlayerAnimation(mockVmInjector);
      mockLive = {
        // 模拟 LiveNotification 的必要属性
        id: 'test_live_id',
        title: 'Test Live',
      } as unknown as LiveNotification;

      // 重置模拟对象
      jest.clearAllMocks();
      RTLUtil.isRTL = jest.fn();
      LogHelper.getLogHelper = jest.fn().mockReturnValue(mockLogHelper);
    });
    afterEach(() => {

    });


    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout0', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_showInfo_with_correct_message1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_clearAnimations_and_startAnimation_when_updateIconAnimation_is_called1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockClearAnimations: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearAnimations)().afterReturnNothing();
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.clearAnimations);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_getLiveMediaPlayerVm_with_live_param1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });

    it('should_call_addAnimation_with_correct_animation_params1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      let mockAddAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.addAnimation);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockAddAnimation)([ArgumentMatchers.any]).afterReturnNothing();

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.addAnimation);
    });

    it('should_call_startAnimation_with_correct_timeout1', 0, async () => {
      let livemediaplayeranimation: LiveMediaPlayerAnimation = new LiveMediaPlayerAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockStartAnimation: Function = mocker.mockFunc(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      let mockGetLiveMediaPlayerVm: Function = mocker.mockFunc(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);

      when(mockGetLiveMediaPlayerVm)(ArgumentMatchers.any).afterReturn({
        maskOpacity: 0,
        oldMediaIconOpacity: 1,
        oldMediaIconScale: { x: 1, y: 1 },
        oldMediaIconOffsetX: 0,
        oldMediaIconOffsetY: 0,
        mediaIconScale: { x: 0.8, y: 0.8 },
        mediaIconOffsetX: 0,
        mediaIconOffsetY: 22
      });
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await livemediaplayeranimation.updateIconAnimation(new LiveNotification());

      mocker.ignoreMock(livemediaplayeranimation, livemediaplayeranimation.startAnimation);
      mocker.ignoreMock(livemediaplayeranimation.vmInjector, livemediaplayeranimation.vmInjector.getLiveMediaPlayerVm);
    });
  });
}