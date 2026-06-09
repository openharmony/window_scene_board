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

import { FASlotName } from '@ohos/commonconstants';
import { PluginSlot } from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { audio } from '@kit.AudioKit';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { ToggleState } from '@ohos/systemuicommon/Index';
import { AccessibilityUtilExt } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityUtilExt';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';

const DEFAULT: number = 0;

export function AccessibilityUtilExtTestCC() {
  const mocker: MockKit = new MockKit();
  describe('AccessibilityUtilExtTestCC', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
      // 设置开关
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(true);
    })
    afterAll((): void => {
      mocker.clearAll();
    })
    afterEach((): void => {
      mocker.clear(AccessibilityUtil);
    })

    it('AccessibilityUtilExtTest_getToggleText1', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleText2', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let toggleState: ToggleState = { slot: FASlotName.WIFI, label: 'WLAN' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getToggleText3', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleText4', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI, isUnavailable: true };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleText5', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI, label: 'TEST' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();

      let toggleState2: ToggleState = { slot: FASlotName.WIFI, label: 'WLAN', value: true };
      let text2 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text2 === '').assertFalse();

      let toggleState3: ToggleState = { slot: FASlotName.WIFI, label: 'WLAN', value: false };
      let text3 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text3 === '').assertFalse();

      let toggleState4: ToggleState = { slot: FASlotName.WIFI_UI_EXTENSION, label: 'TEST' };
      let text4 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text4 === '').assertFalse();

      let toggleState5: ToggleState = { slot: FASlotName.WIFI_UI_EXTENSION, label: 'WLAN', value: true };
      let text5 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text5 === '').assertFalse();

      let toggleState6: ToggleState = { slot: FASlotName.WIFI_UI_EXTENSION, label: 'WLAN', value: false };
      let text6 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text6 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleText6', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.BLUETOOTH, label: 'TEST' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();

      let toggleState2: ToggleState = { slot: FASlotName.BLUETOOTH,
        label: ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name')), value: true };
      let text2 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text2 === '').assertFalse();

      let toggleState3: ToggleState = { slot: FASlotName.BLUETOOTH,
        label: ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name')), value: false };
      let text3 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text3 === '').assertFalse();

      let toggleState4: ToggleState = { slot: FASlotName.BLUETOOTH_UI_EXTENSION, label: 'TEST' };
      let text4 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text4 === '').assertFalse();

      let toggleState5: ToggleState = { slot: FASlotName.BLUETOOTH_UI_EXTENSION,
        label: ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name')), value: true };
      let text5 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text5 === '').assertFalse();

      let toggleState6: ToggleState = { slot: FASlotName.BLUETOOTH_UI_EXTENSION,
        label: ResUtils.getInnerString($r('app.string.cc_accessibility_str_bluetooth_name')), value: false };
      let text6 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text6 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleText7', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.RING_MODE, label: 'TEST' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();

      let toggleState2: ToggleState = { slot: PluginSlot.SLOT_CONTROL_SCREENSHOT, label: 'TEST' };
      let text2 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text2 === '').assertFalse();

      let toggleState3: ToggleState = { slot: PluginSlot.SLOT_CONTROL_SCREEN_RECORDER, label: 'TEST' };
      let text3 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text3 === '').assertFalse();

      let toggleState4: ToggleState = { slot: FASlotName.CAMERA, label: 'TEST' };
      let text4 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text4 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleText8', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.FLASHLIGHT, label: 'TEST' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText1', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText2', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let toggleState: ToggleState = { slot: FASlotName.WIFI, label: 'WLAN' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText3', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI, value: false };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText4', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI, value: true };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText5', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.BLUETOOTH, value: false };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText6', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.BLUETOOTH, value: true };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText7', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.FLASHLIGHT, label: 'flashlight' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === 'flashlight').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleLabelText8', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.FLASHLIGHT, label: '' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleIconClickText1', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let toggleState: ToggleState = { slot: FASlotName.WIFI, label: 'WLAN' };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getToggleIconClickText2', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleIconClickText3', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI, isUnavailable: true };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleIconClickText4', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.WIFI };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleIconClickText5', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: FASlotName.RING_MODE, mode: audio.AudioRingMode.RINGER_MODE_SILENT };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();

      let toggleState2: ToggleState = { slot: FASlotName.RING_MODE, mode: audio.AudioRingMode.RINGER_MODE_VIBRATE };
      let text2 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text2 === '').assertFalse();

      let toggleState3: ToggleState = { slot: FASlotName.RING_MODE, mode: audio.AudioRingMode.RINGER_MODE_NORMAL };
      let text3 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text3 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleIconClickText6', DEFAULT, (): void => {
      let toggleState: ToggleState = { slot: PluginSlot.SLOT_CONTROL_SCREENSHOT };
      let text = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text === '').assertFalse();

      let toggleState2: ToggleState = { slot: PluginSlot.SLOT_CONTROL_SCREEN_RECORDER };
      let text2 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text2 === '').assertFalse();

      let toggleState3: ToggleState = { slot: FASlotName.CAMERA };
      let text3 = AccessibilityUtilExt.getToggleText('', new ToggleViewData()) as string;
      expect(text3 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getEditToggleReportText1', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let text = AccessibilityUtilExt.getEditToggleReportText(12, 20, 4, 4, true) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getEditToggleReportText2', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getEditToggleReportText(20, 20, 4, 4, true) as string;
      expect(text === '').assertFalse();

      let text2 = AccessibilityUtilExt.getEditToggleReportText(4, 20, 4, 4, false) as string;
      expect(text2 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getEditToggleReportText3', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getEditToggleReportText(12, 20, 4, 4, true) as string;
      expect(text === '').assertFalse();

      let text2 = AccessibilityUtilExt.getEditToggleReportText(12, 20, 4, 4, false) as string;
      expect(text2 === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getEditToggleText1', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let text = AccessibilityUtilExt.getEditToggleText(FASlotName.WIFI) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getEditToggleText2', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getEditToggleText(FASlotName.WIFI) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getEditPreviewToggleText1', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let text = AccessibilityUtilExt.getEditPreviewToggleText(FASlotName.WIFI) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getEditPreviewToggleText2', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getEditPreviewToggleText(FASlotName.WIFI) as string;
      expect(text === '').assertFalse();
    })

    it('AccessibilityUtilExtTest_getToggleMoveItemText1', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      let text = AccessibilityUtilExt.getToggleMoveItemText(1, 2) as string;
      expect(text === '').assertTrue();
    })

    it('AccessibilityUtilExtTest_getToggleMoveItemText2', DEFAULT, (): void => {
      let text = AccessibilityUtilExt.getToggleMoveItemText(1, 2) as string;
      expect(text === '').assertFalse();
    })
  })
}