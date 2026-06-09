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
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { ComponentConstants } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { NtfHeadsUpVM } from '../../../../main/ets/vm/NtfHeadsUpVM';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/common/NotificationClose';
export default function Test() {
  describe('build_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_build_close_button_when_closeVM_isShow_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);

      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      mocker.ignoreMock(LogHelper.prototype, LogHelper.prototype.showInfo);
      mocker.ignoreMock(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      mocker.ignoreMock(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
    });

    it('should_not_build_close_button_when_closeVM_isShow_is_false', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(false);

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
    });

    it('should_handle_hover_event_when_isHover_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);

      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
    });

    it('should_build_close_button_when_closeVM_isShow_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);

      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      mocker.ignoreMock(LogHelper.prototype, LogHelper.prototype.showInfo);
      mocker.ignoreMock(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      mocker.ignoreMock(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
    });

    it('should_not_build_close_button_when_closeVM_isShow_is_false', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(false);

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
    });

    it('should_handle_hover_event_when_isHover_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);

      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
    });

    it('should_build_close_button_when_closeVM_isShow_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);

      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      mocker.ignoreMock(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      mocker.ignoreMock(LogHelper.prototype, LogHelper.prototype.showInfo);
      mocker.ignoreMock(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      mocker.ignoreMock(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
    });

    it('should_not_build_close_button_when_closeVM_isShow_is_false', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(false);

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
    });

    it('should_handle_hover_event_when_isHover_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);

      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();

      testee.build();

      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
    });

    it('should_handle_hover_event_when_isHover_is_true', 0, async () => {
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();
      let mockIsShow: Function = mocker.mockFunc(closeVM, closeVM.isShow);
      when(mockIsShow)().afterReturn(true);

      let mockId: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.id);
      when(mockId)(ArgumentMatchers.anyString).afterReturn(new CommonMethod());

      let mockDraggable: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
      when(mockDraggable)(ArgumentMatchers.anyBoolean).afterReturn(new ImageAttribute());

      let mockFillColor: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.fillColor);
      when(mockFillColor)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.anyNumber).afterReturn(new CommonMethod());

      let mockObjectFit: Function = mocker.mockFunc(ImageAttribute.prototype, ImageAttribute.prototype.objectFit);
      when(mockObjectFit)(ArgumentMatchers.any).afterReturn(new ImageAttribute());

      let mockCancelItemHover: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.cancelItemHover);
      when(mockCancelItemHover)(ArgumentMatchers.any).afterReturnNothing();

      let mockClearCancelTimer: Function = mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.clearCancelTimer);
      when(mockClearCancelTimer)().afterReturnNothing();

      let mockDeleteNotification: Function =
        mocker.mockFunc(NtfCloseVM.prototype, NtfCloseVM.prototype.deleteNotification);
      when(mockDeleteNotification)().afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetNumberByResource: Function =
        mocker.mockFunc(ResourceManager.prototype, ResourceManager.prototype.getNumberByResource);
      when(mockGetNumberByResource)(ArgumentMatchers.any).afterReturn(0);
      let headsUpVM: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mockSetItemHoverState: Function =
        mocker.mockFunc(NtfHeadsUpVM.prototype, NtfHeadsUpVM.prototype.setItemHoverState);
      when(mockSetItemHoverState)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let testee: NotificationClose = new NotificationClose();
      testee.closeVM = closeVM;
      testee.headsUpVM = headsUpVM;
      testee.shadowStyle = new ImageAttribute();
      testee.build();
      mocker.ignoreMock(closeVM, closeVM.isShow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.id);
      mocker.ignoreMock(ImageAttribute.prototype, ImageAttribute.prototype.draggable);
    });
  });
}

