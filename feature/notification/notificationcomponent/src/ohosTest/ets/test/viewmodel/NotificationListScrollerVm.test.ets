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

import {
  AnimateParams,
  AnimationBase,
  INotificationCardVm,
  INotificationListScrollerVm,
  INotificationListVm,
  NotificationBaseVm,
} from '@ohos/systemuicommon/newIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationBase, NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import { DropDownPanelConstants, DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { NotificationSwipeVm } from '../../../main/ets/viewmodel/NotificationSwipeVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationListScrollerVm } from '../../../main/ets/viewmodel/NotificationListScrollerVm';
export default function NotificationListScrollerVmTest() {
  describe('doDeleteChainAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_execute_animation_when_ntf_height_is_not_zero', 0, async () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let notificationDataManager: NotificationDataManager = NotificationDataManager.instance;
      let mockFreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.freeze);
      let mockUnfreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.unfreeze);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);

      when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      notificationlistscrollervm.doDeleteChainAnimation(notificationBase);

      expect(mockExecuteAnimation).assertEqual(true);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.freeze);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.unfreeze);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_not_execute_animation_when_ntf_height_is_zero', 0, async () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let notificationDataManager: NotificationDataManager = NotificationDataManager.instance;
      let mockFreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.freeze);
      let mockUnfreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.unfreeze);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);

      when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      notificationlistscrollervm.doDeleteChainAnimation(notificationBase);

      expect(mockExecuteAnimation).assertEqual(false);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.freeze);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.unfreeze);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_ntf_height_is_not_zero', 0, async () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let notificationDataManager: NotificationDataManager = NotificationDataManager.instance;
      let mockFreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.freeze);
      let mockUnfreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.unfreeze);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);

      when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      notificationlistscrollervm.doDeleteChainAnimation(notificationBase);

      expect(mockExecuteAnimation).assertEqual(true);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.freeze);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.unfreeze);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_not_execute_animation_when_ntf_height_is_zero', 0, async () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let notificationDataManager: NotificationDataManager = NotificationDataManager.instance;
      let mockFreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.freeze);
      let mockUnfreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.unfreeze);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);

      when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      notificationlistscrollervm.doDeleteChainAnimation(notificationBase);

      expect(mockExecuteAnimation).assertEqual(false);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.freeze);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.unfreeze);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_execute_animation_when_ntf_height_is_not_zero', 0, async () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let notificationDataManager: NotificationDataManager = NotificationDataManager.instance;
      let mockFreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.freeze);
      let mockUnfreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.unfreeze);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);

      when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      notificationlistscrollervm.doDeleteChainAnimation(notificationBase);

      expect(mockExecuteAnimation).assertEqual(true);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.freeze);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.unfreeze);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_not_execute_animation_when_ntf_height_is_zero', 0, async () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let notificationDataManager: NotificationDataManager = NotificationDataManager.instance;
      let mockFreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.freeze);
      let mockUnfreeze: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.unfreeze);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);

      when(mockFreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUnfreeze)(ArgumentMatchers.any).afterReturnNothing();
      when(mockExecuteAnimation)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      notificationlistscrollervm.doDeleteChainAnimation(notificationBase);

      expect(mockExecuteAnimation).assertEqual(false);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.freeze);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.unfreeze);
      mocker.ignoreMock(AnimationBase.prototype, AnimationBase.prototype.executeAnimation);
    });

    it('should_return_early_when_ntf_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
      when(mockfunc)().afterReturn(null);
      notificationlistscrollervm.transformStartItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
    });

    it('should_calculate_translateY_and_ratio_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);

      when(mockfunc1)(ArgumentMatchers.anyNumber).afterReturn({ y: 10, height: 20 });
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(50);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(0.5);

      notificationlistscrollervm.transformStartItem();

      expect(notificationlistscrollervm.startItemTranslateY).assertEqual(50);
      mocker.ignoreMock(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });

    it('should_call_scrollListItem_with_correct_params', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null), notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);

      when(mockfunc1)(ArgumentMatchers.anyNumber).afterReturn({ y: 10, height: 20 });
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(50);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(0.5);
      when(mockfunc4)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationlistscrollervm.transformStartItem();

      mocker.ignoreMock(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null), notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_return_early_when_ntf_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
      when(mockfunc)().afterReturn(null);
      notificationlistscrollervm.transformStartItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
    });

    it('should_calculate_translateY_and_ratio_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);

      when(mockfunc1)(ArgumentMatchers.anyNumber).afterReturn({ y: 10, height: 20 });
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(50);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(0.5);

      notificationlistscrollervm.transformStartItem();

      expect(notificationlistscrollervm.startItemTranslateY).assertEqual(50);
      mocker.ignoreMock(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });

    it('should_call_scrollListItem_with_correct_params', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null), notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);

      when(mockfunc1)(ArgumentMatchers.anyNumber).afterReturn({ y: 10, height: 20 });
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(50);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(0.5);
      when(mockfunc4)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationlistscrollervm.transformStartItem();

      mocker.ignoreMock(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null), notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_return_early_when_ntf_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
      when(mockfunc)().afterReturn(null);
      notificationlistscrollervm.transformStartItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
    });

    it('should_return_early_when_ntf_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
      when(mockfunc)().afterReturn(null);
      notificationlistscrollervm.transformStartItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getListVm);
    });
    it('should_calculate_translateY_and_ratio_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);

      when(mockfunc1)(ArgumentMatchers.anyNumber).afterReturn({ y: 10, height: 20 });
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(50);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(0.5);

      notificationlistscrollervm.transformStartItem();

      expect(notificationlistscrollervm.startItemTranslateY).assertEqual(50);
      mocker.ignoreMock(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });

    it('should_call_scrollListItem_with_correct_params', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null), notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);

      when(mockfunc1)(ArgumentMatchers.anyNumber).afterReturn({ y: 10, height: 20 });
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(50);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(0.5);
      when(mockfunc4)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationlistscrollervm.transformStartItem();

      mocker.ignoreMock(notificationlistscrollervm.scroller, notificationlistscrollervm.scroller.getItemRect);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getStartTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null), notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_return_immediately_when_ntf_or_listHeight_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn(null);
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 0 });
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
    });

    it('should_call_scrollListItem_when_endIndex_equals_mainNtfList_length', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 100 });
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn({
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
        }
      });
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
    });

    it('should_call_scrollListItem_with_correct_params_when_translateRatio_is_not_DEFAULT_TRANSLATE_RATIO', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      let mockfunc5: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      let mockfunc6: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 100 });
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn({
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
          expect(scale).assertEqual(1);
          expect(opacity).assertEqual(1);
          expect(translateY).assertEqual(10);
        }
      });
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc5)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      when(mockfunc6)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(0.5);
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });

    it('should_call_scrollListItem_with_default_params_when_translateRatio_is_DEFAULT_TRANSLATE_RATIO', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      let mockfunc5: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      let mockfunc6: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);
      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 100 });
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn({
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
          expect(scale).assertEqual(1);
          expect(opacity).assertEqual(1);
          expect(translateY).assertEqual(10);
        }
      });
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc5)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      when(mockfunc6)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(DEFAULT_TRANSLATE_RATIO);
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });
    it('should_return_immediately_when_ntf_or_listHeight_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);

      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn(null);
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 0 });
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
    });

    it('should_call_scrollListItem_when_endIndex_equals_mainNtfList_length', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 100 });
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn({
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
        }
      });
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
    });

    it('should_call_scrollListItem_with_correct_params_when_translateRatio_is_not_DEFAULT_TRANSLATE_RATIO', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      let mockfunc5: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      let mockfunc6: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);

      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 100 });
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn({
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
          expect(scale).assertEqual(1);
          expect(opacity).assertEqual(1);
          expect(translateY).assertEqual(10);
        }
      });
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc5)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      when(mockfunc6)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(0.5);
      notificationlistscrollervm.transformEndItem();

      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });

    it('should_call_scrollListItem_with_default_params_when_translateRatio_is_DEFAULT_TRANSLATE_RATIO', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.scroller);
      let mockfunc3: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      let mockfunc4: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      let mockfunc5: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      let mockfunc6: Function = mocker.mockFunc(notificationlistscrollervm, notificationlistscrollervm.getRatio);

      when(mockfunc1.getListVm?.getListItemByIndex)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2.getItemRect)(ArgumentMatchers.any).afterReturn({ y: 0, height: 100 });
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn({
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
          expect(scale).assertEqual(1);
          expect(opacity).assertEqual(1);
          expect(translateY).assertEqual(10);
        }
      });

      when(mockfunc4)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc5)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
      when(mockfunc6)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(DEFAULT_TRANSLATE_RATIO);
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.scroller);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getNtfMaxHeightThreshold);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getEndTranslateY);
      mocker.ignoreMock(notificationlistscrollervm, notificationlistscrollervm.getRatio);
    });
  });
}