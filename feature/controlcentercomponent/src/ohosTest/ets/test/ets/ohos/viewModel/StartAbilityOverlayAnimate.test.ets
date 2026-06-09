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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  StartAbilityOverlayAnimate
} from '../../../../../../main/ets/com/ohos/viewModel/StartAbilityOverlayAnimate';
import { StartAbilityOverlayAnimateData } from '../../../../../../main/ets/com/ohos/model/StartAbilityOverlayAnimateData'
import { image } from '@kit.ImageKit';
import { ScreenLockApi } from '@ohos/screenlockcommon';

export function StartAbilityOverlayAnimateTest() {

  describe('StartAbilityOverlayAnimateTest', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    it('StartAbilityOverlayAnimate_Constructor_Test', 0, (): void => {
      let viewMode = StartAbilityOverlayAnimate.getInstance();
      expect(viewMode).assertInstanceOf('Object');
    })

    it('StartAbilityOverlayAnimateTest001', 0, (): void => {

      let viewMode = StartAbilityOverlayAnimate.getInstance();
      viewMode.initData(new StartAbilityOverlayAnimateData());
      viewMode.prepareForOverlayAnimate();
      expect(viewMode).assertInstanceOf('Object');
    })

    it('StartAbilityOverlayAnimateTest002', 0, (): void => {

      let viewMode = StartAbilityOverlayAnimate.getInstance();
      viewMode.initData(new StartAbilityOverlayAnimateData());
      viewMode.onOverlayAnimateStart();
      viewMode.onOverlayAnimateCancel()
      expect(viewMode).assertInstanceOf('Object');
    })

    it('StartAbilityOverlayAnimateTest_saveBackGroundImage', 0, async (done: Function) => {
      let viewMode = StartAbilityOverlayAnimate.getInstance();
      viewMode.initData(new StartAbilityOverlayAnimateData());
      let imageMap: image.PixelMap = await createImage(2, 3);
      viewMode.saveBackGroundImage(imageMap);
      expect((viewMode as object)['animateData'].snapshot).not().assertNull();
      done();
    })

    it('StartAbilityOverlayAnimateTest_prepareForOverlayAnimate', 0, (): void => {
      let viewMode = StartAbilityOverlayAnimate.getInstance();
      viewMode.initData(new StartAbilityOverlayAnimateData());
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(ScreenLockApi, ScreenLockApi.getLock);
      when(mockFunc1)().afterReturn(true);
      let mocker2: MockKit = new MockKit();
      let mockFunc2: Function = mocker2.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc2)('lockStatus').afterReturn(true);
      viewMode.prepareForOverlayAnimate();
      (viewMode as object)['animateData'] = null;
      let result = viewMode.prepareForOverlayAnimate();
      expect(result == null).assertTrue();
      mocker1.clear(ScreenLockApi);
      mocker2.clear(AppStorage);
    })

    it('StartAbilityOverlayAnimateTest_onOverlayAnimateStart', 0, (): void => {
      let viewMode = StartAbilityOverlayAnimate.getInstance();
      (viewMode as object)['animateData'] = null;
      let result = viewMode.onOverlayAnimateStart();
      expect(result == null).assertTrue();
    })
  })
}

async function createImage(width: number, height: number): Promise<image.PixelMap> {
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}