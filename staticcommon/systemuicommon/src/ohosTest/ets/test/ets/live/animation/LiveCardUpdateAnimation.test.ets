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
import { AnimateParams, AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
import { curves } from '@kit.ArkUI';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ILiveCardListItemVm } from '../../../../main/ets/live/interface/ILiveCardListItemVm';
import { SystemUICommonUtil } from '../../../../main/ets/TsIndex';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCardUpdateAnimation } from '../../../../main/ets/live/animation/LiveCardUpdateAnimation';
export default function LiveCardUpdateAnimationTest() {
  describe('sort_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_newIndex_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(0);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });

    it('should_execute_all_steps_when_newIndex_not_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(1);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });
  });

  describe('afterAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_zIndex_to_1_for_each_live_item', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListVm);
      let mockGetCardListItemVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListItemVm);

      let mockCardListVm: any = {
        liveList: [
          new LiveNotification(),
          new LiveNotification()
        ]
      };
      when(mockGetCardListVm)([]).afterReturn(mockCardListVm);

      let mockItemVm: any = {
        zIndex: 0
      };
      when(mockGetCardListItemVm)([ArgumentMatchers.any]).afterReturn(mockItemVm);

      livecardupdateanimation.afterAnimation();

      expect(mockItemVm.zIndex).assertEqual(1);

      mocker.ignoreMock(vmInjector, vmInjector.getCardListVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCardListItemVm);
    });

    it('should_not_set_zIndex_when_live_item_is_null', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListVm);
      let mockGetCardListItemVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListItemVm);

      let mockCardListVm: any = {
        liveList: [
          null,
          new LiveNotification()
        ]
      };
      when(mockGetCardListVm)([]).afterReturn(mockCardListVm);

      let mockItemVm: any = {
        zIndex: 0
      };
      when(mockGetCardListItemVm)([ArgumentMatchers.any]).afterReturn(mockItemVm);

      livecardupdateanimation.afterAnimation();

      expect(mockItemVm.zIndex).assertEqual(0);

      mocker.ignoreMock(vmInjector, vmInjector.getCardListVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCardListItemVm);
    });
  });

  describe('sort_testSuite1', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_newIndex_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(0);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });

    it('should_execute_all_steps_when_newIndex_not_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(1);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });
  });

  describe('afterAnimation_testSuite1', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_zIndex_to_1_for_each_live_item', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListVm);
      let mockGetCardListItemVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListItemVm);

      let mockCardListVm: any = {
        liveList: [
          new LiveNotification(),
          new LiveNotification()
        ]
      };
      when(mockGetCardListVm)([]).afterReturn(mockCardListVm);

      let mockItemVm: any = {
        zIndex: 0
      };
      when(mockGetCardListItemVm)([ArgumentMatchers.any]).afterReturn(mockItemVm);

      livecardupdateanimation.afterAnimation();

      expect(mockItemVm.zIndex).assertEqual(1);

      mocker.ignoreMock(vmInjector, vmInjector.getCardListVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCardListItemVm);
    });

    it('should_not_set_zIndex_when_live_item_is_null', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListVm);
      let mockGetCardListItemVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListItemVm);

      let mockCardListVm: any = {
        liveList: [
          null,
          new LiveNotification()
        ]
      };
      when(mockGetCardListVm)([]).afterReturn(mockCardListVm);

      let mockItemVm: any = {
        zIndex: 0
      };
      when(mockGetCardListItemVm)([ArgumentMatchers.any]).afterReturn(mockItemVm);

      livecardupdateanimation.afterAnimation();

      expect(mockItemVm.zIndex).assertEqual(0);

      mocker.ignoreMock(vmInjector, vmInjector.getCardListVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCardListItemVm);
    });
  });

  describe('sort_testSuite2', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_newIndex_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(0);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });

    it('should_execute_all_steps_when_newIndex_not_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(1);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });
  });

  describe('afterAnimation_testSuite2', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_zIndex_to_1_for_each_live_item', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListVm);
      let mockGetCardListItemVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListItemVm);

      let mockCardListVm: any = {
        liveList: [
          new LiveNotification(),
          new LiveNotification()
        ]
      };
      when(mockGetCardListVm)([]).afterReturn(mockCardListVm);

      let mockItemVm: any = {
        zIndex: 0
      };
      when(mockGetCardListItemVm)([ArgumentMatchers.any]).afterReturn(mockItemVm);

      livecardupdateanimation.afterAnimation();

      expect(mockItemVm.zIndex).assertEqual(1);

      mocker.ignoreMock(vmInjector, vmInjector.getCardListVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCardListItemVm);
    });

    it('should_not_set_zIndex_when_live_item_is_null', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCardListVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListVm);
      let mockGetCardListItemVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCardListItemVm);

      let mockCardListVm: any = {
        liveList: [
          null,
          new LiveNotification()
        ]
      };
      when(mockGetCardListVm)([]).afterReturn(mockCardListVm);

      let mockItemVm: any = {
        zIndex: 0
      };
      when(mockGetCardListItemVm)([ArgumentMatchers.any]).afterReturn(mockItemVm);

      livecardupdateanimation.afterAnimation();

      expect(mockItemVm.zIndex).assertEqual(0);

      mocker.ignoreMock(vmInjector, vmInjector.getCardListVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCardListItemVm);
    });
  });

  describe('sort_testSuite3', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_newIndex_equals_oldIndex', 0, async () => {
      let livecardupdateanimation: LiveCardUpdateAnimation = new LiveCardUpdateAnimation(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(livecardupdateanimation, livecardupdateanimation.startAnimation);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockfunc3: Function = mocker.mockFunc(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      let mockfunc4: Function = mocker.mockFunc(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new ILiveCardListItemVm() {
        public getStyle(): LiveStyle {
          return LiveStyle.DEFAULT;
        }
        public getLive(): LiveNotification {
          return new LiveNotification();
        }
      });
      await livecardupdateanimation.sort(0);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.clearAnimations);
      mocker.ignoreMock(livecardupdateanimation, livecardupdateanimation.startAnimation);
      mocker.ignoreMock(livecardupdateanimation.vmInjector.getCardListVm(), livecardupdateanimation.vmInjector.getCardListVm().getCardListItemVm);
      mocker.ignoreMock(livecardupdateanimation.vmInjector, livecardupdateanimation.vmInjector.getCardListItemVm);
    });
  });
}

