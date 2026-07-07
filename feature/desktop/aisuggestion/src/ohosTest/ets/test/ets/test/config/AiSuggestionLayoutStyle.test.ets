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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import {
  AiSuggestionLayoutStyle,
  LayoutComponentId,
} from '../../../../../../main/ets/default/config/AiSuggestionLayoutStyle';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';

class MyLayoutStyle extends AiSuggestionLayoutStyle {
  descAlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
    };
  };
  gridAlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
    };
  };
  chip1AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
    };
  };
  chip2AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
    };
  };
  public getHeaderHeight(displayCardInfo: LauncherDisplayCardInfo | undefined,
    isOuterDesktop: boolean = false, formItemHeight: number): number {
    return 0;
  }
};

export default function AiSuggestionLayoutStyleTest() {
  describe('AiSuggestionLayoutStyleTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('AiSuggestionLayoutStyleTest_gridItemAlignment_01', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      (layout as object)['displayCardInfo'] = undefined;
      const items: LauncherRecItem = new LauncherRecItem();
      expect(layout.gridItemAlignment(items, true)).assertEqual(Alignment.Center)
    });

    it('AiSuggestionLayoutStyleTest_gridItemAlignment_02', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      const info: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      info.column = 1;
      (layout as object)['displayCardInfo'] = info;
      const items: LauncherRecItem = new LauncherRecItem();
      items.columnSpan = 1;
      expect(layout.gridItemAlignment(items, true)).assertEqual(Alignment.Center);
    });

    it('AiSuggestionLayoutStyleTest_getDescPadding_01', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(true);

      expect(layout.getDescPadding().top).assertEqual(14);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getDescPadding_02', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(false);

      expect(layout.getDescPadding().top).assertEqual(16);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getChipItemMargin_01', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(func)().afterReturn(true);

      expect(layout.getChipItemMargin().right).assertEqual(12);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getChipItemMargin_02', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(func)().afterReturn(false);

      expect(layout.getChipItemMargin().right).assertEqual(0);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getDescFontSize_01', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(true);

      expect(layout.getDescFontSize()).assertEqual('17vp');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getDescFontSize_02', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(false);

      expect(layout.getDescFontSize()).assertEqual('19vp');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getDescLineHeight_01', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(true);

      expect(layout.getDescLineHeight()).assertEqual('24vp');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AiSuggestionLayoutStyleTest_getDescLineHeight_02', 0, () => {
      let layout: AiSuggestionLayoutStyle = new MyLayoutStyle();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(func)().afterReturn(false);

      expect(layout.getDescLineHeight()).assertEqual('26vp');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

  });
}