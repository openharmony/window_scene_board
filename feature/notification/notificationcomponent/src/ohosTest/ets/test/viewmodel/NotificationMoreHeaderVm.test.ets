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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { INotificationMoreHeaderVm, NotificationBaseVm } from '@ohos/systemuicommon/newIndex';
import { MoreNotificationCollapsedAnimation } from '../../../main/ets/animation/MoreNotificationCollapsedAnimation';
import { NotificationMoreHeaderModel } from '@ohos/systemuicommon/src/main/ets/notification/model/NotificationMoreHeaderModel';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationMoreHeaderVm } from '../../../main/ets/viewmodel/NotificationMoreHeaderVm';
export default function NotificationMoreHeaderVmTest() {
  describe('updateCollapsedAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_updateTransitionAnimation_when_moreNtfList_is_not_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [new TransitionEffect()];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_not_call_updateTransitionAnimation_when_moreNtfList_is_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [];
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_handle_exception_when_getExtraNtfAnimationArray_returns_null', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_call_updateTransitionAnimation_when_moreNtfList_is_not_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [new TransitionEffect()];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_not_call_updateTransitionAnimation_when_moreNtfList_is_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [];
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_handle_exception_when_getExtraNtfAnimationArray_returns_null', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_call_updateTransitionAnimation_when_moreNtfList_is_not_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [new TransitionEffect()];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_not_call_updateTransitionAnimation_when_moreNtfList_is_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [];
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_handle_exception_when_getExtraNtfAnimationArray_returns_null', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });
    it('should_call_updateTransitionAnimation_when_moreNtfList_is_not_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [new TransitionEffect()];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_not_call_updateTransitionAnimation_when_moreNtfList_is_empty', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      let mockAnimationArray: TransitionEffect[] = [];
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(mockAnimationArray);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [];
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_handle_exception_when_getExtraNtfAnimationArray_returns_null', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let collapsedAnimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let mockfunc: Function = mocker.mockFunc(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);
      notificationmoreheadervm.collapsedAnimation = collapsedAnimation;

      let moreNtfList: NotificationBaseVm[] = [new NotificationBaseVm()];
      moreNtfList[0].notificationId = 1;
      notificationmoreheadervm.vmInjector.getListVm()!.moreNtfList = moreNtfList;

      let cardVm: NotificationBaseVm = new NotificationBaseVm();
      cardVm.notificationId = 1;
      notificationmoreheadervm.vmInjector.getCardVm(cardVm);

      notificationmoreheadervm.updateCollapsedAnimation();

      mocker.ignoreMock(collapsedAnimation, collapsedAnimation.getExtraNtfAnimationArray);
    });

    it('should_call_updateCollapsedAnimation_and_doCollapsedAnimation_when_toggleCollapsed_is_called', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.toggleCollapsed();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_set_isCollapsed_to_true_when_isCollapsed_is_false', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.isCollapsed = false;
      notificationmoreheadervm.toggleCollapsed();

      expect(notificationmoreheadervm.isCollapsed).assertTrue();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_set_isCollapsed_to_false_when_isCollapsed_is_true', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.isCollapsed = true;
      notificationmoreheadervm.toggleCollapsed();

      expect(notificationmoreheadervm.isCollapsed).assertFalse();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });
    it('should_call_updateCollapsedAnimation_and_doCollapsedAnimation_when_toggleCollapsed_is_called', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.toggleCollapsed();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_set_isCollapsed_to_true_when_isCollapsed_is_false', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.isCollapsed = false;
      notificationmoreheadervm.toggleCollapsed();

      expect(notificationmoreheadervm.isCollapsed).assertTrue();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_set_isCollapsed_to_false_when_isCollapsed_is_true', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.isCollapsed = true;
      notificationmoreheadervm.toggleCollapsed();

      expect(notificationmoreheadervm.isCollapsed).assertFalse();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });
    it('should_call_updateCollapsedAnimation_and_doCollapsedAnimation_when_toggleCollapsed_is_called', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.toggleCollapsed();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_set_isCollapsed_to_true_when_isCollapsed_is_false', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.isCollapsed = false;
      notificationmoreheadervm.toggleCollapsed();

      expect(notificationmoreheadervm.isCollapsed).assertTrue();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_set_isCollapsed_to_false_when_isCollapsed_is_true', 0, async () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();
      let mockUpdateCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      let mockDoCollapsedAnimation: Function = mocker.mockFunc(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
      when(mockUpdateCollapsedAnimation)([]).afterReturnNothing();
      when(mockDoCollapsedAnimation)([ArgumentMatchers.anyFunction]).afterReturnNothing();

      notificationmoreheadervm.isCollapsed = true;
      notificationmoreheadervm.toggleCollapsed();

      expect(notificationmoreheadervm.isCollapsed).assertFalse();

      mocker.ignoreMock(notificationmoreheadervm, notificationmoreheadervm.updateCollapsedAnimation);
      mocker.ignoreMock(notificationmoreheadervm.collapsedAnimation, notificationmoreheadervm.collapsedAnimation.doCollapsedAnimation);
    });

    it('should_return_1_when_firstMoreNtf_is_null', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(1);
    });

    it('should_return_opacity_when_firstMoreNtf_is_not_null', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      let firstMoreNtf: EsObject = new EsObject();
      let notificationBaseVm: NotificationBaseVm = new NotificationBaseVm();
      notificationBaseVm.opacity = 0.5;

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(0.5);
    });

    it('should_return_opacity_when_firstMoreNtf_opacity_is_less_than_thr', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      let firstMoreNtf: EsObject = new EsObject();
      let notificationBaseVm: NotificationBaseVm = new NotificationBaseVm();
      notificationBaseVm.opacity = 0.3;

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(0.3 / (1 - 0.712));
    });

    it('should_return_1_when_firstMoreNtf_is_null', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(1);
    });

    it('should_return_opacity_when_firstMoreNtf_is_not_null', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      let firstMoreNtf: EsObject = new EsObject();
      let notificationBaseVm: NotificationBaseVm = new NotificationBaseVm();
      notificationBaseVm.opacity = 0.5;

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(0.5);
    });

    it('should_return_opacity_when_firstMoreNtf_opacity_is_less_than_thr', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      let firstMoreNtf: EsObject = new EsObject();
      let notificationBaseVm: NotificationBaseVm = new NotificationBaseVm();
      notificationBaseVm.opacity = 0.3;

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(0.3 / (1 - 0.712));
    });it('should_return_1_when_firstMoreNtf_is_null', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(1);
    });

    it('should_return_opacity_when_firstMoreNtf_is_not_null', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      let firstMoreNtf: EsObject = new EsObject();
      let notificationBaseVm: NotificationBaseVm = new NotificationBaseVm();
      notificationBaseVm.opacity = 0.5;

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(0.5);
    });

    it('should_return_opacity_when_firstMoreNtf_opacity_is_less_than_thr', 0, () => {
      let notificationmoreheadervm: NotificationMoreHeaderVm = new NotificationMoreHeaderVm();
      let mocker: MockKit = new MockKit();

      let firstMoreNtf: EsObject = new EsObject();
      let notificationBaseVm: NotificationBaseVm = new NotificationBaseVm();
      notificationBaseVm.opacity = 0.3;

      const result = notificationmoreheadervm.opacity;
      expect(result).assertEqual(0.3 / (1 - 0.712));
    });

  });