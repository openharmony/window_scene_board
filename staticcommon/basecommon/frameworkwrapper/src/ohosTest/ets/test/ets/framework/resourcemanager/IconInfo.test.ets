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
import { afterAll, afterEach,
  beforeAll, beforeEach, describe, expect, it} from '@ohos/hypium'
import IconInfo, { IconPicType } from '../../../../../../main/ets/resourcemanager/IconInfo'

export function IconInfoTest() {
  const iconType = IconPicType.NORMAL;
  const combinePic = 'combinePic';
  const adaptivePic = ['pic1', 'pic2'];
  const label = 'label1';

  describe('seticon', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_set_iconType_when_iconType_is_provided', 0, () => {
      let iconInfo1 = new IconInfo(iconType);
      expect(iconInfo1.iconType).assertEqual(IconPicType.NORMAL);
      let iconInfo2 = new IconInfo(undefined, ['']);
      expect(iconInfo2.iconType).assertEqual(IconPicType.NONE);
    });

    it('should_set_adaptivePic_when_adaptivePic_is_provided', 0, () => {
      let iconInfo = new IconInfo(undefined, adaptivePic);
      expect(iconInfo.adaptivePic).assertDeepEquals(adaptivePic);
    });

    it('should_set_combinePic_when_combinePic_is_provided', 0, () => {
      let iconInfo = new IconInfo(undefined, undefined, combinePic);
      expect(iconInfo.combinePic).assertEqual(combinePic);
    });

    it('should_set_label_when_label_is_provided', 0, () => {
      let iconInfo = new IconInfo(undefined, undefined, undefined, undefined, label);
      expect(iconInfo.label).assertEqual(label);
    });

    it('new_Icon', 0, () => {
      let iconInfo = new IconInfo(iconType, adaptivePic, combinePic, undefined, label);
      expect(iconInfo.label).assertEqual(label);
      expect(iconInfo.combinePic).assertEqual(combinePic);
    });


    it('should_not_set_any_property_when_no_argument_is_provided', 0, () => {
      let iconInfo = new IconInfo();
      expect(iconInfo.iconType).assertEqual(IconPicType.NONE);
      expect(iconInfo.adaptivePic).assertDeepEquals([] as string[]);
      expect(iconInfo.combinePic).assertEqual('');
      expect(iconInfo.label).assertEqual('');
    });
  });
}
