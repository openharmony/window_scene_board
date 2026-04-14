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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from "@ohos/hypium";
import { SwiperPageManager } from "../../../../../../main/ets/viewmodel/SwiperPageManager";

export default function SwiperPageManagerTest() {
  describe('SwiperPageManagerTest', () => {
    beforeAll(() => {
      SwiperPageManager.getInstance(false).updateScreenData(true, 0, 0, 0, 0, 0);
      SwiperPageManager.getInstance(false).updateScreenData(false, 0, 0, 0, 0, 0);
      SwiperPageManager.getInstance(false).resetAnimationNum();
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('updateScreenData_01', 0, () => {
      let workSpaceWidth: number = 100;
      let marginLeft: number = 10;
      let marginRight: number = 10;
      let foldPaddingLeft: number = 20;
      let foldPaddingRight: number = 20;
      SwiperPageManager.getInstance()
        .updateScreenData(true, workSpaceWidth, marginLeft, marginRight, foldPaddingLeft, foldPaddingRight);
      expect(100).assertEqual(SwiperPageManager.getInstance().getScreenData()[1][0]);
    })
    it('updateScreenData_02', 0, () => {
      let workSpaceWidth: number = 100;
      let marginLeft: number = 10;
      let marginRight: number = 10;
      let foldPaddingLeft: number = 20;
      let foldPaddingRight: number = 20;
      SwiperPageManager.getInstance()
        .updateScreenData(false, workSpaceWidth, marginLeft, marginRight, foldPaddingLeft, foldPaddingRight);
      expect(100).assertEqual(SwiperPageManager.getInstance().getScreenData()[0][0]);
    });

    it('increaseAnimationNum_01', 0, () => {
      SwiperPageManager.getInstance().increaseAnimationNum();
      expect(1).assertEqual(SwiperPageManager.getInstance().getAnimationNum());
    });
  })
}