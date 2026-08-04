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
import { it, describe, expect } from '@ohos/hypium';
import { ImmersiveAodStyle, AodStyleType } from '../../../../../../../main/ets/immersivekeyguardcommon/base/interface/ImmersiveAodStyle';

export function ImmersiveAodStyleTest() {
  describe('ImmersiveAodStyleTest', (): void => {
    it('test_initImmersiveAodStyle', 0, (): void => {
      let testInstance: ImmersiveAodStyle = new ImmersiveAodStyle();
      expect(testInstance instanceof ImmersiveAodStyle).assertTrue();
    });
    it('test_bindStyle', 0, (): void => {
      let testInstance: ImmersiveAodStyle = new ImmersiveAodStyle();
      let res = testInstance.bindStyle(AodStyleType.FONT_COLOR, 0);
      expect(res instanceof ImmersiveAodStyle).assertTrue();
    });
    it('test_getStyleValue', 0, (): void => {
      let testInstance: ImmersiveAodStyle = new ImmersiveAodStyle();
      testInstance.bindStyle(AodStyleType.FONT_COLOR, 0);
      let res = testInstance.getStyleValue(AodStyleType.FONT_COLOR);
      expect(res).assertEqual(0);
    });
    it('test_isNtfReachMax', 0, (): void => {
      let testInstance: ImmersiveAodStyle = new ImmersiveAodStyle();
      testInstance.setNtfMeshReachMax(true);
      let res = testInstance.isNtfReachMax();
      expect(res).assertTrue();
    });
  });
}