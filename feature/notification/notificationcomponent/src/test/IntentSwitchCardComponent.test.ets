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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { bannerMgr, DarkModeState } from '@ohos/systemuicommon';
import { NtfItemName } from '../../../../main/ets/intent/IntentCodeConstant';
import { LengthMetrics } from '@ohos.arkui.node';
import uiAppearance from '@ohos.uiAppearance';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/common/IntentSwitchCardComponent';
export default function Test() {
  describe('buildCardContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());

      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockWidth: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.width);
      when(mockWidth)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockLineHeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      when(mockLineHeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());

      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());

      let mockHeight: Function = mocker.mockFunc(CommonMethod.prototype, CommonMethod.prototype.height);
      when(mockHeight)(ArgumentMatchers.any).afterReturn(new CommonMethod());

      let mockOnChange: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
      when(mockOnChange)(ArgumentMatchers.anyFunction).afterReturn(new ToggleAttribute());

      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };

      switchCardComponent.buildCardContent();
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });

    it('should_render_switch_card_content_correctly', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      when(mockMaxLines)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());
      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      let mockSwitchStyle: Function = mocker.mockFunc(ToggleAttribute.prototype, ToggleAttribute.prototype.switchStyle);
      when(mockSwitchStyle)(ArgumentMatchers.any).afterReturn(new ToggleAttribute());
      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      when(mockFontWeight)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());
      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      when(mockFontSize)(ArgumentMatchers.anyNumber).afterReturn(new TextAttribute());
      let switchCardComponent: SwitchCardComponent = new SwitchCardComponent();
      switchCardComponent.switchCardVo = {
        switchTitle: 'Test Switch',
        isOn: true,
        onChange: (isOn: boolean) => {
          console.log('Switch state changed to: ' + isOn);
        }
      };
      switchCardComponent.buildCardContent();
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.width);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.lineHeight);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(CommonMethod.prototype, CommonMethod.prototype.height);
      mocker.ignoreMock(ToggleAttribute.prototype, ToggleAttribute.prototype.onChange);
    });
  });
}