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
  CommonUtils,
  DomainName,
  Trace,
  TraceUtil,
  ArrayUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { RectInfo } from '@ohos/basicutils';
import curves from '@ohos.curves';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import { NotificationMenuRow } from '../../../../../main/ets/pages/common/NotificationMenuRow';
import { NotificationAggregateDetail } from '../../../../../main/ets/pages/phone/aggregate/NotificationAggregateDetail';
import { NotificationAggregateBrief } from '../../../../../main/ets/pages/phone/aggregate/NotificationAggregateBrief';
import { NotificationEntry } from '../../../../../main/ets/model/NotificationEntry';
import { NtfHeaderVM } from '../../../../../main/ets/vm/NtfHeaderVM';
import { NtfCloseVM } from '../../../../../main/ets/vm/NtfCloseVM';
import { NotificationAnimationParas } from '../../../../../main/ets/common/NotificationAnimationParas';
import { NotificationConstants } from '../../../../../main/ets/common/NotificationConstants';
import { NtfItemSwipeController } from '../../../../../main/ets/controller/NtfItemSwipeController';
import GroupChildNtfDataChannel from '../../../../../main/ets/vm/GroupChildNtfDataChannel';
import { NotificationConfig } from '../../../../../main/ets/common/NotificationConfig';
import { NotificationType } from '../../../../../main/ets/common/NotificationType';
import { NotificationItemStyle } from '../../../../../main/ets/vm/style/NotificationItemStyle';
import { notificationStyle } from '../../../../../main/ets/vm/style/NotificationStyle';
import { NtfSwipeDeleteEvent, ResetItemSwipeEvent } from '../../../../../main/ets/common/event/NotificationEvent';
import { DEFAULT_CLIP, NtfClipAnimStyle } from '../../../../../main/ets/common/NtfClipAnimStyle';
import { SlNtfItemWidth } from '../../../../../main/ets/common/SlNtfItemWidth';
import { NtfColorModeVM } from '../../../../../main/ets/vm/NtfColorModeVM';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { NotificationUtils } from '../../../../../main/ets/common/NotificationUtils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../../main/ets/pages/phone/aggregate/NotificationAggregateItem';
export default function Test() {
  describe('onNtfDataUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_pause_deleteAnimSync_when_deleteAnimSyncFlag_is_true', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = true;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'testKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.deleteAnimSyncData).assertDeepEquals(newEntry);
    });

    it('should_reportShowUnified_when_aggregateContent_key_is_different', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.aggregateContent = { key: 'oldKey' };
      ntfHeaderVM.ntfEntry = ntfEntry;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'newKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.ntfEntry).assertDeepEquals(newEntry);
    });

    it('should_set_ntfEntry_and_call_refreshGroupCount_refreshChildrenList_when_aggregateContent_key_is_same', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.aggregateContent = { key: 'testKey' };
      ntfHeaderVM.ntfEntry = ntfEntry;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'testKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.ntfEntry).assertDeepEquals(newEntry);
    });

    it('should_reportShowUnified_when_aggregateContent_key_is_different', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.aggregateContent = { key: 'oldKey' };
      ntfHeaderVM.ntfEntry = ntfEntry;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'newKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.ntfEntry).assertDeepEquals(newEntry);
    });

    it('should_set_ntfEntry_and_call_refreshGroupCount_refreshChildrenList_when_aggregateContent_key_is_same', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.aggregateContent = { key: 'testKey' };
      ntfHeaderVM.ntfEntry = ntfEntry;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'testKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.ntfEntry).assertDeepEquals(newEntry);
    });

    it('should_pause_deleteAnimSync_when_deleteAnimSyncFlag_is_true', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = true;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'testKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.deleteAnimSyncData).assertDeepEquals(newEntry);
    });

    it('should_reportShowUnified_when_aggregateContent_key_is_different', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.aggregateContent = { key: 'oldKey' };
      ntfHeaderVM.ntfEntry = ntfEntry;
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.aggregateContent = { key: 'newKey' };
      ntfHeaderVM.onNtfDataUpdate(newEntry);
      expect(ntfHeaderVM.ntfEntry).assertDeepEquals(newEntry);
    });

    it('should_call_all_gesture_handlers_when_gesture_starts_and_ends', 0, () => {
      let mocker: MockKit = new MockKit();


      let mockStartFunc: Function = mocker.mockFunc(this, this.panGestureStart);
      let mockUpdateFunc: Function = mocker.mockFunc(this, this.panGestureUpdate);
      let mockEndFunc: Function = mocker.mockFunc(this, this.panGestureEnd);
      let mockCancelFunc: Function = mocker.mockFunc(this, this.panGestureCancel);

      when(mockStartFunc)(ArgumentMatchers.any).afterReturn(null);
      when(mockUpdateFunc)(ArgumentMatchers.any).afterReturn(null);
      when(mockEndFunc)(ArgumentMatchers.any).afterReturn(null);
      when(mockCancelFunc)().afterReturn(null);

      this.gesture(GestureGroup(GestureMode.Parallel, // 横滑触摸手势
        PanGesture({
          direction: PanDirection.Horizontal,
          distance: NtfItemSwipeController.SWIPE_DISTANCE
        })
          .onActionStart((event) => {
            this.panGestureStart(event);
          })
          .onActionUpdate((event) => {
            this.panGestureUpdate(event);
          })
          .onActionEnd((event) => {
            this.panGestureEnd(event);
          })
          .onActionCancel(() => {
            this.panGestureCancel();
          })
      ));

      mocker.ignoreMock(this, this.panGestureStart);
      mocker.ignoreMock(this, this.panGestureUpdate);
      mocker.ignoreMock(this, this.panGestureEnd);
      mocker.ignoreMock(this, this.panGestureCancel);
    });

    it('should_call_all_gesture_handlers_when_gesture_starts_and_ends', 0, () => {
      let mocker: MockKit = new MockKit();


      let mockStartFunc: Function = mocker.mockFunc(this, this.panGestureStart);
      let mockUpdateFunc: Function = mocker.mockFunc(this, this.panGestureUpdate);
      let mockEndFunc: Function = mocker.mockFunc(this, this.panGestureEnd);
      let mockCancelFunc: Function = mocker.mockFunc(this, this.panGestureCancel);

      when(mockStartFunc)(ArgumentMatchers.any).afterReturn(null);
      when(mockUpdateFunc)(ArgumentMatchers.any).afterReturn(null);
      when(mockEndFunc)(ArgumentMatchers.any).afterReturn(null);
      when(mockCancelFunc)().afterReturn(null);

      this.gesture(GestureGroup(GestureMode.Parallel, // 横滑触摸手势
        PanGesture({
          direction: PanDirection.Horizontal,
          distance: NtfItemSwipeController.SWIPE_DISTANCE
        })
          .onActionStart((event) => {
            this.panGestureStart(event);
          })
          .onActionUpdate((event) => {
            this.panGestureUpdate(event);
          })
          .onActionEnd((event) => {
            this.panGestureEnd(event);
          })
          .onActionCancel(() => {
            this.panGestureCancel();
          })
      ));

      mocker.ignoreMock(this, this.panGestureStart);
      mocker.ignoreMock(this, this.panGestureUpdate);
      mocker.ignoreMock(this, this.panGestureEnd);
      mocker.ignoreMock(this, this.panGestureCancel);
    });

    it('should_return_immediately_when_isGestureEnabled_is_false', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = false;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_event_is_null', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = null;
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_swipeHashCode_is_not_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.swipeHashCode = 'someHashCode';
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('someHashCode');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_hasCalledAboutToDisappear_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.hasCalledAboutToDisappear = true;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_set_isDragged_and_isRTL_correctly_when_all_conditions_are_met', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.swipeController = {
        onStartSwipe: (e: GestureEvent) => {}
      };
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertTrue();
      expect(notificationAggregateDetail.isRTL).assertEqual(RTLUtil.isRTL());
      expect(notificationAggregateDetail.swipeHashCode).assertNotEqual('');
      expect(notificationAggregateDetail.swipeController).assertNotNull();
    });

    it('should_return_immediately_when_isGestureEnabled_is_false', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = false;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_event_is_null', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = null;
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_swipeHashCode_is_not_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.swipeHashCode = 'someHashCode';
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('someHashCode');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_hasCalledAboutToDisappear_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.hasCalledAboutToDisappear = true;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_set_isDragged_and_isRTL_correctly_when_all_conditions_are_met', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.swipeController = {
        onStartSwipe: (e: GestureEvent) => {}
      };
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertTrue();
      expect(notificationAggregateDetail.isRTL).assertEqual(RTLUtil.isRTL());
      expect(notificationAggregateDetail.swipeHashCode).assertNotEqual('');
      expect(notificationAggregateDetail.swipeController).assertNotNull();
    });
    it('should_return_immediately_when_isGestureEnabled_is_false', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = false;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_event_is_null', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = null;
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_swipeHashCode_is_not_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.swipeHashCode = 'someHashCode';
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('someHashCode');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

    it('should_return_immediately_when_hasCalledAboutToDisappear_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationConfig: NotificationConfig = new NotificationConfig();
      let ntfAnimationParas: NotificationAnimationParas = new NotificationAnimationParas();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let notificationAggregateDetail: NotificationAggregateDetail = new NotificationAggregateDetail(ntfEntry, ntfHeaderVM, ntfCloseVM, ntfItemStyle, notificationConfig, ntfAnimationParas, ntfItemSwipeController, groupChildNtfDataChannel, ntfColorModeVM);
      let event: GestureEvent = new GestureEvent();
      notificationAggregateDetail.isGestureEnabled = true;
      notificationAggregateDetail.hasCalledAboutToDisappear = true;
      notificationAggregateDetail.panGestureStart(event);
      expect(notificationAggregateDetail.isDragged).assertFalse();
      expect(notificationAggregateDetail.isRTL).assertFalse();
      expect(notificationAggregateDetail.swipeHashCode).assertEqual('');
      expect(notificationAggregateDetail.swipeController).assertNull();
    });

  });
}