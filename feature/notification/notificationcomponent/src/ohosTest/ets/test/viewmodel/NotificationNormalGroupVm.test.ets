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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NormalNotification, NormalNotificationGroup } from '@ohos/systemuicommon/newTsIndex';
import {
  AnimationBase,
  INotificationCardVm,
  INotificationNormalGroupVm,
  NotificationItemBaseVm
} from '@ohos/systemuicommon/newIndex';
import { NotificationGroupExpandedAnimation } from '../../../main/ets/animation/NotificationGroupExpandedAnimation';
import { NotificationNormalVm } from '../../../main/ets/viewmodel/NotificationNormalVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationNormalGroupVm } from '../../../main/ets/viewmodel/NotificationNormalGroupVm';
export default function NotificationNormalGroupVmTest() {
  describe('onNtfChildrenChanged_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_children_when_isVisible_is_false_or_isExpanded_is_false', 0, async () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = [new NormalNotification(), new NormalNotification()];

      let mockCardVm: INotificationCardVm = {
        update: () => {}
      };
      notificationnormalgroupvm.cardVm = mockCardVm;

      notificationnormalgroupvm.isExpanded = false;
      notificationnormalgroupvm.vmInjector = {
        getPanelVm: () => {
          return {
            isVisible: false
          };
        },
        getCardVm: () => mockCardVm
      };

      notificationnormalgroupvm.onNtfChildrenChanged();

      expect(notificationnormalgroupvm.children.length).assertEqual(2);
      mocker.ignoreMock(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
    });

    it('should_execute_animation_when_isVisible_is_true_and_isExpanded_is_true', 0, async () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = [new NormalNotification(), new NormalNotification()];

      let mockCardVm: INotificationCardVm = {
        update: () => {}
      };
      notificationnormalgroupvm.cardVm = mockCardVm;

      notificationnormalgroupvm.isExpanded = true;
      notificationnormalgroupvm.isBriefContentTransition = false;
      notificationnormalgroupvm.isHideNtfContent = false;
      notificationnormalgroupvm.hideText = '';
      notificationnormalgroupvm.isShowDateTime = true;
      notificationnormalgroupvm.briefFirstNtfY = 0;
      notificationnormalgroupvm.briefIconDiffY = 0;
      notificationnormalgroupvm.briefIconY = 0;
      notificationnormalgroupvm.ntfGroupAnimation = new NotificationGroupExpandedAnimation();

      let mockAnimationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.NTF_GROUP_CHILDREN_UPDATE_ANIMATION, true);
      notificationnormalgroupvm.anim = mockAnimationBase;

      notificationnormalgroupvm.vmInjector = {
        getPanelVm: () => {
          return {
            isVisible: true
          };
        },
        getCardVm: () => mockCardVm
      };

      let mockLogHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION);
      notificationnormalgroupvm.logger = mockLogHelper;

      notificationnormalgroupvm.onNtfChildrenChanged();

      expect(notificationnormalgroupvm.children.length).assertEqual(2);
      mocker.ignoreMock(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
    });

    it('should_update_children_when_isVisible_is_false_or_isExpanded_is_false', 0, async () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = [new NormalNotification(), new NormalNotification()];

      let mockCardVm: INotificationCardVm = {
        update: () => {}
      };
      notificationnormalgroupvm.cardVm = mockCardVm;

      notificationnormalgroupvm.isExpanded = false;
      notificationnormalgroupvm.vmInjector = {
        getPanelVm: () => {
          return {
            isVisible: false
          };
        },
        getCardVm: () => mockCardVm
      };

      notificationnormalgroupvm.onNtfChildrenChanged();

      expect(notificationnormalgroupvm.children.length).assertEqual(2);
      mocker.ignoreMock(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
    });

    it('should_execute_animation_when_isVisible_is_true_and_isExpanded_is_true', 0, async () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = [new NormalNotification(), new NormalNotification()];

      let mockCardVm: INotificationCardVm = {
        update: () => {}
      };
      notificationnormalgroupvm.cardVm = mockCardVm;

      notificationnormalgroupvm.isExpanded = true;
      notificationnormalgroupvm.isBriefContentTransition = false;
      notificationnormalgroupvm.isHideNtfContent = false;
      notificationnormalgroupvm.hideText = '';
      notificationnormalgroupvm.isShowDateTime = true;
      notificationnormalgroupvm.briefFirstNtfY = 0;
      notificationnormalgroupvm.briefIconDiffY = 0;
      notificationnormalgroupvm.briefIconY = 0;
      notificationnormalgroupvm.ntfGroupAnimation = new NotificationGroupExpandedAnimation();

      let mockAnimationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.NTF_GROUP_CHILDREN_UPDATE_ANIMATION, true);
      notificationnormalgroupvm.anim = mockAnimationBase;

      notificationnormalgroupvm.vmInjector = {
        getPanelVm: () => {
          return {
            isVisible: true
          };
        },
        getCardVm: () => mockCardVm
      };

      let mockLogHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION);
      notificationnormalgroupvm.logger = mockLogHelper;

      notificationnormalgroupvm.onNtfChildrenChanged();

      expect(notificationnormalgroupvm.children.length).assertEqual(2);
      mocker.ignoreMock(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
    });

    it('should_update_children_when_isVisible_is_false_or_isExpanded_is_false', 0, async () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = [new NormalNotification(), new NormalNotification()];

      let mockCardVm: INotificationCardVm = {
        update: () => {}
      };
      notificationnormalgroupvm.cardVm = mockCardVm;

      notificationnormalgroupvm.isExpanded = false;
      notificationnormalgroupvm.vmInjector = {
        getPanelVm: () => {
          return {
            isVisible: false
          };
        },
        getCardVm: () => mockCardVm
      };

      notificationnormalgroupvm.onNtfChildrenChanged();

      expect(notificationnormalgroupvm.children.length).assertEqual(2);
      mocker.ignoreMock(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
    });

    it('should_execute_animation_when_isVisible_is_true_and_isExpanded_is_true', 0, async () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = [new NormalNotification(), new NormalNotification()];

      let mockCardVm: INotificationCardVm = {
        update: () => {}
      };
      notificationnormalgroupvm.cardVm = mockCardVm;

      notificationnormalgroupvm.isExpanded = true;
      notificationnormalgroupvm.isBriefContentTransition = false;
      notificationnormalgroupvm.isHideNtfContent = false;
      notificationnormalgroupvm.hideText = '';
      notificationnormalgroupvm.isShowDateTime = true;
      notificationnormalgroupvm.briefFirstNtfY = 0;
      notificationnormalgroupvm.briefIconDiffY = 0;
      notificationnormalgroupvm.briefIconY = 0;
      notificationnormalgroupvm.ntfGroupAnimation = new NotificationGroupExpandedAnimation();

      let mockAnimationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.NTF_GROUP_CHILDREN_UPDATE_ANIMATION, true);
      notificationnormalgroupvm.anim = mockAnimationBase;

      notificationnormalgroupvm.vmInjector = {
        getPanelVm: () => {
          return {
            isVisible: true
          };
        },
        getCardVm: () => mockCardVm
      };

      let mockLogHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION);
      notificationnormalgroupvm.logger = mockLogHelper;

      notificationnormalgroupvm.onNtfChildrenChanged();

      expect(notificationnormalgroupvm.children.length).assertEqual(2);
      mocker.ignoreMock(notificationnormalgroupvm, notificationnormalgroupvm.onNtfChildrenChanged);
    });

    it('should_return_empty_string_when_moreNtfNum_is_less_than_0', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let children: NormalNotification[] = [];
      for (let i = 0; i < MAX_SHOW_NTF_NUM; i++) {
        children.push(new NormalNotification());
      }
      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = children;
      expect(notificationnormalgroupvm.remainderCount).assertEqual('');
    });

    it('should_return_plus_moreNtfNum_when_moreNtfNum_is_greater_than_0', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let children: NormalNotification[] = [];
      for (let i = 0; i < MAX_SHOW_NTF_NUM + 1; i++) {
        children.push(new NormalNotification());
      }
      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = children;
      expect(notificationnormalgroupvm.remainderCount).assertEqual('' + (children.length - MAX_SHOW_NTF_NUM));
    });

    it('should_return_empty_string_when_moreNtfNum_is_less_than_0', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let children: NormalNotification[] = [];
      for (let i = 0; i < MAX_SHOW_NTF_NUM; i++) {
        children.push(new NormalNotification());
      }
      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = children;
      expect(notificationnormalgroupvm.remainderCount).assertEqual('');
    });

    it('should_return_plus_moreNtfNum_when_moreNtfNum_is_greater_than_0', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let children: NormalNotification[] = [];
      for (let i = 0; i < MAX_SHOW_NTF_NUM + 1; i++) {
        children.push(new NormalNotification());
      }
      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = children;
      expect(notificationnormalgroupvm.remainderCount).assertEqual('' + (children.length - MAX_SHOW_NTF_NUM));
    });
    it('should_return_empty_string_when_moreNtfNum_is_less_than_0', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let children: NormalNotification[] = [];
      for (let i = 0; i < MAX_SHOW_NTF_NUM; i++) {
        children.push(new NormalNotification());
      }
      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = children;
      expect(notificationnormalgroupvm.remainderCount).assertEqual('');
    });

    it('should_return_plus_moreNtfNum_when_moreNtfNum_is_greater_than_0', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let children: NormalNotification[] = [];
      for (let i = 0; i < MAX_SHOW_NTF_NUM + 1; i++) {
        children.push(new NormalNotification());
      }
      notificationnormalgroupvm.ntf = new NormalNotificationGroup();
      notificationnormalgroupvm.ntf.children = children;
      expect(notificationnormalgroupvm.remainderCount).assertEqual('' + (children.length - MAX_SHOW_NTF_NUM));
    });

    it('should_return_immediately_when_isMenuExpand_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      notificationnormalgroupvm.switchExpand(true);
    });

    it('should_releaseGroup_and_updateNtf_when_children_length_is_1', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let children: NormalNotification[] = [new NormalNotification()];
      notificationnormalgroupvm.children = children;
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().releaseGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc2: Function = mocker.mockFunc(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().updateNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      notificationnormalgroupvm.switchExpand(false);
      expect(notificationnormalgroupvm.isBriefContentTransition).assertEqual(true);
      mocker.ignoreMock(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().releaseGroup);
      mocker.ignoreMock(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().updateNtf);
    });

    it('should_executeAnimation_and_processAfterExpand_when_children_length_is_not_1', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let children: NormalNotification[] = [new NormalNotification(), new NormalNotification()];
      notificationnormalgroupvm.children = children;
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm.ntfGroupAnimation, notificationnormalgroupvm.ntfGroupAnimation.executeAnimation);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());
      notificationnormalgroupvm.switchExpand(false);
      expect(notificationnormalgroupvm.isExpanded).assertEqual(true);
      mocker.ignoreMock(notificationnormalgroupvm.ntfGroupAnimation, notificationnormalgroupvm.ntfGroupAnimation.executeAnimation);
    });

    it('should_return_immediately_when_isMenuExpand_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      notificationnormalgroupvm.switchExpand(true);
    });

    it('should_releaseGroup_and_updateNtf_when_children_length_is_1', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let children: NormalNotification[] = [new NormalNotification()];
      notificationnormalgroupvm.children = children;
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().releaseGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc2: Function = mocker.mockFunc(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().updateNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      notificationnormalgroupvm.switchExpand(false);
      expect(notificationnormalgroupvm.isBriefContentTransition).assertEqual(true);
      mocker.ignoreMock(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().releaseGroup);
      mocker.ignoreMock(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().updateNtf);
    });

    it('should_executeAnimation_and_processAfterExpand_when_children_length_is_not_1', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let children: NormalNotification[] = [new NormalNotification(), new NormalNotification()];
      notificationnormalgroupvm.children = children;
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm.ntfGroupAnimation, notificationnormalgroupvm.ntfGroupAnimation.executeAnimation);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());
      notificationnormalgroupvm.switchExpand(false);
      expect(notificationnormalgroupvm.isExpanded).assertEqual(true);
      mocker.ignoreMock(notificationnormalgroupvm.ntfGroupAnimation, notificationnormalgroupvm.ntfGroupAnimation.executeAnimation);
    });

    it('should_return_immediately_when_isMenuExpand_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      notificationnormalgroupvm.switchExpand(true);
    });

    it('should_releaseGroup_and_updateNtf_when_children_length_is_1', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let children: NormalNotification[] = [new NormalNotification()];
      notificationnormalgroupvm.children = children;
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().releaseGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc2: Function = mocker.mockFunc(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().updateNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      notificationnormalgroupvm.switchExpand(false);
      expect(notificationnormalgroupvm.isBriefContentTransition).assertEqual(true);
      mocker.ignoreMock(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().releaseGroup);
      mocker.ignoreMock(notificationnormalgroupvm.vmInjector.getListVm(), notificationnormalgroupvm.vmInjector.getListVm().updateNtf);
    });

    it('should_executeAnimation_and_processAfterExpand_when_children_length_is_not_1', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let mocker: MockKit = new MockKit();
      let children: NormalNotification[] = [new NormalNotification(), new NormalNotification()];
      notificationnormalgroupvm.children = children;
      let mockfunc: Function = mocker.mockFunc(notificationnormalgroupvm.ntfGroupAnimation, notificationnormalgroupvm.ntfGroupAnimation.executeAnimation);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());
      notificationnormalgroupvm.switchExpand(false);
      expect(notificationnormalgroupvm.isExpanded).assertEqual(true);
      mocker.ignoreMock(notificationnormalgroupvm.ntfGroupAnimation, notificationnormalgroupvm.ntfGroupAnimation.executeAnimation);
    });

    it('should_set_align_to_TopEnd_when_isExpanded_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: true });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.TopEnd);
    });

    it('should_set_align_to_End_when_isExpanded_is_false', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: false });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.End);
    });

    it('should_set_align_to_TopEnd_when_isExpanded_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: true });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.TopEnd);
    });

    it('should_set_align_to_End_when_isExpanded_is_false', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: false });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.End);
    });

    it('should_set_align_to_TopEnd_when_isExpanded_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: true });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.TopEnd);
    });

    it('should_set_align_to_End_when_isExpanded_is_false', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: false });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.End);
    });

    it('should_set_align_to_TopEnd_when_isExpanded_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: true });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.TopEnd);
    });

    it('should_set_align_to_End_when_isExpanded_is_false', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: false });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.End);
    });

    it('should_set_align_to_TopEnd_when_isExpanded_is_true', 0, () => {
      let notificationnormalgroupvm: NotificationNormalGroupVm = new NotificationNormalGroupVm();
      let monitor: IMonitor = new IMonitor();
      when(monitor.value())
        .afterReturn({ now: true });
      notificationnormalgroupvm.onIsExpandedChange(monitor);
      expect(notificationnormalgroupvm.cardVm?.align).assertEqual(Alignment.TopEnd);
    });
  });
}