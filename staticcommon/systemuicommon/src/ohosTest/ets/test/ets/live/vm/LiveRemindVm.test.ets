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

import { AppLifeCycleManager } from '../../../../../../main/ets/manager/AppLifeCycleManager';
import { BannerVm } from '../../../../../../main/ets/vm/BannerVm';
import { DropdownVm } from '../../../../../../main/ets/vm/DropdownVm';
import { EnvVm } from '../../../../../../main/ets/vm/EnvVm';
import { ILiveRemindVm } from '../../../../../../main/ets/live/interface/ILiveRemindVm';
import { LiveMetaBallScene } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  DEFAULT
} from '@ohos/hypium';
import { LiveRemindVm } from '../../../../../../main/ets/live/vm/LiveRemindVm';
import { LiveVmInjector } from '../../../../../../../newIndex';

export default function LiveRemindVmTest() {
  describe('checkAddCapsuleScene_testSuite', () => {
    let vm: LiveRemindVm;
    let mockVmInjector: MockVmInjector;
    let mockDropdownVm: sinon.SinonStubbedInstance<DropdownVm>;
    let mockBannerVm: sinon.SinonStubbedInstance<BannerVm>;
    let mockEnvVm: sinon.SinonStubbedInstance<EnvVm>;
    let mockAppLifeCycleManager: sinon.SinonStubbedInstance<AppLifeCycleManager>;
    beforeEach(() => {
      mockVmInjector = new MockVmInjector();
      mockDropdownVm = mockVmInjector.dropdownVm;
      mockBannerVm = mockVmInjector.bannerVm;
      mockEnvVm = mockVmInjector.envVm;
      mockAppLifeCycleManager = mockVmInjector.appLifeCycleManager;

      vm = new LiveRemindVm(mockVmInjector);
    });
    afterEach(() => {

    });


    it('should_set_remind_capsule_when_live_is_instant', 0, async () => {
      let remindVm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      when(mocker.mockFunc(live, live.isInstant))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.setRemindCapsule))(ArgumentMatchers.any).afterReturnNothing();
      remindVm.checkAddCapsuleScene(live);
      mocker.verify('setRemindCapsule', [ArgumentMatchers.any]).once();
    });

    it('should_set_remind_capsule_when_live_is_persistent_and_dropdown_is_true', 0, async () => {
      let remindVm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      when(mocker.mockFunc(live, live.isInstant))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(live, live.isPersistent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.getCapsuleVm))(ArgumentMatchers.any).afterReturn(dropdownVm);
      when(mocker.mockFunc(remindVm, remindVm.setRemindCapsule))(ArgumentMatchers.any).afterReturnNothing();
      when(mocker.mockFunc(dropdownVm, dropdownVm.isShowed))(ArgumentMatchers.any).afterReturn(true);
      remindVm.checkAddCapsuleScene(live);
      mocker.verify('setRemindCapsule', [ArgumentMatchers.any]).once();
    });

    it('should_set_remind_capsule_when_live_is_persistent_and_banner_is_hide', 0, async () => {
      let remindVm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let bannerVm: BannerVm = BannerVm.instance;
      when(mocker.mockFunc(live, live.isInstant))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(live, live.isPersistent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.getCapsuleVm))(ArgumentMatchers.any).afterReturn(bannerVm);
      when(mocker.mockFunc(remindVm, remindVm.setRemindCapsule))(ArgumentMatchers.any).afterReturnNothing();
      when(mocker.mockFunc(bannerVm, bannerVm.isHideCapsule))(ArgumentMatchers.any).afterReturn(true);
      remindVm.checkAddCapsuleScene(live);
      mocker.verify('setRemindCapsule', [ArgumentMatchers.any]).once();
    });

    it('should_set_remind_capsule_when_live_is_persistent_and_heads_up_is_same', 0, async () => {
      let remindVm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      when(mocker.mockFunc(live, live.isInstant))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(live, live.isPersistent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.getLiveHeadsUpVm))(ArgumentMatchers.any).afterReturn(live);
      when(mocker.mockFunc(remindVm, remindVm.setRemindCapsule))(ArgumentMatchers.any).afterReturnNothing();
      remindVm.checkAddCapsuleScene(live);
      mocker.verify('setRemindCapsule', [ArgumentMatchers.any]).once();
    });

    it('should_set_remind_capsule_when_live_is_persistent_and_env_is_screen_lock', 0, async () => {
      let remindVm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let envVm: EnvVm = new EnvVm();
      when(mocker.mockFunc(live, live.isInstant))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(live, live.isPersistent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.getEnvVm))(ArgumentMatchers.any).afterReturn(envVm);
      when(mocker.mockFunc(envVm, envVm.isScreenLock))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.setRemindCapsule))(ArgumentMatchers.any).afterReturnNothing();
      remindVm.checkAddCapsuleScene(live);
      mocker.verify('setRemindCapsule', [ArgumentMatchers.any]).once();
    });

    it('should_set_remind_capsule_when_live_is_persistent_and_app_is_foreground_and_sticky_is_false', 0, async () => {
      let remindVm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let appLifeCycleManager: AppLifeCycleManager = new AppLifeCycleManager();
      when(mocker.mockFunc(live, live.isInstant))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(live, live.isPersistent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.getAppLifeCycleManager))(ArgumentMatchers.any)
        .afterReturn(appLifeCycleManager);
      when(mocker.mockFunc(appLifeCycleManager, appLifeCycleManager.isForeground))(ArgumentMatchers.any)
        .afterReturn(true);
      when(mocker.mockFunc(remindVm, remindVm.setRemindCapsule))(ArgumentMatchers.any).afterReturnNothing();
      remindVm.checkAddCapsuleScene(live);
      mocker.verify('setRemindCapsule', [ArgumentMatchers.any]).once();
    });

    it('should_return_immediately_when_live_is_not_Flip', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(liveremindvm.vmInjector.getLiveHeadsUpVm(), liveremindvm.vmInjector.getLiveHeadsUpVm().getLiveHeadsUpVm);
      when(mockfunc3)().afterReturn(null);
      let mockfunc4: Function = mocker.mockFunc(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      when(mockfunc4)().afterReturn(false);
      let mockfunc5: Function = mocker.mockFunc(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      when(mockfunc5)(ArgumentMatchers.anyNumber()).afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.checkUpdateCapsuleScene(live);

      mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      mocker.ignoreMock(liveremindvm.vmInjector.getLiveHeadsUpVm(), liveremindvm.vmInjector.getLiveHeadsUpVm().getLiveHeadsUpVm);
      mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
    });

    it('should_set_isShowed_to_true_when_dropdownVm_is_true', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(liveremindvm.vmInjector.getLiveHeadsUpVm(), liveremindvm.vmInjector.getLiveHeadsUpVm().getLiveHeadsUpVm);
      when(mockfunc3)().afterReturn(null);
      let mockfunc4: Function = mocker.mockFunc(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      when(mockfunc4)().afterReturn(false);
      let mockfunc5: Function = mocker.mockFunc(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      when(mockfunc5)(ArgumentMatchers.anyNumber()).afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.checkUpdateCapsuleScene(live);

      expect(liveremindvm.dropdownVm.isShowed).assertEqual(true);

      mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      mocker.ignoreMock(liveremindvm.vmInjector.getLiveHeadsUpVm(), liveremindvm.vmInjector.getLiveHeadsUpVm().getLiveHeadsUpVm);
      mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
    });

    it('should_set_isShowed_to_true_when_bannerVm_is_true', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(liveremindvm.vmInjector.getLiveHeadsUpVm(), liveremindvm.vmInjector.getLiveHeadsUpVm().getLiveHeadsUpVm);
      when(mockfunc3)().afterReturn(null);
      let mockfunc4: Function = mocker.mockFunc(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      when(mockfunc4)().afterReturn(false);
      let mockfunc5: Function = mocker.mockFunc(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      when(mockfunc5)(ArgumentMatchers.anyNumber()).afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.checkUpdateCapsuleScene(live);

      expect(liveremindvm.bannerVm.isShowed).assertEqual(true);

      mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      mocker.ignoreMock(liveremindvm.vmInjector.getLiveHeadsUpVm(), liveremindvm.vmInjector.getLiveHeadsUpVm().getLiveHeadsUpVm);
      mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
    });

    it('should_clearRemindCapsule_when_live_is_instant_and_capsuleVm_is_to_delete', 0, async () => {
      let liveremindvm: ILiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let live: LiveNotification = new LiveNotification();
      when(mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule))(ArgumentMatchers.any).afterReturn(live);

      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)(ArgumentMatchers.any).afterReturn(true);

      let capsuleVm: ILiveCapsuleVm = new LiveBaseVm();
      when(mocker.mockFunc(liveremindvm, liveremindvm.vmInjector.getCapsuleVm))(ArgumentMatchers.any).afterReturn(capsuleVm);

      let mockIsToDelete: Function = mocker.mockFunc(capsuleVm, capsuleVm.isToDelete);
      when(mockIsToDelete)(ArgumentMatchers.any).afterReturn(true);

      liveremindvm.checkCurrentRemindScene();

      let mockClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      expect(mockClearRemindCapsule).assertCalled();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(capsuleVm, capsuleVm.isToDelete);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clearRemindCapsule_when_live_is_persistent_and_dropdownVm_is_active', 0, async () => {
      let liveremindvm: ILiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let live: LiveNotification = new LiveNotification();
      when(mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule))(ArgumentMatchers.any).afterReturn(live);

      let mockIsPersistent: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockIsPersistent)(ArgumentMatchers.any).afterReturn(true);

      let mockIsDropDown: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      when(mockIsDropDown)(ArgumentMatchers.any).afterReturn(true);

      liveremindvm.checkCurrentRemindScene();

      let mockClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      expect(mockClearRemindCapsule).assertCalled();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(live, live.isPersistent);
      mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clearRemindCapsule_when_live_is_flip_and_bannerVm_is_hidden', 0, async () => {
      let liveremindvm: ILiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let live: LiveNotification = new LiveNotification();
      when(mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule))(ArgumentMatchers.any).afterReturn(live);

      let mockIsFlip: Function = mocker.mockFunc(live, live.isFlip);
      when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

      let mockIsHideCapsule: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      when(mockIsHideCapsule)(ArgumentMatchers.any).afterReturn(true);

      liveremindvm.checkCurrentRemindScene();

      let mockClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      expect(mockClearRemindCapsule).assertCalled();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(live, live.isFlip);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clearRemindCapsule_when_live_is_heads_up_and_live_heads_up_vm_matches', 0, async () => {
      let liveremindvm: ILiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();

      let live: LiveNotification = new LiveNotification();
      when(mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule))(ArgumentMatchers.any).afterReturn(live);

      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      when(mockIsInstant)(ArgumentMatchers.any).afterReturn(false);

      let mockIsPersistent: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockIsPersistent)(ArgumentMatchers.any).afterReturn(false);

      let mockIsFlip: Function = mocker.mockFunc(live, live.isFlip);
      when(mockIsFlip)(ArgumentMatchers.any).afterReturn(false);

      let mockGetLiveHeadsUpVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
      when(mockGetLiveHeadsUpVm)(ArgumentMatchers.any).afterReturn(live);

      liveremindvm.checkCurrentRemindScene();

      let mockClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      expect(mockClearRemindCapsule).assertCalled();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(live, live.isPersistent);
      mocker.ignoreMock(live, live.isFlip);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_set_remindCapsule_and_call_setScene_on_metaBallVm', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let metaBallVm: MockKit = new MockKit();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(metaBallVm);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.setRemindCapsule(live);

      expect(liveremindvm.remindCapsule).assertEqual(live);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_return_undefined_when_remindCapsule_is_undefined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      liveremindvm.remindCapsule = undefined;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertUndefined();
    });

    it('should_return_remindCapsule_when_remindCapsule_is_defined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let remindCapsule: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = remindCapsule;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertDeepEquals(remindCapsule);
    });

    it('should_clear_remind_capsule_and_set_scene_to_meta_ball_vm', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let metalballvm: ILiveMetaBallVm = new ILiveMetaBallVm();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(metalballvm);

      liveremindvm.clearRemindCapsule();

      expect(liveremindvm.remindCapsule).assertUndefined();
      expect(metalballvm.scene).assertEqual(LiveMetaBallScene.REMIND);
      expect(metalballvm.isActive).assertFalse();

      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_clear_remind_capsule_and_set_scene_to_meta_ball_vm', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let metalballvm: ILiveMetaBallVm = new ILiveMetaBallVm();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(metalballvm);

      liveremindvm.clearRemindCapsule();

      expect(liveremindvm.remindCapsule).assertUndefined();
      expect(metalballvm.scene).assertEqual(LiveMetaBallScene.REMIND);
      expect(metalballvm.isActive).assertFalse();

      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_set_remind_capsule_and_set_scene_to_meta_ball_vm', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let metalballvm: ILiveMetaBallVm = new ILiveMetaBallVm();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(metalballvm);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.setRemindCapsule(live);

      expect(liveremindvm.remindCapsule).assertEqual(live);
      expect(metalballvm.scene).assertEqual(LiveMetaBallScene.REMIND);
      expect(metalballvm.isActive).assertTrue();

      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should set and clear remind capsule correctly',DEFAULT, () => {
      const mockLive = { hashCode: 123 } as LiveNotification;
      vm.setRemindCapsule(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
      expect(mockVmInjector.metaBallVm.setScene.calledWith(LiveMetaBallScene.REMIND, true)).to.be.true;

      vm.clearRemindCapsule();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
      expect(mockVmInjector.metaBallVm.setScene.calledWith(LiveMetaBallScene.REMIND, false)).to.be.true;
    });

    it('should handle invalid LiveNotification', DEFAULT,() => {
      expect(() => vm.setRemindCapsule(null as any)).to.throw('Invalid LiveNotification');
      expect(() => vm.setRemindCapsule(undefined as any)).to.throw('Invalid LiveNotification');
    });

    it('should return true for matching hashCode',DEFAULT, () => {
      const mockLive = { hashCode: 123 } as LiveNotification;
      vm.setRemindCapsule(mockLive);
      expect(vm.isCurrentRemindCapsule(mockLive)).to.be.true;
    });

    it('should return false for mismatched hashCode',DEFAULT, () => {
      const mockLive1 = { hashCode: 123 } as LiveNotification;
      const mockLive2 = { hashCode: 456 } as LiveNotification;
      vm.setRemindCapsule(mockLive1);
      expect(vm.isCurrentRemindCapsule(mockLive2)).to.be.false;
    });

    it('should return false when no current capsule',DEFAULT, () => {
      const mockLive = { hashCode: 123 } as LiveNotification;
      expect(vm.isCurrentRemindCapsule(mockLive)).to.be.false;
    });

    it('should set capsule when isInstant()', DEFAULT,() => {
      const instantLive = { ...mockLive, isInstant: () => true };
      vm.checkAddCapsuleScene(instantLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(instantLive);
    });

    it('should set isShowed when dropdown is open',DEFAULT, () => {
      mockDropdownVm.isDropDown = true;
      vm.checkAddCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
    });

    it('should set isShowed when banner hides capsule',DEFAULT, () => {
      mockBannerVm.isHideCapsule.returns(true);
      vm.checkAddCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
    });

    it('should set isShowed when screen is locked',DEFAULT, () => {
      mockEnvVm.isScreenLock = true;
      vm.checkAddCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
    });

    it('should set remind capsule when all conditions fail',DEFAULT, () => {
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should not process when !isFlip()',DEFAULT, () => {
      const nonFlipLive = { ...mockLive, isFlip: () => false };
      vm.checkUpdateCapsuleScene(nonFlipLive);
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should set isShowed when headsUp matches',DEFAULT, () => {
      mockVmInjector.liveHeadsUpVm.headsUpNtfHashCode = mockLive.hashCode;
      vm.checkUpdateCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
    });

    it('should set remind capsule when all conditions fail',DEFAULT, () => {
      vm.checkUpdateCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should clear when isToDelete is true', DEFAULT,() => {
      mockVmInjector.capsuleVm.isToDelete = true;
      vm.setRemindCapsule(mockLive);
      vm.checkCurrentRemindScene();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should clear when dropdown is open', DEFAULT,() => {
      mockDropdownVm.isDropDown = true;
      vm.setRemindCapsule(mockLive);
      vm.checkCurrentRemindScene();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should clear when banner is in headsUp mode',DEFAULT, () => {
      mockBannerVm.bannerType = BannerPanelType.TYPE_LIVE_HEADS_UP;
      mockVmInjector.capsuleVm.isRemindShow = true;
      vm.setRemindCapsule(mockLive);
      vm.checkCurrentRemindScene();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle null LiveNotification in checkAddCapsuleScene',DEFAULT, () => {
      expect(() => vm.checkAddCapsuleScene(null as any)).to.throw('Invalid LiveNotification');
    });

    it('should handle invalid capsule sticky property',DEFAULT, () => {
      const mockLive = { ...mockLive, capsule: undefined };
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle AppLifeCycleManager error',DEFAULT, () => {
      mockAppLifeCycleManager.instance.isForeground.throws(new Error('Test error'));
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle complex scenario with multiple conditions',DEFAULT, () => {
      mockDropdownVm.isDropDown = true;
      mockBannerVm.isHideCapsule.returns(true);
      mockEnvVm.isScreenLock = true;
      mockAppLifeCycleManager.instance.isForeground.returns(true);

      vm.checkAddCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;

      vm.checkUpdateCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle 1000 set/clear operations',DEFAULT, () => {
      const mockLive = { hashCode: 123 } as LiveNotification;
      for (let i = 0; i < 1000; i++) {
        vm.setRemindCapsule(mockLive);
        vm.clearRemindCapsule();
      }
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle multiple conditions in checkAddCapsuleScene',DEFAULT, () => {
      const mockLive = {
        hashCode: 5,
        isPersistent: () => true,
        creatorUid: 6,
        capsule: { sticky: true },
      } as LiveNotification;

      mockDropdownVm.isDropDown = true;
      mockBannerVm.isHideCapsule.returns(true);
      mockEnvVm.isScreenLock = true;
      mockAppLifeCycleManager.instance.isForeground.returns(true);

      vm.checkAddCapsuleScene(mockLive);
      expect(mockVmInjector.capsuleVm.isShowed).to.be.true;
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should clear when banner is headsUp and capsule is in remind show',DEFAULT, () => {
      const mockLive = { hashCode: 6, isPersistent: () => true };
      vm.setRemindCapsule(mockLive);
      mockBannerVm.bannerType = BannerPanelType.TYPE_LIVE_HEADS_UP;
      mockVmInjector.capsuleVm.isRemindShow = true;

      vm.checkCurrentRemindScene();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle sticky capsule in foreground',DEFAULT, () => {
      mockAppLifeCycleManager.instance.isForeground.returns(true);
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive); // 因为sticky为true不设置isShowed
    });

    it('should handle undefined capsule in checkAddCapsuleScene',DEFAULT, () => {
      const mockLive = { hashCode: 8, isPersistent: () => true, capsule: undefined };
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should not set capsule when isForeground throws error',DEFAULT, () => {
      mockAppLifeCycleManager.instance.isForeground.throws(new Error('Test error'));
      const mockLive = { hashCode: 9, isPersistent: () => true };
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle null capsuleVm from injector',DEFAULT, () => {
      mockVmInjector.getCapsuleVm = () => undefined as any;
      const mockLive = { hashCode: 10, isPersistent: () => true };
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive); // 因为capsuleVm不存在，直接设置胶囊
    });

    it('should handle 1000 checkAddCapsuleScene calls',DEFAULT, () => {
      const mockLive = { hashCode: 11, isPersistent: () => true };
      for (let i = 0; i < 1000; i++) {
        vm.checkAddCapsuleScene(mockLive);
        vm.checkCurrentRemindScene();
      }
      expect(vm.getCurrentRemindCapsule()).to.be.undefined; // 最终应被清除
    });

    it('should handle concurrent set/clear operations',DEFAULT, () => {
      const mockLive1 = { hashCode: 12 };
      const mockLive2 = { hashCode: 13 };
      vm.setRemindCapsule(mockLive1);
      vm.setRemindCapsule(mockLive2);
      vm.clearRemindCapsule();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle bannerType as undefined', DEFAULT,() => {
      mockBannerVm.bannerType = undefined as any;
      const mockLive = { hashCode: 14, isPersistent: () => true };
      vm.checkCurrentRemindScene();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined; // 不影响清除逻辑
    });

    it('should handle headsUpNtfHashCode mismatch', DEFAULT,() => {
      mockVmInjector.liveHeadsUpVm.headsUpNtfHashCode = 15;
      const mockLive = { hashCode: 16, isFlip: () => true };
      vm.checkUpdateCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive); // 因为headsUp不匹配
    });

    it('should handle isShowed not set when all conditions fail',DEFAULT, () => {
      const mockLive = { hashCode: 17, isPersistent: () => true };
      mockVmInjector.capsuleVm.isShowed = false;
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle headsUpNtfHashCode mismatch', DEFAULT, () => {
      mockBannerVm.isHideCapsule = () => undefined;
      mockDropdownVm.isDropDown = undefined as any;
      mockEnvVm.isScreenLock = null as any;

      const mockLive = { hashCode: 29, isPersistent: () => true };
      vm.setRemindCapsule(mockLive);
      vm.clearRemindCapsule();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle headsUpNtfHashCode mismatch', DEFAULT, () => {
      mockVmInjector.capsuleVm.isShowed = false;
      const mockLive = { hashCode: 30, isPersistent: () => true };
      vm.checkAddCapsuleScene(mockLive);
      vm.clearRemindCapsule();
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle headsUpNtfHashCode mismatch', DEFAULT, () => {
      mockVmInjector.liveHeadsUpVm = undefined as any;
      const mockLive = { hashCode: 31, isFlip: () => true };
      vm.checkUpdateCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle bannerType as undefined', DEFAULT, () => {
      const mockLive = {
        hashCode: 32,
        isFlip: () => true,
        isInstant: () => true,
      };
      vm.checkUpdateCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle bannerType as undefined', DEFAULT, () => {
      const mockLive = {
        hashCode: 33,
        isPersistent: () => true,
        capsule: { sticky: true },
      };
      mockAppLifeCycleManager.instance.isForeground = () => false;
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.equal(mockLive);
    });

    it('should handle bannerType as undefined', DEFAULT, () => {
      const mockLive = { hashCode: 34, creatorUid: 0 };
      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle bannerType as undefined', DEFAULT, () => {
      const mockLive = { hashCode: 24, isPersistent: () => true };
      const onClickSpy = sinon.spy();
      mockVmInjector.capsuleVm.onClick = onClickSpy;

      vm.checkAddCapsuleScene(mockLive);
      mockVmInjector.capsuleVm.onClick();
      expect(onClickSpy.calledOnce).to.be.true;
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle bannerType as undefined', DEFAULT, () => {
      const mockLive = { hashCode: 25, isPersistent: () => true };
      const onLongPressSpy = sinon.spy();
      mockVmInjector.capsuleVm.onLongPress = onLongPressSpy;

      vm.checkAddCapsuleScene(mockLive);
      mockVmInjector.capsuleVm.onLongPress();
      expect(onLongPressSpy.calledOnce).to.be.true;
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });

    it('should handle bannerType as undefined', DEFAULT, () => {
      const mockLive = { hashCode: 26, isPersistent: () => true };
      mockVmInjector.capsuleVm.isClosed = true;

      vm.checkAddCapsuleScene(mockLive);
      expect(vm.getCurrentRemindCapsule()).to.be.undefined;
    });
  });

  describe('getCurrentRemindCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_remindCapsule_is_undefined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      liveremindvm.remindCapsule = undefined;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertUndefined();
    });

    it('should_return_remindCapsule_when_remindCapsule_is_defined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let remindCapsule: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = remindCapsule;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertDeepEquals(remindCapsule);
    });

    it('should_return_undefined_when_remindCapsule_is_undefined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      liveremindvm.remindCapsule = undefined;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertUndefined();
    });

    it('should_return_remindCapsule_when_remindCapsule_is_defined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let remindCapsule: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = remindCapsule;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertDeepEquals(remindCapsule);
    });

    it('should_return_null_when_remindCapsule_is_null', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      liveremindvm.remindCapsule = null;
      const result = liveremindvm.getCurrentRemindCapsule();
      expect(result).assertNull();
    });

    it('should_return_updated_remindCapsule_after_assignment', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let initialCapsule: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = initialCapsule;
      const result1 = liveremindvm.getCurrentRemindCapsule();
      expect(result1).assertDeepEquals(initialCapsule);

      let updatedCapsule: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = updatedCapsule;
      const result2 = liveremindvm.getCurrentRemindCapsule();
      expect(result2).assertDeepEquals(updatedCapsule);
    });
  });

  describe('setRemindCapsule_testSuite', () => {
    let liveremindvm: LiveRemindVm;

    beforeEach(() => {
      liveremindvm = new LiveRemindVm();
    });

    afterEach(() => {
      // 清理工作，如果需要的话
    });

    it('should_set_remind_capsule_and_call_meta_ball_vm_set_scene', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let mockMetaBallVm: ILiveMetaBallVm = {
        setScene: (scene: LiveMetaBallScene, isLive: boolean) => {
          expect(scene).assertEqual(LiveMetaBallScene.REMIND);
          expect(isLive).assertTrue();
        }
      };
      when(mockGetMetaBallVm)([]).afterReturn(mockMetaBallVm);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.setRemindCapsule(live);

      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_set_remind_capsule_and_handle_null_meta_ball_vm', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      when(mockGetMetaBallVm)([]).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      liveremindvm.setRemindCapsule(live);

      // 验证remindCapsule被设置
      expect(liveremindvm.remindCapsule).assertNotNull();
      expect(liveremindvm.remindCapsule).assertInstanceOf(LiveNotification);

      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_set_remind_capsule_and_handle_exception_in_get_meta_ball_vm', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      when(mockGetMetaBallVm)([]).afterThrow('Error occurred');

      let live: LiveNotification = new LiveNotification();
      liveremindvm.setRemindCapsule(live);

      // 验证remindCapsule被设置
      expect(liveremindvm.remindCapsule).assertNotNull();
      expect(liveremindvm.remindCapsule).assertInstanceOf(LiveNotification);

      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });
  });

  describe('clearRemindCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_clear_remind_capsule_and_set_scene_to_meta_ball_vm', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let mockMetaBallVm: ILiveMetaBallVm = {
        setScene: (scene: LiveMetaBallScene, isExpanding: boolean) => {}
      };
      when(mockGetMetaBallVm)([]).afterReturn(mockMetaBallVm);

      liveremindvm.clearRemindCapsule();

      expect(liveremindvm.remindCapsule).assertUndefined();
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_clear_remind_capsule_and_set_scene_to_meta_ball_vm', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      let mockMetaBallVm: ILiveMetaBallVm = {
        setScene: (scene: LiveMetaBallScene, isExpanding: boolean) => {}
      };
      when(mockGetMetaBallVm)([]).afterReturn(mockMetaBallVm);

      liveremindvm.clearRemindCapsule();

      expect(liveremindvm.remindCapsule).assertUndefined();
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_clear_remind_capsule_when_getMetaBallVm_returns_null', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      when(mockGetMetaBallVm)([]).afterReturn(null);

      liveremindvm.clearRemindCapsule();

      expect(liveremindvm.remindCapsule).assertUndefined();
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });

    it('should_clear_remind_capsule_when_getMetaBallVm_returns_undefined', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockGetMetaBallVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
      when(mockGetMetaBallVm)([]).afterReturn(undefined);

      liveremindvm.clearRemindCapsule();

      expect(liveremindvm.remindCapsule).assertUndefined();
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getMetaBallVm);
    });
  });

  describe('isCurrentRemindCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_remindCapsule_is_undefined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = undefined;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_remindCapsule_hashcode_matches_live_hashcode', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_remindCapsule_hashcode_does_not_match_live_hashcode', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      liveremindvm.remindCapsule = new LiveNotification();
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_remindCapsule_hashCode_is_null_and_live_hashCode_is_null', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = null;
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_remindCapsule_hashCode_is_null_and_live_hashCode_is_not_null', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 123;
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(new LiveNotification());
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_remindCapsule_hashCode_is_undefined_and_live_hashCode_is_undefined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      delete live.hashCode;
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_remindCapsule_hashCode_is_undefined_and_live_hashCode_is_defined', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 123;
      liveremindvm.remindCapsule = live;
      const otherLive: LiveNotification = new LiveNotification();
      delete otherLive.hashCode;
      const result = liveremindvm.isCurrentRemindCapsule(otherLive);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_remindCapsule_hashCode_is_zero_and_live_hashCode_is_zero', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 0;
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_remindCapsule_hashCode_is_zero_and_live_hashCode_is_non_zero', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 0;
      liveremindvm.remindCapsule = live;
      const otherLive: LiveNotification = new LiveNotification();
      otherLive.hashCode = 123;
      const result = liveremindvm.isCurrentRemindCapsule(otherLive);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_remindCapsule_hashCode_is_negative_and_live_hashCode_is_same_negative', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = -123;
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_remindCapsule_hashCode_is_negative_and_live_hashCode_is_different_negative', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = -123;
      liveremindvm.remindCapsule = live;
      const otherLive: LiveNotification = new LiveNotification();
      otherLive.hashCode = -456;
      const result = liveremindvm.isCurrentRemindCapsule(otherLive);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_remindCapsule_hashCode_is_large_number_and_live_hashCode_is_same_large_number', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 9876543210;
      liveremindvm.remindCapsule = live;
      const result = liveremindvm.isCurrentRemindCapsule(live);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_remindCapsule_hashCode_is_large_number_and_live_hashCode_is_different_large_number', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 9876543210;
      liveremindvm.remindCapsule = live;
      const otherLive: LiveNotification = new LiveNotification();
      otherLive.hashCode = 1234567890;
      const result = liveremindvm.isCurrentRemindCapsule(otherLive);
      expect(result).assertEqual(false);
    });
  });

  describe('checkAddCapsuleScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_remind_capsule_when_live_is_instant', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterReturn(true);
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterReturn(null);

      liveremindvm.checkAddCapsuleScene(live);

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });

    it('should_not_set_remind_capsule_when_live_is_not_instant', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterReturn(false);
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterReturn(null);

      liveremindvm.checkAddCapsuleScene(live);

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });

    it('should_set_remind_capsule_when_live_is_instant', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterReturn(true);
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterReturn(null);

      liveremindvm.checkAddCapsuleScene(live);

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });

    it('should_not_set_remind_capsule_when_live_is_not_instant', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterReturn(false);
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterReturn(null);

      liveremindvm.checkAddCapsuleScene(live);

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });

    it('should_not_set_remind_capsule_when_live_is_null', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = null as unknown as LiveNotification;
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterThrow('live is null');
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterReturn(null);

      liveremindvm.checkAddCapsuleScene(live);

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });

    it('should_not_set_remind_capsule_when_isInstant_returns_undefined', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterReturn(undefined);
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterReturn(null);

      liveremindvm.checkAddCapsuleScene(live);

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });

    it('should_handle_exception_when_setRemindCapsule_throws_error', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let live: LiveNotification = new LiveNotification();
      let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
      let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);

      when(mockIsInstant)([]).afterReturn(true);
      when(mockSetRemindCapsule)([ArgumentMatchers.any]).afterThrow('setRemindCapsule error');

      expect(() => {
        liveremindvm.checkAddCapsuleScene(live);
      }).assertThrowError('setRemindCapsule error');

      mocker.ignoreMock(live, live.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
    });
  });

  describe('checkUpdateCapsuleScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_live_is_not_Flip', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      when(mockIsFlip)(ArgumentMatchers.any).afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      liverindvm.checkUpdateCapsuleScene(live);

      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    });

    it('should_set_capsuleVm_isShowed_to_true_when_dropdownVm_is_true', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveRemindVm = {};
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      let live: LiveNotification = new LiveNotification();
      liverindvm.checkUpdateCapsuleScene(live);
      expect(mockCapsuleVm.isShowed).assertEqual(true);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    });

    it('should_set_capsuleVm_isShowed_to_true_when_bannerVm_is_hideCapsule', 0, () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);
      let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveRemindVm = {};
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      let mockIsHideCapsule: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      when(mockIsHideCapsule)([]).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      liverindvm.checkUpdateCapsuleScene(live);
      expect(mockCapsuleVm.isShowed).assertEqual(true);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
    });
  });
}