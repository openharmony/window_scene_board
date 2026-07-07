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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { AppIconStyleConfig, AppBadgeStyleType } from '../../../../../../../main/ets/launchericon/config/AppIconStyleConfig';
import { AppIconModel, StyleConstants } from '../../../../../../../main/ets/TsIndex';

export function AppIconStyleConfigTest() {
  describe('AppIconStyleConfigTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_getCloneBadgeStyle', 0, () => {
      let style = AppIconStyleConfig.getCloneBadgeStyle(AppBadgeStyleType.DEFAULT);
      expect(style.width).assertEqual(18);
      expect(style.height).assertEqual(18);
      style = AppIconStyleConfig.getCloneBadgeStyle(AppBadgeStyleType.SMALLER_ICON);
      expect(style.width).assertEqual(14);
      expect(style.height).assertEqual(14);
      style = AppIconStyleConfig.getCloneBadgeStyle(AppBadgeStyleType.DELIVER_ICON);
      expect(style.width).assertEqual(20);
      expect(style.height).assertEqual(16);
      style = AppIconStyleConfig.getCloneBadgeStyle(AppBadgeStyleType.SMALLER_DELIVER_ICON);
      expect(style.width).assertEqual(14);
      expect(style.height).assertEqual(11);
    });

    it('test_getIconShadowOptions', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockIsEnableIconShadow: Function = mocker.mockFunc(AppIconModel.getInstance(),
        AppIconModel.getInstance().isEnableIconShadow);

      when(mockIsEnableIconShadow)(ArgumentMatchers.any).afterReturn(true);
      let option: ShadowOptions | null = AppIconStyleConfig.getIconShadowOptions(true);
      expect(option?.radius).assertEqual(StyleConstants.APP_ICON_SHADOW_RADIUS);
      expect(option?.color).assertEqual(StyleConstants.APP_ICON_SHADOW_COLOR);
      expect(option?.offsetY).assertEqual(StyleConstants.APP_ICON_SHADOW_OFFSETY);

      when(mockIsEnableIconShadow)(ArgumentMatchers.any).afterReturn(false);
      option = AppIconStyleConfig.getIconShadowOptions(false);

      mocker.clear(AppIconModel.getInstance());
      mocker.clearAll();
    });
  });
}