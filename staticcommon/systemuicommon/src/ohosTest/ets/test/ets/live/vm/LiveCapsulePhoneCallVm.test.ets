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
import { DEFAULT, describe, expect, it } from '@ohos/hypium';
import { LiveCapsulePhoneCallVm } from '../../../../../../main/ets/live/vm/LiveCapsulePhoneCallVm';

// Mocking dependencies
const mockCutoutVm = mock(CutoutVm);
const mockStatusBarHeightVm = mock(StatusBarHeightVm);
const mockStartAppOneMirrorAnimation = mock(StartAppOneMirrorAnimation);
const mockAnimationBase = mock(AnimationBase);
const mockOverlayTransitionParam = mock(OverlayTransitionParam);
const mockOverlayCardState = mock(OverlayCardState);
const mockDeviceHelper = mock(DeviceHelper);
const mockResUtils = mock(ResUtils);
const mockResourceVm = mock(ResourceVm);

// Mocking methods
mockCutoutVm.holes.returns([{}]);
mockStatusBarHeightVm.preSetShowHeight.withArgs(STATUS_BAR_HEIGHT, 'LiveCapsulePhoneCallVm').returns();
mockStartAppOneMirrorAnimation.prepare.withArgs({
  scene: any,
  cardRect: {
    x: 0,
    y: 0,
    width: 0,
    height: 0,
  },
  cardRadius: LiveStyle.CAPSULE_RADIUS,
  bundleName: any,
  cardBgColor: '#000000',
  onExecute: any,
  executeAnimation: any,
}).returns();
mockAnimationBase.executeAnimation.withAnyArguments().returns();
mockDeviceHelper.getDeviceRadius().returns();
mockResUtils.getNumber.withArgs('app.float.status_bar_phone_height').returns(STATUS_BAR_HEIGHT);
mockResourceVm.instance.isRTL.returns(false);

describe('LiveCapsulePhoneCallVm', () => {
  it('should call onClick method correctly',DEFAULT, async () => {
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    const starterVm = { startCapsuleWantAgent: jest.fn() };
    const capsuleListVm = { get: jest.fn().returns({ liveList: [live] }) };
    const switchVm = { expandCapsuleToCard: jest.fn() };
    const vmInjector = {
      getStarterVm: () => starterVm,
      getCapsuleListVm: () => capsuleListVm,
      getSwitchVm: () => switchVm,
    };

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm(vmInjector);
    await liveCapsulePhoneCallVm.onClick();

    expect(starterVm.startCapsuleWantAgent).toHaveBeenCalled();
    expect(capsuleListVm.get).toHaveBeenCalled();
    expect(switchVm.expandCapsuleToCard).not.toHaveBeenCalled();
  });

  it('should call executeAnimation method correctly',DEFAULT, () => {
    const overlayTransitionParam = mock(OverlayTransitionParam);
    const overlayCardState = mock(OverlayCardState);
    const containerSession = { overlayCardTransition: { overlayCardState } };
    const scenePanelManager = {};
    const animation = mock(AnimationBase);

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm({});
    liveCapsulePhoneCallVm.executeAnimation(overlayTransitionParam, animation);

    expect(animation.executeAnimation).toHaveBeenCalled();
  });

  it('should call onClick method correctly',DEFAULT, async () => {
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    const starterVm = { startCapsuleWantAgent: jest.fn() };
    const capsuleListVm = { get: jest.fn().returns({ liveList: [live] }) };
    const switchVm = { expandCapsuleToCard: jest.fn() };
    const vmInjector = {
      getStarterVm: () => starterVm,
      getCapsuleListVm: () => capsuleListVm,
      getSwitchVm: () => switchVm,
    };

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm(vmInjector);
    await liveCapsulePhoneCallVm.onClick();

    expect(starterVm.startCapsuleWantAgent).toHaveBeenCalled();
    expect(capsuleListVm.get).toHaveBeenCalled();
    expect(switchVm.expandCapsuleToCard).not.toHaveBeenCalled();
  });

  it('should call onClick method when capsule list length is greater than 1',DEFAULT, async () => {
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    const starterVm = { startCapsuleWantAgent: jest.fn() };
    const capsuleListVm = { get: jest.fn().returns({ liveList: [live, live] }) };
    const switchVm = { expandCapsuleToCard: jest.fn() };
    const vmInjector = {
      getStarterVm: () => starterVm,
      getCapsuleListVm: () => capsuleListVm,
      getSwitchVm: () => switchVm,
    };

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm(vmInjector);
    await liveCapsulePhoneCallVm.onClick();

    expect(starterVm.startCapsuleWantAgent).not.toHaveBeenCalled();
    expect(switchVm.expandCapsuleToCard).toHaveBeenCalled();
  });

  it('should call executeAnimation method correctly',DEFAULT, () => {
    const overlayTransitionParam = mock(OverlayTransitionParam);
    const overlayCardState = mock(OverlayCardState);
    const containerSession = { overlayCardTransition: { overlayCardState } };
    const scenePanelManager = {};
    const animation = mock(AnimationBase);

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm({});
    liveCapsulePhoneCallVm.executeAnimation(overlayTransitionParam, animation);

    expect(animation.executeAnimation).toHaveBeenCalled();
  });

  it('should handle exceptions in executeAnimation', DEFAULT,() => {
    const overlayTransitionParam = mock(OverlayTransitionParam);
    const animation = mock(AnimationBase);

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm({});
    jest.spyOn(animation, 'executeAnimation').mockImplementation(() => {
      throw new Error('Mocked exception');
    });

    expect(() => liveCapsulePhoneCallVm.executeAnimation(overlayTransitionParam, animation)).toThrow('Mocked exception');
  });

  it('should handle edge cases in executeAnimation',DEFAULT, () => {
    const overlayTransitionParam = mock(OverlayTransitionParam);
    const animation = mock(AnimationBase);
    const containerSession = { overlayCardTransition: { overlayCardState: null } };
    const sessionName = 'testSession';

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm({});
    liveCapsulePhoneCallVm.executeAnimation(overlayTransitionParam, animation);

    expect(animation.executeAnimation).toHaveBeenCalled();
  });

  it('should call onClick method correctly',DEFAULT, async () => {
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    const starterVm = { startCapsuleWantAgent: jest.fn() };
    const capsuleListVm = { get: jest.fn().returns({ liveList: [live] }) };
    const switchVm = { expandCapsuleToCard: jest.fn() };
    const vmInjector = {
      getStarterVm: () => starterVm,
      getCapsuleListVm: () => capsuleListVm,
      getSwitchVm: () => switchVm,
    };

    const liveCapsulePhoneCallVm = new LiveCapsulePhoneCallVm(vmInjector);
    await liveCapsulePhoneCallVm.onClick();

    expect(starterVm.startCapsuleWantAgent).toHaveBeenCalled();
    expect(capsuleListVm.get).toHaveBeenCalled();
    expect(switchVm.expandCapsuleToCard).not.toHaveBeenCalled();
  });
});
