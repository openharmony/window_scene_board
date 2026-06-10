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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { MultiSelectAnimateManager } from '../../../../../../../main/ets/editmode/model/MultiSelectAnimateManager';
import { GatherAnimateTarget } from '../../../../../../../main/ets/editmode/data/MultiSelectData'
import { FrameAnimationParam } from '@ohos/componentanimator/Index';

export function MultiSelectAnimateManagerTest() {
  describe('MultiSelectAnimateManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })
    it('test_getRotateAnimationParams_01', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let target: GatherAnimateTarget = new GatherAnimateTarget();
      let res: FrameAnimationParam[] = (multiSelectAnimateManager as object)['getRotateAnimationParams'](target, 0)
      expect(res !== null).assertTrue()
    })

    it('test_getRotateAnimationParams_02', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let target: GatherAnimateTarget = new GatherAnimateTarget();
      let res: FrameAnimationParam[] = (multiSelectAnimateManager as object)['getRotateAnimationParams'](target, 1)
      expect(res !== null).assertTrue()
    })

    it('test_getRotateAnimationParams_03', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let target: GatherAnimateTarget = new GatherAnimateTarget();
      let res: FrameAnimationParam[] = (multiSelectAnimateManager as object)['getRotateAnimationParams'](target, 2)
      expect(res !== null).assertTrue()
    })

    it('test_getRotateAnimationParams_04', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let target: GatherAnimateTarget = new GatherAnimateTarget();
      let res: FrameAnimationParam[] = (multiSelectAnimateManager as object)['getRotateAnimationParams'](target, 200)
      expect(res !== null).assertTrue()
    })

    it('test_resetDropAnimationItemOpacity_01', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let FunResetDropAnimationItemOpacity: Function =
        Reflect.get(multiSelectAnimateManager, 'resetDropAnimationItemOpacity');
      expect(FunResetDropAnimationItemOpacity('', 0) !== null).assertTrue()
    })

    it('test_releaseAnimateItem_01', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let res: void = (multiSelectAnimateManager as object)['releaseAnimateItem']
      expect(res !== null).assertTrue()
    })

    it('test_cancelAnimation_01', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let FunCancelAnimation: Function = Reflect.get(multiSelectAnimateManager, 'cancelAnimation');
      expect(FunCancelAnimation() !== null).assertTrue()
    })

    it('test_hideAnimationItem_01', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let FunHideAnimationItem: Function = Reflect.get(multiSelectAnimateManager, 'hideAnimationItem');
      expect(FunHideAnimationItem() !== null).assertTrue()
    })

    it('test_resetDropAnimationItemZIndex_01', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let FunResetDropAnimationItemZIndex: Function =
        Reflect.get(multiSelectAnimateManager, 'resetDropAnimationItemZIndex');
      expect(FunResetDropAnimationItemZIndex('') !== null).assertTrue()
    })

    it('test_doDropToFolderAnimate', 0, () => {
      const multiSelectAnimateManager = new MultiSelectAnimateManager();
      let targetList: GatherAnimateTarget[] = [];
      let target1: GatherAnimateTarget = new GatherAnimateTarget();
      target1.animationType = 2;
      targetList.push(target1);
      let target2: GatherAnimateTarget = new GatherAnimateTarget();
      target1.animationType = 3;
      targetList.push(target2);
      let target3: GatherAnimateTarget = new GatherAnimateTarget();
      target1.animationType = 4;
      targetList.push(target3);
      let res: FrameAnimationParam[] = (multiSelectAnimateManager as object)['doDropToFolderAnimate'](targetList, () => {});
      expect(res !== null).assertTrue()
    })
  })
}
