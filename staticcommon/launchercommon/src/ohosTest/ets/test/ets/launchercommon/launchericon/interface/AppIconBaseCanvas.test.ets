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
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { image } from '@kit.ImageKit';
import { AppIconBaseCanvas } from '../../../../../../../main/ets/launchericon/interface/AppIconBaseCanvas';
import { AppItemInfo, CommonConstants, ShortcutViewModel, StyleConstants } from '../../../../../../../main/ets/TsIndex';

export function AppIconBaseCanvasTest() {
  describe('AppIconBaseCanvasTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('constructor', 0, () => {
      let settings: RenderingContextSettings = new RenderingContextSettings(true);
      let canvas: AppIconBaseCanvas = new AppIconBaseCanvas(settings, 'CanvasId', StyleConstants.APP_ICON_GRAY_COLOR);

      canvas = new AppIconBaseCanvas(settings, '', StyleConstants.APP_ICON_GRAY_COLOR);

      canvas = new AppIconBaseCanvas(settings, 'CanvasId', '');
      expect(canvas).not().assertNull();
    });

    it('updateMask', 0, () => {
      let settings: RenderingContextSettings = new RenderingContextSettings(true);
      let canvas: AppIconBaseCanvas = new AppIconBaseCanvas(settings, '', '');
      let image: image.PixelMap = AppStorage.get('AppIconBaseCanvasTestInvalidKey') as image.PixelMap;
      canvas.updateMask(image, 18, new AppItemInfo());


      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(ShortcutViewModel.getInstance(),
        ShortcutViewModel.getInstance().getShortcutBackgroundImage);
      when(mockFun)(ArgumentMatchers.any).afterAction(action);

      canvas = new AppIconBaseCanvas(settings, 'CanvasId', StyleConstants.APP_ICON_GRAY_COLOR);
      let item: AppItemInfo = new AppItemInfo();
      item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      canvas.updateMask(image, 48, item);
      expect(canvas).not().assertNull();

      mocker.clear(ShortcutViewModel.getInstance());
      mocker.clearAll();
    });
  });
}