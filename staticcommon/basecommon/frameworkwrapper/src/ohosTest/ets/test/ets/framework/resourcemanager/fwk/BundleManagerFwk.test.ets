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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { IconExtendParam } from '../../../../../../../main/ets/resourcemanager/IconExtendParam';
import IconInfo, { IconPicType } from '../../../../../../../main/ets/resourcemanager/IconInfo';
import { TaskInfo } from '../../../../../../../main/ets/resourcemanager/TaskInfo';
import { bundleManagerFwk } from '../../../../../../../main/ets/TsIndex';


export function BundleManagerFwkTest() {
  const bundleName = 'com.ohos.photos';
  const moduleName = 'phone_photos';
  const abilityName = 'com.ohos.photos.MainAbility';

  describe('BundleManagerFwkTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('getIconResourceFromFwk_return_empty_string', 0, async (done: Function) => {
      let iconInfo: IconInfo = new IconInfo();
      let param: IconExtendParam = new IconExtendParam();
      const result = await bundleManagerFwk.getIconResourceFromFwk(param, 'bundleName', 'moduleName','abilityName');
      const result1 = await bundleManagerFwk.getIconResourceFromFwk(param, undefined, 'moduleName','abilityName');
      const result2 = await bundleManagerFwk.getIconResourceFromFwk(param, undefined);
      expect(result.combinePic).assertEqual(iconInfo.combinePic);
      expect(result1.combinePic).assertEqual(iconInfo.combinePic);
      expect(result2.combinePic).assertEqual(iconInfo.combinePic);
      done();
    });

    it('getIconResourceFromFwk_return_icon', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      let icon: IconInfo = await bundleManagerFwk.getIconResourceFromFwk(param, bundleName, moduleName, abilityName);
      expect(icon.iconType).assertEqual(IconPicType.ADAPTIVE);
      let icon1: IconInfo = await bundleManagerFwk.getIconResourceFromFwk(param, bundleName);
      expect(icon1.iconType).assertEqual(IconPicType.ADAPTIVE);
      done();
    });

    it('getIconResourceFromFwk_getIconResourceFromFwkBatch', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = false;
      let taskInfo: TaskInfo = new TaskInfo(bundleName, moduleName, abilityName, param)
      let taskInfos: TaskInfo[] = [taskInfo];
      let res: IconInfo[] = await bundleManagerFwk.getIconResourceFromFwkBatch(taskInfos);
      expect(res.length === 1).assertTrue();
      done();
    });

    it('getIconResourceFromFwk_getIconResourceFromFwkBatch_withborder', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = true;
      let taskInfo: TaskInfo = new TaskInfo(bundleName, '', '', param)
      let taskInfos: TaskInfo[] = [taskInfo];
      let res: IconInfo[] = await bundleManagerFwk.getIconResourceFromFwkBatch(taskInfos);
      expect(res.length === 1).assertTrue();
      done();
    });

  });
}