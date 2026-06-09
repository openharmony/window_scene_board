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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { hideBannerNtfContentObj } from '../../../../main/ets/model/HideBannerNtfContentObj'

export default function HideBannerNtfContentObjTest() {
  describe('HideBannerNtfContentObjTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('hide_banner_ntf_content_obj_test_update_face_data', 0, () => {
      hideBannerNtfContentObj.updateFaceData(true);
      expect(hideBannerNtfContentObj.isUseSwing()).assertTrue()
      hideBannerNtfContentObj.updateFaceData(false);
      expect(hideBannerNtfContentObj.isUseSwing()).assertFalse()
    })

    it('hide_banner_ntf_content_obj_test_update_face_open', 0, () => {
      const isFaceOpen1 = 1;
      hideBannerNtfContentObj.updateFaceOpen(isFaceOpen1);
      expect(hideBannerNtfContentObj.isUseSwing()).assertEqual(isFaceOpen1)
      const isFaceOpen2 = 2;
      hideBannerNtfContentObj.updateFaceOpen(isFaceOpen2);
      expect(hideBannerNtfContentObj.isUseSwing()).assertEqual(isFaceOpen2)
    })

    it('hide_banner_ntf_content_obj_test_update_hidden_content', 0, () => {
      const isHiddenContent1 = 1;
      hideBannerNtfContentObj.updateHiddenContent(isHiddenContent1);
      expect(hideBannerNtfContentObj.isUseSwing()).assertEqual(isHiddenContent1)
      const isHiddenContent2 = 2;
      hideBannerNtfContentObj.updateHiddenContent(isHiddenContent2);
      expect(hideBannerNtfContentObj.isUseSwing()).assertEqual(isHiddenContent2)
    })
  })
}