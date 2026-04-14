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
import { display } from '@kit.ArkUI';
import ctx from '@ohos.app.ability.common';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { PinTopLimitDialogInterface } from '../../../main/ets/dialog/PinTopLimitDialogInterface';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ViewType } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PinTopLimitDialogVm } from '../../../main/ets/dialog/PinTopLimitDialogVm';
export default function PinTopLimitDialogVmTest() {
  describe('getIsLandLayout_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_isSingleDisplayPocketFoldDevice_and_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(display, display.getFoldStatus);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isSingleDisplayPocketFoldDevice_or_isSmallFoldProduct_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isXTProductType_and_isMatchXTFoldMode_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isMatchXTFoldMode);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isMatchXTFoldMode);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_false_when_isFold_and_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(display, display.getFoldStatus);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isPad_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_false_when_no_matching_condition_is_met', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);
      when(mockfunc3)().afterReturn(false);
      let mockfunc4: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc4)().afterReturn(false);
      let mockfunc5: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc5)().afterReturn(false);
      let mockfunc6: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc6)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_font_scale_when_font_scale_state_is_not_null', 0, async () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let fontScaleState: FontScaleState = new FontScaleState();
      let mockfunc: Function = mocker.mockFunc(fontScaleState, fontScaleState.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(2.0);
      pintoplimitdialogvm.fontScaleState = fontScaleState;
      const result = pintoplimitdialogvm.getFontScale();
      expect(result).assertEqual(2.0);
      mocker.ignoreMock(fontScaleState, fontScaleState.getFontScale);
    });

    it('should_return_default_font_scale_when_font_scale_state_is_null', 0, async () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let fontScaleState: FontScaleState = new FontScaleState();
      let mockfunc: Function = mocker.mockFunc(fontScaleState, fontScaleState.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(1.0);
      pintoplimitdialogvm.fontScaleState = null;
      const result = pintoplimitdialogvm.getFontScale();
      expect(result).assertEqual(1.0);
      mocker.ignoreMock(fontScaleState, fontScaleState.getFontScale);
    });

    it('should_log_debug_and_emit_event_when_onFocus_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockDebug: Function = mocker.mockFunc(logHelper, logHelper.debug);
      when(mockDebug)(ArgumentMatchers.any).afterReturnNothing();

      let eventHub: EventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      pintoplimitdialogvm.onFocus();

      mocker.ignoreMock(logHelper, logHelper.debug);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });

    it('should_log_debug_and_emit_event_when_onBlur_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.debug);
      when(mockLogFunc)(ArgumentMatchers.any).afterReturnNothing();

      let eventHub: EventHub = GlobalContext.getContext().eventHub;
      let mockEmitFunc: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmitFunc)('SubWindowVisible', ViewType.NOTIFICATION_CENTER, false).afterReturnNothing();

      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      pintoplimitdialogvm.onBlur();

      mocker.ignoreMock(logHelper, logHelper.debug);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });

    it('should_return_false_when_isSingleDisplayPocketFoldDevice_and_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();

      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(display, display.getFoldStatus);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isSingleDisplayPocketFoldDevice_or_isSmallFoldProduct_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isXTProductType_and_isMatchXTFoldMode_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isMatchXTFoldMode);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isMatchXTFoldMode);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_false_when_isFold_and_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(display, display.getFoldStatus);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isPad_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_false_when_no_matching_condition_is_met', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);
      when(mockfunc3)().afterReturn(false);
      let mockfunc4: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc4)().afterReturn(false);
      let mockfunc5: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc5)().afterReturn(false);
      let mockfunc6: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc6)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_font_scale_when_font_scale_state_is_not_null', 0, async () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let fontScaleState: FontScaleState = new FontScaleState();
      let mockfunc: Function = mocker.mockFunc(fontScaleState, fontScaleState.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(2.0);
      pintoplimitdialogvm.fontScaleState = fontScaleState;
      const result = pintoplimitdialogvm.getFontScale();
      expect(result).assertEqual(2.0);
      mocker.ignoreMock(fontScaleState, fontScaleState.getFontScale);
    });

    it('should_return_default_font_scale_when_font_scale_state_is_null', 0, async () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let fontScaleState: FontScaleState = new FontScaleState();
      let mockfunc: Function = mocker.mockFunc(fontScaleState, fontScaleState.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(1.0);
      pintoplimitdialogvm.fontScaleState = null;
      const result = pintoplimitdialogvm.getFontScale();
      expect(result).assertEqual(1.0);
      mocker.ignoreMock(fontScaleState, fontScaleState.getFontScale);
    });

    it('should_log_debug_and_emit_event_when_onFocus_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockDebug: Function = mocker.mockFunc(logHelper, logHelper.debug);
      when(mockDebug)(ArgumentMatchers.any).afterReturnNothing();

      let eventHub: EventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      pintoplimitdialogvm.onFocus();

      mocker.ignoreMock(logHelper, logHelper.debug);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });

    it('should_log_debug_and_emit_event_when_onBlur_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.debug);
      when(mockLogFunc)(ArgumentMatchers.any).afterReturnNothing();

      let eventHub: EventHub = GlobalContext.getContext().eventHub;
      let mockEmitFunc: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmitFunc)('SubWindowVisible', ViewType.NOTIFICATION_CENTER, false).afterReturnNothing();

      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      pintoplimitdialogvm.onBlur();

      mocker.ignoreMock(logHelper, logHelper.debug);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });

    it('should_return_false_when_isSingleDisplayPocketFoldDevice_and_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(display, display.getFoldStatus);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isSingleDisplayPocketFoldDevice_or_isSmallFoldProduct_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isXTProductType_and_isMatchXTFoldMode_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isMatchXTFoldMode);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isMatchXTFoldMode);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_false_when_isFold_and_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(display, display.getFoldStatus);
      when(mockfunc2)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(display, display.getFoldStatus);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_isPad_is_true', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc3)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(true);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_false_when_no_matching_condition_is_met', 0, () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);
      when(mockfunc3)().afterReturn(false);
      let mockfunc4: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc4)().afterReturn(false);
      let mockfunc5: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc5)().afterReturn(false);
      let mockfunc6: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc6)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let result = pintoplimitdialogvm.getIsLandLayout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_font_scale_when_font_scale_state_is_not_null', 0, async () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let fontScaleState: FontScaleState = new FontScaleState();
      let mockfunc: Function = mocker.mockFunc(fontScaleState, fontScaleState.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(2.0);
      pintoplimitdialogvm.fontScaleState = fontScaleState;
      const result = pintoplimitdialogvm.getFontScale();
      expect(result).assertEqual(2.0);
      mocker.ignoreMock(fontScaleState, fontScaleState.getFontScale);
    });

    it('should_return_default_font_scale_when_font_scale_state_is_null', 0, async () => {
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      let mocker: MockKit = new MockKit();
      let fontScaleState: FontScaleState = new FontScaleState();
      let mockfunc: Function = mocker.mockFunc(fontScaleState, fontScaleState.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(1.0);
      pintoplimitdialogvm.fontScaleState = null;
      const result = pintoplimitdialogvm.getFontScale();
      expect(result).assertEqual(1.0);
      mocker.ignoreMock(fontScaleState, fontScaleState.getFontScale);
    });
    it('should_log_debug_and_emit_event_when_onFocus_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockDebug: Function = mocker.mockFunc(logHelper, logHelper.debug);
      when(mockDebug)(ArgumentMatchers.any).afterReturnNothing();
      let eventHub: EventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      pintoplimitdialogvm.onFocus();
      mocker.ignoreMock(logHelper, logHelper.debug);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });
    it('should_log_debug_and_emit_event_when_onBlur_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.debug);
      when(mockLogFunc)(ArgumentMatchers.any).afterReturnNothing();
      let eventHub: EventHub = GlobalContext.getContext().eventHub;
      let mockEmitFunc: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmitFunc)('SubWindowVisible', ViewType.NOTIFICATION_CENTER, false).afterReturnNothing();
      let pintoplimitdialogvm: PinTopLimitDialogVm = new PinTopLimitDialogVm();
      pintoplimitdialogvm.onBlur();
      mocker.ignoreMock(logHelper, logHelper.debug);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });
  });
