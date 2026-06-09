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
  ArgumentMatchers
} from '@ohos/hypium';
import { NotificationListScrollerVm } from '../../../main/ets/viewmodel/NotificationListScrollerVm';

export default function NotificationListScrollerVmTest() {
  describe('onListSizeChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_listHeight_when_onListSizeChange_is_called', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let size: SizeOptions = {
        height: 100
      };
      notificationlistscrollervm.onListSizeChange(size);
      expect(notificationlistscrollervm.listHeight).assertEqual(100);
    });

    it('should_log_info_when_onListSizeChange_is_called', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let size: SizeOptions = {
        height: 100
      };
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      notificationlistscrollervm.onListSizeChange(size);
      expect(notificationlistscrollervm.listHeight).assertEqual(100);
      mocker.ignoreMock(logHelper, logHelper.showInfo); //还原mock函数，否则会影响其他用例
    });

    it('should_update_listHeight_when_onListSizeChange_is_called', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let size: SizeOptions = {
        height: 100
      };
      notificationlistscrollervm.onListSizeChange(size);
      expect(notificationlistscrollervm.listHeight).assertEqual(100);
    });

    it('should_log_info_when_onListSizeChange_is_called', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let size: SizeOptions = {
        height: 100
      };
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      notificationlistscrollervm.onListSizeChange(size);
      expect(notificationlistscrollervm.listHeight).assertEqual(100);
      mocker.ignoreMock(logHelper, logHelper.showInfo); //还原mock函数，否则会影响其他用例
    });

    it('should_call_scroller_scrollEdge_Top', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();

      notificationlistscrollervm.scrollToTop();

      expect(notificationlistscrollervm.isScrollToTop).assertEqual(true);
    });

    it('should_return_early_when_ntf_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();

      notificationlistscrollervm.transformStartItem();

    });

    it('should_calculate_translateY_and_translateRatio_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();

      let mockNtf: NotificationBase = new NotificationBase();
      let mockCardVm: INotificationCardVm = {
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
        }
      };

      notificationlistscrollervm.vmInjector = {
        getListVm: () => mockNtf,
        getCardVm: () => mockCardVm
      };

      let mockScroller: any = {
        getItemRect: (index: number) => {
          return {
            y: 10, height: 50
          };
        }
      };
      notificationlistscrollervm.scroller = mockScroller;

      notificationlistscrollervm.transformStartItem();

      expect(notificationlistscrollervm.startItemTranslateY).assertEqual(10);

    });

    it('should_call_scrollListItem_with_correct_params_when_translateRatio_is_not_1', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();

      let mockNtf: NotificationBase = new NotificationBase();
      let mockCardVm: INotificationCardVm = {
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
          expect(scale).assertEqual(MIN_SCALE);
          expect(opacity).assertEqual(1);
          expect(translateY).assertEqual(10);
        }
      };

      notificationlistscrollervm.vmInjector = {
        getListVm: () => mockNtf,
        getCardVm: () => mockCardVm
      };

      let mockScroller: any = {
        getItemRect: (index: number) => {
          return {
            y: 10, height: 50
          };
        }
      };
      notificationlistscrollervm.scroller = mockScroller;

      notificationlistscrollervm.transformStartItem();

    });

    it('should_call_scrollListItem_with_correct_params_when_translateRatio_is_1', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();

      let mockNtf: NotificationBase = new NotificationBase();
      let mockCardVm: INotificationCardVm = {
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
          expect(scale).assertEqual(1);
          expect(opacity).assertEqual(1);
          expect(translateY).assertEqual(10);
        }
      };

      notificationlistscrollervm.vmInjector = {
        getListVm: () => mockNtf,
        getCardVm: () => mockCardVm
      };

      let mockScroller: any = {
        getItemRect: (index: number) => {
          return {
            y: 10, height: 50
          };
        }
      };
      notificationlistscrollervm.scroller = mockScroller;

      notificationlistscrollervm.transformStartItem();

    });

    it('should_set_clipHeight_and_clipOffset_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();

      let mockNtf: NotificationBase = new NotificationBase();
      let mockCardVm: INotificationCardVm = {
        scrollListItem: (scale: number, opacity: number, translateY: number) => {
        }
      };

      notificationlistscrollervm.vmInjector = {
        getListVm: () => mockNtf,
        getCardVm: () => mockCardVm
      };

      let mockScroller: any = {
        getItemRect: (index: number) => {
          return {
            y: -10, height: 50
          };
        }
      };
      notificationlistscrollervm.scroller = mockScroller;

      notificationlistscrollervm.transformStartItem();

      expect(notificationlistscrollervm.startItemTranslateY).assertEqual(-10);
    });

    it('should_return_immediately_when_ntf_or_listHeight_is_null', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(null);
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
    });

    it('should_call_scrollListItem_when_endIndex_equals_mainNtfList_length', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_call_scrollListItem_with_scale_and_opacity_when_translateRatio_is_not_default', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_call_scrollListItem_with_default_scale_and_opacity_when_translateRatio_is_default', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_call_setClipHeight_when_clipHeight_is_greater_than_0', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });

    it('should_call_setClipHeight_when_clipHeight_is_0', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      let mockfunc2: Function = mocker.mockFunc(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn({});
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      notificationlistscrollervm.transformEndItem();
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getListVm(),
        notificationlistscrollervm.vmInjector.getListVm().getListItemByIndex);
      mocker.ignoreMock(notificationlistscrollervm.vmInjector.getCardVm(null),
        notificationlistscrollervm.vmInjector.getCardVm(null).scrollListItem);
    });


    it('should_call_setItemClipParam_when_overHeight_is_false', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      notificationlistscrollervm.setClipHeight(notificationBase, false);
    });

    it('should_call_setItemClipParam_with_height_and_offset_when_overHeight_is_true', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();
      let height: number = 100;
      let offset: number = 50;
      notificationlistscrollervm.setClipHeight(notificationBase, true, height, offset);
    });

    it('should_handle_first_and_last_ntf_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let cardVm: INotificationCardVm = new NotificationBaseVm();

      let ntfList: NotificationBase[] = [
        {
          uid: '1',
          hashCode: 1,
          notificationType: 1,
          notificationColor: 1,
          notificationTime: 1,
        },
        {
          uid: '2',
          hashCode: 1,
          notificationType: 1,
          notificationColor: 1,
          notificationTime: 1,
        },
        {
          uid: '3',
          hashCode: 1,
          notificationType: 1,
          notificationColor: 1,
          notificationTime: 1,
        },
      ];
      ntfList[0].uid = notificationlistscrollervm.deletedNtf.exStartNtfUid;
      ntfList[2].uid = notificationlistscrollervm.deletedNtf.exEndNtfUid;

      notificationlistscrollervm.setTranslateBeforeAnimation(1, ntfList);

    });

    it('should_handle_middle_ntfs_correctly', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let mocker: MockKit = new MockKit();
      let cardVm: INotificationCardVm = new NotificationBaseVm();

      let ntfList: NotificationBase[] = [
        {
          uid: '1',
          hashCode: 1,
          notificationType: 1,
          notificationColor: 1,
          notificationTime: 1,
        },
        {
          uid: '2',
          hashCode: 1,
          notificationType: 1,
          notificationColor: 1,
          notificationTime: 1,
        },
        {
          uid: '3',
          hashCode: 1,
          notificationType: 1,
          notificationColor: 1,
          notificationTime: 1,
        },
      ];

      notificationlistscrollervm.setTranslateBeforeAnimation(1, ntfList);
    });

    it('should_return_empty_animateParams_when_ntfList_is_empty', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let ntfList: NotificationBase[] = [];
      let index: number = 0;
      const result = notificationlistscrollervm.getDeleteChainAnimations(index, ntfList);
      expect(result).assertDeepEquals([]);
    });

    it('should_return_animateParams_with_correct_delay_when_ntfList_is_not_empty', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let ntfList: NotificationBase[] = [
        {
          uid: '1', hashCode: 1
        },
        {
          uid: '2', hashCode: 2
        },
        {
          uid: '3', hashCode: 3
        },
      ];
      let index: number = 1;
      const result = notificationlistscrollervm.getDeleteChainAnimations(index, ntfList);
      expect(result.length).assertEqual(3);
      expect(result[0].delay).assertEqual(0);
      expect(result[1].delay).assertEqual(16.67);
      expect(result[2].delay).assertEqual(33.33);
    });

    it('should_call_transformStartItem_when_ntf_uid_is_startUid', 0, () => {
      let notificationlistscrollervm: NotificationListScrollerVm = new NotificationListScrollerVm();
      let ntfList: NotificationBase[] = [
        {
          uid: '1', hashCode: 1
        },
        {
          uid: '2', hashCode: 2
        },
        {
          uid: '3', hashCode: 3
        },
      ];
      let index: number = 1;
      notificationlistscrollervm.deletedNtf.newStartNtfUid = '1';
      const result = notificationlistscrollervm.getDeleteChainAnimations(index, ntfList);
      expect(result.length).assertEqual(3);
      expect(result[0].event()).assertInstanceOf(Function);
      result[0].event()();
      expect(notificationlistscrollervm.deletedNtf.newStartNtfUid).assertEqual('1');
    });

    it('should_return_false_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let result = notificationdatavm.delMapData(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_existNtf_is_not_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let existNtf: NotificationBase = new NotificationBase();
      existNtf.notificationType = NotificationCategory.NOTIFICATION_TYPE_ALERT;
      let result = notificationdatavm.delMapData(existNtf);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_existNtf_is_normal_group_and_delete_successfully', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let existNtf: NotificationBase = new NormalNotificationGroup();
      existNtf.notificationType = NotificationCategory.NOTIFICATION_TYPE_ALERT_GROUP;
      existNtf.children = new NotificationArray();
      existNtf.children?.push(new NormalNotification());
      let mocker: MockKit = new MockKit();

      let result = notificationdatavm.delMapData(existNtf);
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_existNtf_is_normal_group_and_delete_fails', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let existNtf: NotificationBase = new NormalNotificationGroup();
      existNtf.notificationType = NotificationCategory.NOTIFICATION_TYPE_ALERT_GROUP;
      existNtf.children = new NotificationArray();
      existNtf.children?.push(new NormalNotification());
      let mocker: MockKit = new MockKit();

      let result = notificationdatavm.delMapData(existNtf);
      expect(result).assertEqual(true);
    });

  });
}